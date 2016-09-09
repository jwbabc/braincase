import fl.transitions.*;
import fl.transitions.easing.*;
import XMLLoader;
import PreLoader;

// Arrays
var items_Array:Array = new Array();
var boughtItems_Array:Array = new Array();
var questions_Array:Array = new Array();
var chosenComment_Array:Array = new Array();
// Working arrays of the item list
var diggingItems_Array:Array = new Array();
var preservationItems_Array:Array = new Array();
var survivabilityItems_Array:Array = new Array();
// Source arrays for refreshing the item list
var diggingItemsSource_Array:Array = new Array();
var preservationItemsSource_Array:Array = new Array();
var survivabilityItemsSource_Array:Array = new Array();
// Container Array
var container_Array:Array = new Array();
// Item variables
var catIndex:int;
var toolIndex:String;
var boughtItem:Object = new Object();
var maxBoughtItems:Number = 24;
// Variable for display tabs
var activeTab:Number = 1;
// Strings for tab titles
var statName1:String = "Digging";
var statName2:String = "Preservation";
var statName3:String = "Survival";

// Root object
var packObject:Object = new Object();
packObject.budgetMaximum = 3000;
packObject.weightMaximum = 500;
packObject.inventorySlotMaximum = 24;
packObject.budget = packObject.budgetMaximum;
packObject.weight = 0;
packObject.stat1 = 0;
packObject.stat2 = 0;
packObject.stat3 = 0;
packObject.stat1Maximum = 0;
packObject.stat2Maximum = 0;
packObject.stat3Maximum = 0;

// Create Timeout
var kiosk_Timeout:AttractTimer = new AttractTimer((4 * 60) * 1000);
//var kiosk_Timeout:AttractTimer = new AttractTimer((5) * 1000);

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

function listDisplayItems (container:DisplayObjectContainer)
{
	var list:Array = new Array();
	for (var i:Number = 0; i < container.numChildren; i++)
	{
		list[i] = (container.getChildAt(i).name);
	}
	return list;
}

function cleanContainer (container:DisplayObjectContainer):void
{
	var i:int = container.numChildren;
	while (i --)
	{
		container.removeChildAt (i);
	}
}

function loadContent (mc:MovieClip, mcName:String, mcScale:Number,  myPath:String):void
{
	var loader:PreLoader = new PreLoader(mc, mcName, mcScale,  myPath);
}

// XML import
var XMLPath:String = "xml/";
var myItemsLoader:XMLLoader = new XMLLoader(XMLPath + "items.xml");
myItemsLoader.addEventListener (Event.COMPLETE, createItemArray);
var myQuestionLoader:XMLLoader = new XMLLoader(XMLPath + "questions.xml");
myQuestionLoader.addEventListener (Event.COMPLETE, createQuestionArray);
var myCommentLoader:XMLLoader = new XMLLoader(XMLPath + "comments.xml");
myCommentLoader.addEventListener (Event.COMPLETE, createCommentArray);

var questionNum:Number = 0;

// Generate the item lists from the XML document
function createItemArray (event:Event):void
{
	var xmlItems:XML = new XML();
	xmlItems = myItemsLoader.p_XML;
	for (var i:Number = 0; i<xmlItems.children().length(); i++)
	{
		for (var e:Number = 0; e<xmlItems.children()[i].children().length(); e++)
		{
			var item:Object = new Object();
			item.itemName = xmlItems.children()[i].children()[e].name;
			item.itemCategory = String(xmlItems.children()[i].children()[e].category);
			item.itemDesc = String(xmlItems.children()[i].children()[e].desc);
			item.itemCost = xmlItems.children()[i].children()[e].cost;
			item.itemWeight = xmlItems.children()[i].children()[e].weight;
			item.itemImage = String("images/"+xmlItems.children()[i].children()[e].image);
			item.digging = xmlItems.children()[i].children()[e].digging;
			item.preservation = xmlItems.children()[i].children()[e].preservation;
			item.survivability = xmlItems.children()[i].children()[e].survivability;
			switch (item.itemCategory)
			{
				case "digging" :
					diggingItems_Array[diggingItems_Array.length] = item;
					// Calculate stat maximum
					if (item.digging > 0)
					{
						packObject.stat1Maximum = Number(packObject.stat1Maximum)+Number(item.digging);
					}
					break;
				case "preservation" :
					preservationItems_Array[preservationItems_Array.length] = item;
					// Calculate stat maximum
					if (item.preservation > 0)
					{
						packObject.stat2Maximum = Number(packObject.stat2Maximum)+Number(item.preservation);
					}
					break;
				case "survivability" :
					survivabilityItems_Array[survivabilityItems_Array.length] = item;
					// Calculate stat maximum
					if (item.survivability > 0)
					{
						packObject.stat3Maximum = Number(packObject.stat3Maximum)+Number(item.survivability);
					}
					break;
			}	
		}
	}
	
	// Make copies of the item list
	diggingItemsSource_Array = diggingItems_Array.slice();
	preservationItemsSource_Array = preservationItems_Array.slice();
	survivabilityItemsSource_Array = survivabilityItems_Array.slice();
}

// Generate the array for the question text
function createQuestionArray (event:Event):void
{
	var xmlItems:XML = new XML();
	xmlItems = myQuestionLoader.p_XML;
	for (var i:Number = 0; i<xmlItems.children().length(); i++)
	{
		var question:Object = new Object();
		question.questionText = xmlItems.children()[i].text;
		question.answer1 = xmlItems.children()[i].answer1;
		question.answer2 = xmlItems.children()[i].answer2;
		question.answer3 = xmlItems.children()[i].answer3;
		questions_Array[questions_Array.length] = question;
	}
}

// Generate the array for results feedback
function createCommentArray (event:Event):void
{
	var xmlItems:XML = new XML();
	xmlItems = myCommentLoader.p_XML;
	for (var e:Number = 0; e<xmlItems.children()[0].children().length(); e++)
	{
		var comment:Object = new Object();
		comment.commentItem = xmlItems.children()[0].children()[e].children()[0];
		comment.commentResult = xmlItems.children()[0].children()[e].children()[1];
		chosenComment_Array[chosenComment_Array.length] = comment;
	}
}

// Pack questions
//
// Make an instance of the questions class
var questionContainer:Interview = new Interview();

// Enable the question navigation and add it to the stage
function displayQuestions (mc_x:Number, mc_y:Number):void
{
	questionContainer.x = mc_x;
	questionContainer.y = mc_y;
	
	questionContainer.prevQuestion_btn.gotoAndStop (1);
	questionContainer.prevQuestion_btn.buttonMode = true;
	questionContainer.prevQuestion_btn.mouseChildren = false;
	questionContainer.prevQuestion_btn.alpha = .25;
	questionContainer.prevQuestion_btn.addEventListener (MouseEvent.MOUSE_OVER, navigation_over, false, 0, true);
	questionContainer.prevQuestion_btn.addEventListener (MouseEvent.MOUSE_UP, navigation_up, false, 0, true);
	questionContainer.prevQuestion_btn.addEventListener (MouseEvent.MOUSE_DOWN, navigation_down, false, 0, true);
	questionContainer.prevQuestion_btn.addEventListener (MouseEvent.MOUSE_OUT, navigation_out, false, 0, true);
	questionContainer.prevQuestion_btn.addEventListener (MouseEvent.CLICK, gotoPrevQuestion, false, 0, true);
	
	questionContainer.nextQuestion_btn.gotoAndStop (1);
	questionContainer.nextQuestion_btn.buttonMode = true;
	questionContainer.nextQuestion_btn.mouseChildren = false;
	questionContainer.nextQuestion_btn.addEventListener (MouseEvent.MOUSE_OVER, navigation_over, false, 0, true);
	questionContainer.nextQuestion_btn.addEventListener (MouseEvent.MOUSE_UP, navigation_up, false, 0, true);
	questionContainer.nextQuestion_btn.addEventListener (MouseEvent.MOUSE_DOWN, navigation_down, false, 0, true);
	questionContainer.nextQuestion_btn.addEventListener (MouseEvent.MOUSE_OUT, navigation_out, false, 0, true);
	questionContainer.nextQuestion_btn.addEventListener (MouseEvent.CLICK, gotoNextQuestion, false, 0, true);
	
	questionContainer.persona1_mc.gotoAndStop (1);
	questionContainer.persona1_mc.buttonMode = true;
	questionContainer.persona1_mc.mouseChildren = false;
	questionContainer.persona1_mc.addEventListener (MouseEvent.MOUSE_OVER, showPersona1_response, false, 0, true);
	questionContainer.persona1_mc.addEventListener (MouseEvent.MOUSE_OUT, hidePersona_response, false, 0, true);
	
	questionContainer.persona2_mc.gotoAndStop (1);
	questionContainer.persona2_mc.buttonMode = true;
	questionContainer.persona2_mc.mouseChildren = false;
	questionContainer.persona2_mc.addEventListener (MouseEvent.MOUSE_OVER, showPersona2_response, false, 0, true);
	questionContainer.persona2_mc.addEventListener (MouseEvent.MOUSE_OUT, hidePersona_response, false, 0, true);
	
	questionContainer.persona3_mc.gotoAndStop (1);
	questionContainer.persona3_mc.buttonMode = true;
	questionContainer.persona3_mc.mouseChildren = false;
	questionContainer.persona3_mc.addEventListener (MouseEvent.MOUSE_OVER, showPersona3_response, false, 0, true);
	questionContainer.persona3_mc.addEventListener (MouseEvent.MOUSE_OUT, hidePersona_response, false, 0, true);
	
	questionContainer.questionNum_txt.text = "Question "+(questionNum+1)+" of "+questions_Array.length;
	addChild (questionContainer);
}

// Make instances of the text balloon classes
var questionTextBubble_Left:TextBalloonLeft = new TextBalloonLeft();
var questionTextBubble_Right:TextBalloonRight = new TextBalloonRight();
var questionTextBubble_Center:TextBalloonCenter = new TextBalloonCenter();

// Display the proper response within the question container
function showResponse (persona:String)
{
	var textBalloon_x:Number = -251.0;
	var textBalloon_y:Number = -74.7;
	switch (persona)
	{
		case "persona1" :
			questionTextBubble_Left.x = textBalloon_x;
			questionTextBubble_Left.y = textBalloon_y;
			questionContainer.addChild (questionTextBubble_Left);
			questionTextBubble_Left.int_txt.text = questions_Array[questionNum].answer1;
			break;
		case "persona2" :
			questionTextBubble_Center.x = textBalloon_x;
			questionTextBubble_Center.y = textBalloon_y;
			questionContainer.addChild (questionTextBubble_Center);
			questionTextBubble_Center.int_txt.text = questions_Array[questionNum].answer2;
			break;
		case "persona3" :
			questionTextBubble_Right.x = textBalloon_x;
			questionTextBubble_Right.y = textBalloon_y;
			questionContainer.addChild (questionTextBubble_Right);
			questionTextBubble_Right.int_txt.text = questions_Array[questionNum].answer3;
			break;
		case "hide_all" :
			if (questionContainer.contains (questionTextBubble_Left))
			{
				questionContainer.removeChild (questionTextBubble_Left);
			}
			if (questionContainer.contains (questionTextBubble_Right))
			{
				questionContainer.removeChild (questionTextBubble_Right);
			}
			if (questionContainer.contains (questionTextBubble_Center))
			{
				questionContainer.removeChild (questionTextBubble_Center);
			}
			break;
	}
}

// Persona listeners
function showPersona1_response (event:MouseEvent)
{
	showResponse ("persona1");
}

function showPersona2_response (event:MouseEvent)
{
	showResponse ("persona2");
}

function showPersona3_response (event:MouseEvent)
{
	showResponse ("persona3");
}

function hidePersona_response (event:MouseEvent)
{
	showResponse ("hide_all");
}

// Question navigation
function gotoPrevQuestion (event:MouseEvent)
{
	if (questionNum > 0)
	{
		questionContainer.prevQuestion_btn.alpha = 1;
		questionContainer.nextQuestion_btn.alpha = 1;
		questionNum--;
	}
	else
	{
		questionContainer.prevQuestion_btn.alpha = .25;
	}
	questionContainer.question_txt.text = questions_Array[questionNum].questionText;
	questionContainer.questionNum_txt.text = "Question "+(questionNum+1)+" of "+questions_Array.length;
}

function gotoNextQuestion (event:MouseEvent)
{
	if (questionNum < questions_Array.length-1)
	{
		questionContainer.prevQuestion_btn.alpha = 1;
		questionContainer.nextQuestion_btn.alpha = 1;
		questionNum++;
	}
	else
	{
		questionContainer.nextQuestion_btn.alpha = .25;
	}
	questionContainer.question_txt.text = questions_Array[questionNum].questionText;
	questionContainer.questionNum_txt.text = "Question "+(questionNum+1)+" of "+questions_Array.length;
}

// Pack activity
//
// Supply category tabs
function swapTab1 (event:MouseEvent):void
{
	activeTab = 1;
	supplies_mc.tab1_mc.alpha = 1;
	supplies_mc.tab2_mc.alpha = .5;
	supplies_mc.tab3_mc.alpha = .5;
	showAvailableItems (items_Array[0], container_Array[0]);
}

function swapTab2 (event:MouseEvent):void
{
	activeTab = 2;
	supplies_mc.tab1_mc.alpha = .5;
	supplies_mc.tab2_mc.alpha = 1;
	supplies_mc.tab3_mc.alpha = .5;
	showAvailableItems (items_Array[1], container_Array[0]);
}

function swapTab3 (event:MouseEvent):void
{
	activeTab = 3;
	supplies_mc.tab1_mc.alpha = .5;
	supplies_mc.tab2_mc.alpha = .5;
	supplies_mc.tab3_mc.alpha = 1;
	showAvailableItems (items_Array[2], container_Array[0]);
}

// Display the item data within the item description container.
function showItemInfo (event:MouseEvent):void
{
	var str:String = event.currentTarget.name.toString();
	var infoIndex = str.substr(4);
	var infoType = str.substr(0, 4);
	var infoName:String;
	var infoDesc:String;
	var infoImage:String;
	var infoStat1:Number;
	var infoStat2:Number;
	var infoStat3:Number;
	var infoCost:Number;
	var infoWeight:Number;

	switch (activeTab)
	{
		case 1:
			catIndex = 0;
			break;
		case 2:
			catIndex = 1;
			break;
		case 3:
			catIndex = 2;
			break;
	}
	
	switch (infoType)
	{
		case "tool" :
			infoName = items_Array[catIndex][infoIndex].itemName;
			infoDesc = items_Array[catIndex][infoIndex].itemDesc;
			infoImage = items_Array[catIndex][infoIndex].itemImage;
			infoStat1 = items_Array[catIndex][infoIndex].digging;
			infoStat2 = items_Array[catIndex][infoIndex].preservation;
			infoStat3 = items_Array[catIndex][infoIndex].survivability;
			infoCost = items_Array[catIndex][infoIndex].itemCost;
			infoWeight = items_Array[catIndex][infoIndex].itemWeight;
			break;
		case "sold" :
			infoName = boughtItems_Array[infoIndex].itemName;
			infoDesc = boughtItems_Array[infoIndex].itemDesc;
			infoImage = boughtItems_Array[infoIndex].itemImage;
			infoStat1 = boughtItems_Array[infoIndex].digging;
			infoStat2 = boughtItems_Array[infoIndex].preservation;
			infoStat3 = boughtItems_Array[infoIndex].survivability;
			infoCost = boughtItems_Array[infoIndex].itemCost;
			infoWeight = boughtItems_Array[infoIndex].itemWeight;
			break;
	}
	itemDescription_mc.itemName_txt.text = infoName;
	itemDescription_mc.itemDesc_txt.text = infoDesc;
	itemDescription_mc.itemCost_txt.text = "$"+infoCost;
	itemDescription_mc.itemWeight_txt.text = infoWeight+" lbs.";
	loadImage (infoImage, itemDescription_mc.itemImage_mc.imageCont_mc, 1.25);
	TransitionManager.start (itemDescription_mc.itemImage_mc.imageCont_mc, {type:Fade, direction:Transition.IN, duration:4, easing:Strong.easeOut});
	TransitionManager.start (itemDescription_mc.itemImage_mc.imageCont_mc, {type:Zoom, direction:Transition.IN, duration:.5, easing:Bounce.easeOut});
}

function clearItemInfo (event:MouseEvent):void
{
	cleanContainer (itemDescription_mc.itemImage_mc.imageCont_mc);
	itemDescription_mc.itemName_txt.text = "";
	itemDescription_mc.itemDesc_txt.text = "";
	itemDescription_mc.itemCost_txt.text = "";
	itemDescription_mc.itemWeight_txt.text = "";
}

function updateStats (action:String):void
{
	// Update budget, weight, and stats
	var itemStat1:Number = boughtItem.digging;
	var itemStat2:Number = boughtItem.preservation;
	var itemStat3:Number = boughtItem.survivability;
	var itemCost:Number = boughtItem.itemCost;
	var itemWeight:Number = boughtItem.itemWeight;
	switch (action)
	{
		case "sold" :
			packObject.budget = Number(packObject.budget+itemCost);
			packObject.weight = Number(packObject.weight-itemWeight);
			packObject.stat1 = Number(packObject.stat1-itemStat1);
			packObject.stat2 = Number(packObject.stat2-itemStat2);
			packObject.stat3 = Number(packObject.stat3-itemStat3);
			break;
		case "bought" :
			packObject.budget = Number(packObject.budget-itemCost);
			packObject.weight = Number(packObject.weight+itemWeight);
			packObject.stat1 = Number(packObject.stat1+itemStat1);
			packObject.stat2 = Number(packObject.stat2+itemStat2);
			packObject.stat3 = Number(packObject.stat3+itemStat3);
			break;
	}
	if (boughtItems_Array.length > 0)
	{
		statContainer_mc.stat1_mc.level_mc.scaleX = packObject.stat1/packObject.stat1Maximum;
		statContainer_mc.stat2_mc.level_mc.scaleX = packObject.stat2/packObject.stat2Maximum;
		statContainer_mc.stat3_mc.level_mc.scaleX = packObject.stat3/packObject.stat3Maximum;
	}
	else
	{
		statContainer_mc.stat1_mc.level_mc.scaleX = 0;
		statContainer_mc.stat2_mc.level_mc.scaleX = 0;
		statContainer_mc.stat3_mc.level_mc.scaleX = 0;
	}
	// Update stat container
	statContainer_mc.budget_mc.budget_txt.text = "$"+int((packObject.budget)*100)/100;
	statContainer_mc.weight_mc.weight_txt.text = packObject.weight+"/"+packObject.weightMaximum+" lbs.";
	statContainer_mc.truck_mc.level_mc.scaleY = packObject.weight/packObject.weightMaximum;
	// Update inventory container
	inventory_mc.slots_txt.text = (packObject.inventorySlotMaximum - boughtItems_Array.length)+"/"+packObject.inventorySlotMaximum;
}

function moveItemToPurchased ():void
{
	// Add item to bought array
	boughtItems_Array.unshift (boughtItem);
	// Remove item from items array
	items_Array[catIndex].splice (items_Array[catIndex].indexOf(boughtItem), 1);
	// Update the bought items container
	showPurchasedItems (boughtItems_Array, container_Array[1]);
	// Update item containers
	switch(activeTab)
	{
		case 1:
			showAvailableItems (items_Array[0], container_Array[0]);
			break;
		case 2:
			showAvailableItems (items_Array[1], container_Array[0]);
			break;
		case 3:
			showAvailableItems (items_Array[2], container_Array[0]);
			break;
	}
	updateStats ("bought");
}

function moveItemToAvailable ():void
{
	// Remove from the bought items list
	boughtItems_Array.splice (boughtItems_Array.indexOf(boughtItem), 1);
	// Add to the proper sell item list
	if (boughtItem.itemCategory == "digging")
	{
		items_Array[0].push (boughtItem);
	}
	else if (boughtItem.itemCategory == "preservation")
	{
		items_Array[1].push (boughtItem);
	}
	else if (boughtItem.itemCategory == "survivability")
	{
		items_Array[2].push (boughtItem);
	}
	// Refresh lists
	showPurchasedItems (boughtItems_Array, container_Array[1]);
	// Repopulate item containers
	switch(activeTab)
	{
		case 1:
			showAvailableItems (items_Array[0], container_Array[0]);
			break;
		case 2:
			showAvailableItems (items_Array[1], container_Array[0]);
			break;
		case 3:
			showAvailableItems (items_Array[2], container_Array[0]);
			break;
	}
	updateStats ("sold");
}

// Make an instance of the disabled stat class
var statDisabled_mc:StatDisabled = new StatDisabled();

function buyItem (event:MouseEvent):void
{
	var str:String = event.currentTarget.name.toString();
	toolIndex = str.substr(4);
		
	var currentItemCost:Number = items_Array[catIndex][toolIndex].itemCost;
	var currentItemWeight:Number = items_Array[catIndex][toolIndex].itemWeight;
	
	if ((packObject.budget-currentItemCost) <= 0)
	{
		statContainer_mc.addChild(statDisabled_mc);
		statDisabled_mc.statDisabled_txt.htmlText = "You overspent your budget!<br /><br />Sell items to get some money back.";
	}
	else if ((packObject.weight+currentItemWeight) >= packObject.weightMaximum)
	{		
		statContainer_mc.addChild(statDisabled_mc);
		statDisabled_mc.statDisabled_txt.htmlText = "You have over-stuffed the truck!<br /><br />Sell items to lighten the load.";
	}
	else if ((boughtItems_Array.length) >= packObject.inventorySlotMaximum)
	{
		statContainer_mc.addChild(statDisabled_mc);
		statDisabled_mc.statDisabled_txt.htmlText = "You have exceeded the space in your truck!<br /><br />Sell items to make more room.";
	}
	else
	{
		if (statContainer_mc.contains (statDisabled_mc))
		{
			statContainer_mc.removeChild(statDisabled_mc);
		}
		boughtItem = items_Array[catIndex][toolIndex];
		moveItemToPurchased ();
	}
}

function returnItem (event:MouseEvent):void
{
	if (statContainer_mc.contains (statDisabled_mc))
	{
		statContainer_mc.removeChild(statDisabled_mc);
	}
	var str:String = event.currentTarget.name.toString();
	toolIndex = str.substr(4);
	boughtItem = boughtItems_Array[toolIndex];
	moveItemToAvailable ();
}

// Populates the item container with the icons from the available items array
function showAvailableItems (array:Array, container:MovieClip):void
{
	// Number of available items in the array
	var numIcons:int = array.length;
	// Item name
	var iconIndex:int = 0;
	// Item image
	var imageIndex:int = 0;
	// Number of columns within the container
	var columns:int = 8;
	// Number of rows within the container
	var rows:int = Math.ceil(numIcons/columns);
	// Width of gap between icons
	var spacing:int = 5;
	// X coordinate of icon
	var iconX:int;
	// Y coordinate of icon
	var iconY:int;
	// Path to the image
	var imagePath:String;
	
	// Clear containers
	cleanContainer (container);
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
				var iconContainer:itemIcon = new itemIcon();
				iconContainer.alpha = .75;
				iconContainer.buttonMode = true;
				iconContainer.mouseChildren = false;
				iconContainer.scaleX = .75;
				iconContainer.scaleY = .75;
				iconContainer.name = "tool"+iconIndex;
				iconContainer.addEventListener (MouseEvent.ROLL_OVER, showItemInfo, false, 0, true);
				iconContainer.addEventListener (MouseEvent.ROLL_OUT, clearItemInfo, false, 0, true);
				iconContainer.addEventListener (MouseEvent.CLICK, buyItem, false, 0, true);
				container.addChild (iconContainer);
				// Position the container into the grid structure
				iconX = spacing+((iconContainer.width+spacing)*c);
				iconY = spacing+((iconContainer.height+spacing)*r);
				iconContainer.x = iconX;
				iconContainer.y = iconY;
				// Add the image to the item container
				iconContainer.image_mc.smoothing = true;
				imagePath = array[imageIndex].itemImage;
				loadImage (imagePath, iconContainer.image_mc, .7);
				// Begin the transitions
				TransitionManager.start (iconContainer.image_mc, {type:Fade, direction:Transition.IN, duration:4, easing:Strong.easeOut});
				TransitionManager.start (iconContainer, {type:Zoom, direction:Transition.IN, duration:.5, easing:Bounce.easeOut});
				// Increment next icon and image
				iconIndex++;
				imageIndex++;
			}
		}
	}
}

// Make an instance of the menu button class
var goResult_btn:MenuOption = new MenuOption();

// Populates the item container with the icons from the bought items array
function showPurchasedItems (array:Array, container:MovieClip):void
{
	// Number of purchased items
	var numIcons:int = array.length;
	// Item name
	var mcName_Index:int = 0;
	// Item image
	var itemImage_Index:int = 0;
	// Item container displayObject count
	var itemDisplayObjects:int;
	// X coordinate of icon
	var iconX:int = 5;
	// Y coordinate of icon
	var iconY:int = 5;
	// Path to the image
	var imagePath:String;
	
	// Clear containers
	cleanContainer (container);
	// Add all items in the array to the bought item container
	for (var i:int = 0; i < numIcons; i++)
	{
		// Load the item container into the bought items container
		var iconContainer:itemIcon = new itemIcon();
		iconContainer.alpha = .75;
		iconContainer.buttonMode = true;
		iconContainer.mouseChildren = false;
		iconContainer.scaleX = 1.25;
		iconContainer.scaleY = 1.25;
		iconContainer.smoothing = true;
		iconContainer.name = "sold"+mcName_Index;
		iconContainer.x = iconX;
		iconContainer.y = iconY;
		iconContainer.addEventListener (MouseEvent.ROLL_OVER, showItemInfo, false, 0, true);
		iconContainer.addEventListener (MouseEvent.ROLL_OUT, clearItemInfo, false, 0, true);
		iconContainer.addEventListener (MouseEvent.CLICK, returnItem, false, 0, true);
		container.addChildAt (iconContainer, itemDisplayObjects);
		// Add the image to the item container
		iconContainer.image_mc.smoothing = true;
		imagePath = array[itemImage_Index].itemImage;
		loadImage (imagePath, iconContainer.image_mc, .7);
		// Begin the transitions
		TransitionManager.start (iconContainer, {type:Zoom, direction:Transition.IN, duration:.5, easing:Bounce.easeOut});
		TransitionManager.start (iconContainer.image_mc, {type:Fade, direction:Transition.IN, duration:4, easing:Strong.easeOut});
		// Increment next icon and image
		mcName_Index++;
		itemImage_Index++;
	}
	// Update the top index of the display list
	itemDisplayObjects = container.numChildren;
	// If the bought items array has one item, display the results button
	if (array.length > 0)
	{
		// Add the "travel to the dig site" button		
		goResult_btn.x = 150;
		goResult_btn.y = 275;
		goResult_btn.gotoAndStop (1);
		goResult_btn.buttonMode = true;
		goResult_btn.mouseChildren = false;
		goResult_btn.btn_txt.text = "Travel to the dig site.";
		goResult_btn.addEventListener (MouseEvent.MOUSE_OVER, navigation_over, false, 0, true);
		goResult_btn.addEventListener (MouseEvent.MOUSE_UP, navigation_up, false, 0, true);
		goResult_btn.addEventListener (MouseEvent.MOUSE_DOWN, navigation_down, false, 0, true);
		goResult_btn.addEventListener (MouseEvent.MOUSE_OUT, navigation_out, false, 0, true);
		goResult_btn.addEventListener (MouseEvent.CLICK, gotoResult, false, 0, true);
		addChild (goResult_btn);
		TransitionManager.start (goResult_btn, {type:Fade, direction:Transition.IN, duration:1, easing:Strong.easeOut});
		inventory_mc.prevItem_mc.alpha = 1;
		inventory_mc.nextItem_mc.alpha = 1;
	}
	else
	{
		removeChild (goResult_btn);
		inventory_mc.prevItem_mc.alpha = .25;
		inventory_mc.nextItem_mc.alpha = .25;
	}
}

// Display the next purchased item in the container
function nextPurchasedItem (event:MouseEvent):void
{
	var container:DisplayObjectContainer = inventory_mc.inventoryContainer_mc;
	var purchasedItems:Array = listDisplayItems(container);
	
	if (purchasedItems.length > 1)
	{
		var bottomItem:DisplayObject = container.getChildAt(0);
		var topItem:int = container.numChildren-1;
				
		container.setChildIndex(bottomItem, topItem);
		TransitionManager.start (inventory_mc.inventoryContainer_mc, {type:Zoom, direction:Transition.IN, duration:.5, easing:Bounce.easeOut});
	}
}

// Display the previous purchased item in the container
function prevPurchasedItem (event:MouseEvent):void
{
	var container:DisplayObjectContainer = inventory_mc.inventoryContainer_mc;
	var purchasedItems:Array = listDisplayItems(container);
	
	if (purchasedItems.length > 1)
	{
		var topItem:DisplayObject = container.getChildAt(container.numChildren-1);
		
		container.setChildIndex(topItem, 0);
		TransitionManager.start (inventory_mc.inventoryContainer_mc, {type:Zoom, direction:Transition.IN, duration:.5, easing:Bounce.easeOut});
	}
}

// Calculate the results of your item purchases
function calculateFeedback ():void
{
	var chosenItemString:String = "";
	var budgetString:String = "";
	var weightString:String = "";
	var statistic1String:String = "";
	var statistic2String:String = "";
	var statistic3String:String = "";
	
	var result_itemString:String = "";
	var result_budgetString:String = "";
	var result_weightString:String = "";
	var result_statsString:String = "";
	
	// Populate final budget
	results_mc.budget_txt.text = "$"+int((packObject.budget)*100)/100;
	// Populate final statistic bars
	results_mc.stat1_mc.statName_txt.text = statName1;
	results_mc.stat2_mc.statName_txt.text = statName2;
	results_mc.stat3_mc.statName_txt.text = statName3;
	// Adjust initial levels for current stat levels
	results_mc.stat1_mc.level_mc.scaleX = packObject.stat1/packObject.stat1Maximum;
	results_mc.stat2_mc.level_mc.scaleX = packObject.stat2/packObject.stat2Maximum;
	results_mc.stat3_mc.level_mc.scaleX = packObject.stat3/packObject.stat3Maximum;
	// Populate final weight and truck
	results_mc.weight_mc.weight_txt.text = packObject.weight+"/"+packObject.weightMaximum+" lbs.";
	results_mc.truck_mc.level_mc.scaleY = packObject.weight/packObject.weightMaximum;
	
	// Calculate feedback based on chosen items
	for (var i:Number = 0; i<boughtItems_Array.length; i++)
	{
		// Check if the item was purchased
		for (var g:Number = 0; g<chosenComment_Array.length; g++)
		{	
			if (boughtItems_Array[i].itemName == chosenComment_Array[g].commentItem)
			{
				chosenItemString = chosenItemString+" "+chosenComment_Array[g].commentResult;
			}
		}
	}
	
	// Calculate budget feedback based on final budget
	if (packObject.budget <= 100)
	{
		budgetString = "You spent a lot of money, and almost bankrupted your institution. Hope your discoveries are worth it.";
	}
	else
	{
		budgetString = "You have some money left in your budget. Nice work -- you should go into banking.";
	} 
	
	// Calculate weight feedback based on final weight
	if (packObject.weight >= (packObject.weightMaximum-50))
	{
		weightString = "Your truck is full and heavy. Let's hope you don't get stuck in any loose sand.";
	}
	else
	{
		weightString = "Your truck is light and nimble. You practically float across the desert sands.";
	}
	
	// Calculate statistic 1 feedback based on final value
	if ((packObject.stat1/packObject.stat1Maximum) < .5)
	{
		statistic1String = "Your "+statName1+" score was pretty low. You’re going to have trouble pulling artifacts out of the ground.";
	}
	else
	{
		statistic1String = "Your "+statName1+" score was high. You should have no problem extracting artifacts from the site.";
	}
	
	// Calculate statistic 2 feedback based on final value
	if ((packObject.stat2/packObject.stat2Maximum) < .5)
	{
		statistic2String = "Your "+statName2+" score was pretty low. You may have some trouble documenting your finds and keeping them safe. ";
	}
	else
	{
		statistic2String = "Your "+statName2+" score was high. Your artifacts are well-documented and preserved.";
	}
	
	// Calculate statistic 3 feedback based on final value
	if ((packObject.stat3/packObject.stat3Maximum) < .5)
	{
		statistic3String = "Your "+statName3+" score was pretty low. You may not make it back alive!";
	}
	else
	{
		statistic3String = "Your "+statName3+" score was high. You should have no problem surviving in the desert.";
	}
	
	result_itemString = chosenItemString;
	result_budgetString = budgetString;
	result_weightString = weightString;
	result_statsString = "<p>"+statistic1String+"<br />"+statistic2String+"<br />"+statistic3String+"</p>";
	
	results_mc.feedback_items.multiline = true;
	results_mc.feedback_items.wordWrap = true;
	results_mc.feedback_items.htmlText = result_itemString;
	
	results_mc.feedback_budget.text = result_budgetString;
	
	results_mc.feedback_weight.text = result_weightString;
	
	results_mc.feedback_stats.multiline = true;
	results_mc.feedback_stats.wordWrap = true;
	results_mc.feedback_stats.htmlText = result_statsString;
}

// Navigation
function gotoMenuOption1 (event:MouseEvent)
{
	event.target.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	event.target.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	event.target.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	event.target.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	event.target.removeEventListener (MouseEvent.CLICK, gotoMenuOption1);
	gotoAndStop ("questions");
}

function gotoMenuOption2 (event:MouseEvent)
{
	event.target.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	event.target.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	event.target.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	event.target.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	event.target.removeEventListener (MouseEvent.CLICK, gotoMenuOption2);
	gotoAndStop ("try");
}

function gotoQOption1 (event:MouseEvent)
{
	event.target.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	event.target.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	event.target.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	event.target.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	event.target.removeEventListener (MouseEvent.CLICK, gotoQOption1);
	removeChild (questionContainer);
	gotoAndStop ("try");
}

function gotoQOption2 (event:MouseEvent)
{
	event.target.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	event.target.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	event.target.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	event.target.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	event.target.removeEventListener (MouseEvent.CLICK, gotoQOption2);
	removeChild (questionContainer);
	gotoAndStop ("menu");
}

function gotoActivityOption1 (event:MouseEvent):void
{
	event.target.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	event.target.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	event.target.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	event.target.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	event.target.removeEventListener (MouseEvent.CLICK, gotoActivityOption1);
	if (contains(goResult_btn))
	{
		removeChild(goResult_btn)
	}
	gotoAndStop ("questions");
}

function gotoActivityOption2 (event:MouseEvent):void
{
	event.target.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	event.target.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	event.target.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	event.target.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	event.target.removeEventListener (MouseEvent.CLICK, gotoActivityOption2);
	if (contains(goResult_btn))
	{
		removeChild(goResult_btn)
	}
	gotoAndStop ("menu");
}

function gotoResult (event:MouseEvent):void
{
	event.target.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	event.target.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	event.target.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	event.target.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	event.target.removeEventListener (MouseEvent.CLICK, gotoResult);
	if (contains(goResult_btn))
	{
		removeChild(goResult_btn)
	}
	gotoAndStop ("result");
}

function gotoResultOption1 (event:MouseEvent):void
{
	event.target.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	event.target.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	event.target.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	event.target.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	event.target.removeEventListener (MouseEvent.CLICK, gotoResultOption1);
	gotoAndStop ("try");
}

function gotoResultOption2 (event:MouseEvent):void
{
	event.target.removeEventListener (MouseEvent.MOUSE_OVER, navigation_over);
	event.target.removeEventListener (MouseEvent.MOUSE_UP, navigation_up);
	event.target.removeEventListener (MouseEvent.MOUSE_DOWN, navigation_down);
	event.target.removeEventListener (MouseEvent.MOUSE_OUT, navigation_out);
	event.target.removeEventListener (MouseEvent.CLICK, gotoResultOption2);
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