<?php
  require_once '/home/tptadmin/scripts/swift-mailer/lib/swift_required.php';
  
  // Connect to the DB
  mysql_connect("ip", "user", "password");
  mysql_select_db("database");
  
  date_default_timezone_set("America/New_York");
 
  $date = date("mjY_His");
  $dir = "/home/tptadmin/articles/";
  $filename = 'na_last_50_articles_'.$date.'.csv';
  
  $fp = fopen($dir.$filename, "w");
  
  $sql = "
    SELECT
      node.nid,
      node.type, 
      node.title,
      node.created
    FROM
      node
    WHERE
      node.type IN ('articles','contrib_articles') 
    ORDER BY 
      created desc 
    LIMIT 50";
  
  $result = mysql_query($sql);
  
  $articles = array();
  
  while ($row = mysql_fetch_object($result)) {
    $articles[] = $row;
  };
  
    
  foreach ($articles as $k => $v) {
    // Use the nid to get the url alias for the node
    $sql = "
      SELECT
        dst
      FROM
        url_alias
      WHERE
        src = 'node/".$v->nid."'";
        
    $result = mysql_query($sql);
    
    while ($row = mysql_fetch_object($result)) {
      $articles[$k]->url = $row->dst;
    }
  }
 
  // Fetch a row and write the column names out to the file
  $line = '';
  $line .= '"nid","type","title","url","created"';
  $line .= "\n";
  fputs($fp, $line);
  
  // Remove the result pointer back to the start
  mysql_data_seek($result, 0);
  
  // Loop through the actual data
  foreach ($articles as $item) {
    $line = '';
    $line .= '"'.$item->nid.'","'.$item->type.'","'.$item->title.'","'.$item->url.'","'.$item->created.'"';
    $line .= "\n";
    fputs($fp, $line);
  }
  
  fclose($fp);
  
  // Mail the list
  $message = Swift_Message::newInstance();
  $message->setSubject('Latest 50 articles for '.$date);
  $message->setBody('Attached is the list of the latest 50 articles created on Next Avenue.', 'text/html');
  
  $attachment = Swift_Attachment::fromPath($dir.$filename);
  $message->attach($attachment);
  
  $message->setFrom('feedback@nextavenue.org');
  $message->setTo(array('jback@tpt.org', 'lhogan@nextavenue.org'));
  
  //Create the Transport
  $transport = Swift_SendmailTransport::newInstance();
  
  // Create the Mailer using your created Transport
  $mailer = Swift_Mailer::newInstance($transport);
  
  // Send the message
  $result = $mailer->send($message);
?>