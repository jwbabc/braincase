$(document).ready(function() {
  console.log('localization-choose.js initialized');
  console.log(Drupal.settings.affiliates);
  
  var html = '';
  html = html + '<div class="affiliate-dialog-header">';
  html = html +   '<h6>CHOOSE YOUR STATION</h6>';
  html = html +   '<p>We have found several affiliates that service your area, please choose from the stations below.</p>';
  html = html + '</div>'
  
  html = html + '<div class="affiliate-dialog-content">';
  html = html +   '<div class="affiliate-logo-container">';
  for (i in Drupal.settings.affiliates.data) {
    html = html +   '<div class="affiliate-logo">'
    html = html +     '<a href="'+ Drupal.settings.affiliates.data[i].localizeURL +'">';
    html = html +       '<img src="'+ Drupal.settings.affiliates.data[i].logoPath +'" />';
    html = html +       '<p>' + Drupal.settings.affiliates.data[i].name + '</p>';
    html = html +     '</a>';
    html = html +   '</div>'
  };
  html = html +   '</div>';
  
  html = html +   '<div class="affiliate-dialog-footer">'
  html = html +     '<p>If you do not see your local public television station listed, please click the button below.';
  html = html +     '<div class="stations">';
  html = html +       Drupal.settings.affiliates.chooseBtn;
  html = html +     '</div>';
  html = html +   '</div>';
  
  html = html + '</div>';
  
  // Initialize the a tag to open the modal
  $.fancybox(
    html,
    {
      autoDimensions: true,
      autoSize: true,
      overlayColor: '#404040',
      centerOnScroll: false,
      closeBtn: true,
      scrolling: 'no',
      onStart: function() {},
      onComplete: function() {}
    });
});


