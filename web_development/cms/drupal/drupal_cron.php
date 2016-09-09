<?php
  error_reporting(E_ALL); ini_set('display_errors', '1');

  $ch = curl_init(); 
  curl_setopt($ch, CURLOPT_URL,'http://staging.nextavenue.org/cron.php'); 
  curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
  curl_setopt($ch, CURLOPT_USERPWD, "user:password");  
  curl_setopt($ch, CURLOPT_FOLLOWLOCATION,1);

  curl_exec($ch); 
  curl_close($ch);
?>
