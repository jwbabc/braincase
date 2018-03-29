// JavaScript Document
jQuery(document).ready( function() {
  
  // Initialize wtRotator
  jQuery(".container").wtRotator({
    width: 557,
    height: 310,
    thumb_width: 20,
    thumb_height: 20,
    button_width: 20,
    button_height: 20,
    button_margin: 5,
    auto_start: true,
    delay: 10000,
    play_once: false,
    transition: "h.slide",
    transition_speed: 800,
    auto_center: true,
    easing: "",
    cpanel_position: "inside",
    cpanel_align: "BL",
    //timer_align:"top",
    display_thumbs: true,
    display_dbuttons: true,
    display_playbutton: true,
    display_thumbimg: false,
    display_side_buttons: false,
    display_numbers: true,
    display_timer: false,
    mouseover_pause: false,
    cpanel_mouseover: false,
    text_mouseover: false,
    text_effect: "fade",
    text_sync: true,
    tooltip_type: "none",
    lock_tooltip: true,
    shuffle: false,
    block_size: 75,
    vert_size: 55,
    horz_size: 50,
    block_delay: 25,
    vstripe_delay: 75,
    hstripe_delay: 180
  });
  
  // Insert the content into the banner ads
  Banners.insertContent();
});