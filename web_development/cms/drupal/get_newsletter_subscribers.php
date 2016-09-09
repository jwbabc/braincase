<?php
  require_once '/home/tptadmin/scripts/swift-mailer/lib/swift_required.php';
  
  // Connect to the DB
  mysql_connect("ip", "user", "password");
  mysql_select_db("database");
  
  date_default_timezone_set("America/New_York");
 
  $date = date("mjY_His");
  $dir = "/home/tptadmin/subscribers/";
  $filename = 'na_subscribers_'.$date.'.csv';
  
  $fp = fopen($dir.$filename, "w");
  
  $sql = "
    SELECT
      users.uid,
      users.name,
      first_name.value first_name,
      last_name.value last_name,
      users.mail
     
    FROM
      profile_values,
      users
     
    LEFT JOIN
      profile_values first_name
    ON
      users.uid = first_name.uid AND
      first_name.fid = 22
     
    LEFT JOIN
      profile_values last_name
    ON
      users.uid = last_name.uid AND
      last_name.fid = 23
     
    WHERE
      users.uid = profile_values.uid AND
      users.status = 1 AND
      profile_values.fid = 29 AND
      profile_values.value = 1";
  
  $result = mysql_query($sql);
  
  // Fetch a row and write the column names out to the file
  $row = mysql_fetch_assoc($result);
  $line = "";
  $comma = "";
  
  foreach($row as $name => $value) {
    $line .= $comma . '"' . str_replace('"', '""', $name) . '"';
    $comma = ",";
  }
  
  $line .= "\n";
  
  fputs($fp, $line);
  
  // Remove the result pointer back to the start
  mysql_data_seek($result, 0);
  
  // Loop through the actual data
  while($row = mysql_fetch_assoc($result)) {
    $line = "";
    $comma = "";
    foreach($row as $value) {
      $line .= $comma . '"' . str_replace('"', '""', $value) . '"';
      $comma = ",";
    }
    $line .= "\n";
    fputs($fp, $line);
  }
  
  fclose($fp);
  
  // Mail the list
  $message = Swift_Message::newInstance();
  $message->setSubject('Next Avenue Subscribers for '.$date);
  $message->setBody('Attached is the list of subscribers for the Next Avenue Newsletter.', 'text/html');
  
  $attachment = Swift_Attachment::fromPath($dir.$filename);
  $message->attach($attachment);
  
  $message->setFrom('feedback@nextavenue.org');
  $message->setTo(array('jback@tpt.org', 'JDaenzer@tpt.org','bkirchoff@nextavenue.org'));
  
  //Create the Transport
  $transport = Swift_SendmailTransport::newInstance();
  
  // Create the Mailer using your created Transport
  $mailer = Swift_Mailer::newInstance($transport);
  
  // Send the message
  $result = $mailer->send($message);
?>
