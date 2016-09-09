// Classes
import XMLLoader;

// XML Import
// XML filepath
var myXMLPath = "newscasts/";
// Create the xmlQsetList object
var xmlNewscastList:XMLLoader = new XMLLoader(myXMLPath + "newscast_admin.xml");
// Add a listener for when the list completes loading
xmlNewscastList.addEventListener (Event.COMPLETE, xmlImportComplete);
// Newscast list
var newscast_list:Object = new Object();
var newscast_info:Object = new Object();
// Newscast Container
var newscastContainer:MovieClip = new MovieClip();
// Newscast String
var newscastBody:String;
// Stylesheet
var style:StyleSheet = new StyleSheet();
// Scrolling
var scrolling:Boolean = false;
var endOfStory:Boolean = false;
var scrollSpeed:int = 2;

function addCSS () {   
  var title:Object = new Object();
  title.fontFamily = "Arial";
  title.fontWeight = "bold";
  title.textAlign = "center";
  title.color = "#FF0000";
  title.fontSize = 36;

  var actor1:Object = new Object();
  actor1.fontFamily = "Arial";
  actor1.fontWeight = "bold";
  actor1.color = "#99FF77";
  actor1.fontSize = 48;

  var story:Object = new Object();
  story.fontFamily = "Arial";
  story.color = "#FFFFFF";
  story.fontSize = 48;

  var footer:Object = new Object();
  footer.fontFamily = "Arial";
  footer.fontWeight = "bold";
  footer.textAlign = "center";
  footer.color = "#FF0000";
  footer.fontSize = 36;
  
  style.setStyle(".title", title);
  style.setStyle(".actor1", actor1);
  style.setStyle(".story", story);
  style.setStyle(".footer", footer);
}

// Establish CSS Style
addCSS();
// Add a container to the stage
addChild(newscastContainer);

// Generate the newscast set list
// Load the first set
function xmlImportComplete (event:Event):void {
  var xmlNewscastSets:XML = new XML();
  xmlNewscastSets = xmlNewscastList.p_XML;
  newscast_list = xmlNewscastSets;
  newscast_info.numActive = (newscast_list.set_list.@total_qsets)-1;
  newscast_info.setNumber = 0;
  newscast_info.setLoaded = false;
  // Load the Qset from the list
  loadNewscast (newscast_info.setNumber);
}

// Loads the question set in the list based on the slot qset_info.setNumber
function loadNewscast (newscastNum:Number) {
  trace ("newscastNum: "+newscastNum);
  trace ("numActiveNewscasts: "+newscast_info.numActive);
  trace ("newscast filename: "+newscast_list.set_list.newscast[newscastNum]);
  
  var xmlNewscastLoader:XMLLoader = new XMLLoader(myXMLPath + newscast_list.set_list.newscast[newscastNum]+".xml");
  xmlNewscastLoader.addEventListener (Event.COMPLETE, newscastLoadComplete);
  
  // Alias the newscast from the XML object
  function newscastLoadComplete (event:Event):void {
    var xmlNewscast:XML = new XML();
    xmlNewscast = xmlNewscastLoader.p_XML;
    newscast_info.newscastInfo = xmlNewscast.set_info;
    newscast_info.newscastName = newscast_list.set_list.newscast[newscast_info.setNumber];
    newscast_info.newscastLoaded = true;
    
    // Generate newscast text
    newscastBody = xmlNewscast.title + "<br><br>";
    for each (var i:XML in xmlNewscast.actor) {
      newscastBody += i.name + "<br>" + i.passage + "<br><br><br>";
    }
    newscastBody += xmlNewscast.endline;
    addNewscast(newscastContainer);
  }
}

var newscastText:TextField = new TextField();

function addNewscast (container:MovieClip)
{
  if (container.contains(newscastText)) {
    container.removeChildAt(0);
  } 
  // Generate text field
  container.x = 140;
  container.y = 0;
  //newscastText.scaleX = -1;
  //newscastText.x = 1000;
  newscastText.width = 1000;
  newscastText.autoSize = TextFieldAutoSize.LEFT;
  newscastText.wordWrap = true;
  newscastText.multiline = true;
  //newscastText.embedFonts = true;
  newscastText.selectable = false;
  newscastText.styleSheet = style;
  newscastText.htmlText = "<p>"+newscastBody+"</p>";
  container.addChild(newscastText);
  // Add scrolling listener
  container.addEventListener(KeyboardEvent.KEY_DOWN, initScroll);
  // Set the focus to the textfield
  stage.stageFocusRect = false;
  stage.focus = container;
}

// Input events for the newscast
function initScroll (event:KeyboardEvent) {
  trace("keyDownHandler: " + event.keyCode);
  switch (event.keyCode) {
    // "Spacebar" Key
    case 32:
      if (scrolling == false) {
        if (endOfStory == true) {
          newscastContainer.y = 0;
          endOfStory = false;
        } else {	
          newscastContainer.addEventListener(Event.ENTER_FRAME, scrollField, false, 0, true);
          scrolling = true;
        }
      } else {
        newscastContainer.removeEventListener(Event.ENTER_FRAME, scrollField);
        scrolling = false;
      }
      break;
    // "n" Key
    case 78:
      trace ("Next!");
      loadNextNewscast();
      break;
  }
}

// Scrolls the newscast
function scrollField (event:Event) {
  var newscastValue:Number = newscastContainer.y + newscastContainer.height;
  var stageValue:Number = stage.stageHeight-50;
  if (newscastValue >= stageValue) {
    newscastContainer.y = newscastContainer.y-scrollSpeed;
  } else {
    newscastContainer.removeEventListener(Event.ENTER_FRAME, scrollField);
    endOfStory = true;
    scrolling = false;
  }
}	

// Loads the next newscast in the list
function loadNextNewscast() {
  if (newscast_info.setNumber < newscast_info.numActive) {
    newscast_info.setNumber++;
  } else {
    newscast_info.setNumber = 0;
  }
  loadNewscast (newscast_info.setNumber);
  /* 	newscastContainer.removeEventListener(Event.ENTER_FRAME, scrollField); */
  endOfStory = false;
  scrolling = false;
}

fscommand("fullscreen", "true");
