# Question set - form generation
function qset_form() {
	$sql = "SELECT * FROM qset WHERE active=0 ORDER BY qset_id";    
 	$result = db_query($sql);   
	$c = 0;
	while($currrow = db_fetch_array($result)){
    $qset = 'q_set'.$c;  
    $form[$qset] = array(   
     '#type' => 'fieldset',    
     '#title' => $currrow['title'],    
     '#collapsible' => TRUE,    
     '#collapsed' => TRUE,
     '#prefix' => '<div class="">',
     '#sufix' => '</div>',
    );
		$form[$qset]['del_qset'] = array(
			'#type' => 'checkbox',
			'#title' => t('Delete the Question Set'),
		);
		$form[$qset]['incup_qset'] = array(
			'#type' => 'checkbox',
			'#title' => t('Move the question set up'),
		);
		$form[$qset]['incdwn_qset'] = array(
			'#type' => 'checkbox',
			'#title' => t('Move the question set down'),
		);
		$form[$qset]['title'] = array(
			'#type' => 'textfield',
			'#title' => t('Title'),
			'#default_value' => $currrow['title'],
			'#size' => 60,
			'#maxlength' => 100,
			'#description' => t('This is the title of the question set.'),
		);
		$form[$qset]['author'] = array(
			'#type' => 'textfield',
			'#title' => t('Author'),
			'#default_value' => $currrow['author'],
			'#size' => 60,
			'#maxlength' => 100,
			'#description' => t('This is the author of the question set.'),
		);
		$form[$qset]['date_of_creation'] = array(
			'#type' => 'textfield',
			'#title' => t('Date of Creation'),
			'#default_value' => $currrow['date'],
			'#size' => 60,
			'#maxlength' => 100,
			'#description' => t('Date the question set was created.'),
		);
		$form[$qset]['num_easy'] = array(
			'#type' => 'textfield',
			'#title' => t('Easy questions'),
			'#default_value' => $currrow['num_easy'],
			'#size' => 15,
			'#maxlength' => 10,
			'#description' => t('Total number of easy questions in the question set.'),
		);
		$form[$qset]['num_hard'] = array(
			'#type' => 'textfield',
			'#title' => t('Hard questions'),
			'#default_value' => $currrow['num_hard'],
			'#size' => 15,
			'#maxlength' => 10,
			'#description' => t('Total number of hard questions in the question set.'),
		);
		$form[$qset]['edit_link'] = array(
			'#type' => 'markup',
			'#value' => '<A href="http://www.w3.org/">Edit question set</A>',
		);
    $c++;  
	}
	$output = drupal_get_form('qset_form',$form);
	return $output;
}