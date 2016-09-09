<?php
  // Connect to the DB
  mysql_connect("ip", "user", "password");
  mysql_select_db("database");

  $sql = "
    SELECT
      src
    FROM
      url_alias
    WHERE
      src LIKE '%node%'";
  
  $result = mysql_query($sql);
  
  $aliasedNodes = array();
  
  while ($row = mysql_fetch_object($result)) {
    $nodeString = '';
    $nodeString = $row->src;
    $nodeString = str_replace('node/', '', $nodeString);
   
    $aliasedNodes[] = (int) $nodeString;
  };
  
  $sql = "
    SELECT
      nid
    FROM
      node";
  
  $result = mysql_query($sql);
  
  $unaliasedNodes = array();
  
  while ($row = mysql_fetch_object($result)) {
    if (in_array($row->nid, $aliasedNodes)) {
      // Do nothing.
    } else {
      $unaliasedNodes[] = (int) $row->nid;
      echo $row->nid."\n";
    }
  };
?>