// Classes
import CreatePlayer;
import AttractTimer;
import QuestionTimer;
import MovieClipWatcher;
import SoundLoader;
import XMLLoader;

// Create players
// Instantiate player objects
var player1:CreatePlayer = new CreatePlayer();
var player2:CreatePlayer = new CreatePlayer();
var player3:CreatePlayer = new CreatePlayer();
// Name players
player1.p_name = "Player 1";
player2.p_name = "Player 2";
player3.p_name = "Player 3";

// Create question
// Instantiate question object
var qsetQuestion:CreateQuestion = new CreateQuestion();

// Create Timer
var myCountdownSeconds:Number = 15;
// Instantiate timer object
var qTimer:QuestionTimer = new QuestionTimer(myCountdownSeconds);

// Create Timeout
// Instantiate timeout object
var quizTimeout:AttractTimer = new AttractTimer(180 * 1000);

// Create mcWatcher for quiz_mc container
// Instantiate mcWatcher object
var myQuizWatcher:MovieClipWatcher = new MovieClipWatcher();

// Create SoundLoader objects
// Instantiate SoundLoader object
var gong_snd:SoundLoader = new SoundLoader("sounds/gong.mp3", false);
var music_snd:SoundLoader = new SoundLoader("sounds/music_15s.mp3", false);
var ting_snd:SoundLoader = new SoundLoader("sounds/ting.mp3", false);
var clap_snd:SoundLoader = new SoundLoader("sounds/clap.mp3", false);
var intro1_snd:SoundLoader = new SoundLoader("sounds/intro1.mp3", false);
var intro3_snd:SoundLoader = new SoundLoader("sounds/intro3.mp3", false);
var endRound_snd:SoundLoader = new SoundLoader("sounds/endRound.mp3", false);

// XML Import
// XML filepath
var myXMLPath = "q_sets/";
// Create the xmlQsetList object
var xmlQsetList:XMLLoader = new XMLLoader(myXMLPath + "qset_admin.xml");
// Add a listener for when the list completes loading
xmlQsetList.addEventListener (Event.COMPLETE, onQsetListComplete);

// Question set variables
var qset_list:Object = new Object();
var qset_info:Object = new Object();

// Assign variables from the XML object
function onQsetListComplete (event:Event):void
{
	var xmlQuizSets:XML = new XML();
	xmlQuizSets = xmlQsetList.p_XML;
	qset_list = xmlQuizSets;
	qset_info.numActiveSets = qset_list.set_list.@total_qsets;
	qset_info.setNumber = 0;
	qset_info.setLoaded = false;
	// Load the Qset from the list
	loadQset (qset_info.setNumber);
}

// Loads the question set in the list based on the slot qset_info.setNumber
function loadQset (qsetNum:Number)
{	
	var xmlQsetLoad:XMLLoader = new XMLLoader(myXMLPath + qset_list.set_list.qset[qsetNum] +".xml");
	xmlQsetLoad.addEventListener (Event.COMPLETE, onQsetComplete);

	// Alias the qset from the XML object
	function onQsetComplete (event:Event):void
	{
		var xmlQuiz:XML = new XML();
		xmlQuiz = xmlQsetLoad.p_XML;
		qset_info.set_info = xmlQuiz.set_info;
		qset_info.qsetName = xmlQuiz.set_info.@title;
		qset_info.easy = xmlQuiz.easy;
		qset_info.hard = xmlQuiz.hard;
		qset_info.qNumber = 0;
		qset_info.numQuestions;
		qset_info.difficulty;
		qset_info.setLoaded = true;
	}
}

//
// Input
//
// Assign Keys
// Keyboard Codes
// 1
var player1A_code:Number = 49;
// 2
var player1B_code:Number = 50;
// 3
var player1C_code:Number = 51;
// 4
var player2A_code:Number = 52;
// 5
var player2B_code:Number = 53;
// 6
var player2C_code:Number = 54;
// 7
var player3A_code:Number = 55;
// 8
var player3B_code:Number = 56;
// 9
var player3C_code:Number = 57;
// F
var reset_code:Number = 70;

//
// Frame events
// Checks the array from the quiz watcher object and compares the current frame
// Assigns key listeners, fires off display of data and sounds
//
function checkQuizLabel (event:Event)
{
	myQuizWatcher.getLabels (quiz_mc);
	switch (quiz_mc.currentLabel)
	{
		case myQuizWatcher.p_labels[0].name :// intro
			quiz_mc.stop ();
			stage.removeEventListener (KeyboardEvent.KEY_UP, gotoIntro);
			stage.addEventListener (KeyboardEvent.KEY_UP, gotoSet);
			// Stop the sound
			endRound_snd.p_isPlaying = false;
			// Cue voice over
			if (intro1_snd.p_isPlaying == false)
			{
				intro1_snd.play ();
			}
			break;
		case myQuizWatcher.p_labels[1].name :// intro_done
			break;
		case myQuizWatcher.p_labels[2].name :// set
			quiz_mc.stop ();
			stage.removeEventListener (KeyboardEvent.KEY_UP, gotoSet);
			stage.addEventListener (KeyboardEvent.KEY_UP, gotoDifficulty);
			showSetData ();
			break;
		case myQuizWatcher.p_labels[3].name :// set_done
			break;
		case myQuizWatcher.p_labels[4].name :// difficulty
			quiz_mc.stop ();
			stage.removeEventListener (KeyboardEvent.KEY_UP, gotoDifficulty);
			stage.addEventListener (KeyboardEvent.KEY_UP, gotoQuestion);
			showDifficultyData ();
			// Cue voice over
			if (intro3_snd.p_isPlaying == false)
			{
				intro3_snd.play ();
			}
			break;
		case myQuizWatcher.p_labels[5].name :// difficulty_done
			break;
		case myQuizWatcher.p_labels[6].name :// next_question
			break;
		case myQuizWatcher.p_labels[7].name :// question
			quiz_mc.stop ();
			stage.removeEventListener (KeyboardEvent.KEY_UP, nextQuestion);
			stage.removeEventListener (KeyboardEvent.KEY_UP, gotoQuestion);
			stage.addEventListener (KeyboardEvent.KEY_UP, submitAnswer);
			// Populate the text fields with the question data
			showQuestionData ();
			// Cue music
			if (music_snd.p_isPlaying == false)
			{
				music_snd.play ();
			}
			break;
		case myQuizWatcher.p_labels[8].name :// question_done
			break;
		case myQuizWatcher.p_labels[9].name :// explanation
			quiz_mc.stop ();
			stage.removeEventListener (KeyboardEvent.KEY_UP, submitAnswer);
			stage.addEventListener (KeyboardEvent.KEY_UP, nextQuestion);
			showExplanationData ();
			// Reset the ability for the music and ting to play
			ting_snd.p_isPlaying = false;
			music_snd.p_isPlaying = false;
			break;
		case myQuizWatcher.p_labels[10].name :// explanation_done
			break;
		case myQuizWatcher.p_labels[11].name :// end
			quiz_mc.stop ();
			stage.removeEventListener (KeyboardEvent.KEY_UP, nextQuestion);
			stage.addEventListener (KeyboardEvent.KEY_UP, endRound);
			showResultsData ();
			// Cue voice over
			if (endRound_snd.p_isPlaying == false)
			{
				endRound_snd.play ();
			}
			intro1_snd.p_isPlaying = false;
			intro3_snd.p_isPlaying = false;
			break;
		case myQuizWatcher.p_labels[12].name :// attract
			// Remove all listeners
			stage.removeEventListener (KeyboardEvent.KEY_UP, gotoSet);
			stage.removeEventListener (KeyboardEvent.KEY_UP, gotoDifficulty);
			stage.removeEventListener (KeyboardEvent.KEY_UP, nextQuestion);
			stage.removeEventListener (KeyboardEvent.KEY_UP, submitAnswer);
			stage.removeEventListener (KeyboardEvent.KEY_UP, nextQuestion);
			// Reset all sound loops
			intro1_snd.p_isPlaying = false;
			intro3_snd.p_isPlaying = false;
			music_snd.p_isPlaying = false;
			ting_snd.p_isPlaying = false;
			endRound_snd.p_isPlaying = false;
			// Add listener to return the user to the menu
			stage.addEventListener (KeyboardEvent.KEY_UP, gotoIntro);
			break;
	}
}

//
// Navigation
//

// Send user to second screen of the introduction
function gotoIntro (event:KeyboardEvent):void
{
	resetKiosk();
}

// Send user to second screen of the introduction
function gotoSet (event:KeyboardEvent):void
{
	// Reset the timeout object
	quizTimeout.p_lastInterval = getTimer();
	// Players press A to advance
	switch (event.keyCode)
	{
		case player1A_code :
			quiz_mc.gotoAndPlay (myQuizWatcher.p_labels[1].name);
			break;
		case player2A_code :
			quiz_mc.gotoAndPlay (myQuizWatcher.p_labels[1].name);
			break;
		case player3A_code :
			quiz_mc.gotoAndPlay (myQuizWatcher.p_labels[1].name);
			break;
		case reset_code :
			// M - Reset
			resetKiosk ();
			break;
	}
	// Stop voiceover
	intro1_snd.stop ();
}

// Send user to select the difficulty
function gotoDifficulty (event:KeyboardEvent):void
{
	// Reset the timeout object
	quizTimeout.p_lastInterval = getTimer();
	// Players press A to advance
	switch (event.keyCode)
	{
		case player1A_code :
			quiz_mc.gotoAndPlay (myQuizWatcher.p_labels[3].name);
			break;
		case player2A_code :
			quiz_mc.gotoAndPlay (myQuizWatcher.p_labels[3].name);
			break;
		case player3A_code :
			quiz_mc.gotoAndPlay (myQuizWatcher.p_labels[3].name);
			break;
		case reset_code :
			// M - Reset
			resetKiosk ();
			break;
	}
}

// Send user to the question screen
function gotoQuestion (event:KeyboardEvent):void
{
	// Reset the timeout object
	quizTimeout.p_lastInterval = getTimer();
	// Detect the key input and assign difficulty
	switch (event.keyCode)
	{
		case player1A_code :
			setDifficulty ("easy");
			break;
		case player1B_code :
			setDifficulty ("hard");
			break;
		case player2A_code :
			setDifficulty ("easy");
			break;
		case player2B_code :
			setDifficulty ("hard");
			break;
		case player3A_code :
			setDifficulty ("easy");
			break;
		case player3B_code :
			setDifficulty ("hard");
			break;
		case reset_code :
			// M - Reset
			resetKiosk ();
			break;
	}
	switch (qset_info.difficulty)
	{
		case "easy" :
			if (qset_info.set_info.@num_easy != 0)
			{
				quiz_mc.gotoAndPlay (myQuizWatcher.p_labels[5].name);
			}
			break;
		case "hard" :
			if (qset_info.set_info.@num_hard != 0)
			{
				quiz_mc.gotoAndPlay (myQuizWatcher.p_labels[5].name);
			}
			break;
	}
	// Stop voiceover
	intro3_snd.stop ();
}

// Answer submittion for the quiz show
function submitAnswer (event:KeyboardEvent):void {
	// Reset the timeout object
	quizTimeout.p_lastInterval = getTimer();
	// Detect key input and submit answer
	switch (event.keyCode) {
		case player1A_code :
			// Letter A
			if (player1.p_answer == ""){
			 player1.p_answer = "Answer A";
			 quiz_mc.player1_mc.gotoAndPlay ("submit");
			 ting_snd.play ();
			 // Check that all answers have been submitted
	     // Go to the explnation screen
	     gotoExplanation ();
			}
			break;
		case player1B_code :
			// Letter B
			if (player1.p_answer == ""){
			 player1.p_answer = "Answer B";
			 quiz_mc.player1_mc.gotoAndPlay ("submit");
			 ting_snd.play ();
			 // Check that all answers have been submitted
	     // Go to the explnation screen
	     gotoExplanation ();
			}
			break;
		case player1C_code :
			// Letter C
			if (player1.p_answer == ""){
			 player1.p_answer = "Answer C";
			 quiz_mc.player1_mc.gotoAndPlay ("submit");
			 ting_snd.play ();
			 // Check that all answers have been submitted
	     // Go to the explnation screen
	     gotoExplanation ();
			}			
			break;
		case player2A_code :
			// Letter A
			if (player2.p_answer == ""){
			 player2.p_answer = "Answer A";
			 quiz_mc.player2_mc.gotoAndPlay ("submit");
			 ting_snd.play ();
			 // Check that all answers have been submitted
	     // Go to the explnation screen
	     gotoExplanation ();
			}
			break;
		case player2B_code :
			// Letter B
			if (player2.p_answer == ""){
  			player2.p_answer = "Answer B";
  			quiz_mc.player2_mc.gotoAndPlay ("submit");
  			ting_snd.play ();
        // Check that all answers have been submitted
        // Go to the explnation screen
        gotoExplanation ();
			}
			break;
		case player2C_code :
			// Letter C
			if (player2.p_answer == ""){
  			player2.p_answer = "Answer C";
  			quiz_mc.player2_mc.gotoAndPlay ("submit");
  			ting_snd.play ();
  			// Check that all answers have been submitted
  			// Go to the explnation screen
  			gotoExplanation ();
			}
			break;
		case player3A_code :
			// Letter A
			if (player3.p_answer == ""){
  		  player3.p_answer = "Answer A";
  			quiz_mc.player3_mc.gotoAndPlay ("submit");
  			ting_snd.play ();
  			// Check that all answers have been submitted
  			// Go to the explnation screen
  			gotoExplanation ();
			}
			break;
		case player3B_code :
			// Letter B
			if (player3.p_answer == ""){
        player3.p_answer = "Answer B";
        quiz_mc.player3_mc.gotoAndPlay ("submit");
        ting_snd.play ();
        // Check that all answers have been submitted
        // Go to the explnation screen
        gotoExplanation ();
			}
			break;
		case player3C_code :
			// Letter C
			if (player3.p_answer == ""){
        player3.p_answer = "Answer C";
        quiz_mc.player3_mc.gotoAndPlay ("submit");
        ting_snd.play ();
        // Check that all answers have been submitted
        // Go to the explnation screen
        gotoExplanation ();
			}
			break;
	}
}

// Make sure all users have submitted an answer before moving
// onto the explanation screen
function gotoExplanation ():void
{
	if (player1.p_answer != "" && player2.p_answer != "" && player3.p_answer != "" || qTimer.p_seconds <= 0)
	{
		// Enable the ability to gain points
		player1.p_scoreMe = true;
		player2.p_scoreMe = true;
		player3.p_scoreMe = true;
		// Go to the explanation
		quiz_mc.gotoAndPlay (myQuizWatcher.p_labels[8].name);
		// Reset the timer
		qTimer.unInitTimer (myCountdownSeconds);
		// Stop music
		music_snd.stop ();
	}
}

// Resets the timeout for the attract screen
// Increments to the next question, unless the end of the round
// Clears player panels, and submitted answers
function nextQuestion (event:KeyboardEvent):void
{
	// Reset the timeout object
	quizTimeout.p_lastInterval = getTimer();
	function checkRound ()
	{
		// If the last question in the set is reached
		// Notify them that the round has ended
		// (take one away for proper slot designation in the array)
		if (qset_info.qNumber >= qset_info.numQuestions-1)
		{
			switch (quiz_mc.player1_mc.currentLabel)
			{
				case "feedback" :
					quiz_mc.player1_mc.gotoAndPlay ("reset");
					break;
			}
			switch (quiz_mc.player2_mc.currentLabel)
			{
				case "feedback" :
					quiz_mc.player2_mc.gotoAndPlay ("reset");
					break;
			}
			switch (quiz_mc.player3_mc.currentLabel)
			{
				case "feedback" :
					quiz_mc.player3_mc.gotoAndPlay ("reset");
					break;
			}
			qset_info.qNumber = 0;
			quiz_mc.gotoAndPlay ("end");
		}
		else
		{
			// Increment the question number
			qset_info.qNumber = qset_info.qNumber+1;
			// Reset the player panels
			quiz_mc.player1_mc.gotoAndPlay ("reset");
			quiz_mc.player2_mc.gotoAndPlay ("reset");
			quiz_mc.player3_mc.gotoAndPlay ("reset");
			// Goto the new question
			quiz_mc.gotoAndPlay (myQuizWatcher.p_labels[6].name);
		}
		// Clear the player answers
		player1.p_answer = "";
		player2.p_answer = "";
		player3.p_answer = "";
	}
	// Players press A to advance or M to reset
	switch (event.keyCode)
	{
		case player1A_code :
			checkRound ();
			break;
		case player2A_code :
			checkRound ();
			break;
		case player3A_code :
			checkRound ();
			break;
		case reset_code :
			// M - reset
			resetKiosk ();
			break;
	}
}

function endRound (event:KeyboardEvent):void
{
	// Reset the timeout object
	quizTimeout.p_lastInterval = getTimer();
	// Go to the menu screen
	switch (event.keyCode)
	{
		case reset_code :
			// M - reset
			// If you have reached the end of the question set list, go back to the first question set.
			if (qset_info.setNumber < qset_info.numActiveSets-1)
			{
				qset_info.setNumber++;
				trace ("qset_info.setNumber incremented to "+qset_info.setNumber);
			}
			else
			{
				qset_info.setNumber = 0;
				trace ("qset_info.setNumber reset to "+qset_info.setNumber);
			}
			// Load the Qset from the list
			loadQset (qset_info.setNumber);
			resetKiosk ();
			break;
	}
	// Stop voiceover
	endRound_snd.stop ();
}

// Attract screen timer
// Checks to see if the timeout interval has been reached
// If so, sends the playhead to the attract loop
function checkTimeout (event:Event):void
{
	if (quizTimeout.p_intervalComplete == true)
	{
		SoundMixer.stopAll();
		quiz_mc.gotoAndStop ("attract");
		quiz_mc.removeEventListener (Event.ENTER_FRAME, checkTimeout);
	}
}

// Reset the timeout interval
// Reset all player scores and answers
// Reset the question number
// Send the user to the initial intro screen
function resetKiosk ():void
{
	// Reset attract loop timeout
	quizTimeout.p_lastInterval = getTimer();
	// Enable a set to be loaded
	qset_info.setLoaded = false;
	// Reset scores
	player1.p_score = 0;
	player2.p_score = 0;
	player3.p_score = 0;
	// Reset submitted answers
	player1.p_answer = "";
	player2.p_answer = "";
	player3.p_answer = "";
	// Reset question increment
	qset_info.qNumber = 0;
	// Reset the countdown
	qTimer.unInitTimer (myCountdownSeconds);
	// Remove all listeners
	stage.removeEventListener (KeyboardEvent.KEY_UP, gotoSet);
	stage.removeEventListener (KeyboardEvent.KEY_UP, gotoDifficulty);
	stage.removeEventListener (KeyboardEvent.KEY_UP, nextQuestion);
	stage.removeEventListener (KeyboardEvent.KEY_UP, submitAnswer);
	stage.removeEventListener (KeyboardEvent.KEY_UP, nextQuestion);
	// Reset all sound loops
	intro1_snd.p_isPlaying = false;
	intro3_snd.p_isPlaying = false;
	music_snd.p_isPlaying = false;
	ting_snd.p_isPlaying = false;
	endRound_snd.p_isPlaying = false;
	// Go to introduction
	quiz_mc.gotoAndStop ("intro1");
}

//
// Data display and calculation
//

// Populate set selection fields with the question set titles
// TODO: Create multiple movieclips that provide the user with all of the
// available question sets and let them choose which to play
function showSetData ():void
{
	quiz_mc.qset_select.qset_title.text = qset_info.qsetName;
}

// Set maximum number of questions for the round
// based on the selected difficulty
function setDifficulty (myDifficulty):void
{
	switch (myDifficulty)
	{
		case "easy" :
			qset_info.numQuestions = qset_info.set_info.@num_easy;
			qset_info.difficulty = "easy";
			break;
		case "hard" :
			qset_info.numQuestions = qset_info.set_info.@num_hard;
			qset_info.difficulty = "hard";
			break;
	}
}

function showDifficultyData ():void
{
	quiz_mc.easy_select.qset_title.text = "Easy";
	quiz_mc.hard_select.qset_title.text = "Hard";
	var num_easy:Number = qset_info.set_info.@num_easy;
	var num_hard:Number = qset_info.set_info.@num_hard;
	switch (num_easy)
	{
		case 0 :
			quiz_mc.easy_select.alpha = 0.2;
			break;
		default :
			quiz_mc.easy_select.alpha = 1;
			break;

	}
	switch (num_hard)
	{
		case 0 :
			quiz_mc.hard_select.alpha = 0.2;
			break;
		default :
			quiz_mc.hard_select.alpha = 1;
			break;
	}
}

// Populate the player panels for the "Question" section of the quiz
function showQuestionData ():void
{
	// Populate current set title, and question number
	quiz_mc.setTitle.text = qset_info.qsetName;
	var qStatus:String = "You are on question "+(qset_info.qNumber+1)+" of "+qset_info.numQuestions+", these questions are "+qset_info.difficulty;
	quiz_mc.setQNum.text = qStatus;
	// Start the countdown
	qTimer.initTimer ();
	// Display seconds in timer movieclip
	quiz_mc.qClock_mc.timer_txt.text = qTimer.p_seconds;
	// If timer reaches 0, stop the timer
	// Reset the countdown
	// Go to the explanation
	switch (qTimer.p_seconds)
	{
		case 0 :
			gotoExplanation ();
			break;
	}
	// Set the question properties
	switch (qset_info.difficulty)
	{
		case "easy" :
			qsetQuestion.p_currentQuestionText = qset_info.easy.question[qset_info.qNumber].question_txt;
			qsetQuestion.p_currentAnswerAText = qset_info.easy.question[qset_info.qNumber].answer_a;
			qsetQuestion.p_currentAnswerBText = qset_info.easy.question[qset_info.qNumber].answer_b;
			qsetQuestion.p_currentAnswerCText = qset_info.easy.question[qset_info.qNumber].answer_c;
			qsetQuestion.p_currentQuestionAnswer = qset_info.easy.question[qset_info.qNumber].correct;
			qsetQuestion.p_currentExplanationText = qset_info.easy.question[qset_info.qNumber].explanation_txt;
			break;

		case "hard" :
			qsetQuestion.p_currentQuestionText = qset_info.hard.question[qset_info.qNumber].question_txt;
			qsetQuestion.p_currentAnswerAText = qset_info.hard.question[qset_info.qNumber].answer_a;
			qsetQuestion.p_currentAnswerBText = qset_info.hard.question[qset_info.qNumber].answer_b;
			qsetQuestion.p_currentAnswerCText = qset_info.hard.question[qset_info.qNumber].answer_c;
			qsetQuestion.p_currentQuestionAnswer = qset_info.hard.question[qset_info.qNumber].correct;
			qsetQuestion.p_currentExplanationText = qset_info.hard.question[qset_info.qNumber].explanation_txt;
			break;
	}
	quiz_mc.questionText.htmlText = qsetQuestion.p_currentQuestionText;
	quiz_mc.answerA_mc.answerText.text = qsetQuestion.p_currentAnswerAText;
	quiz_mc.answerB_mc.answerText.text = qsetQuestion.p_currentAnswerBText;
	quiz_mc.answerC_mc.answerText.text = qsetQuestion.p_currentAnswerCText;

	switch (quiz_mc.player1_mc.currentLabel)
	{
		case "score" :
			// Populate player panels
			quiz_mc.player1_mc.playerName.text = player1.p_name;
			quiz_mc.player1_mc.playerScore.text = player1.p_score;
			break;
		default :
			if (player1.p_answer == "")
			{
				quiz_mc.player1_mc.gotoAndPlay ("score");
			}
			break;
	}
	switch (quiz_mc.player2_mc.currentLabel)
	{
		case "score" :
			// Populate player panels
			quiz_mc.player2_mc.playerName.text = player2.p_name;
			quiz_mc.player2_mc.playerScore.text = player2.p_score;
			break;
		default :
			if (player2.p_answer == "")
			{
				quiz_mc.player2_mc.gotoAndPlay ("score");
			}
			break;
	}
	switch (quiz_mc.player3_mc.currentLabel)
	{
		case "score" :
			// Populate player panels
			quiz_mc.player3_mc.playerName.text = player3.p_name;
			quiz_mc.player3_mc.playerScore.text = player3.p_score;
			break;
		default :
			if (player3.p_answer == "")
			{
				quiz_mc.player3_mc.gotoAndPlay ("score");
			}
			break;
	}
}

// Populate the player panels for the "Answer/Explanation" section of the quiz
function showExplanationData ():void
{
	function checkAnswer (myPlayer):void
	{
		// Check if correct or incorrect
		switch (myPlayer.p_answer)
		{
			case qsetQuestion.p_currentQuestionAnswer :
				myPlayer.p_feedback = "Correct. You get 1 point.";
				myPlayer.p_colorFrame = 2;
				// Give the player 1 point
				if (myPlayer.p_scoreMe == true)
				{
					myPlayer.givePoints ();
					myPlayer.p_scoreMe = false;
				}
				break;
			case "" :
				myPlayer.p_feedback = "You can join in at anytime, so come share the fun.";
				myPlayer.p_colorFrame = 1;
				myPlayer.p_choiceFrame = 1;
				break;
			default :
				myPlayer.p_feedback = "Oops. This is incorrect.";
				myPlayer.p_colorFrame = 3;
				break;
		}
		// Display what answer the user chose
		switch (myPlayer.p_answer)
		{
			case "Answer A" :
				myPlayer.p_choiceFrame = 2;
				break;
			case "Answer B" :
				myPlayer.p_choiceFrame = 3;
				break;
			case "Answer C" :
				myPlayer.p_choiceFrame = 4;
				break;
		}
	}
	checkAnswer (player1);
	checkAnswer (player2);
	checkAnswer (player3);
	// Change letter icon based on correct answer
	switch (qsetQuestion.p_currentQuestionAnswer)
	{
		case "Answer A" :
			quiz_mc.correctLtr_mc.gotoAndStop (1);
			break;
		case "Answer B" :
			quiz_mc.correctLtr_mc.gotoAndStop (2);
			break;
		case "Answer C" :
			quiz_mc.correctLtr_mc.gotoAndStop (3);
			break;
	}
	// Populate explanation text
	quiz_mc.explanationText.htmlText = qsetQuestion.p_currentExplanationText;
	switch (quiz_mc.player1_mc.currentLabel)
	{
		case "feedback" :
			quiz_mc.player1_mc.playerName.text = player1.p_name;
			quiz_mc.player1_mc.playerScore.text = player1.p_score;
			quiz_mc.player1_mc.playerFeedback.text = player1.p_feedback;
			quiz_mc.player1_mc.choice_mc.gotoAndStop (player1.p_choiceFrame);
			quiz_mc.player1_mc.color_mc.gotoAndStop (player1.p_colorFrame);
			break;
		default :
			quiz_mc.player1_mc.gotoAndPlay ("feedback");
			break;
	}
	switch (quiz_mc.player2_mc.currentLabel)
	{
		case "feedback" :
			quiz_mc.player2_mc.playerName.text = player2.p_name;
			quiz_mc.player2_mc.playerScore.text = player2.p_score;
			quiz_mc.player2_mc.playerFeedback.text = player2.p_feedback;
			quiz_mc.player2_mc.choice_mc.gotoAndStop (player2.p_choiceFrame);
			quiz_mc.player2_mc.color_mc.gotoAndStop (player2.p_colorFrame);
			break;
		default :
			quiz_mc.player2_mc.gotoAndPlay ("feedback");
			break;
	}
	switch (quiz_mc.player3_mc.currentLabel)
	{
		case "feedback" :
			quiz_mc.player3_mc.playerName.text = player3.p_name;
			quiz_mc.player3_mc.playerScore.text = player3.p_score;
			quiz_mc.player3_mc.playerFeedback.text = player3.p_feedback;
			quiz_mc.player3_mc.choice_mc.gotoAndStop (player3.p_choiceFrame);
			quiz_mc.player3_mc.color_mc.gotoAndStop (player3.p_colorFrame);
			break;
		default :
			quiz_mc.player3_mc.gotoAndPlay ("feedback");
			break;
	}
}

// Populate the player panels for the "End of Round" section of the quiz
function showResultsData ():void
{
	// Calculate the values for game feedback
	var winMessage:String = "Congratulations! You're the winner.";
	var tieMessage:String = "You've tied with another player. How about a rematch?";
	var looseMessage:String = "Better luck next time.";
	// Calculate the winner
	// Is player 1 the winner?
	if (player1.p_score > player2.p_score && player1.p_score > player3.p_score)
	{
		player1.p_feedback = winMessage;
	}
	else if (player1.p_score == player2.p_score || player1.p_score == player3.p_score)
	{
		player1.p_feedback = tieMessage;
	}
	else
	{
		player1.p_feedback = looseMessage;
	}
	// Is player 2 the winner?
	if (player2.p_score > player1.p_score && player2.p_score > player3.p_score)
	{
		player2.p_feedback = winMessage;
	}
	else if (player2.p_score == player1.p_score || player2.p_score == player3.p_score)
	{
		player2.p_feedback = tieMessage;
	}
	else
	{
		player2.p_feedback = looseMessage;
	}
	// Is player 3 the winner?
	if (player3.p_score > player1.p_score && player3.p_score > player2.p_score)
	{
		player3.p_feedback = winMessage;
	}
	else if (player3.p_score == player1.p_score || player3.p_score == player2.p_score)
	{
		player3.p_feedback = tieMessage;
	}
	else
	{
		player3.p_feedback = looseMessage;
	}
	switch (quiz_mc.player1_mc.currentLabel)
	{
		case "feedback" :
			quiz_mc.player1_mc.playerName.text = player1.p_name;
			quiz_mc.player1_mc.playerScore.text = player1.p_score;
			quiz_mc.player1_mc.playerFeedback.text = player1.p_feedback;
			quiz_mc.player1_mc.choice_mc.gotoAndStop (1);
			quiz_mc.player1_mc.color_mc.gotoAndStop (1);
			break;
		default :
			quiz_mc.player1_mc.gotoAndPlay ("feedback");
			break;
	}
	switch (quiz_mc.player2_mc.currentLabel)
	{
		case "feedback" :
			quiz_mc.player2_mc.playerName.text = player2.p_name;
			quiz_mc.player2_mc.playerScore.text = player2.p_score;
			quiz_mc.player2_mc.playerFeedback.text = player2.p_feedback;
			quiz_mc.player2_mc.choice_mc.gotoAndStop (1);
			quiz_mc.player2_mc.color_mc.gotoAndStop (1);
			break;
		default :
			quiz_mc.player2_mc.gotoAndPlay ("feedback");
			break;
	}
	switch (quiz_mc.player3_mc.currentLabel)
	{
		case "feedback" :
			quiz_mc.player3_mc.playerName.text = player3.p_name;
			quiz_mc.player3_mc.playerScore.text = player3.p_score;
			quiz_mc.player3_mc.playerFeedback.text = player3.p_feedback;
			quiz_mc.player3_mc.choice_mc.gotoAndStop (1);
			quiz_mc.player3_mc.color_mc.gotoAndStop (1);
			break;
		default :
			quiz_mc.player3_mc.gotoAndPlay ("feedback");
			break;
	}
}

// Make the application fullscreen
stage.displayState = StageDisplayState.FULL_SCREEN;
stop ();
quiz_mc.stop ();
// Assign timeout and label watcher functions to the quiz_mc movieclip
quiz_mc.addEventListener (Event.ENTER_FRAME, quizTimeout.checkTime);
quiz_mc.addEventListener (Event.ENTER_FRAME, checkTimeout);
quiz_mc.addEventListener (Event.ENTER_FRAME, checkQuizLabel);