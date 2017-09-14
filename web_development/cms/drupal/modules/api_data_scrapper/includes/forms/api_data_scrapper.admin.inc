<?php
/**
 * Page callback: Current API Data Scrapper Settings
 *
 * @see api_data_scrapper_menu()
 */
function api_data_scrapper_form($form, &$form_state) {
  
  // Init the form container
  $form = [];
  
  // Form header
  $form['api_credentials'] = [
    '#markup' => t(''
        . '<div>'
        .   '<p>This configuration page contains all the keys and endpoints for our data source APIs used by the API Data Scrapper<p>'
        . '</div>'),
  ];
  
  // Google Civic Information API
  $form['api_1'] = [
    '#type' => 'fieldset',
    '#title' => t('Google Civic Information API'),
    '#description' => t(''
        . '<div>'
        .   'These credentials allow us to use the API available at <a href="https://developers.google.com/civic-information/" target="_blank">https://developers.google.com/civic-information/</a>. '
        .   '<ul>'
        .     '<li>First you will need to register your website with Google <a href="https://developers.google.com/civic-information/docs/using_api" target="_blank">here</a>. They will generate an API key for you.</li>'
        .     '<li>Documentation for the API is located <a href="https://developers.google.com/civic-information/docs/v2/" target="_blank">here</a>.</li>'
        .     '<li>You can experiment with the API using the <a href="https://developers.google.com/apis-explorer/#p/civicinfo/v2/" target="_blank">Google APIs Explorer</a>.</li>'
        .   '<ul>'
        . '</div>'),
    '#collapsible' => TRUE,
    '#collapsed' => FALSE,
  ];
  
  $form['api_1']['api_data_scrapper_api_1_key'] = [
    '#type' => 'textfield',
    '#title' => t('API Key'),
    '#default_value' => variable_get('api_data_scrapper_api_1_key'),
    '#size' => 60,
    '#maxlength' => 128,
    '#required' => FALSE,
  ];
  
  $form['api_1']['api_data_scrapper_api_1_endpoint'] = [
    '#type' => 'textfield',
    '#title' => t('API Endpoint (URL)'),
    '#default_value' => variable_get('api_data_scrapper_api_1_endpoint'),
    '#size' => 60,
    '#maxlength' => 128,
    '#required' => FALSE,
  ];
  
  // govtrack.us API
  $form['api_2'] = [
    '#type' => 'fieldset',
    '#title' => t('govtrack.us API'),
    '#description' => t(''
        . '<div>'
        .   'These credentials allow us to use the API available at <a href="https://www.govtrack.us/" target="_blank">https://www.govtrack.us</a>. '
        .   '<ul>'
        .     '<li>The developer documentation is located <a href="https://www.govtrack.us/developers/api" target="_blank">here</a>.</li>'
        .     '<li>There is no API key for this service, but you have to agree to their <a href="https://www.govtrack.us/developers/license" target="_blank">Data Terms of Service</a>.</li>'
        .     '<li>They also have their databases available as Raw Bulk Data, you can find more information about that <a href="https://www.govtrack.us/developers/data" target="_blank">here</a>.</li>'
        .   '<ul>'
        . '</div>'),
    '#collapsible' => TRUE,
    '#collapsed' => FALSE,
  ];
  
  $form['api_2']['api_data_scrapper_api_2_endpoint'] = [
    '#type' => 'textfield',
    '#title' => t('API Endpoint (URL)'),
    '#default_value' => variable_get('api_data_scrapper_api_2_endpoint'),
    '#size' => 60,
    '#maxlength' => 128,
    '#required' => FALSE,
  ];
  
  $form['api_data_scrapper_csv_output_path'] = [
    '#type' => 'textfield',
    '#title' => t('CSV file output path'),
    '#description' => t('Specify a filepath for your CSV files, this will default to <strong>sites/all/default/files</strong>'),
    '#default_value' => variable_get('api_data_scrapper_csv_output_path'),
    '#size' => 60,
    '#maxlength' => 128,
    '#required' => FALSE,
  ];
  
  return system_settings_form($form);
}