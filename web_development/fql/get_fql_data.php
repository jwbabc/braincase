<?php
  $time_start = microtime(true);
  
  // Connect to the DB
  mysql_connect('ip', 'user', 'password');
  mysql_select_db('database');
    
  date_default_timezone_set('America/New_York');
   
  $sql = "
    SELECT
      src,
      dst
    FROM
      url_alias";
  
  $result = mysql_query($sql);
  
  $nodes = array();
  
  while ($row = mysql_fetch_object($result)) {
    $nodes[] = $row;
  }
  
  $fqlData = array();
  
  foreach ($nodes as $item) {
    $fql = 'https://api.facebook.com/method/fql.query?query=';  
    $fql .= urlencode('select like_count, total_count, share_count, click_count from link_stat where url="http://nextavenue.org'.$item->dst.'"');
    
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $fql);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $response = curl_exec($ch);
    curl_close($ch);
      
    $fqlResult = new SimpleXMLElement($response);
    
    $page = (object) array();
    $page->src = $nodes[0]->src;
    $page->stats->like_count = (int) $fqlResult->link_stat->like_count;
    $page->stats->total_count = (int) $fqlResult->link_stat->total_count;
    $page->stats->share_count = (int) $fqlResult->link_stat->share_count;
    $page->stats->click_count = (int) $fqlResult->link_stat->click_count;
    
    $fqlData[] = $page;
  }
  
  print_r ($fqlData);
  
  $time_end = microtime(true);
  $time = $time_end - $time_start;
  
  echo "Script executed in $time seconds\n";