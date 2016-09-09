// Containers and objects used in the lab companion

// Objects for XML data
var introductionText_array:Array = new Array();
var introductionImage_array:Array = new Array();
var experimentList_xml:XML;
var experimentList_array:Array = new Array();
var experimentFile_array:Array = new Array();
var experiment_xml:XML;
var experimentSteps_array:Array = new Array();
var experimentAudio_array:Array = new Array();
var experimentVideo_array:Array = new Array();
var experimentActivity_array:Array = new Array();
var numExperiments:int;
var numSteps:int;
var experimentTitle:String;
var experimentExplanationHeader:String;
var experimentExplanationText:String;
var glossary_xml:XML;
var glossaryTermIndex:int = 0;
var glossaryDescriptionIndex:int = 0;

// Increment for building the experiment tile sets
var initialArraySlot:int = 0;
// End of list switch for the experiment tile sets
var endOfList:Boolean = false;
// Page tracker for the experiment tile set
var pageCount:int = 0;
// Current step of the experiment
var stepCount:int = 1;
// Explanation switch
var explanationLoaded:Boolean = false;

// Root container
var rootContainer_mc:MovieClip = new MovieClip ();

// Title screen
var titleLogo_mc:MovieClip = new MovieClip();
var titlePlate_mc:MovieClip = new MovieClip();
// Begin button container
var beginButton_mc:MovieClip = new MovieClip ();
var titleBeginButton_txt:TextField = new TextField();

// Intro screen
// Title textfield
var introTitleStatic_txt:TextField = new TextField();
var introTitleDynamic_txt:TextField = new TextField();
// Image 1 container
var introImg1_mc:MovieClip = new MovieClip();
// Textfield 1
var introImg1_txt:TextField = new TextField();
// Textfield 2
var introImg2_txt:TextField = new TextField();
// Right button block container
var introRightButtonBlock_mc:MovieClip = new MovieClip();
// Choose an experiment button container
var introMenuButton_mc:MovieClip = new MovieClip ();
var introMenuButton_txt:TextField = new TextField ();

// Select screen
// Instruction text
var selectInstruction_txt:TextField = new TextField();
// Previous experiment set container
var previousSelectSet_mc:MovieClip = new MovieClip ();
// Next experiment set container
var nextSelectSet_mc:MovieClip = new MovieClip ();
// Experiment sets container
var experimentsContainer_mc:MovieClip = new MovieClip ();
// Left button block
var selectLeftButtonBlock_mc:MovieClip = new MovieClip ();
// Getting started button container
var selectMenuButton_mc:MovieClip = new MovieClip ();
var selectMenuButton_txt:TextField = new TextField ();
// Set page indicator container
var setPageContainer_mc:MovieClip = new MovieClip ();

// Experiment screen
// Experiment title
var experimentTitle_txt:TextField = new TextField();
// Experiment video container
var experimentStepVideo_mc:MovieClip = new MovieClip ();
// Experiment video player
var player:FLVPlayback = new FLVPlayback ();
// Experiment left button block container
var leftButtonBlock_mc:MovieClip = new MovieClip ();
// Experiment "back to menu" button container
var experimentMenuButton_mc:MovieClip = new MovieClip ();
var experimentMenuButton_txt:TextField = new TextField();
// Experiment right button block container
var rightButtonBlock_mc:MovieClip = new MovieClip ();
// Experiment "back" button container
var experimentBackButton_mc:MovieClip = new MovieClip ();
var experimentBackButton_txt:TextField = new TextField();
// Experiment "next step" button container
var experimentNextButton_mc:MovieClip = new MovieClip ();
var experimentNextButton_txt:TextField = new TextField();
// Step counter
var experimentStepCount_txt:TextField = new TextField();
// Step progress bar
var experimentStepCount_pb:ProgressBar = new ProgressBar();

// Glossary
// Glossary container
var glossaryTab_mc:MovieClip = new MovieClip ();
// Glossary list container
var glossaryTermList_mc:MovieClip = new MovieClip ();
// Glossary list slider
var glossarySlider:Slider = new Slider();
// Glossary list textfields
var glossaryTermName_txt:TextField = new TextField ();
var glossaryTermDescription_txt:TextField = new TextField ();
// Glossary tab name textfield
var glossaryTabName_txt:TextField = new TextField ();
// Glossary next page button container
var glossaryNextPageButton_mc:MovieClip = new MovieClip ();
var glossaryNextPageButton_txt:TextField = new TextField ();
// Glossary previous page button container
var glossaryPreviousPageButton_mc:MovieClip = new MovieClip ();
var glossaryPreviousPageButton_txt:TextField = new TextField ();
// Glossary close button container
var glossaryCloseButton_mc:MovieClip = new MovieClip ();
var glossaryCloseButton_txt:TextField = new TextField ();
// Object for glossary list selection
var prevTarget:Object;

// Explainer
// Explainer root container
var explainerTab_mc:MovieClip = new MovieClip ();
// Activity text header
var explainerTextHeader_txt:TextField = new TextField ();
// Activity text
var explainerText_txt:TextField = new TextField ();
// Activity container
var explainerActivity_mc:MovieClip = new MovieClip();

// Sound object
var step_snd:SoundLoader;
// Timer object
var csTimeout:AttractTimer;
// Tab tweening object
var tabTween:Tween;