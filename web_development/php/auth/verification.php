<?php
  // ini_set("display_errors","1");
  // ERROR_REPORTING(E_ALL);
  CRYPT_BLOWFISH or die ('No Blowfish found.');

  $link = mysql_connect('host', 'user', 'password') or die('Not connected : ' . mysql_error());

  mysql_select_db('db', $link) or die ('Not selected : ' . mysql_error());

  $password = mysql_real_escape_string($_GET['password']);
  $email = mysql_real_escape_string($_GET['email']);

  //This string tells crypt to use blowfish for 5 rounds.
  $Blowfish_Pre = '$2a$05$';
  $Blowfish_End = '$';
  
  $sql = "SELECT salt, password FROM users WHERE email='".$email."'";
  $result = mysql_query($sql) or die( mysql_error() );
  $row = mysql_fetch_assoc($result);

  $hashed_pass = crypt($password, $Blowfish_Pre . $row['salt'] . $Blowfish_End);

  if ($hashed_pass === $row['password']) {
    echo 'Password verified!';
  } else {
    echo 'There was a problem with your user name or password.';
  }