<?php

/**
 * The base class for the API Data Scrapper
 */
class APIDataScrapper {
  
  protected static $APIGateway;
  protected static $outputPath;
  
  /**
   * Constructor for the class
   */
  public function __construct() {
    
    // Construct an API gateway for our API calls
    self::$APIGateway = new APINetworkComponent();
  }
  
  /**
   * Destructor for the class
   */
  public function __destruct() {
    //
  }
  
  /**
   * Inits the process of calling the APIs and building the CSVs with the returned datasets
   * 
   * @param string $api Specifies which API to call and build a dataset for
   */
  public static function buildDataset($api = '') {
    switch($api) {
      case 'api_1':
        // Call the Google API
        $api = new GoogleCIAPI();
        $status = $api::call();
        break;
      case 'api_2':
        // Call the govtrack.us API
        $api = new GovTrackAPI();
        $status = $api::call();
        break;
      default:
        drupal_set_message('No value for $api sent to buildDataset', 'error');
        $status = FALSE;
        break;
    }
    
    return $status;
  }
  
  public static function getOutputPath() {
    // Construct the output path for the file
    // Get the output path for the CSV files from the Drupal configuration page if set
    $outputPath = variable_get('api_data_scrapper_csv_output_path');    
    // Otherwise, we set it to the default
    if(!isset($outputPath) || empty($outputPath)) {
      $outputPath = variable_get('file_public_path', conf_path() . '/files');
    }
    
    return $outputPath;
  }
  
  /**
   * Outputs the CSV file to the specified filename, using the output path from the settings page
   * 
   * @param array $data The dataset for the CSV file
   * @param string $filename The name of the output file
   * @return boolean Success of writing the CSV file to the directory
   */
  protected static function outputToCSV($data = [], $filename = '') {
    
    // Output the contacts to a CSV file
    if (isset($data) && !empty($data)) {
      
      // Open the file handler
      $fh = fopen(self::getOutputPath() . '/' . $filename, 'w+');
      // Place the headers into the file
      fputcsv($fh, array_keys($data['0']));
      // Inject the data into the file
      foreach($data as $item) {
        fputcsv($fh, $item);
      }
      // Close the file handler
      fclose($fh);
      
      return TRUE;
    } else {
      return FALSE;
    }
  }
}