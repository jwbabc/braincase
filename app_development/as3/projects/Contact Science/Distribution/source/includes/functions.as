import fl.transitions.*;
import fl.transitions.easing.*;
import fl.controls.Slider;
import fl.controls.SliderDirection;
import fl.controls.ProgressBar;
import fl.controls.ProgressBarMode;
import fl.events.SliderEvent;
import fl.video.FLVPlayback;
import AssetLoader;
import AttractTimer;
import SoundLoader;
import VideoLoader;
import XMLLoader;

// Load container objects
include "objects.as"
// Load textformat objects
include "textformats.as"
// Load the template file
include "template.as"

// XML Import
// Load the xml data for a list of experiments available
function getExperimentList (XMLFilename:String):void {
  var XMLListPath:String = "assets/xml/";
  var myXMLListLoader:XMLLoader = new XMLLoader(XMLListPath + XMLFilename);
  myXMLListLoader.addEventListener (Event.COMPLETE, initExperimentList);
  
  function initExperimentList (event:Event):void {
    experimentList_xml = myXMLListLoader.p_XML;
    grabCompanionData ();
  }
}

// Load the xml data for the selected experiment
function getExperiment (XMLFilename:String):void {
  var XMLPath:String = "assets/xml/experiments/";
  var myXMLLoader:XMLLoader = new XMLLoader(XMLPath + XMLFilename);
  myXMLLoader.addEventListener (Event.COMPLETE, initExperiment);
  
  function initExperiment (event:Event):void {
    experiment_xml = myXMLLoader.p_XML;
    grabExperimentData ();
  }
}

// Load the glossary data from the xml file
function getGlossaryTerms (XMLFilename:String):void {
  var XMLPath:String = "assets/xml/glossary/";
  var myXMLLoader:XMLLoader = new XMLLoader(XMLPath + XMLFilename);
  myXMLLoader.addEventListener (Event.COMPLETE, initGlossary);
  
  function initGlossary (event:Event):void {
    glossary_xml = myXMLLoader.p_XML;
    loadGlossary ();
  }
}

// Populate the lab companion titles
// Create an array of the experiments
function grabCompanionData ():void {
  numExperiments = experimentList_xml.child("experiment").length();
  var timeoutLength:Number = Number(experimentList_xml.attribute("timeout"));
  
  for each (var introItem in experimentList_xml.intro_text) {
    introductionText_array.push (introItem);
    introductionImage_array.push (introItem.attribute("filename"));
  }
  
  for each (var item in experimentList_xml.experiment) {
    experimentList_array.push (item);
    experimentFile_array.push (item.attribute("filename"));
  }
  
  // Set the timeout for the kiosk
  csTimeout = new AttractTimer(timeoutLength * 1000);
  
  // Start the kiosk
  loadTitleScreen ();
}

// Using the list of companion titles, grab the data of the experiment
// Populate data for assets of the experiment
// Create arrays of the experiment's media assets
function grabExperimentData ():void {
  numSteps = experiment_xml.child("step").length();
  experimentTitle = experiment_xml.title;
  experimentExplanationHeader = experiment_xml.explanation.header;
  experimentExplanationText = experiment_xml.explanation.text;
  // Grab the text for each step of the experiment and place it in the array
  for each (var step in experiment_xml.step.text) {
    experimentSteps_array.push (step);
  }
  // Grab the mp3 path for each step of the experiment and place it in the array
  for each (var mp3 in experiment_xml.step.mp3) {
    experimentAudio_array.push (mp3);
  }
  
  // Add the explanation audio to the end of the experimentAudio array
  experimentAudio_array.push (experiment_xml.explanation.mp3);
  
  // Grab the video path for each step of the experiment and place it in the array
  for each (var video in experiment_xml.step.video) {
    experimentVideo_array.push (video);
  }
  
  //Grab the activity path for each experiment and place it in the array
  for each (var activity in experiment_xml.activity) {
    experimentActivity_array.push (activity);
  }
  
  clearContainer (rootContainer_mc);
  loadExperimentScreen (experimentTitle);
}

// Utility functions
// Loads the graphic into the target movieclip from the path specified
function loadAsset (target:MovieClip, path:String):void {
  var assetLoader:AssetLoader = new AssetLoader (target, path);
}

// Clears all children from the target container
function clearContainer (container:Object):void {
  while (container.numChildren > 0) container.removeChildAt (container.numChildren-1);
}

// Attract screen timer
// Checks to see if the timeout interval has been reached
// If so, sends the playhead to the title screen
function checkTimeout (event:Event):void {
  if (csTimeout.p_intervalComplete == true) {
    SoundMixer.stopAll();
    clearContainer(rootContainer_mc);
    // Reset the kiosk envrionment
    resetKioskEnvironment();
    // Reset timeout
    csTimeout.p_intervalComplete = false;
    csTimeout.p_lastInterval = getTimer();
    // Remove the timeout listeners
    rootContainer_mc.removeEventListener (Event.ENTER_FRAME, checkTimeout);
    rootContainer_mc.removeEventListener (Event.ENTER_FRAME, csTimeout.checkTime);
    rootContainer_mc.removeEventListener (MouseEvent.MOUSE_DOWN, resetTimeout);
    // Load the title screen
    loadTitleScreen();
  }
}

// Reset the timeout interval
function resetTimeout (event:MouseEvent):void {
  csTimeout.p_lastInterval = getTimer();
}

// Navigation functions
function resetKioskEnvironment () :void {
  // Stop sound playback
  SoundMixer.stopAll();
  // Reset experiment list to default
  initialArraySlot = 0;
  // Reset experiment variables to default
  stepCount = 1;
  explanationLoaded = false;
  glossaryTermIndex = 0;
  glossaryDescriptionIndex = 0;
  // Empty experiment arrays
  experimentSteps_array = [];
  experimentAudio_array = [];
  experimentVideo_array = [];
  experimentActivity_array = [];
}

function navigate_TitleToIntro (event:MouseEvent):void {
  // Build the select screen
  loadIntroScreen ();
  // Remove button listener
  event.target.removeEventListener (MouseEvent.MOUSE_DOWN, navigate_TitleToIntro);
}

function navigate_IntroToSelect (event:MouseEvent):void {
  // Build the select screen
  loadSelectScreen ();
  // Remove button listener
  event.target.removeEventListener (MouseEvent.MOUSE_DOWN, navigate_IntroToSelect);
}

function navigate_SelectToIntro (event:MouseEvent):void {
  // Build the select screen
  loadIntroScreen ();
  // Remove button listener
  event.target.removeEventListener (MouseEvent.MOUSE_DOWN, navigate_SelectToIntro);
}

function navigate_ExperimentToSelect (event:MouseEvent):void {
  // Reset the environment to its initial state
  resetKioskEnvironment();
  // Build the select screen
  loadSelectScreen ();
  // Remove button listener
  event.target.removeEventListener (MouseEvent.MOUSE_DOWN, navigate_ExperimentToSelect);
}

// Display the title screen
function loadTitleScreen ():void {
  // Clear the root container
  clearContainer (rootContainer_mc);
  
  // Build title screen logo
  titleLogo_mc.mouseChildren = false;
  loadAsset(titleLogo_mc, "assets/png/Logo.png");
  
  // Build title plate
  titlePlate_mc.mouseChildren = false;
  loadAsset(titlePlate_mc, "assets/png/Title Plate.png");
  
  // Build begin button label
  titleBeginButton_txt.embedFonts = true;
  titleBeginButton_txt.background = false;
  titleBeginButton_txt.selectable = false;
  titleBeginButton_txt.autoSize = TextFieldAutoSize.LEFT;
  titleBeginButton_txt.defaultTextFormat = titleBeginButton_fmt;      
  titleBeginButton_txt.text = "TOUCH TO BEGIN";
  titleBeginButton_txt.x = 60;
  titleBeginButton_txt.y = 35;
  
  // Build begin button
  beginButton_mc.mouseChildren = false;
  beginButton_mc.addEventListener (MouseEvent.MOUSE_DOWN, navigate_TitleToIntro);
  loadAsset(beginButton_mc, "assets/png/Begin Button.png");
  beginButton_mc.addChild (titleBeginButton_txt);

  rootContainer_mc.addChild (titleLogo_mc);
  rootContainer_mc.addChild (titlePlate_mc);
  rootContainer_mc.addChild (beginButton_mc);
  
  // Add timeout listeners
  rootContainer_mc.addEventListener (Event.ENTER_FRAME, checkTimeout);
  rootContainer_mc.addEventListener (Event.ENTER_FRAME, csTimeout.checkTime);
  rootContainer_mc.addEventListener (MouseEvent.MOUSE_DOWN, resetTimeout); 
}

// Display the experiment select screen
function loadIntroScreen ():void {
  // Clear the root container
  clearContainer (rootContainer_mc);
  
  // Intro container locations
  // Title textfield
  introTitleStatic_txt.embedFonts = true;
  introTitleStatic_txt.background = false;
  introTitleStatic_txt.selectable = false;
  introTitleStatic_txt.width = 600;
  introTitleStatic_txt.defaultTextFormat = introStaticTitle_fmt;      
  introTitleStatic_txt.text = "Getting started:";
  
  introTitleDynamic_txt.embedFonts = true;
  introTitleDynamic_txt.background = false;
  introTitleDynamic_txt.selectable = false;
  introTitleDynamic_txt.width = 400;
  introTitleDynamic_txt.defaultTextFormat = introDynamicTitle_fmt;
  introTitleDynamic_txt.htmlText = experimentList_xml.attribute("topic");
  
  // Image 1 container
  loadAsset(introImg1_mc, "assets/intro/"+introductionImage_array[0]);
  
  // Textfield 1
  introImg1_txt.embedFonts = true;
  introImg1_txt.background = false;
  introImg1_txt.selectable = false;
  introImg1_txt.multiline = true;
  introImg1_txt.wordWrap = true;
  introImg1_txt.width = 400;
  introImg1_txt.autoSize = TextFieldAutoSize.LEFT;
  introImg1_txt.defaultTextFormat = experimentStep_fmt;
  introImg1_txt.htmlText = introductionText_array[0];
  
  // Textfield 2
  introImg2_txt.embedFonts = true;
  introImg2_txt.background = false;
  introImg2_txt.selectable = false;
  introImg2_txt.multiline = true;
  introImg2_txt.wordWrap = true;
  introImg2_txt.width = 400;
  introImg2_txt.autoSize = TextFieldAutoSize.LEFT;
  introImg2_txt.defaultTextFormat = experimentStep_fmt;
  introImg2_txt.htmlText = introductionText_array[1];
  
  // Build Right button block container
  // Choose an experiment button
  introMenuButton_mc.x = 25;
  introMenuButton_mc.y = 15;
  
  introMenuButton_txt.embedFonts = true;
  introMenuButton_txt.background = false;
  introMenuButton_txt.selectable = false;
  introMenuButton_txt.autoSize = TextFieldAutoSize.LEFT;
  introMenuButton_txt.defaultTextFormat = navigationButton_fmt;      
  introMenuButton_txt.text = "CHOOSE AN EXPERIMENT";
  introMenuButton_txt.x = 15;
  introMenuButton_txt.y = 15;
  
  loadAsset(introMenuButton_mc, "assets/png/Choose Experiment Button Right.png");
  introMenuButton_mc.addChild(introMenuButton_txt);
  
  // Right button block
  introRightButtonBlock_mc.mouseChildren = true;
  loadAsset(introRightButtonBlock_mc, "assets/png/Choose Experiment Right Button Block.png");
  introRightButtonBlock_mc.addChild(introMenuButton_mc);
    
  rootContainer_mc.addChild (introTitleStatic_txt);
  rootContainer_mc.addChild (introTitleDynamic_txt);
  rootContainer_mc.addChild (introImg1_mc);
  rootContainer_mc.addChild (introImg1_txt);
  rootContainer_mc.addChild (introImg2_txt);
  rootContainer_mc.addChild (introRightButtonBlock_mc);
  
  introMenuButton_mc.addEventListener(MouseEvent.MOUSE_DOWN, navigate_IntroToSelect);  
}

// Grab the name of the experiment from the button title
// Send the name as an argument and load the XML file with the experiment data
function selectExperiment (event:MouseEvent):void {
  var target:String = event.target.name;
  loadExperimentData (target);
}

function loadExperimentData (buttonName:String):void {
  getExperiment(experimentFile_array[buttonName.substr(3)]);
}

// Builds the tiles for the experiment list on the select screen
function loadExperimentTileSet (initialSlot:int):void {
  clearContainer (experimentsContainer_mc);
  
  // Populate the experiment container with a grid of experiments from the XML file 
  var totalRows:int = 2;
  var totalCols:int = 3;
  var row:int; 
  var col:int;
  var xSpacing:int = 269;
  var xPadding:int = 5;
  var ySpacing:int = 203;
  var yPadding:int = 5;
  
  var num:int = (totalCols * totalRows);
  var experimentArraySlot:int = initialSlot;
    
  for (var i:int = 0; i <num; i++) {
    row = (i % totalRows);
    col = Math.floor(i / totalRows);

    var experimentButton_mc:MovieClip = new MovieClip ();
    var experimentBtn_txt:TextField = new TextField ();
    
    experimentBtn_txt.name = "experimentName_txt";
    experimentBtn_txt.embedFonts = true;
    experimentBtn_txt.background = false;
    experimentBtn_txt.selectable = false;
    experimentBtn_txt.multiline = true;
    experimentBtn_txt.wordWrap = true;
    experimentBtn_txt.autoSize = TextFieldAutoSize.LEFT;
    experimentBtn_txt.width = 200;
    experimentBtn_txt.defaultTextFormat = navigationButton_fmt;
    experimentBtn_txt.x = 35;
    experimentBtn_txt.y = 35;
        
    if (experimentList_array[experimentArraySlot] != null){
      loadAsset(experimentButton_mc, "assets/png/Experiment Button.png");
      experimentBtn_txt.htmlText = experimentList_array[experimentArraySlot];
      experimentArraySlot++;
    } else {
      loadAsset(experimentButton_mc, "assets/png/Experiment Button Inactive.png");
      endOfList = true;
    }
    
    experimentButton_mc.name = "mc_"+(initialSlot+i);
    experimentButton_mc.mouseChildren = false;
    experimentButton_mc.addEventListener (MouseEvent.MOUSE_DOWN, selectExperiment);
    experimentButton_mc.addChild (experimentBtn_txt);
    
    experimentButton_mc.x = (col * (xSpacing + xPadding));
    experimentButton_mc.y = (row * (ySpacing + yPadding));
    
    experimentsContainer_mc.addChild (experimentButton_mc);
    TransitionManager.start(experimentButton_mc, {type:Fade, direction:Transition.IN, duration:3, easing:Strong.easeOut});
  }
  
  // If the end of the experiment list has been reached, disable the next select set button
  if (endOfList == true) {
    clearContainer(nextSelectSet_mc);
    loadAsset(nextSelectSet_mc, "assets/png/Next Experiment Page Inactive.png");
    nextSelectSet_mc.removeEventListener(MouseEvent.MOUSE_DOWN, loadNextExperimentSet);
  }
}

function loadPreviousExperimentSet (event:MouseEvent) :void {  
  if (initialArraySlot > 6) {
    // Increment the initial starting slot for the experiment array
    initialArraySlot = initialArraySlot-6;
  } else {
    initialArraySlot = 0;
    // If the beginning of the experiment list has been reached, disable the previous select set button
    clearContainer(previousSelectSet_mc);
    loadAsset(previousSelectSet_mc, "assets/png/Previous Experiment Page Inactive.png");
    previousSelectSet_mc.removeEventListener(MouseEvent.MOUSE_DOWN, loadPreviousExperimentSet);
    // Enable the next select set button
    clearContainer(nextSelectSet_mc);
    loadAsset(nextSelectSet_mc, "assets/png/Next Experiment Page Active.png");
    TransitionManager.start(nextSelectSet_mc, {type:Fade, direction:Transition.IN, duration:2, easing:Strong.easeOut});
    nextSelectSet_mc.addEventListener(MouseEvent.MOUSE_DOWN, loadNextExperimentSet);
    // Reset the experiment list switch
    endOfList = false;
  }
  
  // Decrement pageCount
  pageCount--;
  updatePageCounter(pageCount);
    
  // Build the new tile set
  loadExperimentTileSet (initialArraySlot);
  
  TransitionManager.start(experimentsContainer_mc, {type:Fly, direction:Transition.IN, duration:.75, easing:Strong.easeOut, startPoint:4});
}

function loadNextExperimentSet (event:MouseEvent) :void {  
  if (initialArraySlot < numExperiments-6) {
    // Increment the initial starting slot for the experiment array
    initialArraySlot = initialArraySlot+6;
    // Increment pageCount
    pageCount++;
    updatePageCounter(pageCount);
    // Enable the previous select set button
    clearContainer(previousSelectSet_mc);
    loadAsset(previousSelectSet_mc, "assets/png/Previous Experiment Page Active.png");
    TransitionManager.start(previousSelectSet_mc, {type:Fade, direction:Transition.IN, duration:2, easing:Strong.easeOut});
    previousSelectSet_mc.addEventListener(MouseEvent.MOUSE_DOWN, loadPreviousExperimentSet);
  }
  // Build the new tile set
  loadExperimentTileSet (initialArraySlot);
  TransitionManager.start(experimentsContainer_mc, {type:Fly, direction:Transition.IN, duration:.75, easing:Strong.easeOut, startPoint:6});
}

function updatePageCounter (currentPage:int):void {
  // Clear the container
  clearContainer (setPageContainer_mc);
  
  // Calculate how many sets are displayed (one dot per 6 experiments)
  var numPages = Math.round(numExperiments/6);
  
  // Place the dots inside of the container
  for (var i=0;i<numPages;i++) {
    var setPageIndicator_mc:MovieClip = new MovieClip ();
    setPageIndicator_mc.mouseChildren = false;
    setPageIndicator_mc.x = 30*i;
    setPageIndicator_mc.y = 0;
    if (i == currentPage) {
      loadAsset(setPageIndicator_mc, "assets/png/Experiment Page Indicator Active.png");
    } else {
      loadAsset(setPageIndicator_mc, "assets/png/Experiment Page Indicator Inactive.png");
    }
    setPageContainer_mc.addChild (setPageIndicator_mc);
  }
}

// Display the experiment select screen
function loadSelectScreen ():void {
  clearContainer (rootContainer_mc);
 
  // Build select screen instruction text
  selectInstruction_txt.embedFonts = true;
  selectInstruction_txt.background = false;
  selectInstruction_txt.selectable = false;
  selectInstruction_txt.autoSize = TextFieldAutoSize.LEFT;
  selectInstruction_txt.defaultTextFormat = selectInstruction_fmt;      
  selectInstruction_txt.text = "Choose an experiment";
  
  previousSelectSet_mc.mouseChildren = false;
  loadAsset(previousSelectSet_mc, "assets/png/Previous Experiment Page Inactive.png");
  
  nextSelectSet_mc.mouseChildren = false;
  
  // Enable next button if there are more than 6 experiments
  if (numExperiments > 6){
    loadAsset(nextSelectSet_mc, "assets/png/Next Experiment Page Active.png");
    nextSelectSet_mc.addEventListener(MouseEvent.MOUSE_DOWN, loadNextExperimentSet);
  
    // Create the page indicator container
    setPageContainer_mc.mouseChildren = false;
    setPageContainer_mc.x = 490;
    setPageContainer_mc.y = 700;

    updatePageCounter(pageCount);
  } else {
    loadAsset(nextSelectSet_mc, "assets/png/Next Experiment Page Inactive.png");
  }
  
  loadExperimentTileSet (initialArraySlot);

  // Build left button block
  // Left button block
  selectLeftButtonBlock_mc.mouseChildren = true;
  loadAsset(selectLeftButtonBlock_mc, "assets/png/Getting Started Button Block.png");
  
  // Getting started button container
  selectMenuButton_txt.embedFonts = true;
  selectMenuButton_txt.background = false;
  selectMenuButton_txt.selectable = false;
  selectMenuButton_txt.autoSize = TextFieldAutoSize.LEFT;
  selectMenuButton_txt.defaultTextFormat = navigationButton_fmt;      
  selectMenuButton_txt.text = "GETTING STARTED";
  selectMenuButton_txt.x = 26;
  selectMenuButton_txt.y = 15;
  
  selectMenuButton_mc.mouseChildren = false;
  selectMenuButton_mc.x = 25;
  selectMenuButton_mc.y = 15;
  loadAsset(selectMenuButton_mc, "assets/png/Getting Started Button.png");
  selectMenuButton_mc.addChild (selectMenuButton_txt);
  
  selectLeftButtonBlock_mc.addChild (selectMenuButton_mc);
  
  rootContainer_mc.addChild (selectInstruction_txt);
  rootContainer_mc.addChild (experimentsContainer_mc);
  rootContainer_mc.addChild (previousSelectSet_mc);
  rootContainer_mc.addChild (nextSelectSet_mc);
  rootContainer_mc.addChild (selectLeftButtonBlock_mc);
  rootContainer_mc.addChild (setPageContainer_mc);
  
  selectMenuButton_mc.addEventListener(MouseEvent.MOUSE_DOWN, navigate_SelectToIntro);
}

function loadPreviousExperimentStep (event:MouseEvent):void {
  // Assign targets for previous step movieclip and next button
  var previousStepTarget:MovieClip = rootContainer_mc.getChildByName("step_"+(stepCount)) as MovieClip;    
  var nextButtonContainer:MovieClip = rootContainer_mc.getChildByName("rightButtonBlock_mc") as MovieClip;
  var nextButtonTarget:MovieClip = nextButtonContainer.getChildByName("nextBtn_mc") as MovieClip;
  
  if (nextButtonTarget.alpha != 1) {
    // Enable next button
    nextButtonTarget.alpha = 1;
    experimentNextButton_mc.addEventListener(MouseEvent.MOUSE_UP, loadNextExperimentStep);
  }
  
  if (explanationLoaded == true) {
    // Stop sound playback
    SoundMixer.stopAll()
    // Load the sound file into the object
    step_snd = new SoundLoader("assets/audio/"+experimentAudio_array[stepCount-2], false);
    // Play previous sound
    step_snd.soundPlay();
    
    // Remove the previous checkmark and replace the graphic
    previousStepTarget.removeChildAt(1);
    loadAsset (previousStepTarget, "assets/png/Checkbox Unchecked.png");
    
    // Open the explainer tab
    closeExplainerTab();
    
    // Rebuild video player
    if (experimentVideo_array[stepCount-1] != ""){
      experimentStepVideo_mc.addChild(player);
    }
  } else {
    // Remove the previous step
    rootContainer_mc.removeChild (previousStepTarget);
    // Decrement the step counter
    stepCount = stepCount-1;
    // Re-assign target to the step for reseting the checkmark 
    previousStepTarget = rootContainer_mc.getChildByName("step_"+(stepCount)) as MovieClip;
    // Remove the previous checkmark and replace the graphic
    previousStepTarget.removeChildAt(1);
    loadAsset (previousStepTarget, "assets/png/Checkbox Unchecked.png");
    
    if (stepCount == 1) {
      // Disable the back button
      var backButtonTarget = rootContainer_mc.getChildByName("rightButtonBlock_mc");
      backButtonTarget.getChildByName("backBtn_mc").alpha = .25;
      experimentBackButton_mc.removeEventListener(MouseEvent.MOUSE_UP, loadPreviousExperimentStep);
    }
  }
  // Update the step counter textfield
  experimentStepCount_txt.text = "STEP "+stepCount+" OF "+numSteps;
  experimentStepCount_pb.setProgress(stepCount, numSteps);
  
  // Specify the video source for the player if one exists
  if (experimentVideo_array[stepCount-1] != ""){
    var videoPath:String = "assets/video/"+experimentVideo_array[stepCount-1];
    player.source = videoPath;
  }
  
  // Stop sound playback
  SoundMixer.stopAll()
  // Load the sound file into the object
  step_snd = new SoundLoader("assets/audio/"+experimentAudio_array[stepCount-1], false);
  // Play previous sound
  step_snd.soundPlay();
}

function loadNextExperimentStep (event:MouseEvent):void {
  // Stop sound playback
  SoundMixer.stopAll()
  // Load the sound file into the object
  var step_snd:SoundLoader = new SoundLoader("assets/audio/"+experimentAudio_array[stepCount], false);
  // Play previous sound
  step_snd.soundPlay();
  
  // Specify the video source for the player if one exists
  if (experimentVideo_array[stepCount] != ""){
    var videoPath:String = "assets/video/"+experimentVideo_array[stepCount];
    player.source = videoPath;
  }
  
  // Assign the target movieclip of the previous step
  var previousStepTarget:MovieClip = rootContainer_mc.getChildByName("step_"+(stepCount)) as MovieClip;
  var backButtonContainer:MovieClip = rootContainer_mc.getChildByName("rightButtonBlock_mc") as MovieClip;
  var backButtonTarget:MovieClip = backButtonContainer.getChildByName("backBtn_mc") as MovieClip;

  if (backButtonTarget.alpha != 1) {
    // Enable the back button
    backButtonTarget.alpha = 1
    experimentBackButton_mc.addEventListener(MouseEvent.MOUSE_UP, loadPreviousExperimentStep);
  }

  if (stepCount != numSteps){
    // Increment the step counter
    stepCount = stepCount+1;
  
    // Add checked box to previous step
    previousStepTarget.removeChildAt(1);
    loadAsset(previousStepTarget, "assets/png/Checkbox Checked.png");
    
    // Build step textfield
    var experimentStep_txt:TextField = new TextField();
    experimentStep_txt.name = "stepText";
    experimentStep_txt.embedFonts = true;
    experimentStep_txt.background = false;
    experimentStep_txt.selectable = false;
    experimentStep_txt.multiline = true;
    experimentStep_txt.wordWrap = true;
    experimentStep_txt.autoSize = TextFieldAutoSize.LEFT;
    experimentStep_txt.width = 400;
    experimentStep_txt.defaultTextFormat = experimentStep_fmt;
    experimentStep_txt.x = 50;
    experimentStep_txt.y = 10;
    experimentStep_txt.htmlText = experimentSteps_array[stepCount-1];
    
    // Build experiment checkmark container
    var experimentCheckmark_mc:MovieClip = new MovieClip ();
    experimentCheckmark_mc.name = "stepCheckmark";
    experimentCheckmark_mc.mouseChildren = false;
    experimentCheckmark_mc.x = 0;
    experimentCheckmark_mc.y = 0;
    loadAsset(experimentCheckmark_mc, "assets/png/Checkbox unchecked.png");
    
    // Build experiment step container
    var experimentStep_mc:MovieClip = new MovieClip ();
    experimentStep_mc.name = "step_"+stepCount;
    experimentStep_mc.mouseChildren = true;
    experimentStep_mc.x = 40;
    experimentStep_mc.y = previousStepTarget.y + 80;
    experimentStep_mc.addChild (experimentStep_txt);
    experimentStep_mc.addChild (experimentCheckmark_mc);
    
    rootContainer_mc.addChild (experimentStep_mc);
    
    TransitionManager.start(experimentStep_mc, {type:Fade, direction:Transition.IN, duration:2, easing:Strong.easeOut});
    
  } else {
    // Remove the previous checkmark and replace the graphic
    previousStepTarget.removeChildAt(1);
    loadAsset(previousStepTarget, "assets/png/Checkbox Checked.png");
    // Disable the next button
    var nextButtonTarget = rootContainer_mc.getChildByName("rightButtonBlock_mc");
    nextButtonTarget.getChildByName("nextBtn_mc").alpha = .25;
    experimentNextButton_mc.removeEventListener(MouseEvent.MOUSE_UP, loadNextExperimentStep);
    // Open the explainer tab
    openExplainerTab();
  }
  // Update the step counter textfield
  experimentStepCount_txt.text = "STEP "+stepCount+" OF "+numSteps;
  experimentStepCount_pb.setProgress(stepCount, numSteps);
}

// Tab functionality for experiments
// Opens and closes the tab within the experiment screen
function moveTab (target:MovieClip, axis:String, start:int, end:int):void {
  // Move the container down
  tabTween = new Tween(target, axis, Regular.easeIn, start, end, 1, true);
}

function activateGlossaryTab (event:TweenEvent) {
  // Add listener to the glossary container
  glossaryTab_mc.addEventListener(MouseEvent.MOUSE_DOWN, openGlossaryTab);
  // Add the listeners back to the navigation buttons
  experimentBackButton_mc.addEventListener(MouseEvent.MOUSE_UP, loadPreviousExperimentStep);
  experimentNextButton_mc.addEventListener(MouseEvent.MOUSE_UP, loadNextExperimentStep);
}

function openGlossaryTab (event:MouseEvent):void {
  // Bring the glossary to the top of the display list 
  rootContainer_mc.setChildIndex(glossaryTab_mc, rootContainer_mc.numChildren-1);
  // Open the tab
  moveTab (glossaryTab_mc, "y", glossaryTab_mc.y, 0);
  // Remove the listener from the glossary object
  glossaryTab_mc.removeEventListener(MouseEvent.MOUSE_DOWN, openGlossaryTab);
  // Remove listeners from the buttons underneath the glossary
  experimentBackButton_mc.removeEventListener(MouseEvent.MOUSE_UP, loadPreviousExperimentStep);
  experimentNextButton_mc.removeEventListener(MouseEvent.MOUSE_UP, loadNextExperimentStep);
  // Add listener to the close button of the glossary container
  glossaryCloseButton_mc.addEventListener(MouseEvent.MOUSE_DOWN, closeGlossaryTab);
}

function closeGlossaryTab (event:MouseEvent):void {
  // Close the tab
  moveTab (glossaryTab_mc, "y", glossaryTab_mc.y, -768);
  // Add listener to enable the tab to be opened once closed.
  tabTween.addEventListener(TweenEvent.MOTION_STOP, activateGlossaryTab);
  // Remove the listener from the glossary close button object
  glossaryCloseButton_mc.removeEventListener(MouseEvent.MOUSE_DOWN, closeGlossaryTab);
}

function openExplainerTab ():void {
  // Set the switch
  explanationLoaded = true;
  // Bring the explainer tab to the top of the display list 
  rootContainer_mc.setChildIndex(explainerTab_mc, rootContainer_mc.numChildren-1);
  // Open the tab
  moveTab (explainerTab_mc, "x", explainerTab_mc.x, 46);
}

function closeExplainerTab ():void {
  // Set the switch
  explanationLoaded = false;
  // Open the tab
  moveTab (explainerTab_mc, "x", explainerTab_mc.x, 1030);
}

// Loads the glossary term and displays the description in the textfield
// Deselects the previous term in the list
// Indicates the current term is selected in the list
function loadGlossaryTerm (event:MouseEvent):void {
  var targetTerm:String = event.target.getChildAt(0).text;
  var targetTermNameTextField:Object = glossaryTab_mc.getChildByName("termName");
  var targetTermDescriptionTextField:Object = glossaryTab_mc.getChildByName("termDescription");
  
  // Cache the text within the previous container
  var prevTargetLabel:String = prevTarget.getChildByName("term_txt").text;
  
  // Clear container of previous term
  clearContainer(prevTarget);
  
  // Replace with the previous term with default text
  var prevTarget_txt:TextField = new TextField ();
  prevTarget_txt.name = "term_txt";
  prevTarget_txt.embedFonts = true;
  prevTarget_txt.background = false;
  prevTarget_txt.selectable = false;
  prevTarget_txt.autoSize = TextFieldAutoSize.LEFT;
  prevTarget_txt.defaultTextFormat = glossaryTermUnselected_fmt;
  prevTarget_txt.text = prevTargetLabel;
  // Add textfield to previous container
  prevTarget.addChild(prevTarget_txt);
  
  // Reset the term description slot for the array 
  glossaryDescriptionIndex = 0;
  
  for (var i:int = 0 ; i < glossary_xml.child("term").length() ; i++){    
    if (glossary_xml.child("term")[i].child("term_name") == targetTerm) {
      // Clear container of target term
      clearContainer(event.target);
      // Add indicator graphic
      loadAsset(event.target as MovieClip, "assets/png/Glossary Selection Indicator.png");
      event.target.getChildAt(0).x = -15;
      event.target.getChildAt(0).y = -2;
      // Add Bold, Reversed text
      var targetTerm_txt:TextField = new TextField ();
      targetTerm_txt.name = "term_txt";
      targetTerm_txt.embedFonts = true;
      targetTerm_txt.background = false;
      targetTerm_txt.selectable = false;
      targetTerm_txt.autoSize = TextFieldAutoSize.LEFT;
      targetTerm_txt.defaultTextFormat = glossaryTermSelected_fmt;
      targetTerm_txt.text = glossary_xml.child("term")[i].child("term_name");
      event.target.addChild(targetTerm_txt);
      // Populate the glossary description fields
      targetTermNameTextField.htmlText = glossary_xml.child("term")[i].child("term_name");
      targetTermDescriptionTextField.htmlText = glossary_xml.child("term")[i].child("description")[0];
      // Register the index of the current term within the XML object
      glossaryTermIndex = i;
      
      trace (glossary_xml.child("term")[i].child("description").length());
      
      // Check for the need for pagination
      if(glossary_xml.child("term")[i].child("description").length() > 1){
        glossaryTab_mc.addChild(glossaryPreviousPageButton_mc);
        glossaryPreviousPageButton_mc.alpha = .1;
        glossaryTab_mc.addChild(glossaryNextPageButton_mc);
        glossaryNextPageButton_mc.alpha = 1;
      }else if (glossaryTab_mc.contains(glossaryNextPageButton_mc)) {
        glossaryTab_mc.removeChild(glossaryPreviousPageButton_mc);
        glossaryTab_mc.removeChild(glossaryNextPageButton_mc);
      }
      
      // Set the previous target to the current target
      prevTarget = event.target;
    }
  }
}

function loadGlossaryDefinitionPage (event:MouseEvent){
  var targetTermDescriptionTextField:Object = glossaryTab_mc.getChildByName("termDescription");
  var targetTermDescriptionLength:int = glossary_xml.child("term")[glossaryTermIndex].child("description").length();
  
  trace (targetTermDescriptionLength);
  
  switch(event.target.name) {
    case "glossaryNextDescriptionPage_mc":
      glossaryDescriptionIndex++;
      if (glossaryDescriptionIndex >= targetTermDescriptionLength - 1) {
        glossaryDescriptionIndex = targetTermDescriptionLength - 1;
        // Disable the next page button
        glossaryNextPageButton_mc.alpha = .1;
        glossaryPreviousPageButton_mc.alpha = 1;
      }
      break;
    case "glossaryPreviousDescriptionPage_mc":
      glossaryDescriptionIndex--;
      if (glossaryDescriptionIndex <= 0) {
        glossaryDescriptionIndex = 0;
        // Disable the previous page button
        glossaryPreviousPageButton_mc.alpha = .1;
        glossaryNextPageButton_mc.alpha = 1;
      }
      break;
  }
  
  // Update the text field with the new data
  targetTermDescriptionTextField.htmlText = glossary_xml.child("term")[glossaryTermIndex].child("description")[glossaryDescriptionIndex];
}

// Build the glossary within the experiment screen
function loadGlossary ():void {
  clearContainer (glossaryTab_mc);
  
  // Position glossary container
  glossaryTab_mc.mouseChildren = true;
  glossaryTab_mc.x = 0;
  glossaryTab_mc.y = -768;
  
  // Build the term title textfield
  glossaryTermName_txt.name = "termName";
  glossaryTermName_txt.embedFonts = true;
  glossaryTermName_txt.background = false;
  glossaryTermName_txt.selectable = false;
  glossaryTermName_txt.width = 800;
  glossaryTermName_txt.defaultTextFormat = glossaryTermName_fmt;
  glossaryTermName_txt.x = 40;
  glossaryTermName_txt.y = 100;
  glossaryTermName_txt.htmlText = glossary_xml.child("term")[0].child("term_name");
  
  // Build the term description textfield
  glossaryTermDescription_txt.name = "termDescription";
  glossaryTermDescription_txt.embedFonts = true;
  glossaryTermDescription_txt.background = false;
  glossaryTermDescription_txt.selectable = false;
  glossaryTermDescription_txt.wordWrap = true;
  glossaryTermDescription_txt.multiline = true;
  glossaryTermDescription_txt.autoSize = TextFieldAutoSize.LEFT;
  glossaryTermDescription_txt.width = 600;
  glossaryTermDescription_txt.defaultTextFormat = glossaryTermDescription_fmt;
  glossaryTermDescription_txt.x = 40;
  glossaryTermDescription_txt.y = 160;
  glossaryTermDescription_txt.htmlText = glossary_xml.child("term")[0].child("description")[0];
  
  // Build the tab name
  glossaryTabName_txt.embedFonts = true;
  glossaryTabName_txt.background = false;
  glossaryTabName_txt.selectable = false;
  glossaryTabName_txt.autoSize = TextFieldAutoSize.LEFT;
  glossaryTabName_txt.defaultTextFormat = glossaryTab_fmt;
  glossaryTabName_txt.x = 660;
  glossaryTabName_txt.y = 778;
  glossaryTabName_txt.text = "WANT TO KNOW MORE?";
  
  // Build the term selection container
  glossaryTermList_mc.mouseChildren = true;
  glossaryTermList_mc.x = 680;
  glossaryTermList_mc.y = 100;
  clearContainer(glossaryTermList_mc);
  
  // Populate the term selection container with the list of terms
  for (var i=0 ; i < glossary_xml.child("term").length() ; i++) {
    // Build the term list  
    var glossaryTerm_txt:TextField = new TextField ();
    glossaryTerm_txt.name = "term_txt";
    glossaryTerm_txt.embedFonts = true;
    glossaryTerm_txt.background = false;
    glossaryTerm_txt.selectable = false;
    glossaryTerm_txt.autoSize = TextFieldAutoSize.LEFT;
    glossaryTerm_txt.defaultTextFormat = glossaryTermUnselected_fmt;
    glossaryTerm_txt.htmlText = glossary_xml.child("term")[i].child("term_name");
    
    var glossaryTerm_mc:MovieClip = new MovieClip ();
    glossaryTerm_mc.name = "term"+i;
    glossaryTerm_mc.mouseChildren = false;
    glossaryTerm_mc.x = 0;
    glossaryTerm_mc.y = 40*i;
    glossaryTerm_mc.addEventListener(MouseEvent.MOUSE_DOWN, loadGlossaryTerm);
    
    glossaryTerm_mc.addChild(glossaryTerm_txt);
    glossaryTermList_mc.addChild(glossaryTerm_mc);
  }
  
  // Rebuild the first glossary term as "selected"
  prevTarget = glossaryTermList_mc.getChildByName("term0");
  // Clear container of target term
  clearContainer(prevTarget);
  
  // Add indicator graphic
  loadAsset(prevTarget as MovieClip, "assets/png/Glossary Selection Indicator.png");
  prevTarget.getChildAt(0).x = -15;
  prevTarget.getChildAt(0).y = -2;
  // Add Bold, Reversed text
  var targetTerm_txt:TextField = new TextField ();
  targetTerm_txt.name = "term_txt";
  targetTerm_txt.embedFonts = true;
  targetTerm_txt.background = false;
  targetTerm_txt.selectable = false;
  targetTerm_txt.autoSize = TextFieldAutoSize.LEFT;
  targetTerm_txt.defaultTextFormat = glossaryTermSelected_fmt;
  targetTerm_txt.text = glossary_xml.child("term")[0].child("term_name");
  prevTarget.addChild(targetTerm_txt);
  
  // Build close button
  glossaryCloseButton_mc.mouseChildren = false;
  glossaryCloseButton_mc.x = 850;
  glossaryCloseButton_mc.y = 700;
  loadAsset(glossaryCloseButton_mc, "assets/png/Glossary Close Button Icon.png");
  
  glossaryCloseButton_txt.embedFonts = true;
  glossaryCloseButton_txt.background = false;
  glossaryCloseButton_txt.selectable = false;
  glossaryCloseButton_txt.width = 180;
  glossaryCloseButton_txt.defaultTextFormat = glossaryCloseTab_fmt;
  glossaryCloseButton_txt.x = 30;
  glossaryCloseButton_txt.y = -3;
  glossaryCloseButton_txt.text = "CLOSE";
  
  glossaryCloseButton_mc.addChild(glossaryCloseButton_txt);
  
  // Build the glossary window
  loadAsset(glossaryTab_mc, "assets/png/Glossary Background.png");
  glossaryTab_mc.addChild(glossaryTermName_txt);
  glossaryTab_mc.addChild(glossaryTermDescription_txt);
  glossaryTab_mc.addChild(glossaryTermList_mc);
  
  // Check the need for a slider and mask rectangle for the glossary list
  if (glossary_xml.child("term").length() > 12){
    // Build the term selection mask
    var glossaryTermListMask:Sprite = new Sprite();
    glossaryTermListMask.graphics.beginFill(0xFF0000);
    glossaryTermListMask.graphics.drawRect(-15, -4, 300, 479);
    glossaryTermListMask.x = glossaryTermList_mc.x;
    glossaryTermListMask.y = glossaryTermList_mc.y;
    glossaryTab_mc.addChild(glossaryTermListMask);
    
    // Build the slider bar
    glossarySlider.width = 475;
    glossarySlider.direction = SliderDirection.VERTICAL;
    glossarySlider.liveDragging = true;
    glossarySlider.minimum = ((100 + glossaryTermListMask.height) - glossaryTermList_mc.height) - 4;
    glossarySlider.maximum = 100;
    glossarySlider.value = 100;
    glossarySlider.move(980, 100);
    glossarySlider.getChildAt(0).height = 18;
    glossarySlider.getChildAt(1).width = 20;
    glossarySlider.getChildAt(1).height = 40;
    glossarySlider.addEventListener(SliderEvent.CHANGE, changeHandler);
    
    function changeHandler(event:SliderEvent):void {
      glossaryTermList_mc.y = event.value; 
    }
    
    glossaryTab_mc.addChild(glossarySlider);
    // Assign the mask to the term list
    glossaryTermList_mc.mask = glossaryTermListMask;
  }
  
  trace (glossary_xml.child("term")[glossaryTermIndex].child("description").length());
  
  // Build pagination navigation
  // Glossary previous page button container
  glossaryPreviousPageButton_mc.name = "glossaryPreviousDescriptionPage_mc";
  glossaryPreviousPageButton_mc.mouseChildren = false;
  glossaryPreviousPageButton_mc.alpha = .1;
  glossaryPreviousPageButton_mc.x = 40;
  glossaryPreviousPageButton_mc.y = 560;
  loadAsset(glossaryPreviousPageButton_mc, "assets/png/Glossary Previous Page Icon.png");
  // Glossary previous page button textfield
  glossaryPreviousPageButton_txt.embedFonts = true;
  glossaryPreviousPageButton_txt.background = false;
  glossaryPreviousPageButton_txt.selectable = false;
  glossaryPreviousPageButton_txt.width = 250;
  glossaryPreviousPageButton_txt.defaultTextFormat = glossaryPreviousPage_fmt;
  glossaryPreviousPageButton_txt.x = 30;
  glossaryPreviousPageButton_txt.y = -4;
  glossaryPreviousPageButton_txt.text = "PREVIOUS PAGE";
  // Add the textfield to the previous button container display list
  glossaryPreviousPageButton_mc.addChild(glossaryPreviousPageButton_txt);
  // Add the listener to the button
  glossaryPreviousPageButton_mc.addEventListener(MouseEvent.MOUSE_DOWN, loadGlossaryDefinitionPage);
  
  // Glossary next page button container
  glossaryNextPageButton_mc.name = "glossaryNextDescriptionPage_mc";
  glossaryNextPageButton_mc.mouseChildren = false;
  glossaryNextPageButton_mc.alpha = 1;
  glossaryNextPageButton_mc.x = 615;
  glossaryNextPageButton_mc.y = 560;
  loadAsset(glossaryNextPageButton_mc, "assets/png/Glossary Next Page Icon.png");
  // Glossary next page button textfield
  glossaryNextPageButton_txt.embedFonts = true;
  glossaryNextPageButton_txt.background = false;
  glossaryNextPageButton_txt.selectable = false;
  glossaryNextPageButton_txt.width = 250;
  glossaryNextPageButton_txt.defaultTextFormat = glossaryNextPage_fmt;
  glossaryNextPageButton_txt.x = -255;
  glossaryNextPageButton_txt.y = -4;
  glossaryNextPageButton_txt.text = "NEXT PAGE";
  // Add the textfield to the next button container display list
  glossaryNextPageButton_mc.addChild(glossaryNextPageButton_txt);
  // Add the listener to the button
  glossaryNextPageButton_mc.addEventListener(MouseEvent.MOUSE_DOWN, loadGlossaryDefinitionPage);
    
  // Check for the need for pagination within the term description
  if(glossary_xml.child("term")[glossaryTermIndex].child("description").length() > 1){
    // Add the button containers to the glossary tab display list
    glossaryTab_mc.addChild(glossaryPreviousPageButton_mc);
    glossaryTab_mc.addChild(glossaryNextPageButton_mc);
  } else {
    if (glossaryTab_mc.contains(glossaryPreviousPageButton_mc)){
      // Remove the button containers from the glossary tab display list
      glossaryTab_mc.removeChild(glossaryPreviousPageButton_mc);
      glossaryTab_mc.removeChild(glossaryNextPageButton_mc);
    }
  }
  
  // Add the glossary tab label to the glossary container's display list
  glossaryTab_mc.addChild(glossaryTabName_txt);
  // Add the glossary close to the glossary container's display list
  glossaryTab_mc.addChild(glossaryCloseButton_mc);
  // Add the glossary to the root contianer's display list
  rootContainer_mc.addChild(glossaryTab_mc);
  TransitionManager.start(glossaryTab_mc, {type:Fade, direction:Transition.IN, duration:2, easing:Strong.easeOut});
  // Assign a listener to the glossary tab
  glossaryTab_mc.addEventListener(MouseEvent.MOUSE_DOWN, openGlossaryTab);
}

function loadActivityTab ():void {
  // Position the explainer tab
  explainerTab_mc.mouseChildren = true;
  explainerTab_mc.x = 1030;
  explainerTab_mc.y = 110;
  
  loadAsset(explainerTab_mc, "assets/png/Explainer Background.png");
  
  explainerTextHeader_txt.embedFonts = true;
  explainerTextHeader_txt.background = false;
  explainerTextHeader_txt.selectable = false;
  explainerTextHeader_txt.width = 300;
  explainerTextHeader_txt.defaultTextFormat = experimentExplainerHeader_fmt;
  explainerTextHeader_txt.x = 30;
  explainerTextHeader_txt.y = 25;
  explainerTextHeader_txt.htmlText = experimentExplanationHeader;
  
  explainerText_txt.embedFonts = true;
  explainerText_txt.background = false;
  explainerText_txt.selectable = false;
  explainerText_txt.wordWrap = true;
  explainerText_txt.multiline = true;
  explainerText_txt.autoSize = TextFieldAutoSize.LEFT;
  explainerText_txt.width = 300;
  explainerText_txt.defaultTextFormat = experimentExplainer_fmt;
  explainerText_txt.x = 30;
  explainerText_txt.y = 60;
  explainerText_txt.htmlText = experimentExplanationText;
  
  clearContainer(explainerActivity_mc);
  loadAsset(explainerActivity_mc, "assets/activities/"+experimentActivity_array[0]);
  explainerActivity_mc.mouseChildren = true;
  explainerActivity_mc.buttonMode = true;
  explainerActivity_mc.x = 375;
  explainerActivity_mc.y = 25;
  
  explainerTab_mc.addChild(explainerTextHeader_txt);
  explainerTab_mc.addChild(explainerText_txt);
  explainerTab_mc.addChild(explainerActivity_mc);
  
  rootContainer_mc.addChild(explainerTab_mc);
}

// Display the experiment screen
function loadExperimentScreen (experimentTitle:String):void {
  // Build screen title
  experimentTitle_txt.embedFonts = true;
  experimentTitle_txt.background = false;
  experimentTitle_txt.selectable = false;
  experimentTitle_txt.autoSize = TextFieldAutoSize.LEFT;
  experimentTitle_txt.defaultTextFormat = experimentTitle_fmt;
  experimentTitle_txt.htmlText = experimentTitle;
  
  // Build button textfields
  experimentMenuButton_txt.embedFonts = true;
  experimentMenuButton_txt.background = false;
  experimentMenuButton_txt.selectable = false;
  experimentMenuButton_txt.autoSize = TextFieldAutoSize.LEFT;
  experimentMenuButton_txt.defaultTextFormat = navigationButton_fmt;
  experimentMenuButton_txt.text = "CHOOSE AN EXPERIMENT";
  experimentMenuButton_txt.x = 26;
  experimentMenuButton_txt.y = 15;
    
  experimentBackButton_txt.embedFonts = true;
  experimentBackButton_txt.background = false;
  experimentBackButton_txt.selectable = false;
  experimentBackButton_txt.autoSize = TextFieldAutoSize.LEFT;
  experimentBackButton_txt.defaultTextFormat = navigationButton_fmt;
  experimentBackButton_txt.text = "BACK";
  experimentBackButton_txt.x = 22;
  experimentBackButton_txt.y = 15;
  
  experimentNextButton_txt.embedFonts = true;
  experimentNextButton_txt.background = false;
  experimentNextButton_txt.selectable = false;
  experimentNextButton_txt.autoSize = TextFieldAutoSize.LEFT;
  experimentNextButton_txt.defaultTextFormat = navigationButton_fmt;
  experimentNextButton_txt.text = "NEXT STEP";
  experimentNextButton_txt.x = 15;
  experimentNextButton_txt.y = 15;
  
  // Build experiment checkmark container
  var experimentCheckmark_mc:MovieClip = new MovieClip ();
  experimentCheckmark_mc.name = "stepCheckmark";
  experimentCheckmark_mc.mouseChildren = false;
  experimentCheckmark_mc.x = 0;
  experimentCheckmark_mc.y = 0;
  loadAsset(experimentCheckmark_mc, "assets/png/Checkbox unchecked.png");
  
  // Build experiment step textfield
  var experimentStep_txt:TextField = new TextField();
  experimentStep_txt.name = "stepText";
  experimentStep_txt.embedFonts = true;
  experimentStep_txt.background = false;
  experimentStep_txt.selectable = false;
  experimentStep_txt.multiline = true;
  experimentStep_txt.wordWrap = true;
  experimentStep_txt.autoSize = TextFieldAutoSize.LEFT;
  experimentStep_txt.width = 400;
  experimentStep_txt.defaultTextFormat = experimentStep_fmt;
  experimentStep_txt.x = 50;
  experimentStep_txt.y = 10;
  experimentStep_txt.htmlText = experimentSteps_array[0];
  
  // Build experiment step container
  var experimentStep_mc:MovieClip = new MovieClip ();
  experimentStep_mc.name = "step_1";
  experimentStep_mc.mouseChildren = true;
  experimentStep_mc.x = 40;
  experimentStep_mc.y = 125;
  experimentStep_mc.addChild(experimentStep_txt);
  // If there is only 1 step, do not load the checkmark into the container
  if (numSteps > 1){
    experimentStep_mc.addChild(experimentCheckmark_mc);
  }
  
  // Build video container
  experimentStepVideo_mc.mouseChildren = true;
  loadAsset(experimentStepVideo_mc, "assets/png/Video Container.png");
  
  // If there is only 1 step, do not load the video player into the container
  if (numSteps > 1){
    // Init video player
    var videoPath:String = "assets/video/"+experimentVideo_array[0];
         
    player.source = videoPath;
    player.skin = "assets/skin/cs_skin_video.swf";
    player.skinBackgroundColor = 0x4d4d4d;
    player.fullScreenTakeOver = false;
    player.scaleX = 1.25;
    player.scaleY = 1.25;
    player.x = 30;
    player.y = 40;
    experimentStepVideo_mc.addChild(player);
  } else {
    // Add image container and place advanced experiment image in the container
    loadAsset(experimentStepVideo_mc, "assets/video/"+experimentVideo_array[0]);
  }
  
  // Build left button block
  leftButtonBlock_mc.name = "leftButtonBlock_mc";
  leftButtonBlock_mc.mouseChildren = true;
  loadAsset(leftButtonBlock_mc, "assets/png/Choose Experiment Left Button Block.png");
  
  // Build the "Choose an experiment" button
  experimentMenuButton_mc.mouseChildren = false;
  experimentMenuButton_mc.x = 25;
  experimentMenuButton_mc.y = 15;
  loadAsset(experimentMenuButton_mc, "assets/png/Choose Experiment Button Left.png");
  
  experimentMenuButton_mc.addChild (experimentMenuButton_txt);
  
  experimentMenuButton_mc.addEventListener(MouseEvent.MOUSE_UP, navigate_ExperimentToSelect);
  
  leftButtonBlock_mc.addChild (experimentMenuButton_mc);  
  
  rootContainer_mc.addChild (experimentTitle_txt);
  rootContainer_mc.addChild (experimentStep_mc);
  TransitionManager.start(experimentStep_mc, {type:Fade, direction:Transition.IN, duration:2, easing:Strong.easeOut});
  rootContainer_mc.addChild (leftButtonBlock_mc);
  TransitionManager.start(rightButtonBlock_mc, {type:Fade, direction:Transition.IN, duration:2, easing:Strong.easeOut});
  rootContainer_mc.addChild (experimentStepVideo_mc);
  
  // If there is more than 1 step, load the step counter and right button block
  if (numSteps > 1){
    // Build experiment step counter textfield
    experimentStepCount_txt.embedFonts = true;
    experimentStepCount_txt.background = false;
    experimentStepCount_txt.selectable = false;
    experimentStepCount_txt.width = 200;
    experimentStepCount_txt.defaultTextFormat = experimentStepCount_fmt;
    experimentStepCount_txt.text = "STEP 1 OF "+numSteps;
    
    // Build right button block
    rightButtonBlock_mc.name = "rightButtonBlock_mc";
    rightButtonBlock_mc.mouseChildren = true;
    loadAsset(rightButtonBlock_mc, "assets/png/Right Button Block.png");
  
    // Configure the back button
    experimentBackButton_mc.name = "backBtn_mc";
    experimentBackButton_mc.mouseChildren = false;
    experimentBackButton_mc.x = 25;
    experimentBackButton_mc.y = 15;
    experimentBackButton_mc.alpha = .25;
    loadAsset(experimentBackButton_mc, "assets/png/Back Button.png");
  
    experimentBackButton_mc.addChild (experimentBackButton_txt);
  
    // Configure the next button
    experimentNextButton_mc.name = "nextBtn_mc";
    experimentNextButton_mc.mouseChildren = false;
    experimentNextButton_mc.x = 190;
    experimentNextButton_mc.y = 15;
    experimentNextButton_mc.alpha = 1;
    loadAsset(experimentNextButton_mc, "assets/png/Next Button.png");
  
    experimentNextButton_mc.addChild (experimentNextButton_txt);
  
    experimentNextButton_mc.addEventListener(MouseEvent.MOUSE_UP, loadNextExperimentStep);
  
    rightButtonBlock_mc.addChild (experimentBackButton_mc);
    rightButtonBlock_mc.addChild (experimentNextButton_mc);
    
    // Set the progress bar variables
    experimentStepCount_pb.minimum = stepCount;
    experimentStepCount_pb.maximum = numSteps;
    experimentStepCount_pb.mode = ProgressBarMode.MANUAL;
    experimentStepCount_pb.setSize(125, 15);
    experimentStepCount_pb.setProgress(stepCount, numSteps);

    rootContainer_mc.addChild (experimentStepCount_pb);
    rootContainer_mc.addChild (experimentStepCount_txt);
    rootContainer_mc.addChild (rightButtonBlock_mc);
        
    TransitionManager.start(rightButtonBlock_mc, {type:Fade, direction:Transition.IN, duration:2, easing:Strong.easeOut});
  }
  
  // Get the glossary terms from the xml file and build the glossary container
  getGlossaryTerms ("glossary_terms.xml");
  // Load the activity tab
  loadActivityTab();
  // Load the sound file into the object
  step_snd = new SoundLoader("assets/audio/"+experimentAudio_array[0], false);
  // Play the sound
  step_snd.soundPlay();
}

// Init the kiosk
// Bring the kiosk to full screen
stage.displayState = StageDisplayState.FULL_SCREEN;
// Create the main container
addChild (rootContainer_mc);
// Assign timeout listeners
getExperimentList ("experiment_list.xml");


