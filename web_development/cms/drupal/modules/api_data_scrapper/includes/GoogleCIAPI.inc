<?php

/**
 * Class for calling and formatting data from the Google Civic Information API
 * https://developers.google.com/civic-information/
 */
class GoogleCIAPI extends APIDataScrapper {
  
  const GOOGLE_CI_API_KEY = 'api_data_scrapper_api_1_key';
  const GOOGLE_CI_API_ENDPOINT = 'api_data_scrapper_api_1_endpoint';
  const GOOGLE_CI_API_FILENAME = 'gci_api_contacts.csv';
  
  private static $suffixes = [
    'SR.',
    'Sr.',
    'JR.',
    'Jr.',
    'I',
    'II',
    'III',
    'IV',
    'V'
  ];
  
  /**
   * Constructor for the class
   */
  public function __construct() {
    parent::__construct();
  }
  
  /**
   * Destructor for the class
   */
  public function __destruct() {
    parent::__destruct();
  }
  
  /**
   * Sends CURL request to the Google Civic Information API
   * 
   * @return boolean Success of the request, or return from _mapContacts()
   */
  public static function call() {
    // Construct the data payload from Drupal's variable table for the call to Google's API
    $data = [
      'key' => variable_get(self::GOOGLE_CI_API_KEY),
    ];
    
    // Merge the Custom OCD Division IDs with the external CSV file into an array for our API Endpoint requests
    $OCDDivisionIds = array_map('str_getcsv', file(__DIR__.'/ocd-division-ids/state-il-local_gov.csv'));
    
    // Container for the dataset for the API requests
    $dataSet = [];
    
    foreach ($OCDDivisionIds as $divisionId) {
      // Construct the URL Endpoint for the instance of the API request
      $url = variable_get(self::GOOGLE_CI_API_ENDPOINT) . urlencode($divisionId[0]);
      
      // Check that all variables are populated, if not, send errors to Drupal's messaging system
      if (!isset($url) || empty($url)) {
        drupal_set_message('The API Endpoint for the Google API is not set, please enter an API endpoint on the settings page.', 'error');
        return FALSE;
      } elseif (!isset($data['key']) || empty($data['key'])) {
        drupal_set_message('The API key for the Google API is not set, please enter an API key on the settings page.', 'error');
        return FALSE;
      } else {
        // Place each response from the API into $dataSet
        // TODO: We need to trap errors from the request here
        $dataSet[] = json_decode(self::$APIGateway->sendRequest('GET', $url, $data));
      }
    }
    
    // Prepare the data for output to CSV or return FALSE
    if (isset($dataSet) && !empty($dataSet)) {
      return self::_mapContacts($dataSet);
    } else {
      return FALSE;
    }
  }
  
  /**
   * Formats the data for output to CSV
   * 
   * @param array $data The source dataset to map from
   * @return boolean The success of outputToCSV()
   */
  private static function _mapContacts($data) {
    // Init the container for the formatted data
    $contacts = [];
    $guid = 0;
    
    // Reformat the data set
    foreach($data as $district) {
      
      /**
       * $district->divisions
       * $district->offices
       * $district->officials
       */
      
      if (property_exists($district, 'divisions')) {
      
        foreach($district->divisions as $division) {

          if (property_exists($district, 'offices')) {

            foreach($division->officeIndices as $officeId) {

              if (property_exists($district, 'officials')) {

                foreach($district->offices[$officeId]->officialIndices as $officialId) {
                  
                  // Split the full name of the official into parts
                  $parts = explode(' ', $district->officials[$officialId]->name);
                  
                  switch (count($parts)) {
                    case 3:
                      $first_name  = isset($parts[0]) && !empty($parts[0]) ? $parts[0] : '';

                      // Deal with suffix within a name
                      If (!in_array($parts[2], self::$suffixes, TRUE)) {
                        $middle_name = isset($parts[1]) && !empty($parts[1]) ? $parts[1] : '';
                        $last_name   = isset($parts[2]) && !empty($parts[2]) ? $parts[2] : '';
                      } else {
                        $middle_name = '';
                        $last_name   = isset($parts[1], $parts[2]) && !empty($parts[1]) && !empty($parts[2]) ? $parts[1].' '.$parts[2] : '';
                      }

                      break;
                    case 2:
                      $first_name  = isset($parts[0]) && !empty($parts[0]) ? $parts[0] : '';
                      $middle_name = '';
                      $last_name   = isset($parts[1]) && !empty($parts[1]) ? $parts[1] : '';
                      break;
                  }
                  
                  $contact = [
                    'guid'          => $guid,
                    'division'      => $division->name,
                    'office'        => $district->offices[$officeId]->name,
                    'party'         => $district->officials[$officialId]->party,
                    'first_name'    => $first_name,
                    'middle_name'   => $middle_name,
                    'last_name'     => $last_name,
                    'address_line1' => $district->officials[$officialId]->address[0]->line1,
                    'city'          => $district->officials[$officialId]->address[0]->city,
                    'state'         => $district->officials[$officialId]->address[0]->state,
                    'zip'           => $district->officials[$officialId]->address[0]->zip,
                    'phone'         => $district->officials[$officialId]->phones[0],
                    'emails'        => $district->officials[$officialId]->emails[0],
                    'url'           => $district->officials[$officialId]->urls[0],
                  ];

                  $contacts[] = $contact;
                  $guid++;
                }
              }
            }
          }
        }
      }
    }
    
    //echo '<pre>';
    //print_r($contacts);
    //echo '</pre>';
    
    return self::outputToCSV($contacts, self::GOOGLE_CI_API_FILENAME);
  }
}