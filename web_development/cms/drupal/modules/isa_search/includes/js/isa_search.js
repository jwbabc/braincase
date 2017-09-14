(function($) {
  Drupal.behaviors.isa_search = {
    attach: function (context, settings) {
      
      // Function to wait for pause in typing to execute ajax calls
      function createDelay(ms) {
        
        var timer = 0;
        
        return function(callback) {
          clearTimeout (timer);
          timer = setTimeout(callback, ms);
        };
      };
      
      // Execute an AJAX call to search for the contact's node data
      function searchForContact(text, textInput, resultsContainer) {
        $.ajax({
          url: Drupal.settings.basePath + 'isa-search/ajax/search',
          type: 'post',
          data: 'query=' + text,
          dataType: 'json',
          beforeSend: function () {
            // Disable the search text field
            textInput.prop('disabled', true);
            resultsContainer.addClass('loader');
            resultsContainer.removeClass('hide-form-search');
            resultsContainer.addClass('show-form-search');
          },
          complete: function () {
            textInput.prop('disabled', false);
            textInput.focus();
          },
          success: function (data) {
            resultsContainer.removeClass('loader');

            if (data.success === true) {
              resultsContainer.removeClass('hide-form-search');
              resultsContainer.addClass('show-form-search');

              resultsContainer.html(data.content);
            } else {
              resultsContainer.addClass('hide-form-search');
              resultsContainer.removeClass('show-form-search');
            }
          }
        });
      }
      
      var delay = createDelay(500);
      
      // Keyup event listener
      $('.isa-search').on('keyup', '#isa-search-text', function () {  
          var text = $(this).val();
          var textInput = $('#isa-search-text');
          var resultsContainer = $('.isa-slideout-ajax-results');
          
          delay(
            function() {
              if (text.length > 3) {      
                searchForContact(text, textInput, resultsContainer);
              } else {
                resultsContainer.addClass('hide-form-search');
                resultsContainer.removeClass('show-form-search');
                resultsContainer.html('');
              }
            }
          );
        });
    }
  };
  
  Drupal.behaviors.isa_slideout = {
    attach: function (context, settings) {
      
      var slideout = $('.block-isa-search');
      
      $('.isa-slideout-toggle').on('click', function() {
        
        if (slideout.hasClass('open')) {
          slideout.removeClass('open');
        } else {
          slideout.addClass('open');
        }
      });
    }
  };
})(jQuery);


