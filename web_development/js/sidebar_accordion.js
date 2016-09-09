$(document).ready(function(){
  // Hide all sidebar divs
  $('div.sidebar-channel ul.categories li div#cat-0').hide();
  $('div.sidebar-channel ul.categories li div#cat-1').hide();
  $('div.sidebar-channel ul.categories li div#cat-2').hide();
  // Open the div that contains the current node
  $('<?php echo $slideToggleDiv ?>').show();
  // Remove the icon and replace it with an open icon
  $('<?php echo $slideToggleDiv ?>').parent().parent().find('li h2 a span').toggleClass( 'opened closed' );
  // Init the click event for the expand/collapse button
  $('div.sidebar-channel ul.categories li h2 a').click(function(event) {
    // Prevent the link from going anywhere
    event.preventDefault();
    // Show the div for the category clicked
    $(this).parent().parent().find('div').slideToggle();
    // Change the arrow to point up or down
    $(this).children('span').toggleClass( 'opened closed' );
  });
});