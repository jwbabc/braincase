<?php
/**
 * Plugin Name: CRC Post From Site
 * Plugin URI: http://www.crc-inc.com/
 * Description: Create posts dynamically from a front end modal, and sends email notifications to users.
 * Author: CRC Incorporated
 * Version: 1.0
 * Date: 11.13.2017
 * Author URI: http://www.crc-inc.com/
 */

include( plugin_dir_path(__FILE__) . 'includes/classes/form-builder.class.php');
include( plugin_dir_path(__FILE__) . 'includes/classes/post-manager.class.php');

/**
 * Injects the modal markup into the targeted DOM element
 */
function crc_post_from_site_build_form() {
    
    $crc_pfs_form = new crc\pfs\FormBuilder();
    
    echo $crc_pfs_form->buildForm();
    wp_die();
}

/**
 * Handles the post data from the form
 * Creates the WP Post
 * Redirects back to the home page
 */
function crc_post_from_site_handle_post() {
    
    // Make sure $_REQUEST is set before proceeding
    
    $wp_nonce  = $_REQUEST['_wp_nonce'];
    $wp_action = $_REQUEST['action'];
    
    if ( wp_verify_nonce($wp_nonce, $wp_action)) {
        
        wp_die('Security check');
        
    } else {
        
        $status = false;
        
        // Pass the data to the post creation class
        $crc_pfs_post_manager = new crc\pfs\PostManager();
        
        $status = $crc_pfs_post_manager->createWPPost($_REQUEST);
        
        if ($status) {
        
            wp_redirect(get_site_url());
            
        } else {
            
            crc_write_log('An error occurred in createWPPost, post was not created.');
        }
        
    }
}

/**
 * Write PlugIn errors to the WP debug log
 */
if (!function_exists('write_log')) {
    
    function crc_write_log ($log)  {
        
        // Make sure that WP_DEBUG is enabled
        if (true === WP_DEBUG) {
            
            if (is_array($log) || is_object($log)) {
                
                // Print out the array or object
                error_log(print_r($log, true));
                
            } else {
                
                // Print out the message sent
                error_log($log);
            }
        }
    }
}


/**
 * Add plugin style sheets
 */
function crc_add_styles() {
    
    $plugin_url = plugins_url ( plugin_basename ( dirname ( __FILE__ ) ) );
    
    wp_enqueue_style( 'crc-pfs-style', $plugin_url.'/includes/css/crc-post-from-site.css' );
}

/**
 * Add plugin javascript files
 */
function crc_add_scripts() {
    
    $plugin_url = plugins_url ( plugin_basename ( dirname ( __FILE__ ) ) );
    
    wp_enqueue_script('jquery');
    wp_enqueue_script('crc-pfs', $plugin_url.'/includes/js/crc-post-from-site.js' , array('jquery'), false, true );
    wp_enqueue_script('crc-pfs-script', $plugin_url.'/includes/js/script.js' , array('jquery', 'crc-pfs'), false, true );
    
    wp_localize_script( 'crc-pfs',
        'wp_ajax',
        array(
            'ajaxUrl'  => admin_url('admin-ajax.php'),
            'nonce'    => wp_create_nonce('unique_id_nonce')
        )
    );
}

// Que stylesheets and scripts
add_action('wp_enqueue_scripts', 'crc_add_styles');
add_action('wp_enqueue_scripts', 'crc_add_scripts');

// Que methods for ajax
add_action('wp_ajax_crc_post_from_site_build_form', 'crc_post_from_site_build_form');

// Que method for $_POST
add_action('admin_post_crc_post_from_site_handle_post', 'crc_post_from_site_handle_post');