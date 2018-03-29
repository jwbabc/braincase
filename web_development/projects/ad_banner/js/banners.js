/**
 * Banners class
 * - Injects data from banner_data.json into the DOM elements contained in wlec_banners_live.html
 * - Manages relocating the browser to new URLs pulled from banner_data.json
 *
 * NOTES:
 * JQuery: Dependant upon JQuery 1.6.1 
 * CSS classes: .ad-header and .ad-body get blocked by the AdBlock browser extension, so we changed them.
 */
var Banners = function () {

  // Constructor method
  init = function () {
    //
  };
  
  /**
   * insertContent method
   * Injects the string data from banner_data.JSON into the selected DOM elements
   *
   **/
  insertContent = function() {
    // For every li in ul#ads
    jQuery('ul#ads li.ad').each( function(i) {
      
      // Banner Ad Wrapper URLs
      if (bannerAdData[i].link_url !== "") {
    
        jQuery(this)
          .find('.ad-container-url')
          .attr('href', bannerAdData[i]['link_url']);
  
        jQuery(this)
          .find('.ad-outer-wrapper')
          .attr('data-url', bannerAdData[i]['link_url']);
      }
      
      // Preheader Text
      if (bannerAdData[i]['pre_header_text'] !== "") {
      
        jQuery(this)
          .find('.ad-h2-preheader')
          .html(bannerAdData[i]['pre_header_text']);
      }
      
      // Date / Location Left
      if (bannerAdData[i]['date_location_left'] !== "") {
      
        jQuery(this)
          .find('.ad-date-location-left')
          .html(bannerAdData[i]['date_location_left']);
      }
      
      // Date / Location Middle
      if (bannerAdData[i]['date_location_middle'] !== "") {
            
        jQuery(this)
          .find('.ad-date-location-middle')
          .html(bannerAdData[i]['date_location_middle']);
      }
      
      // Date / Location Right
      if (bannerAdData[i]['date_location_right'] !== "") {
      
        jQuery(this)
          .find('.ad-date-location-right')
          .html(bannerAdData[i]['date_location_right']);
      }
      
      // Header Text
      if (bannerAdData[i]['header_text'] !== "") {
      
        jQuery(this)
          .find('.ad-h1-header')
          .html(bannerAdData[i]['header_text']);
      }
      
      // Body Text
      if (bannerAdData[i]['body_text_1'] !== "") {
      
        jQuery(this)
          .find('.ad-body1')
          .html(bannerAdData[i]['body_text_1']);
      }
      
      // Body Text 2
      if (bannerAdData[i]['body_text_2'] !== "") {
      
        jQuery(this)
          .find('.ad-body2')
          .html(bannerAdData[i]['body_text_2']);
      }
      
      // Ad Button URL and Text
      if (bannerAdData[i]['link_text'] !== "" && bannerAdData[i]['link_url'] !== "") {
      
        jQuery(this)
          .find('.ad-button-url')
          .html(bannerAdData[i]['link_text'])
          .attr('href', bannerAdData[i]['link_url']);
      }
    });
  }
  
  /**
   * gotoURL method
   * Pulls the URL data attribute from the target object and redirects the brower window to the URL
   * 
   * @param object target The target of the DOM element click
   *
   **/
  gotoURL = function(target) {
    window.open($(target).data('url'), '_parent', false);
  }
  
  // Return public methods
  return {
    //init : init,
    insertContent : insertContent,
    gotoURL : gotoURL
  }
}(jQuery);