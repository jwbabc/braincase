<?php
/**
 * Creating a new drupal node
 *
 */
require_once './includes/bootstrap.inc';
drupal_bootstrap(DRUPAL_BOOTSTRAP_FULL);

$new_page_node = array('type' => 'page');

$values = array();
$values['title'] = "Welcome to Unibia";
$values['title'] = "Welcome to Unibia";
$values['body'] = "This is the content that appears on the page";
$values['uid'] = 1;
$values['name'] = "admin";
$values['status'] = 1;
$values['field_address'] = array(array('street1' => '132 N Main St.', 'city' => 'Naples', 'state' => 'FL', 'zip' => '34100', 'country' => 'US'));
$values['field_phone_number'] = array(array('value' => '239-123-1111'));
$existing_pagenode = node_load(2);
print_r($existing_pagenode);

$result = drupal_execute('page_node_form', $values, $new_page_node);

//Extract the node ID from the result string
$nid = str_replace("node/", "", $result);

//Get the term ID by name
$term = taxonomy_get_term_by_name('Legacy');
//Assign it to the node
taxonomy_node_save($nid, $term);

/**
 * Updating a drupal node
 *
 */
$contact_node = node_load(32);

$values['title'] = 'New Title.';
$values['body'] = $node->body;
$values['status'] = 1;
$values['field_address'] = $node->field_address; //CCK Field
$values['field_email'] = $node->field_email;  //CCK Field
$values['field_fax'] = $node->field_fax;  //CCK Field
$values['field_phone_number'] = $node->field_phone_number;  //CCK Field

$result = drupal_execute('contact_node_form', $values, $contact_node);


/**
 * Example of adding a node reference to a CCK field
 *
 */
$values['field_mynode_reference'] = array('nids' => '30');

/**
 * Be sure to assign an author for the piece of content
 *
 */
global $user;
$user = user_load(array(uid => 1));
