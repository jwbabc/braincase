<?php

/**
 * Networking component for the API Data Scrapper Module
 */
class APINetworkComponent {
  
  /**
   * Constructor for the class
   */
  public function __construct() {
    //
  }
  
  /**
   * Destructor for the class
   */
  public function __destruct() {
    //
  }
  
  /**
   * Entry method for the APINetworkComponent
   * 
   * @param string $method The protocol used for the API request (GET, POST, PUT, etc) 
   * @param string $url The endpoint for the API
   * @param array $data Any key:value pairs of data that need to be sent with the request
   * @param array $basicAuthCredentials key:value pair for the basic auth credentials
   * 
   * @return type
   */
  public static function sendRequest($method = 'GET', $url = '', $data = [], $basicAuthCredentials = []) {
    // Init the call to the API and store the result
    return self::_callAPI($method, $url, $data, $basicAuthCredentials);
  }
  
  /**
   * Simple CURL implementation for calling APIs
   * 
   * @param string $method The protocol used for the API request (GET, POST, PUT, etc) 
   * @param string $url The endpoint for the API
   * @param array $data Any key:value pairs of data that need to be sent with the request
   * @param array $basicAuthCredentials key:value pair for the basic auth credentials
   * 
   * @return type
   */
  private static function _callAPI($method, $url, $data = [], $basicAuthCredentials = []) {
    
    // Init the CURL handler
    $ch = curl_init();
    
    // Set the protocol for the request
    switch ($method) {
      case "POST":
        curl_setopt($ch, CURLOPT_POST, 1);

        if (isset($data) && !empty($data)) {
          curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
        }
        break;
      case "PUT":
        curl_setopt($ch, CURLOPT_PUT, 1);
        break;
      default:
        if (isset($data) && !empty($data)) {
            $url = sprintf("%s?%s", $url, http_build_query($data));
        }
    }
    
    // Optional Authentication:
    if (isset($basicAuthCredentials) && !empty($basicAuthCredentials)) {
      curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
      curl_setopt($ch, CURLOPT_USERPWD, "username:password");
    }

    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_REFERER, $_SERVER['HTTP_REFERER']);

    $result = curl_exec($ch);

    curl_close($ch);

    return $result;
  }
}