<?php

namespace crc\pfs;

/**
 * This class manages the following:
 * - Generation and modification of the post from site form markup.
 * 
 */
class FormBuilder {
    
    /**
     * The HTML markup for the form
     * @var string 
     */
    private $_html;
    
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
     * buildForm
     * Builds the HTML markup for the Post from Site modal
     * 
     * @return string The HTML markup
     */
    public function buildForm() {
        
        if (current_user_can('publish_posts')) {
            
            $this->_html = '';
            
            $categories_html = $this->_buildCategoriesSelect();
            $user_roles_html = $this->_buildUserRolesSelect();
            $priorities_html = $this->_buildPrioritiesSelect();
            
            $this->_html = $this->_html
                .'<span class="pfs-status"></span>'
                .'<div class="pfs-postbox">'
                .   '<h4>New request</h4>'
                .   '<div class="pfs-postbox-close-x">'
                .       '<a>x</a>'
                .   '</div>'
                .   '<form class="pfs-form" method="post" action="'.esc_url(admin_url('admin-post.php')).'" enctype="multipart/form-data">'
                .       '<input type="hidden" id="action" name="action" value="crc_post_from_site_handle_post">'
                .       '<input type="hidden" id="_wp_nonce" name="_wp_nonce" value="'.wp_create_nonce('unique_id_nonce').'" />'
                .       '<input type="hidden" name="MAX_FILE_SIZE" value="">'
                .       '<h2>Title</h2>'
                .       '<input type="text" name="pfs-form-title" value="">'
                .       '<h2>Description</h2>'
                .       '<textarea name="pfs-form-description" rows="5" cols="30"></textarea>'
                .       '<h2>Attach screenshot (if applicable)</h2>'
                .       '<div class="pfs-form-image-upload-wrapper">'
                .           '<input id="pfs_image0" type="file" name="image0">'
                .       '</div>'
                .       '<div class="pfs-form-add-more-button">'
                .           'Add more'
                .       '</div>'
                .       $priorities_html
                .       $categories_html
                .       $user_roles_html
                .       '<div class="clear"></div>'
                .       '<input class="pfs-form-submit" type="submit" name="submit" value="Submit">'
                .   '</form>'
                .   '<div class="clear"></div>'
                .'</div>';
        } else {
           $this->_html = '<p>Login to post</p>'; 
        }
        
        return $this->_html;
    }
    
    /**
     * _buildCategoriesSelect
     * Builds the HTML markup for the category select DOM element
     * 
     * @return string The HTML markup
     */
    private function _buildCategoriesSelect() {
        
        $args = array(
            'orderby' => 'name',
            'order' => 'ASC',
            'hide_empty' => 0,
        );
        
        $categories = get_terms('category', $args);
        
        if (isset($categories) && !empty($categories)) {
            
            // Remove unwanted catefories from the list before we generate the markup
            $validCategories = array(
                'Print',
                'Promotional items',
                'Reports',
                'Staffing',
                'Supplier connection issues',
                'Surveys'
            );
            
            $validCategorySelectList = array();
            
            foreach ($categories as $category) {
                
                if (in_array($category->name, $validCategories)) {
                    
                    $validCategorySelectList[] = $category;
                    
                } else {
                    
                    continue;
                }
            }
            
            // Generate the markup for the category select input
            $html = ''
                .'<div class="pfs-form-select-wrapper pfs-form-category-select-wrapper">'
                .   '<div class="pfs-form-header-wrapper">'
                .       '<h2>Category<br><span>(use shift-click to choose more than one category.)</span></h2>'
                .   '</div>'
                .   '<select class="pfs-form-category-select" name="categories[]" multiple="multiple">';

            foreach ($validCategorySelectList as $category) {
                
                $html = $html . '<option value='.$category->term_id.' >'.$category->name.'</option>';
            }

            $html = $html
                .   '</select>'
                .'</div>';
        } else {
            $html = '';
        }
        
        return $html;
    }
    
    /**
     * _buildUserRolesSelect
     * Builds the HTML markup for the user roles select DOM element
     * 
     * @return string The HTML markup
     */
    private function _buildUserRolesSelect() {
        
        $userRoleArgs = array(
            'orderby' => 'name',
            'order' => 'ASC',
            'hide_empty' => 0
        );
        
        $userRoleTerms = get_terms( 'userrole', $userRoleArgs );
        
        if (isset($userRoleTerms) && !empty($userRoleTerms)) {
            
            // Remove unwanted catefories from the list before we generate the markup
            $validUserRoles = array(
                'Admin',
                'Customer',
                'Enroller',
                'General User',
                'PM',
                'PMA',
                'Vendor'
            );

            $validUserRolesSelectList = array();
            
            foreach ($userRoleTerms as $userRole) {
                
                if (in_array($userRole->name, $validUserRoles)) {
                    
                    $validUserRolesSelectList[] = $userRole;
                    
                } else {
                    
                    continue;
                }
            }
                        
            $html = ''
                .'<div class="pfs-form-select-wrapper pfs-form-user-role-select-wrapper">'
                .   '<div class="pfs-form-header-wrapper">'
                .       '<h2>User roles affected<br><span>(use shift-click to choose more than one user role.)</span></h2>'
                .   '</div>'
                .   '<select class="pfs-form-user-role-select" name="user-roles[]" multiple="multiple">';

            foreach ($validUserRolesSelectList as $userRole) {
                
                $html = $html . '<option value='.$userRole->slug.' >'.$userRole->name.'</option>';
            }

            $html = $html
                .   '</select>'
                .'</div>';
        } else {
            $html = '';
        }
        
        return $html;
    }
    
    /**
     * _buildPrioritiesSelect
     * Builds the HTML markup for the priorities select DOM element
     * 
     * @return string The HTML markup
     */
    private function _buildPrioritiesSelect() {
        
        $priority_args = array(
            'orderby' => 'name',
            'order' => 'ASC',
            'hide_empty' => 0
        ); 

        $priority_terms = get_terms( 'priority', $priority_args );
        $priority_terms_ordered = array('0','1','2','3');
        
        foreach ($priority_terms as $term){
            
            switch ($term->slug) {
                case 'low':
                    array_splice($priority_terms_ordered, 0, 1, $term->term_id);
                    break;
                case 'medium':
                    array_splice($priority_terms_ordered, 1, 1, $term->term_id);
                    break;
                case 'high':
                    array_splice($priority_terms_ordered, 2, 1, $term->term_id);
                    break;
                case 'urgent':
                    array_splice($priority_terms_ordered, 3, 1, $term->term_id);
                    break;
            }
        }
        
        if (isset($priority_terms) && !empty($priority_terms)) {
        
            $html = ''
                .'<div class="pfs-form-select-wrapper pfs-form-priority-select-wrapper">'
                .   '<div class="pfs-form-header-wrapper">'
                .       '<h2>Priority level</h2>'
                .   '</div>'
                .   '<select class="pfs-form-priority-select" name="priority[]">';

            foreach ($priority_terms_ordered as $priority_term_id) {
                
                $priority_term = get_term_by('id', $priority_term_id, 'priority');
                
                $html = $html . '<option value='.$priority_term->slug.' >'.$priority_term->name.'</option>';
            }

            $html = $html
                .   '</select>'
                .'</div>';
        } else {
            $html = '';
        }
        
        return $html;
    }
}
