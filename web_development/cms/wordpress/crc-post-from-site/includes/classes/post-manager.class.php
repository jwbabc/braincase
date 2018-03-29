<?php

namespace crc\pfs;

/**
 * Description of crc-post-from-site-post-manager
 *
 * @author joelback
 */
class PostManager {
    
    private $_filesUploaded;
    private $_wpPostCreated;
    private $_wpMediaAttachmentIds;
    
    
    /**
     * Constructor Method
     */
    public function __construct() {
        //
    }
    
    /**
     * Destructor Method
     */
    public function __destruct() {
        //
    }
    
    /**
     * createWPPost Method
     * 
     * @param array $data The data array from $_REQUEST
     * @return boolean
     */
    public function createWPPost($data) {
        
        if (is_user_logged_in()) { 
            
            // Make sure we have files to upload from $_REQUEST
            if (isset($_FILES) && !empty($_FILES)) {
                
                $this->_filesUploaded = $this->_createWPMedia($_FILES);
                
            }
            
            // Create the post in WordPress
            $this->_wpPostCreated = $this->_createWPPost($data);
            
            // If everything completed successfully return true
            if ($this->_filesUploaded && $this->_wpPostCreated) {
                
                return true;
                
            } else {
                
                return false;
            }
        }
	
	return false;
    }
    
    /**
     * validateWPMedia
     * Validates whether a file is safe for upload into WordPress
     * 
     * @param type $file
     * @return boolean
     */
    private function _validateWPMedia($file) {
        
        if(isset($file['tmp_name']) && !empty($file['tmp_name'])) { 
                
            if (filesize($file['tmp_name'])){ 

                if (getimagesize($file['tmp_name'])) { 

                    $fileValid = true;

                } else {

                    $fileValid = false;
                }

            } else {

                $fileValid = false;
            }
            
        } else {
            
            $fileValid = false;
        }
        
        return $fileValid;
    }
    
    /**
     * _createWPMedia Method
     * Uploads the imade file data from $_FILES into the WP media library
     * 
     * @param Array $files The $_FILES array from $_REQUEST
     * 
     * @return boolean The success of the upload
     */
    private function _createWPMedia($files) {
        
        //echo '<pre>'; 
        //var_dump($files); 
        //echo '</pre>';
        
        $this->_wpMediaAttachmentIds = array();
        $count = 0;

        foreach($files as $file) {
            
            $valid = $this->_validateWPMedia($file);

            if ($valid){
                
                // These files need to be included as dependencies when on the front end.
                require_once( ABSPATH . 'wp-admin/includes/image.php' );
                require_once( ABSPATH . 'wp-admin/includes/file.php' );
                require_once( ABSPATH . 'wp-admin/includes/media.php' );
                
                // Upload the file to the media library, pretty handy!
                // https://codex.wordpress.org/Function_Reference/media_handle_upload
                
                // Construct the key for the image in $_FILES
                $imageKey = 'image'.$count;
                
                $attachmentId = media_handle_upload($imageKey , 0);
                
                if (is_wp_error($attachmentId)) {
                    
                    //echo '<pre>';
                    //var_dump($attachmentId);
                    //echo '</pre>';
                    
                    return false;
                    
                } else {
                    
                    $this->_wpMediaAttachmentIds[] = $attachmentId;
                }
                
            } else {

                return false;
            }

            $count++;
        }
        
        return true;
    }
    
    /**
     * _validateWPPost
     * Validates the WP Post data sent from $_REQUEST
     * 
     * @param type $data
     * @return boolean
     */
    private function _validateWPPost($data) {
        
        $postValid = false;
        
        if (isset($data['pfs-form-title']) && !empty($data['pfs-form-title'])) {
            
            if (isset($data['pfs-form-description']) && !empty($data['pfs-form-description'])) {
                
                if (isset($data['priority']) && !empty($data['priority'])) {
                    
                    if (isset($data['categories']) && !empty($data['categories'])) {
                        
                        if (isset($data['user-roles']) && !empty($data['user-roles'])) {
                            
                            $postValid = true;
                            
                        } else {
                            
                            $postValid = false;
                            
                        }
                        
                    } else {
                        
                        $postValid = false;
                        
                    }
                    
                } else {
                    
                    $postValid = false;
                    
                }
                
            } else {
                
                $postValid = false;
            }
            
        } else {
            
            $postValid = false;   
        }
        
        return $postValid;
    }
    
    /**
     * 
     * @global type $user_ID
     * @param type $data
     */
    private function _createWPPost($data) {
        
        //echo '<pre>';
        //var_dump($data);
        //echo '</pre>';
        
        $valid = $this->_validateWPPost($data);
                
        if ($valid) {
            
            global $user_ID;
            
            // Construct the title for the WP post
            $title = $data['pfs-form-title'];
            
            // Construct the content for the WP post
            $content = $data['pfs-form-description'];
            
            // Add image attachement markup to the post (if they exist)
            if (
                    $this->_filesUploaded === true && 
                    isset($this->_wpMediaAttachmentIds) && 
                    !empty($this->_wpMediaAttachmentIds)
                ) {
                
                foreach ($this->_wpMediaAttachmentIds as $attachment_id){
                    
                    $fileURL = wp_get_attachment_url($attachment_id);
                    
                    $content .= ''
                        . '<div class="link_image_wrap">'
                        .   '<a href="'.$fileURL.'"><img src="'.$fileURL.'" class="postimg" /></a>'
                        . '</div>'
                        . '<p class="hidden_img_url">'.$fileURL.'</p>';
                }
            }
            
            $categories = $data['categories'];
            $priority   = $data['priority'];
            $userRoles  = $data['user-roles'];
                    
            // Construct the array for the WP post
            $wpPost = array();
            
            $wpPost['post_type']      = 'post';
            $wpPost['post_title']     = $title;
            $wpPost['post_content']   = $content;
            $wpPost['post_author']    = $user_ID;
            $wpPost['comment_status'] = get_option('default_comment_status');          
            $wpPost['post_category']  = $categories;
            
            $wpPostId = wp_insert_post($wpPost);
            
            // Set the priority and user roles
            wp_set_object_terms( $wpPostId, $priority, 'priority', true );
            wp_set_object_terms( $wpPostId, $userRoles, 'userrole', true );

            if ($wpPostId === 0) {
                
                return false;
                
            } else {
                
                wp_publish_post($wpPostId);
            }

        } else {
            
            return false;
        }
        
        return true;

    }
}