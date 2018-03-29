/**
 * CRCPostFromSite class
 * 
 * Manages the following for the CRCPostFromSite Wordpress Plugin:
 * -- Display of the form
 * -- Add/Remove image file inputs
 * -- validation of the form (using the JS validate library)
 * -- AJAX transmission of POST form data
 * 
 */
var CRCPostFromSite = (function () {
    
    /**
     * 
     * @returns {undefined}
     */
    init = function () {
        // Build the post from site form link
        buildFormLink(jQuery('.pfs-post-box-container'));

        // Build the post from site form
        buildForm(jQuery('.pfs-post-box-container'));

        // Bind event to the post button
        jQuery(document).on('click', '.pfs-post-link', function(e) {

            showForm();
        });

        // Bind event to the post form close button
        jQuery(document).on('click', '.pfs-postbox .pfs-postbox-close-x', function(e) {
            
            hideForm();
        });

        // Bind event to the post form "add more" button
        jQuery(document).on('click', '.pfs-postbox .pfs-form-add-more-button', function(e) {

            addInputs();
        });

        // Bind event to the post form "remove" buttons
        jQuery(document).on('click', '.pfs-postbox .pfs-form-input-remove', function(e) {

            removeInput(jQuery(this));
        });
        
        // Bind event to the post form submit button
        jQuery(document).on('submit', '.pfs-postbox .pfs-form', function(e) {
            
            submitForm(jQuery(e.target));
            e.preventDefault();
        });
    };
    
    /**
     * 
     * @param {type} data
     * @param {type} target
     * @returns {undefined}
     */
    var sendXHR = function(data, dataType, target = '') {
                
        jQuery.ajax({
            url: wp_ajax.ajaxUrl,
            data: data,
            type: 'post',
            dataType: dataType,
            success: function(response) {
                
                if (response === 0 || target === '') {
                    
                    alert(response);
                    
                } else {
                    
                    target.append(response);
                }
            }
        });
    };
    
    /**
     * 
     * @param {type} target
     * @returns {undefined}
     */
    var buildFormLink = function(target) {
        
        target.append('<a class="pfs-post-link">New request</a>');
    };
    
    /**
     * 
     * @param {type} target
     * @returns {undefined}
     */
    var buildForm = function(target) {
        
        var data = {
            action: 'crc_post_from_site_build_form',
            nonce: wp_ajax.nonce
        };
        
        sendXHR(data, 'html', target);
    };
    
    /**
     * 
     * @returns {undefined}
     */
    var showForm = function() {
        
        jQuery('.pfs-postbox').show();
    };
    
    /**
     * 
     * @returns {undefined}
     */
    var hideForm = function() {
        
        jQuery('.pfs-postbox').hide();
    };
    
    /**
     * 
     * @param {type} target
     * @returns {undefined}
     */
    var addInputs = function(target) {
        
        // We know the container for our image file inputs
        var container = jQuery('.pfs-form-image-upload-wrapper');
        // Get the id of the last file input in the container
        var lastId = container.find('input').last().attr('id');
        // Increment the id for the new input
        var newId = parseInt(lastId.substring(9));
        newId++;
        
        // Append the new input to the container div
        container.append('<input id="pfs-image' + newId + '" type="file" name="image' + newId + '"><a id="pfs-remove-input' + newId + '" class="pfs-form-input-remove">Remove</a>');
    };
    
    /**
     * 
     * @param {type} target
     * @returns {undefined}
     */
    var removeInput = function(target) {
        
        // We know the container for our image file inputs
        var container = jQuery('.pfs-form-image-upload-wrapper');
        // Get the id for the input number for the input to remove
        var targetIdNum = target.attr('id').substr(16);
        // Remove the input element and its remove button based on the targetId
        jQuery('#pfs-image' + targetIdNum).remove();
        jQuery('#pfs-remove-input' + targetIdNum).remove();
    };
    
    /**
     * 
     * @param {type} form
     * @returns {Boolean}
     */
    var validateForm = function(form) {
        
        var emptyFields = [];
        
        // Find all empty fields in the form, and push them into the array
        form.find(':text, textarea, select')
            .filter(
                function() {
                    
                    if (jQuery.trim(this.value) === '') {
                        emptyFields.push(jQuery(this));
                    } else {
                        jQuery(this).removeClass('error');
                    }
                }
            );
        
        // Return boolean value based on if empty fields exist in the form
        if(emptyFields.length > 0){
            
            for (var i in emptyFields) {
                
                emptyFields[i].addClass('error');
            }
            
            return false;
            
        } else {
            
            return true;
        }
    };
    
    /**
     * 
     * @param {type} form
     * @returns {undefined}
     */
    var submitForm = function(form) {
        
        // Validate form fields and return errors
        if (validateForm(form)) {
            // If form data is valid, submit the form
            form.submit();
        } else {
            
        }
    };
    
    // Return public methods
    return {
        init: init
    };
    
})(jQuery);