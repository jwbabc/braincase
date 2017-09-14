<?php

/*
 * Calls and formats data from the govtrack.us API
 * https://www.govtrack.us/developers/api
 */
class GovTrackAPI extends APIDataScrapper {
  
  const GOVTRACK_API_ENDPOINT = 'api_data_scrapper_api_2_endpoint';
  const GOVTRACK_API_FILENAME = 'govtrack_api_contacts.csv';
  
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
   * Sends a CURL request to the govtrack.us API
   */
  public function call() {
    // Get the endpoint for the api call
    $url = variable_get(self::GOVTRACK_API_ENDPOINT);

    // Check that all variables are populated, if not, send errors to Drupal's messaging system
    if (!isset($url) || empty($url)) {
      drupal_set_message('The API Endpoint for the govtrack.us API is not set, please enter an API endpoint on the settings page.', 'error');
      return FALSE;
    } else {
      // Place each response from the API into $dataSet
      // TODO: We need to trap errors from the request here
      $response = json_decode(self::$APIGateway->sendRequest('GET', $url));
      
      if(property_exists($response, 'objects')) {
        // format the dataset and output it to CSV
        return self::_mapContacts($response);
      } else {
        drupal_set_message('No data was received from the API.', 'error');
        return FALSE;
      }
    }
  }
  
  private static function _mapContacts($data) {
    
    $contacts = [];
    $guid = 0;
    
    foreach($data->objects as $item) {
          
      $contact = [
        'guid'         => $guid,
        'sortname'     => $item->person->sortname,
        'first_name'   => $item->person->firstname,
        'last_name'    => $item->person->lastname,
        'role'         => $item->role_type_label,
        'start_date'   => $item->startdate,
        'end_date'     => $item->enddate,
        'district'     => $item->district,
        'address'      => $item->extra->office,
        'phone'        => $item->phone,
        'fax'          => $item->extra->fax,
        'url'          => $item->website,
        'contact_form' => $item->extra->contact_form,
        'party'        => $item->party,
        'gender'       => $item->person->gender_label,
        'dob'          => $item->person->birthday
      ];

      $contacts[] = $contact;
      $guid++;
    }

    // If the dataSet is set, output the dataset to a CSV file
    if(isset($contacts) && !empty($contacts)) {
      return self::outputToCSV($contacts, self::GOVTRACK_API_FILENAME);
    } else {
      return FALSE;
    }
  }
}