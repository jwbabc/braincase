<?php
/**
 * Page callback: Current ISA Contacts Search Tab Settings
 *
 * @see isa_contacts_search_menu()
 */
function isa_search_settings_form($form, &$form_state) {
  
  // Init the form container
  $form = [];
  
  // Form header
  $form['isa_search_settings'] = [
    '#markup' => t(''
        . '<div>'
        .   '<p>This configuration page contains all the configurations needed for ISA Contacts Search<p>'
        . '</div>'),
  ];
  
  return system_settings_form($form);
}
