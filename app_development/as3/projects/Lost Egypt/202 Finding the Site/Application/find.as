// $Id$

import fl.transitions.*;
import fl.transitions.easing.*;
import fl.video.FLVPlayback;
import PreLoader;
import PhotoStack;

// Variables
var gallery:PhotoStack;
var tutorialBook:PhotoStack;
var player:FLVPlayback = new FLVPlayback();
var tutorialOption1_btn:TutorialVideo = new TutorialVideo();
var tutorialOption2_btn:TutorialFlipbook = new TutorialFlipbook();
var tutorialOption3_btn:MenuOption = new MenuOption();
var locDescription:LocationDescription = new LocationDescription();
var loc1Btn:Location = new Location();
var loc2Btn:Location = new Location();
var loc3Btn:Location = new Location();
var loc4Btn:Location = new Location();
var loc5Btn:Location = new Location();
var loc6Btn:Location = new Location();
var loc7Btn:Location = new Location();		
var satImage_Mask:MapMask = new MapMask();
var navImage_Mask:NavMask = new NavMask();

var videoPath:String = "video/find.flv";
var indicatorRect:MovieClip;
var mapScale:Number = 1;
var indicatorScale:Number = int((mapScale*.18)*100)/100;
var panDirection:String = "";
var isDragging:Boolean = false;
var isZoomed:Boolean = false;

// Create Timeout
var kiosk_Timeout:AttractTimer = new AttractTimer((4 * 60) * 1000);

// Utility functions
function loadContent (mc:MovieClip, mcName:String, mcScale:Number,  myPath:String):void
{
	var loader:PreLoader = new PreLoader(mc, mcName, mcScale,  myPath);
}

function cleanContainer (container:DisplayObjectContainer):void
{
	var i:int = container.numChildren;
	while (i --)
	{
		container.removeChildAt (i);
	}
}

// Tutorial section
function gotoTutorialOption1 (event:MouseEvent)
{
	tutorialOption1_btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	tutorialOption1_btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	tutorialOption1_btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	tutorialOption1_btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	tutorialOption1_btn.removeEventListener (MouseEvent.CLICK, gotoTutorialOption1);
	tutorialContainer_mc.removeChild (tutorialOption1_btn);

	tutorialOption2_btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	tutorialOption2_btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	tutorialOption2_btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	tutorialOption2_btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	tutorialOption2_btn.removeEventListener (MouseEvent.CLICK, gotoTutorialOption2);
	tutorialContainer_mc.removeChild (tutorialOption2_btn);

	player.width = 450;
	player.height = 300;
	player.x = 0;
	player.y = 0;
	player.fullScreenTakeOver = false;
	player.source = videoPath;
	player.skin = "video/SkinUnderAllNoFullNoCaption.swf";
	player.skinAutoHide = true;
	player.skinBackgroundColor = 0x002E56;
	player.buttonMode = true;
	tutorialContainer_mc.addChild (player);
	
	tutorialOption3_btn.x = -622;
	tutorialOption3_btn.y = 100;
	tutorialOption3_btn.gotoAndStop (1);
	tutorialOption3_btn.buttonMode = true;
	tutorialOption3_btn.mouseChildren = false;
	tutorialOption3_btn.btn_txt.text = "Choose another tutorial.";
	tutorialOption3_btn.addEventListener (MouseEvent.MOUSE_OVER, navigation_over, false, 0, true);
	tutorialOption3_btn.addEventListener (MouseEvent.MOUSE_UP, navigation_up, false, 0, true);
	tutorialOption3_btn.addEventListener (MouseEvent.MOUSE_DOWN, navigation_down, false, 0, true);
	tutorialOption3_btn.addEventListener (MouseEvent.MOUSE_OUT, navigation_out, false, 0, true);
	tutorialOption3_btn.addEventListener (MouseEvent.CLICK, gotoShowOption4, false, 0, true);
	addChild (tutorialOption3_btn);
}

function gotoTutorialOption2 (event:MouseEvent)
{
	tutorialOption1_btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	tutorialOption1_btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	tutorialOption1_btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	tutorialOption1_btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	tutorialOption1_btn.removeEventListener (MouseEvent.CLICK, gotoTutorialOption1);
	tutorialContainer_mc.removeChild (tutorialOption1_btn);

	tutorialOption2_btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	tutorialOption2_btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	tutorialOption2_btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	tutorialOption2_btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	tutorialOption2_btn.removeEventListener (MouseEvent.CLICK, gotoTutorialOption2);
	tutorialContainer_mc.removeChild (tutorialOption2_btn);
		
	tutorialText_txt.x = -625;
	tutorialText_txt.y = -145;
	
	tutorialContainer_mc.scaleX = .75;
	tutorialContainer_mc.scaleY = .75;
	// Populate the gallery container
	tutorialBook = new PhotoStack("xml/process.xml",tutorialContainer_mc, tutorialText_txt);
	
	tutorialOption3_btn.x = -622;
	tutorialOption3_btn.y = 100;
	tutorialOption3_btn.gotoAndStop (1);
	tutorialOption3_btn.buttonMode = true;
	tutorialOption3_btn.mouseChildren = false;
	tutorialOption3_btn.btn_txt.text = "Choose another tutorial.";
	tutorialOption3_btn.addEventListener (MouseEvent.MOUSE_OVER, navigation_over, false, 0, true);
	tutorialOption3_btn.addEventListener (MouseEvent.MOUSE_UP, navigation_up, false, 0, true);
	tutorialOption3_btn.addEventListener (MouseEvent.MOUSE_DOWN, navigation_down, false, 0, true);
	tutorialOption3_btn.addEventListener (MouseEvent.MOUSE_OUT, navigation_out, false, 0, true);
	tutorialOption3_btn.addEventListener (MouseEvent.CLICK, gotoShowOption4, false, 0, true);
	addChild (tutorialOption3_btn);
}

// Activity section
function trackImageLocation ():void
{
	if (!isDragging)
	{
		var currentIndicatorScale:Number = indicatorScale;
		var image:MovieClip = mapBrowser_mc.mapContainer_mc.imageContainer_mc;
		var imageMask:MovieClip = satImage_Mask;
		var navigatorImage:MovieClip = mapBrowser_mc.mapNavigator_mc.mapNavigatorContainer_mc;
		var indicator:MovieClip = indicatorRect;
		
		indicator.x = -(image.x)/(image.width/navigatorImage.width);
		indicator.y = -(image.y)/(image.height/navigatorImage.height);
		indicator.width = imageMask.width/(image.width/navigatorImage.width);
		indicator.height = imageMask.height/(image.height/navigatorImage.height);
	}
}

function trackIndicatorLocation (event:Event):void
{
	if (isDragging)
	{
		var image:MovieClip = mapBrowser_mc.mapContainer_mc.imageContainer_mc;
		var imageMask:MovieClip = satImage_Mask;
		var navigatorImage:MovieClip = mapBrowser_mc.mapNavigator_mc.mapNavigatorContainer_mc;
		var indicator:MovieClip = indicatorRect;
		var x:Number = -(indicator.x*(image.width/navigatorImage.width))-imageMask.x;
		var y:Number = -(indicator.y*(image.height/navigatorImage.height))-imageMask.y;
		
		image.x = x;
		image.y = y;
	}
}

function scaleImage (mcToScale:MovieClip, sx:Number, sy:Number, scalePoint:Point):void
{
	var image:MovieClip = mcToScale;
	var imageMask:MovieClip = satImage_Mask;
	var m:Matrix=mcToScale.transform.matrix;
	
	m.tx -= scalePoint.x;
	m.ty -= scalePoint.y;
	m.scale(sx, sy);
	m.tx += scalePoint.x;
	m.ty += scalePoint.y;
	mcToScale.transform.matrix = m;
	
	// Check limits and adjust image if out of frame
	if (image.y >= imageMask.y)
	{
		image.y = imageMask.y;
	}
	if (image.y <= -(image.height-imageMask.height))
	{
		image.y = -(image.height-imageMask.height);
	}
	if (image.x >= imageMask.x)
	{
		image.x = imageMask.x;
	}
	if (image.x <= -(image.width-imageMask.width))
	{
		image.x = -(image.width-imageMask.width);
	}
	
	trackImageLocation ();
}

function toggleZoomImage (event:MouseEvent):void
{
	var image:MovieClip = mapBrowser_mc.mapContainer_mc.imageContainer_mc;
	var navigatorImage:MovieClip = mapBrowser_mc.mapNavigator_mc.mapNavigatorContainer_mc;
	
	var xCoord:Number = -(image.x)/(image.width/navigatorImage.width);
	var yCoord:Number = -(image.y)/(image.height/navigatorImage.height);
	
	//this will create a point object at the center of the display object
	var ptScalePoint = new Point(xCoord,yCoord);
	
	if (!isZoomed)
	{
		scaleImage(image, 2, 2, ptScalePoint);
		
		isZoomed = true;
		mapBrowser_mc.zoomBtn_mc.btn_txt.text = "Zoom out.";
	}
	else
	{
		scaleImage(image, .5, .5, ptScalePoint);
		
		isZoomed = false;
		mapBrowser_mc.zoomBtn_mc.btn_txt.text = "Zoom in.";
	}
}

function moveImage (image:MovieClip, directionToMove:String):void
{
	var imageMask:MovieClip = satImage_Mask;
	var moveIncrement:Number = 5;
	
	switch (directionToMove)
	{
		case "up" :
			if (image.y >= imageMask.y)
			{
				image.y = imageMask.y;
			}
			else
			{
				image.y = image.y+(moveIncrement*mapScale);
			}
			break;
		case "down" :
			if (image.y <= -(image.height-imageMask.height))
			{
				image.y = -(image.height-imageMask.height);
			}
			else
			{
				image.y = image.y-(moveIncrement*mapScale);
			}
			break;
		case "left" :
			if (image.x >= imageMask.x)
			{
				image.x = imageMask.x;
			}
			else
			{
				image.x = image.x+(moveIncrement*mapScale);
			}
			break;
		case "right" :
			if (image.x <= -(image.width-imageMask.width))
			{
				image.x = -(image.width-imageMask.width);
			}
			else
			{
				image.x = image.x-(moveIncrement*mapScale);
			}
			break;
	}
}

function panSatImage (event:Event):void
{
		moveImage (mapBrowser_mc.mapContainer_mc.imageContainer_mc, panDirection);
}

function startTrack (event:MouseEvent):void
{
	var navigatorImage:MovieClip = mapBrowser_mc.mapNavigator_mc.mapNavigatorContainer_mc;
	var indicator:MovieClip = indicatorRect;
	var rx:Number = navigatorImage.x;
	var ry:Number = navigatorImage.y;
	var rwidth:Number = navigatorImage.width - indicator.width;
	var rheight:Number = navigatorImage.height - indicator.height;
	var rect1:Rectangle = new Rectangle(rx, ry, rwidth, rheight);
		
	indicator.startDrag (false,rect1);
	isDragging = true;
	indicatorRect.addEventListener (Event.ENTER_FRAME, trackIndicatorLocation, false, 0, true);
}

function stopTrack (event:MouseEvent):void
{
	var indicator:MovieClip = indicatorRect;
	
	indicator.stopDrag ();
	isDragging = false;
	indicatorRect.removeEventListener (Event.ENTER_FRAME, trackIndicatorLocation);
	trackImageLocation();
}

function drawNavigatorBox ():void
{
	// Add the mask to the satImage container
	indicatorRect = new MovieClip();
	cleanContainer(mapBrowser_mc.mapNavigator_mc.mapNavigatorContainer_mc);
	
	satImage_Mask.name = "mapContainerMask_mc";
	mapBrowser_mc.mapContainer_mc.addChild (satImage_Mask);
	mapBrowser_mc.mapContainer_mc.mask = satImage_Mask;
	
	// Add the mask to the satImage navigator container
	navImage_Mask.name = "navContainerMask_mc";
	mapBrowser_mc.mapNavigator_mc.mapNavigatorContainer_mc.addChild (navImage_Mask);
	mapBrowser_mc.mapNavigator_mc.mapNavigatorContainer_mc.mask = navImage_Mask;
	
	// Create the image navigator location indicator
	indicatorRect.graphics.beginFill (0xFFCC00);
	indicatorRect.graphics.lineStyle (2, 0x666666);
	indicatorRect.graphics.drawRect (0, 0, 100, 100);
	indicatorRect.graphics.endFill ();
	indicatorRect.buttonMode = true;
	indicatorRect.mouseChildren = false;
	indicatorRect.alpha = .5;
	indicatorRect.name = "mapNavigatorIndicator_mc";
	indicatorRect.addEventListener (MouseEvent.MOUSE_DOWN, startTrack, false, 0, true);
	indicatorRect.addEventListener (MouseEvent.MOUSE_UP, stopTrack, false, 0, true);

	mapBrowser_mc.mapNavigator_mc.addChild (indicatorRect);
}

function toggleSatImage(event:MouseEvent):void
{
	var mapContainer:DisplayObjectContainer = mapBrowser_mc.mapContainer_mc.imageContainer_mc;
	var mapFilteredImage:DisplayObject = mapContainer.getChildByName("filtered_mc");
	var mapUnfilteredImage:DisplayObject = mapContainer.getChildByName("unfiltered_mc");
	
	var navContainer:DisplayObjectContainer = mapBrowser_mc.mapNavigator_mc.mapNavigatorContainer_mc;
	var navFilteredImage:DisplayObject = navContainer.getChildByName("filtered_mc");
	var navUnfilteredImage:DisplayObject = navContainer.getChildByName("unfiltered_mc");
	
	if (mapContainer.contains(mapFilteredImage))
	{
		var filteredMapImageIndex:Number = mapContainer.getChildIndex(mapFilteredImage);
		
		mapContainer.swapChildren(mapFilteredImage, mapUnfilteredImage);

		if (mapBrowser_mc.filterSelection_mc.filter_btn1.btn_txt.text == "Look at the unfiltered image.")
		{
			mapBrowser_mc.filterSelection_mc.filter_btn1.btn_txt.text = "Look at the filtered image.";
		}
		else
		{
			mapBrowser_mc.filterSelection_mc.filter_btn1.btn_txt.text = "Look at the unfiltered image.";
		}	
	}
	if (navContainer.contains(navFilteredImage))
	{
		var filteredNavImageIndex:Number = navContainer.getChildIndex(navFilteredImage);
		
		if (filteredNavImageIndex == navContainer.numChildren-1)
		{
			navContainer.swapChildren(navFilteredImage, navUnfilteredImage);
		}
		else
		{
			navContainer.swapChildren(navFilteredImage, navUnfilteredImage);
		}	
	}
}

function showUnfilteredImage(event:Event):void
{
	var container:Object = event.currentTarget;
	var unfilteredImage:DisplayObject = container.getChildByName("unfiltered_mc");
	
	if (container.contains(unfilteredImage))
	{
		container.setChildIndex(unfilteredImage, container.numChildren-1);
		trackImageLocation ();
	}
}

function togglePOI(event:MouseEvent):void
{
	var mapContainer:MovieClip = mapBrowser_mc.mapContainer_mc.imageContainer_mc;
	var map_poi_do:DisplayObject = mapContainer.getChildByName("poi_mc");
	var map_poi_doIndex:int = mapContainer.getChildIndex(map_poi_do);
	
	var navContainer:MovieClip = mapBrowser_mc.mapNavigator_mc.mapNavigatorContainer_mc;
	var nav_poi_do:DisplayObject = navContainer.getChildByName("poi_mc");
	var nav_poi_doIndex:int = navContainer.getChildIndex(nav_poi_do);
	
	if (map_poi_doIndex < 2)
	{
		var mapContainerTopIndex = mapContainer.numChildren-1;
		var navContainerTopIndex = navContainer.numChildren-1;
		 
		mapContainer.setChildIndex(map_poi_do, mapContainerTopIndex);
		navContainer.setChildIndex(nav_poi_do, navContainerTopIndex);
		mapBrowser_mc.filterSelection_mc.filter_btn2.btn_txt.text = "Hide the dig locations.";
		
		var row1_y:Number = 130;
		var row2_y:Number = 180;
		var row3_y:Number = 230;
		var row4_y:Number = 280;
		var column1_x:Number = 230;
		var column2_x:Number = 440;
		
		// Show location information
		locDescription.x = 430;
		locDescription.y = 50;
		locDescription.loc_title_txt.text = "";
		locDescription.loc_description_txt.text = "Click on a button below to learn more about a specific site.";
		
		loc1Btn.x = column1_x;
		loc1Btn.y = row1_y;
		loc1Btn.gotoAndStop (1);
		loc1Btn.buttonMode = true;
		loc1Btn.mouseChildren = false;
		loc1Btn.btn_txt.text = "Desert Altars";
		loc1Btn.addEventListener (MouseEvent.MOUSE_OVER, navigation_over, false, 0, true);
		loc1Btn.addEventListener (MouseEvent.MOUSE_UP, navigation_up, false, 0, true);
		loc1Btn.addEventListener (MouseEvent.MOUSE_DOWN, navigation_down, false, 0, true);
		loc1Btn.addEventListener (MouseEvent.MOUSE_OUT, navigation_out, false, 0, true);
		loc1Btn.addEventListener (MouseEvent.CLICK, showLocation1Info, false, 0, true);
		
		loc2Btn.x = column1_x;
		loc2Btn.y = row2_y;
		loc2Btn.gotoAndStop (1);
		loc2Btn.buttonMode = true;
		loc2Btn.mouseChildren = false;
		loc2Btn.btn_txt.text = "Kom El-Nana";
		loc2Btn.addEventListener (MouseEvent.MOUSE_OVER, navigation_over, false, 0, true);
		loc2Btn.addEventListener (MouseEvent.MOUSE_UP, navigation_up, false, 0, true);
		loc2Btn.addEventListener (MouseEvent.MOUSE_DOWN, navigation_down, false, 0, true);
		loc2Btn.addEventListener (MouseEvent.MOUSE_OUT, navigation_out, false, 0, true);
		loc2Btn.addEventListener (MouseEvent.CLICK, showLocation2Info, false, 0, true);
		
		loc3Btn.x = column1_x;
		loc3Btn.y = row3_y;
		loc3Btn.gotoAndStop (1);
		loc3Btn.buttonMode = true;
		loc3Btn.mouseChildren = false;
		loc3Btn.btn_txt.text = "Main City";
		loc3Btn.addEventListener (MouseEvent.MOUSE_OVER, navigation_over, false, 0, true);
		loc3Btn.addEventListener (MouseEvent.MOUSE_UP, navigation_up, false, 0, true);
		loc3Btn.addEventListener (MouseEvent.MOUSE_DOWN, navigation_down, false, 0, true);
		loc3Btn.addEventListener (MouseEvent.MOUSE_OUT, navigation_out, false, 0, true);
		loc3Btn.addEventListener (MouseEvent.CLICK, showLocation3Info, false, 0, true);
		
		loc4Btn.x = column1_x;
		loc4Btn.y = row4_y;
		loc4Btn.gotoAndStop (1);
		loc4Btn.buttonMode = true;
		loc4Btn.mouseChildren = false;
		loc4Btn.btn_txt.text = "South Suburb";
		loc4Btn.addEventListener (MouseEvent.MOUSE_OVER, navigation_over, false, 0, true);
		loc4Btn.addEventListener (MouseEvent.MOUSE_UP, navigation_up, false, 0, true);
		loc4Btn.addEventListener (MouseEvent.MOUSE_DOWN, navigation_down, false, 0, true);
		loc4Btn.addEventListener (MouseEvent.MOUSE_OUT, navigation_out, false, 0, true);
		loc4Btn.addEventListener (MouseEvent.CLICK, showLocation4Info, false, 0, true);
		
		loc5Btn.x = column2_x;
		loc5Btn.y = row1_y;
		loc5Btn.gotoAndStop (1);
		loc5Btn.buttonMode = true;
		loc5Btn.mouseChildren = false;
		loc5Btn.btn_txt.text = "North Palace";
		loc5Btn.addEventListener (MouseEvent.MOUSE_OVER, navigation_over, false, 0, true);
		loc5Btn.addEventListener (MouseEvent.MOUSE_UP, navigation_up, false, 0, true);
		loc5Btn.addEventListener (MouseEvent.MOUSE_DOWN, navigation_down, false, 0, true);
		loc5Btn.addEventListener (MouseEvent.MOUSE_OUT, navigation_out, false, 0, true);
		loc5Btn.addEventListener (MouseEvent.CLICK, showLocation5Info, false, 0, true);
		
		loc6Btn.x = column2_x;
		loc6Btn.y = row2_y;
		loc6Btn.gotoAndStop (1);
		loc6Btn.buttonMode = true;
		loc6Btn.mouseChildren = false;
		loc6Btn.btn_txt.text = "North Suburb";
		loc6Btn.addEventListener (MouseEvent.MOUSE_OVER, navigation_over, false, 0, true);
		loc6Btn.addEventListener (MouseEvent.MOUSE_UP, navigation_up, false, 0, true);
		loc6Btn.addEventListener (MouseEvent.MOUSE_DOWN, navigation_down, false, 0, true);
		loc6Btn.addEventListener (MouseEvent.MOUSE_OUT, navigation_out, false, 0, true);
		loc6Btn.addEventListener (MouseEvent.CLICK, showLocation6Info, false, 0, true);
		
		loc7Btn.x = column2_x;
		loc7Btn.y = row3_y;
		loc7Btn.gotoAndStop (1);
		loc7Btn.buttonMode = true;
		loc7Btn.mouseChildren = false;
		loc7Btn.btn_txt.text = "Maru-Aten";
		loc7Btn.addEventListener (MouseEvent.MOUSE_OVER, navigation_over, false, 0, true);
		loc7Btn.addEventListener (MouseEvent.MOUSE_UP, navigation_up, false, 0, true);
		loc7Btn.addEventListener (MouseEvent.MOUSE_DOWN, navigation_down, false, 0, true);
		loc7Btn.addEventListener (MouseEvent.MOUSE_OUT, navigation_out, false, 0, true);
		loc7Btn.addEventListener (MouseEvent.CLICK, showLocation7Info, false, 0, true);
		
		addChild(locDescription);
		addChild(loc1Btn);
		addChild(loc2Btn);
		addChild(loc3Btn);
		addChild(loc4Btn);
		addChild(loc5Btn);
		addChild(loc6Btn);
		addChild(loc7Btn);
		
	}
	else
	{
		mapContainer.setChildIndex(map_poi_do, 0);
		navContainer.setChildIndex(nav_poi_do, 0);
		mapBrowser_mc.filterSelection_mc.filter_btn2.btn_txt.text = "Show me the dig locations.";
		
		removeChild(locDescription);
		loc1Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc1Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc1Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc1Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc1Btn.removeEventListener (MouseEvent.CLICK, showLocation1Info);
		removeChild(loc1Btn);
		loc2Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc2Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc2Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc2Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc2Btn.removeEventListener (MouseEvent.CLICK, showLocation2Info);
		removeChild(loc2Btn);
		loc3Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc3Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc3Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc3Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc3Btn.removeEventListener (MouseEvent.CLICK, showLocation3Info);
		removeChild(loc3Btn);
		loc4Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc4Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc4Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc4Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc4Btn.removeEventListener (MouseEvent.CLICK, showLocation4Info);
		removeChild(loc4Btn);
		loc5Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc5Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc5Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc5Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc5Btn.removeEventListener (MouseEvent.CLICK, showLocation5Info);
		removeChild(loc5Btn);
		loc6Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc6Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc6Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc6Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc6Btn.removeEventListener (MouseEvent.CLICK, showLocation6Info);
		removeChild(loc6Btn);
		loc7Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc7Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc7Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc7Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc7Btn.removeEventListener (MouseEvent.CLICK, showLocation7Info);
		removeChild(loc7Btn);
	}
}

function showLocation1Info (event:MouseEvent):void
{
	locDescription.loc_title_txt.text = "Desert Altars";
	locDescription.loc_description_txt.text = "The Desert Altars are a group of mud-brick buildings that lie close to the road that leads out of the North Tombs. They were excavated in 1931-32.";
}

function showLocation2Info (event:MouseEvent):void
{
	locDescription.loc_title_txt.text = "Kom El-Nana";
	locDescription.loc_description_txt.text = "Kom El-Nana is the local name of an enclosure south of the Main City. Archaeologists believe it was originally built as a Sun temple.";
}

function showLocation3Info (event:MouseEvent):void
{
	locDescription.loc_title_txt.text = "Main City";
	locDescription.loc_description_txt.text = "The Main City consists of an area of closely packed houses. A river cut through a section of the city, washing out a wide swath of homes.";
}

function showLocation4Info (event:MouseEvent):void
{
	locDescription.loc_title_txt.text = "South Suburb";
	locDescription.loc_description_txt.text = "Archaeologists have examined little of the South Suburb. Most of the area was destroyed by a modern-day cemetery.";
}

function showLocation5Info (event:MouseEvent):void
{
	locDescription.loc_title_txt.text = "North Palace";
	locDescription.loc_description_txt.text = "The North Palace is an isolated structure facing the Nile River. First excavated in the 1920s, scientists returned for more digging in the 1990s.";
}

function showLocation6Info (event:MouseEvent):void
{
	locDescription.loc_title_txt.text = "North Suburb";
	locDescription.loc_description_txt.text = "Homes north of the Central City and separated by desert make up the North Suburb. The area has been completely excavated.";
}

function showLocation7Info (event:MouseEvent):void
{
	locDescription.loc_title_txt.text = "Maru-Aten";
	locDescription.loc_description_txt.text = "This lone building in the desert to the south of the Main City was explored in 1992.";
}

function updateIndicatorPosition (event:Event):void
{
	trackImageLocation();
}

// Map scroll button event listeners
function moveImageUp (event:MouseEvent):void
{
	panDirection = "up";
	indicatorRect.addEventListener (Event.ENTER_FRAME, updateIndicatorPosition, false, 0, true);
	mapBrowser_mc.mapContainer_mc.imageContainer_mc.addEventListener (Event.ENTER_FRAME, panSatImage, false, 0, true);
}

function stopMoveImageUp (event:MouseEvent):void
{
	indicatorRect.addEventListener (Event.ENTER_FRAME, updateIndicatorPosition);
	mapBrowser_mc.mapContainer_mc.imageContainer_mc.removeEventListener (Event.ENTER_FRAME, panSatImage);
}

function moveImageDown (event:MouseEvent):void
{
	panDirection = "down";
	indicatorRect.addEventListener (Event.ENTER_FRAME, updateIndicatorPosition, false, 0, true);
	mapBrowser_mc.mapContainer_mc.imageContainer_mc.addEventListener (Event.ENTER_FRAME, panSatImage, false, 0, true);
}

function stopMoveImageDown (event:MouseEvent):void
{
	indicatorRect.addEventListener (Event.ENTER_FRAME, updateIndicatorPosition);
	mapBrowser_mc.mapContainer_mc.imageContainer_mc.removeEventListener (Event.ENTER_FRAME, panSatImage);
}

function moveImageLeft (event:MouseEvent):void
{
	panDirection = "left";
	indicatorRect.addEventListener (Event.ENTER_FRAME, updateIndicatorPosition, false, 0, true);
	mapBrowser_mc.mapContainer_mc.imageContainer_mc.addEventListener (Event.ENTER_FRAME, panSatImage, false, 0, true);
}

function stopMoveImageLeft (event:MouseEvent):void
{
	indicatorRect.addEventListener (Event.ENTER_FRAME, updateIndicatorPosition);
	mapBrowser_mc.mapContainer_mc.imageContainer_mc.removeEventListener (Event.ENTER_FRAME, panSatImage);
}

function moveImageRight (event:MouseEvent):void
{
	panDirection = "right";
	indicatorRect.addEventListener (Event.ENTER_FRAME, updateIndicatorPosition, false, 0, true);
	mapBrowser_mc.mapContainer_mc.imageContainer_mc.addEventListener (Event.ENTER_FRAME, panSatImage, false, 0, true);
}

function stopMoveImageRight (event:MouseEvent):void
{
	indicatorRect.addEventListener (Event.ENTER_FRAME, updateIndicatorPosition);
	mapBrowser_mc.mapContainer_mc.imageContainer_mc.removeEventListener (Event.ENTER_FRAME, panSatImage);
}

// Navigation
function gotoMenuOption1 (event:MouseEvent):void
{
	event.target.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	event.target.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	event.target.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	event.target.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	event.target.removeEventListener (MouseEvent.CLICK, gotoMenuOption1);
	gotoAndStop ("show");
}

function gotoMenuOption2 (event:MouseEvent):void
{
	event.target.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	event.target.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	event.target.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	event.target.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	event.target.removeEventListener (MouseEvent.CLICK, gotoMenuOption2);
	gotoAndStop ("tryIntro");
}

function gotoMenuOption3 (event:MouseEvent):void
{
	event.target.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	event.target.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	event.target.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	event.target.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	event.target.removeEventListener (MouseEvent.CLICK, gotoMenuOption3);
	gotoAndStop ("gallery");
}

function gotoShowOption1 (event:MouseEvent):void
{
	event.target.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	event.target.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	event.target.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	event.target.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	event.target.removeEventListener (MouseEvent.CLICK, gotoShowOption1);
	
	if (contains(tutorialOption3_btn))
	{
		removeChild (tutorialOption3_btn);
	}
	if (tutorialContainer_mc.contains(player))
	{
		player.stop();
		tutorialContainer_mc.removeChild(player);
	}

	gotoAndStop ("tryIntro");
}

function gotoShowOption2 (event:MouseEvent):void
{
	event.target.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	event.target.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	event.target.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	event.target.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	event.target.removeEventListener (MouseEvent.CLICK, gotoShowOption2);

	if (contains(tutorialOption3_btn))
	{
		removeChild (tutorialOption3_btn);
	}
	if (tutorialContainer_mc.contains(player))
	{
		player.stop();
		tutorialContainer_mc.removeChild(player);
	}

	gotoAndStop ("gallery");
}

function gotoShowOption3 (event:MouseEvent):void
{
	event.target.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	event.target.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	event.target.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	event.target.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	event.target.removeEventListener (MouseEvent.CLICK, gotoShowOption3);
	
	if (contains(tutorialOption3_btn))
	{
		removeChild (tutorialOption3_btn);
	}
	if (tutorialContainer_mc.contains(player))
	{
		player.stop();
		tutorialContainer_mc.removeChild(player);
	}

	gotoAndStop ("menu");
}

function gotoShowOption4 (event:MouseEvent):void
{
	tutorialOption3_btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	tutorialOption3_btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	tutorialOption3_btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	tutorialOption3_btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	tutorialOption3_btn.removeEventListener (MouseEvent.CLICK, gotoShowOption3);
	removeChild(tutorialOption3_btn);
	
	if (tutorialContainer_mc.contains(player))
	{
		player.stop();
	}
	cleanContainer(tutorialContainer_mc);
	tutorialText_txt.y = -560;
	tutorialContainer_mc.scaleX = 1;
	tutorialContainer_mc.scaleY = 1;

	tutorialOption1_btn.x = -500;
	tutorialOption1_btn.y = 25;
	tutorialOption1_btn.gotoAndStop (1);
	tutorialOption1_btn.buttonMode = true;
	tutorialOption1_btn.mouseChildren = false;
	tutorialOption1_btn.addEventListener (MouseEvent.MOUSE_OVER, navigation_over, false, 0, true);
	tutorialOption1_btn.addEventListener (MouseEvent.MOUSE_UP, navigation_up, false, 0, true);
	tutorialOption1_btn.addEventListener (MouseEvent.MOUSE_DOWN, navigation_down, false, 0, true);
	tutorialOption1_btn.addEventListener (MouseEvent.MOUSE_OUT, navigation_out, false, 0, true);
	tutorialOption1_btn.addEventListener (MouseEvent.CLICK, gotoTutorialOption1, false, 0, true);

	tutorialOption2_btn.x = 25;
	tutorialOption2_btn.y = 25;
	tutorialOption2_btn.gotoAndStop (1);
	tutorialOption2_btn.buttonMode = true;
	tutorialOption2_btn.mouseChildren = false;
	tutorialOption2_btn.addEventListener (MouseEvent.MOUSE_OVER, navigation_over, false, 0, true);
	tutorialOption2_btn.addEventListener (MouseEvent.MOUSE_UP, navigation_up, false, 0, true);
	tutorialOption2_btn.addEventListener (MouseEvent.MOUSE_DOWN, navigation_down, false, 0, true);
	tutorialOption2_btn.addEventListener (MouseEvent.MOUSE_OUT, navigation_out, false, 0, true);
	tutorialOption2_btn.addEventListener (MouseEvent.CLICK, gotoTutorialOption2, false, 0, true);

	tutorialContainer_mc.addChild (tutorialOption1_btn);
	TransitionManager.start (tutorialOption1_btn, {type:Fade, direction:Transition.IN, duration:2, easing:Strong.easeOut});
	tutorialContainer_mc.addChild (tutorialOption2_btn);
	TransitionManager.start (tutorialOption2_btn, {type:Fade, direction:Transition.IN, duration:2, easing:Strong.easeOut});
}

function gotoMapOption1 (event:MouseEvent):void
{
	indicatorRect.removeEventListener (MouseEvent.MOUSE_DOWN, startTrack);
	indicatorRect.removeEventListener (MouseEvent.MOUSE_UP, stopTrack);
	isZoomed = false;
	
	mapBrowser_mc.upArrow_mc.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	mapBrowser_mc.upArrow_mc.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	mapBrowser_mc.upArrow_mc.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	mapBrowser_mc.upArrow_mc.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	mapBrowser_mc.upArrow_mc.removeEventListener (MouseEvent.MOUSE_DOWN, moveImageUp);
	mapBrowser_mc.upArrow_mc.removeEventListener (MouseEvent.MOUSE_UP, stopMoveImageUp);
	
	mapBrowser_mc.downArrow_mc.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	mapBrowser_mc.downArrow_mc.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	mapBrowser_mc.downArrow_mc.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	mapBrowser_mc.downArrow_mc.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	mapBrowser_mc.downArrow_mc.removeEventListener (MouseEvent.MOUSE_DOWN, moveImageDown);
	mapBrowser_mc.downArrow_mc.removeEventListener (MouseEvent.MOUSE_UP, stopMoveImageDown);
	
	mapBrowser_mc.leftArrow_mc.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	mapBrowser_mc.leftArrow_mc.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	mapBrowser_mc.leftArrow_mc.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	mapBrowser_mc.leftArrow_mc.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	mapBrowser_mc.leftArrow_mc.removeEventListener (MouseEvent.MOUSE_DOWN, moveImageLeft);
	mapBrowser_mc.leftArrow_mc.removeEventListener (MouseEvent.MOUSE_UP, stopMoveImageLeft);
	
	mapBrowser_mc.rightArrow_mc.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	mapBrowser_mc.rightArrow_mc.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	mapBrowser_mc.rightArrow_mc.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	mapBrowser_mc.rightArrow_mc.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	mapBrowser_mc.rightArrow_mc.removeEventListener (MouseEvent.MOUSE_DOWN, moveImageRight);
	mapBrowser_mc.rightArrow_mc.removeEventListener (MouseEvent.MOUSE_UP, stopMoveImageRight);
	
	mapBrowser_mc.zoomBtn_mc.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	mapBrowser_mc.zoomBtn_mc.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	mapBrowser_mc.zoomBtn_mc.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	mapBrowser_mc.zoomBtn_mc.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	mapBrowser_mc.zoomBtn_mc.removeEventListener (MouseEvent.CLICK, toggleZoomImage);

	mapBrowser_mc.filterSelection_mc.filter_btn1.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	mapBrowser_mc.filterSelection_mc.filter_btn1.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	mapBrowser_mc.filterSelection_mc.filter_btn1.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	mapBrowser_mc.filterSelection_mc.filter_btn1.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	mapBrowser_mc.filterSelection_mc.filter_btn1.removeEventListener (MouseEvent.CLICK, toggleSatImage);
	
	mapBrowser_mc.filterSelection_mc.filter_btn2.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	mapBrowser_mc.filterSelection_mc.filter_btn2.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	mapBrowser_mc.filterSelection_mc.filter_btn2.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	mapBrowser_mc.filterSelection_mc.filter_btn2.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	mapBrowser_mc.filterSelection_mc.filter_btn2.removeEventListener (MouseEvent.CLICK, togglePOI);
	
	if (contains(locDescription))
	{
		removeChild(locDescription);
		loc1Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc1Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc1Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc1Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc1Btn.removeEventListener (MouseEvent.CLICK, showLocation1Info);
		removeChild(loc1Btn);
		loc2Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc2Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc2Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc2Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc2Btn.removeEventListener (MouseEvent.CLICK, showLocation2Info);
		removeChild(loc2Btn);
		loc3Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc3Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc3Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc3Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc3Btn.removeEventListener (MouseEvent.CLICK, showLocation3Info);
		removeChild(loc3Btn);
		loc4Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc4Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc4Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc4Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc4Btn.removeEventListener (MouseEvent.CLICK, showLocation4Info);
		removeChild(loc4Btn);
		loc5Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc5Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc5Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc5Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc5Btn.removeEventListener (MouseEvent.CLICK, showLocation5Info);
		removeChild(loc5Btn);
		loc6Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc6Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc6Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc6Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc6Btn.removeEventListener (MouseEvent.CLICK, showLocation6Info);
		removeChild(loc6Btn);
		loc7Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc7Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc7Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc7Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc7Btn.removeEventListener (MouseEvent.CLICK, showLocation7Info);
		removeChild(loc7Btn);
	}
	
	event.target.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	event.target.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	event.target.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	event.target.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	event.target.removeEventListener (MouseEvent.CLICK, gotoMapOption1);
	gotoAndStop ("show");
}

function gotoMapOption2 (event:MouseEvent):void
{
	indicatorRect.removeEventListener (MouseEvent.MOUSE_DOWN, startTrack);
	indicatorRect.removeEventListener (MouseEvent.MOUSE_UP, stopTrack);
	isZoomed = false;
	
	mapBrowser_mc.upArrow_mc.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	mapBrowser_mc.upArrow_mc.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	mapBrowser_mc.upArrow_mc.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	mapBrowser_mc.upArrow_mc.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	mapBrowser_mc.upArrow_mc.removeEventListener (MouseEvent.MOUSE_DOWN, moveImageUp);
	mapBrowser_mc.upArrow_mc.removeEventListener (MouseEvent.MOUSE_UP, stopMoveImageUp);
	
	mapBrowser_mc.downArrow_mc.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	mapBrowser_mc.downArrow_mc.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	mapBrowser_mc.downArrow_mc.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	mapBrowser_mc.downArrow_mc.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	mapBrowser_mc.downArrow_mc.removeEventListener (MouseEvent.MOUSE_DOWN, moveImageDown);
	mapBrowser_mc.downArrow_mc.removeEventListener (MouseEvent.MOUSE_UP, stopMoveImageDown);
	
	mapBrowser_mc.leftArrow_mc.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	mapBrowser_mc.leftArrow_mc.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	mapBrowser_mc.leftArrow_mc.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	mapBrowser_mc.leftArrow_mc.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	mapBrowser_mc.leftArrow_mc.removeEventListener (MouseEvent.MOUSE_DOWN, moveImageLeft);
	mapBrowser_mc.leftArrow_mc.removeEventListener (MouseEvent.MOUSE_UP, stopMoveImageLeft);
	
	mapBrowser_mc.rightArrow_mc.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	mapBrowser_mc.rightArrow_mc.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	mapBrowser_mc.rightArrow_mc.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	mapBrowser_mc.rightArrow_mc.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	mapBrowser_mc.rightArrow_mc.removeEventListener (MouseEvent.MOUSE_DOWN, moveImageRight);
	mapBrowser_mc.rightArrow_mc.removeEventListener (MouseEvent.MOUSE_UP, stopMoveImageRight);
	
	mapBrowser_mc.zoomBtn_mc.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	mapBrowser_mc.zoomBtn_mc.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	mapBrowser_mc.zoomBtn_mc.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	mapBrowser_mc.zoomBtn_mc.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	mapBrowser_mc.zoomBtn_mc.removeEventListener (MouseEvent.CLICK, toggleZoomImage);

	mapBrowser_mc.filterSelection_mc.filter_btn1.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	mapBrowser_mc.filterSelection_mc.filter_btn1.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	mapBrowser_mc.filterSelection_mc.filter_btn1.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	mapBrowser_mc.filterSelection_mc.filter_btn1.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	mapBrowser_mc.filterSelection_mc.filter_btn1.removeEventListener (MouseEvent.CLICK, toggleSatImage);
	
	mapBrowser_mc.filterSelection_mc.filter_btn2.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	mapBrowser_mc.filterSelection_mc.filter_btn2.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	mapBrowser_mc.filterSelection_mc.filter_btn2.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	mapBrowser_mc.filterSelection_mc.filter_btn2.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	mapBrowser_mc.filterSelection_mc.filter_btn2.removeEventListener (MouseEvent.CLICK, togglePOI);
	
	if (contains(locDescription))
	{
		removeChild(locDescription);
		loc1Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc1Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc1Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc1Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc1Btn.removeEventListener (MouseEvent.CLICK, showLocation1Info);
		removeChild(loc1Btn);
		loc2Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc2Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc2Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc2Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc2Btn.removeEventListener (MouseEvent.CLICK, showLocation2Info);
		removeChild(loc2Btn);
		loc3Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc3Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc3Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc3Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc3Btn.removeEventListener (MouseEvent.CLICK, showLocation3Info);
		removeChild(loc3Btn);
		loc4Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc4Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc4Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc4Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc4Btn.removeEventListener (MouseEvent.CLICK, showLocation4Info);
		removeChild(loc4Btn);
		loc5Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc5Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc5Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc5Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc5Btn.removeEventListener (MouseEvent.CLICK, showLocation5Info);
		removeChild(loc5Btn);
		loc6Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc6Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc6Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc6Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc6Btn.removeEventListener (MouseEvent.CLICK, showLocation6Info);
		removeChild(loc6Btn);
		loc7Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc7Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc7Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc7Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc7Btn.removeEventListener (MouseEvent.CLICK, showLocation7Info);
		removeChild(loc7Btn);
	}
	
	event.target.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	event.target.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	event.target.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	event.target.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	event.target.removeEventListener (MouseEvent.CLICK, gotoMapOption2);
	gotoAndStop ("gallery");
}

function gotoMapOption3 (event:MouseEvent):void
{
	indicatorRect.removeEventListener (MouseEvent.MOUSE_DOWN, startTrack);
	indicatorRect.removeEventListener (MouseEvent.MOUSE_UP, stopTrack);
	isZoomed = false;
	
	mapBrowser_mc.upArrow_mc.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	mapBrowser_mc.upArrow_mc.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	mapBrowser_mc.upArrow_mc.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	mapBrowser_mc.upArrow_mc.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	mapBrowser_mc.upArrow_mc.removeEventListener (MouseEvent.MOUSE_DOWN, moveImageUp);
	mapBrowser_mc.upArrow_mc.removeEventListener (MouseEvent.MOUSE_UP, stopMoveImageUp);
	
	mapBrowser_mc.downArrow_mc.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	mapBrowser_mc.downArrow_mc.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	mapBrowser_mc.downArrow_mc.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	mapBrowser_mc.downArrow_mc.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	mapBrowser_mc.downArrow_mc.removeEventListener (MouseEvent.MOUSE_DOWN, moveImageDown);
	mapBrowser_mc.downArrow_mc.removeEventListener (MouseEvent.MOUSE_UP, stopMoveImageDown);
	
	mapBrowser_mc.leftArrow_mc.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	mapBrowser_mc.leftArrow_mc.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	mapBrowser_mc.leftArrow_mc.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	mapBrowser_mc.leftArrow_mc.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	mapBrowser_mc.leftArrow_mc.removeEventListener (MouseEvent.MOUSE_DOWN, moveImageLeft);
	mapBrowser_mc.leftArrow_mc.removeEventListener (MouseEvent.MOUSE_UP, stopMoveImageLeft);
	
	mapBrowser_mc.rightArrow_mc.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	mapBrowser_mc.rightArrow_mc.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	mapBrowser_mc.rightArrow_mc.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	mapBrowser_mc.rightArrow_mc.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	mapBrowser_mc.rightArrow_mc.removeEventListener (MouseEvent.MOUSE_DOWN, moveImageRight);
	mapBrowser_mc.rightArrow_mc.removeEventListener (MouseEvent.MOUSE_UP, stopMoveImageRight);
	
	mapBrowser_mc.zoomBtn_mc.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	mapBrowser_mc.zoomBtn_mc.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	mapBrowser_mc.zoomBtn_mc.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	mapBrowser_mc.zoomBtn_mc.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	mapBrowser_mc.zoomBtn_mc.removeEventListener (MouseEvent.CLICK, toggleZoomImage);

	mapBrowser_mc.filterSelection_mc.filter_btn1.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	mapBrowser_mc.filterSelection_mc.filter_btn1.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	mapBrowser_mc.filterSelection_mc.filter_btn1.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	mapBrowser_mc.filterSelection_mc.filter_btn1.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	mapBrowser_mc.filterSelection_mc.filter_btn1.removeEventListener (MouseEvent.CLICK, toggleSatImage);
	
	mapBrowser_mc.filterSelection_mc.filter_btn2.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	mapBrowser_mc.filterSelection_mc.filter_btn2.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	mapBrowser_mc.filterSelection_mc.filter_btn2.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	mapBrowser_mc.filterSelection_mc.filter_btn2.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	mapBrowser_mc.filterSelection_mc.filter_btn2.removeEventListener (MouseEvent.CLICK, togglePOI);
	
	if (contains(locDescription))
	{
		removeChild(locDescription);
		loc1Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc1Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc1Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc1Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc1Btn.removeEventListener (MouseEvent.CLICK, showLocation1Info);
		removeChild(loc1Btn);
		loc2Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc2Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc2Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc2Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc2Btn.removeEventListener (MouseEvent.CLICK, showLocation2Info);
		removeChild(loc2Btn);
		loc3Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc3Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc3Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc3Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc3Btn.removeEventListener (MouseEvent.CLICK, showLocation3Info);
		removeChild(loc3Btn);
		loc4Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc4Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc4Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc4Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc4Btn.removeEventListener (MouseEvent.CLICK, showLocation4Info);
		removeChild(loc4Btn);
		loc5Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc5Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc5Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc5Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc5Btn.removeEventListener (MouseEvent.CLICK, showLocation5Info);
		removeChild(loc5Btn);
		loc6Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc6Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc6Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc6Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc6Btn.removeEventListener (MouseEvent.CLICK, showLocation6Info);
		removeChild(loc6Btn);
		loc7Btn.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
		loc7Btn.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
		loc7Btn.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
		loc7Btn.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
		loc7Btn.removeEventListener (MouseEvent.CLICK, showLocation7Info);
		removeChild(loc7Btn);
	}
	
	event.target.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	event.target.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	event.target.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	event.target.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	event.target.removeEventListener (MouseEvent.CLICK, gotoMapOption3);
	gotoAndStop ("menu");
}

function gotoGalleryOption1 (event:MouseEvent):void
{
	event.target.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	event.target.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	event.target.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	event.target.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	event.target.removeEventListener (MouseEvent.CLICK, gotoGalleryOption1);
	if (galleryContainer_mc.contains(gallery))
	{
		galleryContainer_mc.removeChild(gallery);
	}
	gotoAndStop ("show");
}

function gotoGalleryOption2 (event:MouseEvent):void
{
	event.target.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	event.target.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	event.target.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	event.target.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	event.target.removeEventListener (MouseEvent.CLICK, gotoGalleryOption2);
	if (galleryContainer_mc.contains(gallery))
	{
		galleryContainer_mc.removeChild(gallery);
	}
	gotoAndStop ("tryIntro");
}

function gotoGalleryOption3 (event:MouseEvent):void
{
	event.target.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	event.target.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	event.target.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	event.target.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	event.target.removeEventListener (MouseEvent.CLICK, gotoMenu);
	if (galleryContainer_mc.contains(gallery))
	{
		galleryContainer_mc.removeChild(gallery);
	}
	gotoAndStop ("menu");
}

function gotoTry (event:MouseEvent):void
{
	event.target.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	event.target.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	event.target.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	event.target.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	event.target.removeEventListener (MouseEvent.CLICK, gotoTry);
	gotoAndStop ("try");
}

function gotoMenu (event:MouseEvent):void
{
	event.target.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	event.target.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	event.target.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	event.target.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	event.target.removeEventListener (MouseEvent.CLICK, gotoMenu);
	gotoAndStop ("menu");
}

// Rollover Events
function navigation_over (event:MouseEvent)
{
	event.target.gotoAndStop (2);
}

function navigation_up (event:MouseEvent)
{
	event.target.gotoAndStop (2);
}

function navigation_down (event:MouseEvent)
{
	event.target.gotoAndStop (3);
}

function navigation_out (event:MouseEvent)
{
	event.target.gotoAndStop (1);
}