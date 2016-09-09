import fl.transitions.*;
import fl.transitions.easing.*;
import XMLLoader;
import PreLoader;
import CameraCapture;
import AttractTimer;

// Set the application to fullscreen
fscommand("fullscreen", "true");

// Variables
var captureSlot:int;
var captureClip:DisplayObject;
var colorSpacing:int = 5;
var showQuoteNum:int = 0;

// Arrays
var capture_Array:Array = new Array();
var rowHeight_Array:Array = new Array();
rowHeight_Array[0] = 23;
rowHeight_Array[1] = 174;
rowHeight_Array[2] = 326;
rowHeight_Array[3] = 477;
rowHeight_Array[4] = 628;

var quote_Array:Array = new Array();
quote_Array[0] = "How often do you think about your skin color?";
quote_Array[1] = "Does your skin color affect how others treat you?";
quote_Array[2] = "Does your skin color give you advantages?";
quote_Array[3] = "Does your skin color give you disadvantages?";
quote_Array[4] = "Who decides what skin color means?";
quote_Array[5] = "Who decides what skin color means?";

var quote1_right:QuoteRight = new QuoteRight;
var quote2_right:QuoteRight = new QuoteRight;
var quote3_right:QuoteRight = new QuoteRight;

var quote1_left:QuoteLeft = new QuoteLeft;
var quote2_left:QuoteLeft = new QuoteLeft;
var quote3_left:QuoteLeft = new QuoteLeft;

// Containers
var mainContainer:MovieClip = new MovieClip;
var attractContainer:MovieClip = new MovieClip;

// Add attract listener
addEventListener (Event.ENTER_FRAME, checkTimeout, false, 0, true);

// Remove the focus highlight from the stage
stage.stageFocusRect = false;

// Camera
var colorCamera:CameraCapture = new CameraCapture(160, 120, 1, 0, 0);

// Utility functions
function loadImage (imgPath:String, mc:MovieClip, scale:Number):void
{
	var ldr:Loader = new Loader();
	var url:String = imgPath;
	var urlReq:URLRequest = new URLRequest(url);
	ldr.load (urlReq);
	ldr.scaleX = scale;
	ldr.scaleY = scale;
	mc.smoothing = true;
	mc.addChild (ldr);
}

function loadContent (mc:MovieClip, mcName:String, mcScale:Number,  myPath:String):void
{
	var loader:PreLoader = new PreLoader(mc, mcName, mcScale,  myPath);
}

function listDisplayItems (container:DisplayObjectContainer)
{
	var list:Array = new Array();
	for (var i:Number = 0; i < container.numChildren; i++)
	{
		list[i] = (container.getChildAt(i).name);
	}
	return list;
}

function cleanContainer (container):void
{
	var i:int = container.numChildren;
	while (i --)
	{
		container.removeChildAt (i);
	}
}

// XML import
var XMLPath:String = "xml/";
var myItemsLoader:XMLLoader = new XMLLoader(XMLPath + "captures.xml");
myItemsLoader.addEventListener (Event.COMPLETE, createCaptureArray);

// Generate the capture lists from the XML document
function createCaptureArray (event:Event):void
{
	var xmlItems:XML = new XML();
	xmlItems = myItemsLoader.p_XML;
	for (var i:Number = 0; i<xmlItems.children().length(); i++)
	{
			var item:Object = new Object();
			item.jpgPath = xmlItems.children()[i];
			capture_Array[capture_Array.length] = item;
	}
	// Add the root container
	addChild(mainContainer);
	mainContainer.x = 10;
	mainContainer.y = 0;
	// Create the image grid
	createGrid (capture_Array, mainContainer, 8, colorSpacing);
	// Add the camera to the stage
	// Add the key event to the camera
	colorCamera.addEventListener(KeyboardEvent.KEY_DOWN, moveCamera, false, 0, true);
	addChild(colorCamera);
	stage.focus = colorCamera;
	// Position the camera
	captureSlot = int(Math.random() * capture_Array.length);
	captureClip = mainContainer.getChildAt(captureSlot);
	colorCamera.x = captureClip.x + (colorSpacing*2);
	colorCamera.y = captureClip.y;
}

// Attract screen timer

// Create Timeout
var kiosk_Timeout:AttractTimer = new AttractTimer((4 * 60) * 1000);

function resetTimer (event:KeyboardEvent):void
{
	// Reset attract loop timeout
	kiosk_Timeout.p_lastInterval = getTimer();
}

// Checks to see if the timeout interval has been reached
function checkTimeout (event:Event):void
{
	kiosk_Timeout.checkTime (event);
	if (kiosk_Timeout.p_intervalComplete == true)
	{
		gotoAttract();
	}
}

function gotoAttract ()
{
	removeEventListener (KeyboardEvent.KEY_DOWN, resetTimer);
	removeEventListener (Event.ENTER_FRAME, checkTimeout);
	
	// Clear the main container
	addChild(attractContainer);
	// Remove the camera
	removeChild(colorCamera);
	// Clean up any quotes that are present on the stage
	if (contains(quote1_right))
	{
		removeChild(quote1_right);
	}
	if (contains(quote2_right))
	{
		removeChild(quote2_right);
	}
	if (contains(quote3_right))
	{
		removeChild(quote3_right);
	}
	if (contains(quote1_left))
	{
		removeChild(quote1_left);
	}
	if (contains(quote2_left))
	{
		removeChild(quote2_left);
	}
	if (contains(quote3_left))
	{
		removeChild(quote3_left);
	}
	// Set focus to the stage
	stage.focus = attractContainer;
	// Load screensaver swf
	loadContent (attractContainer, "attract_mc", 1, "attract/attractscreen_1360.swf");
	
	// Add listener to return the user to the main activity
	attractContainer.addEventListener (KeyboardEvent.KEY_DOWN, gotoActivity, false, 0, true);
}

// Reset the timeout interval
// Send the user to the initial intro screen
function gotoActivity (event:KeyboardEvent):void
{
	removeEventListener (KeyboardEvent.KEY_DOWN, gotoActivity);
	// Reset attract loop timeout
	kiosk_Timeout.p_lastInterval = getTimer();
	kiosk_Timeout.p_intervalComplete = false;
	
	removeChild(attractContainer);
	addChild(colorCamera);
	stage.focus = colorCamera;
	// Position the camera
	captureSlot = int(Math.random() * capture_Array.length);
	captureClip = mainContainer.getChildAt(captureSlot);
	colorCamera.x = captureClip.x + (colorSpacing*2);
	colorCamera.y = captureClip.y;
	
	addEventListener (KeyboardEvent.KEY_DOWN, resetTimer, false, 0, true);
	addEventListener (Event.ENTER_FRAME, checkTimeout, false, 0, true);
}

// Moves the camera to a new position
// Places the image grab into the previous container
function moveCamera (event:KeyboardEvent)
{
	trace("Moving camera");
	// Assign the current target clip
	captureClip = mainContainer.getChildAt(captureSlot);
	// Clean the target container of children
	cleanContainer(captureClip);
	// Place the bitmap data into the current container
	colorCamera.grabVideoData(1, 0, 0, mainContainer.getChildAt(captureSlot));
	// Move the camera to the next container
	captureSlot = int(Math.random() * capture_Array.length);
	captureClip = mainContainer.getChildAt(captureSlot);
	colorCamera.x = captureClip.x + (colorSpacing*2);
	colorCamera.y = captureClip.y;
	
	// Clean up any quotes that are present on the stage
	if (contains(quote1_right))
	{
		removeChild(quote1_right);
	}
	if (contains(quote2_right))
	{
		removeChild(quote2_right);
	}
	if (contains(quote3_right))
	{
		removeChild(quote3_right);
	}
	if (contains(quote1_left))
	{
		removeChild(quote1_left);
	}
	if (contains(quote2_left))
	{
		removeChild(quote2_left);
	}
	if (contains(quote3_left))
	{
		removeChild(quote3_left);
	}
	
	// Display the next quote in the sequence
	switch (showQuoteNum)
	{
		case 0 :
			quote1_right.x = colorSpacing;
			quote1_right.y = rowHeight_Array[1] - 33;
			quote1_right.quote_txt.text = quote_Array[0];
			addChild(quote1_right);
			TransitionManager.start(quote1_right, {type:Wipe, direction:Transition.IN, duration:.25, easing:None.easeNone, startPoint:4});
			break;
	
		case 1 :
			quote2_right.x = colorSpacing;
			quote2_right.y = rowHeight_Array[3] - 33;
			quote2_right.quote_txt.text = quote_Array[1];
			addChild(quote2_right);
			TransitionManager.start(quote2_right, {type:Wipe, direction:Transition.IN, duration:.25, easing:None.easeNone, startPoint:4});
			break;
			
		case 2 :
			quote3_right.x = colorSpacing;
			quote3_right.y = rowHeight_Array[4] - 33;
			quote3_right.quote_txt.text = quote_Array[2];
			addChild(quote3_right);
			TransitionManager.start(quote3_right, {type:Wipe, direction:Transition.IN, duration:.25, easing:None.easeNone, startPoint:4});
			break;
			
		case 3 :
			quote1_left.x = 950;
			quote1_left.y = rowHeight_Array[1] - 33;
			quote1_left.quote_txt.text = quote_Array[3];
			addChild(quote1_left);
			TransitionManager.start(quote1_left, {type:Wipe, direction:Transition.IN, duration:.25, easing:None.easeNone, startPoint:4});
			break;
			
		case 4 :
			quote2_left.x = 950;
			quote2_left.y = rowHeight_Array[2] - 33;
			quote2_left.quote_txt.text = quote_Array[4];
			addChild(quote2_left);
			TransitionManager.start(quote2_left, {type:Wipe, direction:Transition.IN, duration:.25, easing:None.easeNone, startPoint:4});
			break;
			
		case 5 :
			quote3_left.x = 950;
			quote3_left.y = rowHeight_Array[3] - 33;
			quote3_left.quote_txt.text = quote_Array[5];
			addChild(quote3_left);
			TransitionManager.start(quote3_left, {type:Wipe, direction:Transition.IN, duration:.25, easing:None.easeNone, startPoint:4});
			break;
	}
	// Increment the showQuote number
	if (showQuoteNum < 5)
	{
		showQuoteNum++;
	}
	else
	{
		showQuoteNum = 0;
	}
}

function showName (event:MouseEvent)
{
	trace(event.target.name);
}

// Populates the item container with the icons from the available items array
function createGrid (array:Array, container:MovieClip, numColumns:int, gudderWidth:int):void
{
	// Number of available items in the array
	var numIcons:int = array.length;
	// Item name
	var iconIndex:int = 0;
	// Item image
	var imageIndex:int = 0;
	// Number of columns within the container
	var columns:int = numColumns;
	// Number of rows within the container
	var rows:int = Math.ceil(numIcons/columns);
	// Width of gap between icons
	var gudder:int = gudderWidth;
	// X coordinate of icon
	var iconX:int;
	// Y coordinate of icon
	var iconY:int;
	// Path to the image
	var imagePath:String;
	
	// Populate the container with the available tools from the array
	// Rows
	for (var r:int = 0; r < rows; r++)
	{
		// Columns
		for (var c:int = 0; c < columns; c++)
		{
			if (iconIndex < numIcons)
			{
				// Make an instance of the icon container class
				var iconContainer:SkinContainer = new SkinContainer();
				iconContainer.alpha = .75;
				iconContainer.mouseChildren = false;
				iconContainer.name = "capture"+iconIndex;
				// Position the container into the grid structure
				iconX = gudder+((iconContainer.width+gudder)*c);
				iconY = rowHeight_Array[r];
				iconContainer.x = iconX;
				iconContainer.y = iconY;
				iconContainer.addEventListener(MouseEvent.ROLL_OVER, showName, false, 0, true);
				// Add the image to the item container
				iconContainer.bmp_mc.smoothing = true;
				imagePath = "skins/"+array[imageIndex].jpgPath;
				loadImage (imagePath, iconContainer.bmp_mc, 1);
				container.addChild (iconContainer);
				// Begin the transitions
				TransitionManager.start (iconContainer, {type:Fade, direction:Transition.IN, duration:4, easing:Strong.easeOut});
				TransitionManager.start (iconContainer, {type:Zoom, direction:Transition.IN, duration:.5, easing:Bounce.easeOut});
				// Increment next icon and image
				iconIndex++;
				imageIndex++;
			}
		}
	}
} 
	