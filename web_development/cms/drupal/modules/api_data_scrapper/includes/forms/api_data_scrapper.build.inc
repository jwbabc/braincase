<?php
/**
 * Page callback: Current API Data Scrapper Build
 *
 * @see api_data_scrapper_menu()
 */
function api_data_scrapper_build_form($form, &$form_state) {
  $form = [];
  
  $form['api_build'] = [
    '#markup' => t(''
        . '<div>'
        .   '<h1>Welcome to the API Data Scrapper!</h1>'
        .   '<ol>'
        .     '<li>Ensure that your API keys and endpoints are set on the <a href="/admin/config/system/api_data_scrapper/settings">settings</a> page.</li>'
        .     '<li>Specify a filepath for your CSV files on the <a href="/admin/config/system/api_data_scrapper/settings">settings</a> page (CSV files will be written to <strong>sites/all/default/files</strong> by default).</li>'
        .     '<li>Click the button to build your CSV files from the API Endpoints.</li>'
        .   '</ol>'
        .   '<br />'
        . '</div>'),
  ];
  
  $form['submit'] = array(
    '#type' => 'submit',
    '#ajax' => array(
      'callback' => 'api_data_scrapper_form_submit_callback'
    ),
    '#value' => t('Generate CSV files'),
  );
  
  return $form;
}

/**
 * Callback for Submit Button AJAX call
 */
function api_data_scrapper_form_submit_callback($form, $form_state) {
  //
}

/**
 * Implements hook_form_submit
 */
function api_data_scrapper_build_form_submit($form, &$form_state) {
  
  // Init the APIDataScrapper base class
  $scrapper = new APIDataScrapper();
  // Query the APIs
  $status = $scrapper->buildDataset('api_1');
  $status = $scrapper->buildDataset('api_2');
  
  if ($status) {
    drupal_set_message('CSV files has been created in ' . $scrapper::getOutputPath(), 'status');
  } else {
    drupal_set_message('An error occurred creating the CSV files', 'error');
  }
}