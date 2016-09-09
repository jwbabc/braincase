import fl.transitions.*;
import fl.transitions.easing.*;
import XMLLoader;

// Arrays
var items_Array:Array = new Array();
var boughtItems_Array:Array = new Array();
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
var statName3:String = "Survivability";

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

function listDisplayItems (container:MovieClip)
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
	//trace (packObject.stat1Maximum+","+packObject.stat2Maximum+","+packObject.stat3Maximum);
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
	showItems (items_Array[0], container_Array[0]);
}

function swapTab2 (event:MouseEvent):void
{
	activeTab = 2;
	supplies_mc.tab1_mc.alpha = .5;
	supplies_mc.tab2_mc.alpha = 1;
	supplies_mc.tab3_mc.alpha = .5;
	showItems (items_Array[1], container_Array[0]);
}

function swapTab3 (event:MouseEvent):void
{
	activeTab = 3;
	supplies_mc.tab1_mc.alpha = .5;
	supplies_mc.tab2_mc.alpha = .5;
	supplies_mc.tab3_mc.alpha = 1;
	showItems (items_Array[2], container_Array[0]);
}

// Display the item data within the item description container.
function showItemInfo (event:MouseEvent):void
{
	var str:String = event.currentTarget.name.toString();
	//trace ("showItemInfo: "+str);
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
		// trace (stat1_mc.level_mc.scaleX+","+stat2_mc.level_mc.scaleX+","+stat3_mc.level_mc.scaleX);
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

function moveItemToBought ():void
{
	// Add item to bought array
	boughtItems_Array.unshift (boughtItem);
	// Remove item from items array
	items_Array[catIndex].splice (items_Array[catIndex].indexOf(boughtItem), 1);
	// Update the bought items container
	showItems (boughtItems_Array, container_Array[1]);
	// Update item containers
	switch(activeTab)
	{
		case 1:
			showItems (items_Array[0], container_Array[0]);
			break;
		case 2:
			showItems (items_Array[1], container_Array[0]);
			break;
		case 3:
			showItems (items_Array[2], container_Array[0]);
			break;
	}
	updateStats ("bought");
}

function moveItemToSell ():void
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
	showItems (boughtItems_Array, container_Array[1]);
	// Repopulate item containers
	switch(activeTab)
	{
		case 1:
			showItems (items_Array[0], container_Array[0]);
			break;
		case 2:
			showItems (items_Array[1], container_Array[0]);
			break;
		case 3:
			showItems (items_Array[2], container_Array[0]);
			break;
	}
	updateStats ("sold");
}

// Make an instance of the disabled stat class
var statDisabled_mc:StatDisabled = new StatDisabled();

function buyItem (event:MouseEvent):void
{
	if (packObject.budget <= 0)
	{
		statContainer_mc.addChild(statDisabled_mc);
		statDisabled_mc.statDisabled_txt.htmlText = "You overspent your budget!<br /><br />Sell items to get back some money.";
	}
	else if (packObject.weight >= packObject.weightMaximum)
	{		
		statContainer_mc.addChild(statDisabled_mc);
		statDisabled_mc.statDisabled_txt.htmlText = "You have exceeded the weight of the truck!<br /><br />Sell items to lighten the load.";
	}
	else if (boughtItems_Array.length >= packObject.inventorySlotMaximum)
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
		var str:String = event.currentTarget.name.toString();
		toolIndex = str.substr(4);
		trace ("buyItem - catIndex/toolIndex: "+catIndex+"/"+toolIndex);
		boughtItem = items_Array[catIndex][toolIndex];
		moveItemToBought ();
	}
}

function returnItem (event:MouseEvent):void
{
	if (statContainer_mc.contains (statDisabled_mc))
	{
		statContainer_mc.removeChild(statDisabled_mc);
	}
	var str:String = event.currentTarget.name.toString();
	trace ("returnItem - str:"+str);
	toolIndex = str.substr(4);
	trace ("returnItem - toolIndex: "+toolIndex);
	boughtItem = boughtItems_Array[toolIndex];
	moveItemToSell ();
}

// Make an instance of the menu button class
var goResult_btn:MenuOption = new MenuOption();

// Populates the item container with the icons from the proper array
function showItems (array:Array, container:MovieClip):void
{
	var numIcons:int = array.length;
	var iconIndex:int = 0;
	var imageIndex:int = 0;
	var columns:int = 8;
	var rows:int = Math.ceil(numIcons/columns);
	var spacing:int = 5;
	var iconX:int;
	var iconY:int;
	// Clear containers
	cleanContainer (container);
	// Populate the container with the tools and name them
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
				var imagePath:String = array[imageIndex].itemImage;
				// Load image into the icon container
				iconContainer.image_mc.smoothing = true;
				loadImage (imagePath, iconContainer.image_mc, .7);
				TransitionManager.start (iconContainer.image_mc, {type:Fade, direction:Transition.IN, duration:4, easing:Strong.easeOut});
				iconContainer.alpha = .75;
				iconContainer.buttonMode = true;
				iconContainer.mouseChildren = false;
				switch (container.parent)
				{
					case supplies_mc :
						iconContainer.scaleX = .75;
						iconContainer.scaleY = .75;
						iconContainer.name = "tool"+iconIndex;
						iconContainer.addEventListener (MouseEvent.ROLL_OVER, showItemInfo, false, 0, true);
						iconContainer.addEventListener (MouseEvent.ROLL_OUT, clearItemInfo, false, 0, true);
						iconContainer.addEventListener (MouseEvent.CLICK, buyItem, false, 0, true);
						break;
					case inventory_mc :
						iconContainer.scaleX = 1.25;
						iconContainer.scaleY = 1.25;
						iconContainer.name = "sold"+iconIndex;
						iconContainer.addEventListener (MouseEvent.ROLL_OVER, showItemInfo, false, 0, true);
						iconContainer.addEventListener (MouseEvent.ROLL_OUT, clearItemInfo, false, 0, true);
						iconContainer.addEventListener (MouseEvent.CLICK, returnItem, false, 0, true);
						// If the container has reached its limit display the results button
						if (boughtItems_Array.length > 0)
						{
							goResult_btn.x = 800;
							goResult_btn.y = 683;
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
						}
						else
						{
							removeChild (goResult_btn);
						}
						break;
				}
				container.addChild (iconContainer);
				iconX = spacing+((iconContainer.width+spacing)*c);
				iconY = spacing+((iconContainer.height+spacing)*r);
				iconContainer.x = iconX;
				iconContainer.y = iconY;
				TransitionManager.start (iconContainer, {type:Zoom, direction:Transition.IN, duration:.5, easing:Bounce.easeOut});
				// Increment next icon and image
				iconIndex++;
				imageIndex++;
			}
		}
	}
}