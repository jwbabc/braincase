<?php

/**
 * Page callback: Contacts search form
 *
 * @see isa_contacts_search_menu()
 */
function isa_search_form($form, &$form_state) {
  $form = [];
 
  $form['search'] = [
    '#title' => t('Contacts'),
    '#type' => 'textfield',
    '#maxlength' => 60,
    '#autocomplete_path' => 'isa-search/ajax/search',
  ];
 
  $form['submit'] = [
    '#type' => 'submit',
    '#value' => 'Submit',
  ];
 
  return $form;
}