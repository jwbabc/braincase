<?php
function convert_smart_quotes($string) {
  $search = array(
    chr(145), 
    chr(146), 
    chr(147), 
    chr(148), 
    chr(151)
  );
  
  $replace = array(
    '&lsquo;', 
    '&rsquo;', 
    '&ldquo;', 
    '&rdquo;', 
    '&mdash;'
  ); 
  
  return str_replace($search, $replace, $string);
}