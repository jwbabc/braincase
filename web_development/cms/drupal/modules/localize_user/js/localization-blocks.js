function readCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}

function getCurrentLocalHubCopy(cookie, nodeId) {
  var status = '';
  var urlString = '/get_local_hub_copy?nid='+nodeId
  // Call the URL via AJAX to return the latest Local Hub copy for the affiliate.
  $.ajax({
    url: urlString,
    dataType: "json",
    beforeSend: function() {
      // Construct message
      status = "Calculating data...";
    },
    error:function(xhr, error){
      if(xhr.status == 0){
        status = 'You are offline!! Please check your network.';
      }else if(xhr.status == 404){
        status = 'Requested URL not found.';
      }else if(xhr.status == 500){
        status = 'Internal server error.';
      }else if(error == 'parsererror'){
        status = 'Error. Parsing JSON request failed.';
      }else if(error == 'timeout'){
        status = 'Request timed out.';
      }else {
        status = 'An unknown error has occured. '+xhr.responseText;
      }
      return false;
    },
    success: function(response) {
      // Place the local copy into the cookie.
      if (response.field_local_hub_copy_value) {
        cookie.local_hub_copy = response.field_local_hub_copy_value;
      } else {
        cookie.local_hub_copy = '';
      }

      // Clear the contents of the target DOM elements
      $('div#affiliates').html('');
      $('div#block-localize_user-1 div.content h4').html('');
      $('div#block-localize_user-1 p.local-hub-copy').html('');

      // Assign the path to the module
      var modulePath = "/sites/all/modules/custom/localize_user";
      // Construct the output string
      var output = '';

      // If the logo is not co-branded place the PBS logo image inside the div
      if (cookie.co_branded === false) {
        output = output + '<div id="pbs-container">';
        output = output +   '<a href="http://www.pbs.org" target="_blank">';
        output = output +     '<img src="'+modulePath+'/img/pbs-logo.png" />';
        output = output +   '</a>';
        output = output + '</div>';
        output = output + '<div id="img-container">';
        output = output +   '<a href="'+cookie['small_url']+'" target="_blank"><img src="'+cookie['small']+'" /></a>';
        output = output + '</div>';
      } else {
        output = output + '<div id="img-container">';
        output = output +   '<a href="'+cookie['small_url']+'" target="_blank"><img src="'+cookie['small']+'" /></a>';
        output = output + '</div>';
      }
      // Add the new icon to the localization area block
      $('div#affiliates').html(output);
      // Add the new information to the local hub block
      $('div#block-localize_user-1 div.content h4').html('<a href="'+cookie['small_url']+'" target="_blank"><img src="'+cookie['icon']+'" />'+cookie['name']+'</a>');
      $('div#block-localize_user-1 p.local-hub-copy').html(cookie['local_hub_copy']);
    }
  });
}

$(document).ready(function() {
  // Read in the cookie from the document
  var cookie = readCookie('na_affiliate');
  if (cookie) {
    // Prep the cookie for manipulation
    cookie = Drupal.parseJson(decodeURI(unescape(cookie)));
    cookie.name = cookie.name.split('+').join(' ');
    // Init the AJAX call to get the latest local hub copy
    var status = getCurrentLocalHubCopy(cookie, cookie.nid);
  }
});