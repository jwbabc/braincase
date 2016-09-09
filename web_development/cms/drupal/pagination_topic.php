<?php
// Get the node id for the topic
$n = $node->nid;
// Get the title for the topic
$title = $node->title;
// Get the sort order for the article list
$sort = $_GET['sort'];
// Get the current page of the pagination sequence
$currentPage = (int) $_GET['currentpage'];

// Make sure the current page is 1 if currentpage is not available in GET
if ($currentPage === 0) {
    $currentPage = 1;
}

// Variables needed for pagination
$rowsPerPage = 20;
$offset = ($currentPage - 1) * $rowsPerPage;
$range = 3;

if ($title === "Join A Discussion") {
    // Get the channel for the topic
    $sql = "
      SELECT 
				c.field_channel_nid, 
				t.field_category_nid 
			FROM 
				{content_field_channel} c, 
				{content_field_category} t 
			WHERE 
				c.nid = t.field_category_nid AND 
				t.nid = %d";

    $result = db_query($sql, $n);
    $cat = db_fetch_object($result);

    // Use the category id to get the discussions for the channel
    $sql = "
			SELECT 
				count(*) 
			FROM 
				{content_field_channel} ch, 
				{content_type_discussions} d, 
				{node} n, 
				{node_revisions} r 
			WHERE 
				n.nid = r.nid AND 
				r.nid = d.nid AND 
				ch.nid = n.nid AND 
				n.vid = r.vid AND 
				n.vid = d.vid AND 
				ch.vid = n.vid AND 
				ch.field_channel_nid = %d";

    $result = db_query($sql, $cat->field_channel_nid);
} elseif ($title === "Share Your Stories") {
    // TODO: Share your stories content goes here.
} else {
    $values = array(
        "articles",
        "video",
        "slideshow",
        "audio",
        "blog",
        $n,
    );

    $sql = "
			SELECT 
				count(*) 
			FROM 
				{content_field_topic} t, 
				{node} n, 
				{node_revisions} r 
			WHERE 
				t.nid = n.nid AND 
				n.nid = r.nid AND 
				t.vid = n.vid AND 
				n.vid = r.vid AND 
				n.type IN ('%s', '%s', '%s', '%s', '%s') AND 
				t.field_topic_nid = %d";

    $result = db_query($sql, $values);
}

// Calculate the number of rows for the result
$numRows = db_result($result);

// Paginate the number of results from tbe DB
$pagination = paginate($numRows, $rowsPerPage, $currentPage, $offset, $range, $n, $sort);
echo $pagination;
