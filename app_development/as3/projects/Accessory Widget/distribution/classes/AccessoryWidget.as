// $Id$

/**
 * Accessory Widget
 * A flash application for selecting accessories
 *
 * ------ General Overview ------
 * When index.html is finished loading, we use the EIManager class to
 * communicate with the "container" (this being index.html) to first,
 * make sure that the ExternalInterface is available, and second, to
 * notify the Javascript in index.html that the *.swf file is ready to
 * receive any Javascript calls.
 *
 * Once this is done, we enable the alert function to send javascript alerts.
 *
 * We then recieve a variable from swfObject based on the location of the page.
 * The CurrencyLocalization class uses this variable to format the currency
 * for the accessory price.
 * 
 * The application then uses the XMLLoader class to pull in the XML schema
 * and data from the two XML files "app_config.xml" and "product_data.xml".
 *
 * Using this schema and data, once loaded, we proceed to load the categories
 * of the accessory widget and place them in the array "categoryArray_Array"
 * and an XML object "configXML_XML".
 * 
 * We then pull in the accessory data and place them in an XML object "accessoryXML_XML".
 *
 * We then use the CSSLoader class to load the widget's CSS StyleSheet from 
 * the "css/" directory and place it within a StyleSheet object to be applied
 * to our dynamic textfields later.
 *
 * Finally we build our rootContainer called "rootContainer_mc" and build the
 * category list ("categoryList_mc"), and accessory list ("accessoryList_mc")
 * within the root container. Using the XML object we build the category items,
 * accessory assets and items, and program the list functionality.
 *
 * @access public
 * @author Joel Back <jwbabc@comcast.net>
 * @version 1.0
 *
 */

package {
  
  import flash.display.*;
  import flash.display.Sprite;
  import flash.display.MovieClip;
  import flash.display.Shape;
  import flash.display.Graphics;
  import flash.text.*;
  import flash.utils.*;
  import flash.events.*;
  import flash.net.*;
  import fl.transitions.*;
  import fl.transitions.easing.*;

  import XMLLoader;
  import CSSLoader;
  import AssetLoader;
  import CurrencyLocalization;
  import EIManager;
  
	public class AccessoryWidget extends MovieClip {
		// ------ Class Objects ------
		// External Interface Manager Class
		private var ei:EIManager = new EIManager();
    // "app_config.xml" XML object
		private var configXML_XML:XMLLoader;
		// "product_data.xml" XML object
		private var accessoryXML_XML:XMLLoader;
		// The CSSLoader class
		private var widgetCSSLoader:CSSLoader;
		// The CurrencyLocalization class
		private var formattedPrice:CurrencyLocalization;
		
		// ------ Arrays ------
		// This array will store all the categories for the accessories
		private var categoryArray_Array:Array;
		// This array will store all the accessory transitions
    private var transitions:Array = new Array();
    
    private var accessoryAssets_Array:Array;
    private var accessoryContainer_Array:Array;
    
		
		// ------ Paths ------
		// Path to the xml documents
		private var xmlPath_String:String;
		// Configuation XML filename
		private var configXMLPath_String:String;
		// Product data XML filename
		private var productDataXMLPath_String:String;
		// The path to the CSS file
		private var cssPath_String:String;
		// The AssetLoader class
		private var loadAssets:AssetLoader;
		// The SimpleLoader class
		private var loadAsset:SimpleLoader;
		// The path to the assets
		private var assetPath_String:String;
		
		// ------ StyleSheets ------
		// The CSS StyleSheet object
		private var cssStyleSheet:StyleSheet;
		
		// ------ Containers ------
		// The root container
		private var rootContainer_mc:MovieClip = new MovieClip();
		// The category list container
		private var categoryList_mc:MovieClip = new MovieClip();
		// The accessory list container
		private var accessoryList_mc:MovieClip = new MovieClip();
		// The accessory item container contained within the accessory list container
		private var accessoryListContainer_mc:MovieClip = new MovieClip();
		
		// The selected category highlight container
		private var selectedCategoryTab_mc:MovieClip = new MovieClip();
		// The accessory list button containers
		private var nextAccessoryBtn_mc:MovieClip = new MovieClip();
		private var prevAccessoryBtn_mc:MovieClip = new MovieClip();
		
		// ------ Load Progress Assets
		// Load progress loader bar in application library
		private var loadProgressDisplay:LoadProgress = new LoadProgress ();
		
		// ------ Masks ------
		// The accessory list dynamic mask
		private var accessoryMaskObject:Sprite;
		
		// ------ Accessory Item List variables ------
		// Current selected category
		var currentCategory:String;
		// Item counter, used to determine if the "next accessory" button is needed
		private var itemCount:int;
		// The spacing between accessory items in the list
		private var itemSpacing:Number = 164.5;
		// The country variable passed from swfObject
		private var country:String = root.loaderInfo.parameters.country;
		
		// ------ Tweening and Transitions ------
		// The fade transition manager for the accessories
		private var tm:TransitionManager;
		// The fade transition manager for the load progress display
		private var loadProgress_tm:TransitionManager;
		
		// The tween objects for the accessory item container
    private var nextAccessoryTween:Tween;
		private var prevAccessoryTween:Tween;
		
		// Accessory Widget constructor
		public function AccessoryWidget ():void {
		  xmlPath_String = "xml/";
		  cssPath_String = "css/widget.css";
		  assetPath_String = "assets/"
		  configXMLPath_String = "app_config.xml";
		  productDataXMLPath_String = "product_data.xml";		  
		  // Add the load progress display to the root display list
      loadProgressDisplay.x = 40;
      loadProgressDisplay.y = 475;
      addChild(loadProgressDisplay);
      // Load the config XML file
		  loadConfig ();
		}
		
		/**
		 * ------ Utility Functions ------
		 *
		 * Clears all children from the target container
		 *
		 */
    public function clearContainer (container:Object):void {
      while (container.numChildren > 0) container.removeChildAt (container.numChildren-1);
    }
    
    /**
     * Adds objects from the asset loader array to the target container's display list
     *
     */
    public function showAllObjects(mc:MovieClip, o:Array){
      for (var i:int=0; i<o.length; i++) {
        mc.addChild(o[i]);
      }
    }
    
    /**
     * Add objects in a specific order to specific containers in the accessory list container
     *
     */
    public function showAccessoryObjects (mc:MovieClip, o:Array) {
      for (var i:int=0; i<o.length; i++) {
        mc.accessoryImageContainer_mc.addChild(o[i]);
      }
    }
    
    /**
		 * Draws the horizontal rule for each category in the category list
		 * Adds it to the target movieclip's display list
		 *
		 */
		public function drawHorizontalRule(mc:MovieClip):void {
      var hRule:Shape = new Shape();    
      hRule.graphics.lineStyle(.25, 0xb6b6b6, 1, false, LineScaleMode.VERTICAL, CapsStyle.NONE, JointStyle.MITER, 10);
      hRule.graphics.moveTo(5, 47);
      hRule.graphics.lineTo(175, 47);
      mc.addChild(hRule);
		}
		
		/**
		 * Draws the vertical rule for the category list
		 * Adds it to the target movieclip's display list
		 *
		 */
		public function drawVerticalRule(mc:MovieClip):void {
		  var vRule:Shape = new Shape();    
      vRule.graphics.lineStyle(.25, 0xb6b6b6, 1, false, LineScaleMode.VERTICAL, CapsStyle.NONE, JointStyle.MITER, 10);
      vRule.graphics.moveTo(185, 20);
      vRule.graphics.lineTo(185, 470);
      mc.addChild(vRule);
		}
		
		/**
		 * ------ Import CSS & XML data and schema ------
		 *
		 * Load the configuration data from the path in "configXMLPath_String" into the XML object
		 * Listen for the loading of the XML data to complete
		 * Once complete, load the accessory categories
		 *
		 */
		public function loadConfig ():void {
		  // Pass the XML path to the XML loader class
		  configXML_XML = new XMLLoader(xmlPath_String+configXMLPath_String);
		  // Assign load progress listeners
		  configXML_XML.addEventListener(ProgressEvent.PROGRESS, loadConfig_Progress);
		  configXML_XML.addEventListener(Event.COMPLETE, loadConfig_Complete);
		  // Assign a task to the load progress display
		  loadProgressDisplay.task_txt.text = "Loading "+configXMLPath_String;
		}
		
		/**
		 * Listens on the progress of the configXML_XML load
		 *
		 */
		public function loadConfig_Progress (event:Event):void {
		  // Update the load progress display
		  loadProgressDisplay.progress_txt.text = event.target.p_Loaded + "% loaded";
			loadProgressDisplay.bar_mc.width = event.target.p_Loaded;
		}
		
		/**
		 * Finalize the output of loading progress
		 * Remove the listener for loading the configuration data
		 * Load the accessory categries
		 */
		public function loadConfig_Complete (event:Event):void {
			// Finalize the output to the load progress display
			loadProgressDisplay.bar_mc.width = 100;
			loadProgressDisplay.progress_txt.text = "Loading complete";
			// Remove the progress and complete listeners
			configXML_XML.removeEventListener(ProgressEvent.PROGRESS, loadConfig_Progress);
		  configXML_XML.removeEventListener(Event.COMPLETE, loadConfig_Complete);
		  // load the accessory categories
		  categoryArray_Array = new Array();
		  for each (var item in configXML_XML.p_XML.categories.category){
		    categoryArray_Array.push(item.@id);
		  }
		  // load the first set of accessories
		  loadAccessoryData ();
		}
		
		/**
		 * Load the configuration data from the path in "productDataXMLPath_String" into the XML object
		 * Listen for the loading of the XML data to complete
		 * Once complete, load the application StyleSheet
		 *
		 */
		public function loadAccessoryData ():void {
		  // Pass the XML path to the XML loader class
		  accessoryXML_XML = new XMLLoader(xmlPath_String+productDataXMLPath_String);
		  // Assign load progress listeners
		  accessoryXML_XML.addEventListener(ProgressEvent.PROGRESS, loadAccessoryData_Progress);
		  accessoryXML_XML.addEventListener(Event.COMPLETE, loadAccessoryData_Complete);
		  // Assign a task to the load progress display
		  loadProgressDisplay.task_txt.text = "Loading "+productDataXMLPath_String;
		}
		
		/**
		 * Listens on the progress of the accessoryXML_XML load
		 *
		 */
		public function loadAccessoryData_Progress (event:Event):void {
		  // Update the load progress display
		  loadProgressDisplay.progress_txt.text = event.target.p_Loaded + "% loaded";
			loadProgressDisplay.bar_mc.width = event.target.p_Loaded;
		}
		
		/**
		 * Finalize the output of loading progress
		 * Remove the listeners for loading the accessory data
		 * Load the CSS Stylesheet
		 */
		public function loadAccessoryData_Complete (event:Event):void {
			// Finalize the output to the load progress display
			loadProgressDisplay.bar_mc.width = 100;
			loadProgressDisplay.progress_txt.text = "Loading complete";
			// Remove the progress and complete listeners
			accessoryXML_XML.removeEventListener(ProgressEvent.PROGRESS, loadAccessoryData_Progress);
		  accessoryXML_XML.removeEventListener(Event.COMPLETE, loadAccessoryData_Complete);
		  // load the CSS Stylesheet
		  loadCSSStyleSheet ();
		}
		
		/**
		 * Pass the CSS data from the path in cssPath_String to the CSSLoader class
		 * Load the CSS data from widgetCSSLoader into the StyleSheet object
		 *
		 */
		public function loadCSSStyleSheet ():void {
		  // Pass the CSS path to the CSS loader class
		  widgetCSSLoader = new CSSLoader(cssPath_String);
		  // Assign load progress listeners
		  widgetCSSLoader.addEventListener(ProgressEvent.PROGRESS, loadCSSStyleSheet_Progress);
		  widgetCSSLoader.addEventListener(Event.COMPLETE, loadCSSStyleSheet_Complete);
		  // Assign a task to the load progress display
		  loadProgressDisplay.task_txt.text = "Loading "+cssPath_String;
		}
		
		/**
		 * Listens on the progress of the accessoryXML_XML load
		 *
		 */
		public function loadCSSStyleSheet_Progress (event:Event):void {
		  // Update the load progress display
		  loadProgressDisplay.progress_txt.text = event.target.p_Loaded + "% loaded";
			loadProgressDisplay.bar_mc.width = event.target.p_Loaded;
		}
		
		/**
		 * Finalize the output of loading progress
		 * Remove the listeners for loading the CSS data
		 * Load the CSS Stylesheet
		 */
		public function loadCSSStyleSheet_Complete (event:Event):void {
			// Finalize the output to the load progress display
			loadProgressDisplay.bar_mc.width = 100;
			loadProgressDisplay.progress_txt.text = "Loading complete";
			// Remove the progress and complete listeners
			widgetCSSLoader.removeEventListener(ProgressEvent.PROGRESS, loadCSSStyleSheet_Progress);
		  widgetCSSLoader.removeEventListener(Event.COMPLETE, loadCSSStyleSheet_Complete);
		  // Assign the CSS data to the CSS object
		  cssStyleSheet = widgetCSSLoader.p_styles;
		  // Build the widget primary containers
		  buildWidgetContainers();
		}
		
		/**
		 * ------ Container Construction ------
		 * Load the background for the root container
		 * Load the container for the accessory list
		 * Load the accessory items for the first category of the accessories
		 * Load the container for the category list
		 *
		 */
		public function buildWidgetContainers ():void {
		  // Pass the path to the background image into the asset loader class array
		  loadAssets = new AssetLoader([assetPath_String+"ui/widget_bkg.png"]);
		  // Assign listeners
		  loadAssets.addEventListener("preloadProgress", buildWidgetContainers_Progress);
			loadAssets.addEventListener("preloadComplete", buildWidgetContainers_Complete);
			// Assign a task to the load progress display
		  loadProgressDisplay.task_txt.text = "Loading "+assetPath_String+"ui/widget_bkg.png";
		}
		
		/**
		 * Listens on the progress of the loadAssets load
		 *
		 */
		public function buildWidgetContainers_Progress (event:Event):void {
		  // Update the load progress display
		  loadProgressDisplay.progress_txt.text = event.target.p_Loaded + "% loaded";
			loadProgressDisplay.bar_mc.width = event.target.p_Loaded;
		}
		
		public function buildWidgetContainers_Complete (event:Event):void {
		  // Finalize the output to the load progress display
		  loadProgressDisplay.bar_mc.width = 100;
			loadProgressDisplay.progress_txt.text = "Loading complete";
			// Remove listeners
		  loadAssets.addEventListener("preloadProgress", buildWidgetContainers_Progress);
			loadAssets.addEventListener("preloadComplete", buildWidgetContainers_Complete);
			// Remove the load progress display from the display list
			removeChild(loadProgressDisplay);
			// Add the root container
		  addChild(rootContainer_mc);
		  // Add the background graphic to rootContainer_mc
      showAllObjects(rootContainer_mc, loadAssets.p_Objects);
		  // Add the accessory list to the root container
		  rootContainer_mc.addChild(accessoryList_mc);
		  // Add the category list to the root container
      rootContainer_mc.addChild(categoryList_mc);
      // Build the accessory list container
      buildAccessoryListContainer ();
      // Build the category list container
      buildCategoryListContainer();
      // Load the first categories' list of items
      loadAccessoryItems(categoryArray_Array[0].toString());
		}
		
		/**
		 * Positions the accessory list container
		 * Adds it to the accessory container
		 * Passes the accessory container to the function that builds the dynamic mask
		 *
		 */
		public function buildAccessoryListContainer ():void {
		  // Position the list
		  accessoryList_mc.x = 200;
      accessoryList_mc.y = 30;
      // Add accessory list container to the root container of the accessory list
		  accessoryList_mc.addChild(accessoryListContainer_mc);
		  // Assign the mask
      buildAccessoryListMask (accessoryList_mc);
		}
		
		/**
		 * Builds the dynamic mask for the target container
		 * In this case, the accessory container
		 *
		 */
		public function buildAccessoryListMask (target:MovieClip):void {
		  // Create mask
      accessoryMaskObject = new Sprite();
      accessoryMaskObject.graphics.beginFill(0xFF0000);
      accessoryMaskObject.graphics.drawRect(target.x, target.y, 198, 488);
      rootContainer_mc.addChild(accessoryMaskObject);
      // Apply mask
      target.mask = accessoryMaskObject;
		}
		
    /**
		 * Receives the selected category
		 * Resets the accessory list container back to its starting posiiton
		 * The item count increment is set to 0
		 * Based on that category, the function checks the item to see if the selected category matches
		 * the category of the item.
		 * If so, an accessory item container is created
		 * The accessory item container is positioned based on itemSpacing
		 * A listener is assigned to navigate to the accessory info URL when clicked
		 * Textfields and images of the accessory are loaded
		 * The price data is formatted based on the country code and output to a textField
		 * If the accessory item list has less than 4 items, remove the "next and prev accessory" buttons
		 * Add a transition manager for the fade-in of each accessory
		 * Push the transition manager to an array so that it is not garbage collected
		 * Start the fade-in transition
		 * Listen for the fade-in transition to complete and call the function fadeInsComplete()
		 * Item count is incremented for the next item
		 * 
		 */
		public function loadAccessoryItems (accessoryCategory:String):void {
		  // Reset the y position of accessory list container
		  accessoryListContainer_mc.y = 0;
		  
		  // Assign the curent category selected
		  currentCategory = accessoryCategory;
		  
		  // Initialize the accessory assets array
		  accessoryAssets_Array = new Array();
		  
		  // Add the assets to the accessoryAssets array
		  for each (var item in accessoryXML_XML.p_XML.product){
		    for each (var catItem in item.categories.category){
		      if (catItem == currentCategory) {
		        accessoryAssets_Array.push(assetPath_String+"ui/accessory_bkg.png");
		        accessoryAssets_Array.push(assetPath_String+item.thumb);
		      }
		    }
		  }
		  
		  // Preload all assets for the accessories
		  loadAssets = new AssetLoader(accessoryAssets_Array);
		  
		  // Add listeners
		  loadAssets.addEventListener("preloadProgress", loadAccessoryItems_Progress);
			loadAssets.addEventListener("preloadComplete", loadAccessoryItems_Complete);
			
			// Add the load progress display to the display list
			loadProgressDisplay.x = 40;
			loadProgressDisplay.y = 475;
			addChild(loadProgressDisplay);
			
			// Assign the transition manager object to the load progress display
		  loadProgress_tm = new TransitionManager(loadProgressDisplay);
		  // Initiate the fade-in transition
      loadProgress_tm.startTransition({type:Fade, direction:Transition.IN, duration:.2, easing:Strong.easeIn});
			
			// Assign a task to the load progress display
		  loadProgressDisplay.task_txt.text = "Loading accessories";
		}
		
		public function loadAccessoryItems_Progress (event:Event){
		  // Update the load progress display
		  loadProgressDisplay.progress_txt.text = event.target.p_Loaded + "% loaded";
			loadProgressDisplay.bar_mc.width = event.target.p_Loaded;
		}

    public function loadAccessoryItems_Complete (event:Event){
      // Finalize the output to the load progress display
		  loadProgressDisplay.bar_mc.width = 100;
			loadProgressDisplay.progress_txt.text = "Loading complete";
			
			// Remove listeners
		  loadAssets.addEventListener("preloadProgress", loadAccessoryItems_Progress);
			loadAssets.addEventListener("preloadComplete", loadAccessoryItems_Complete);
			
			// Initialize the accessory container array
			accessoryContainer_Array = new Array();
    
      // Build the accessory items
      itemCount = 0;
		  for each (var item in accessoryXML_XML.p_XML.product){
		    for each (var catItem in item.categories.category){ 
		      if (catItem == currentCategory) {
		        // Create a new instance of the accessory item container
		        var accessoryItemContainer_mc:MovieClip = new MovieClip();
		        accessoryItemContainer_mc.name = item.name;
		        accessoryItemContainer_mc.x = 0;   
            accessoryItemContainer_mc.y = itemSpacing*itemCount;
            accessoryItemContainer_mc.mouseChildren = false;
            accessoryItemContainer_mc.addEventListener(MouseEvent.MOUSE_UP, navigateToAccessoryInfoURL);
            
            // Create accessory background image container
		        var accessoryBackgroundImageContainer_mc:MovieClip = new MovieClip();
		        accessoryItemContainer_mc.addChild (accessoryBackgroundImageContainer_mc);
		        // Load accessory background image container into the array
		        accessoryContainer_Array.push(accessoryBackgroundImageContainer_mc);
		        
		        // Load accessory description text field
		        var accessoryDescriptionTextField:TextField = new TextField();
		        accessoryDescriptionTextField.x = 0;
		        accessoryDescriptionTextField.y = 5;
            accessoryDescriptionTextField.width = 200;
            accessoryDescriptionTextField.autoSize = TextFieldAutoSize.LEFT;
            accessoryDescriptionTextField.wordWrap = true;
            accessoryDescriptionTextField.multiline = true;
            accessoryDescriptionTextField.selectable = false;
            accessoryDescriptionTextField.styleSheet = cssStyleSheet;
            accessoryDescriptionTextField.htmlText = "<p class='accessory-name'>"+item.name+"</p>";
            accessoryItemContainer_mc.addChild(accessoryDescriptionTextField);
		        
		        // Load accessory image
		        var accessoryImageContainer_mc:MovieClip = new MovieClip();
		        accessoryImageContainer_mc.x = 22;
		        accessoryImageContainer_mc.y = 26;
		        accessoryItemContainer_mc.addChild (accessoryImageContainer_mc);
		        // Load accessory image container into the array
		        accessoryContainer_Array.push(accessoryImageContainer_mc);
		        
		        // Load accessory price text field
		        var accessoryPriceTextField:TextField = new TextField();
		        accessoryPriceTextField.x = 0;
		        accessoryPriceTextField.y = 140;
            accessoryPriceTextField.width = 200;
            accessoryPriceTextField.autoSize = TextFieldAutoSize.LEFT;
            accessoryPriceTextField.wordWrap = true;
            accessoryPriceTextField.multiline = true;
            accessoryPriceTextField.selectable = false;
            accessoryPriceTextField.styleSheet = cssStyleSheet;
            
            // Adjust pricing output based on var country
            formattedPrice = new CurrencyLocalization(item.price, country as String);
            var priceLabel:String = configXML_XML.p_XML.appContent.content[1]; 
            accessoryPriceTextField.htmlText = "<span class='accessory-price'>"+priceLabel+": "+formattedPrice.p_output+"</span>";
            accessoryItemContainer_mc.addChild(accessoryPriceTextField);
		        // Add the item to the accessory list container
		        accessoryListContainer_mc.addChild(accessoryItemContainer_mc);
		        
		        // If there are less than 4 items
		        // Remove the "prev accessory" button and button event listener, if it exists
		        removePrevAccessoryBtn();
		        // Remove the "next accessory" button and button event listener, if it exists
		        removeNextAccessoryBtn();
		        
		        // Initiate the fade-in transitions
		        // Assign the transition manager object to the accessory item container
		        tm = new TransitionManager(accessoryListContainer_mc.getChildByName(item.name) as MovieClip);
		        // Add the transition manager to the array
		        transitions.push(tm);
		        // Initiate the fade-in transition
            tm.startTransition({type:Fade, direction:Transition.IN, duration:.5, easing:Strong.easeIn});
		        // Listen for all accessory fade-ins to complete
		        tm.addEventListener ("allTransitionsInDone", fadeInsComplete);
		        
		        // Increment value
		        itemCount++;
		      }
		    }
		  }
		  // Load assets into proper containers
		  
		  for (var i:int = 0; i < accessoryContainer_Array.length; i++){
		    trace (accessoryContainer_Array[i].name);
		    accessoryContainer_Array[i].addChild(loadAssets.p_Objects[i]);
		  }
		  
		  // Initiate the fade-out transition
      loadProgress_tm.startTransition({type:Fade, direction:Transition.OUT, duration:.2, easing:Strong.easeOut});
      // Listen for the load progress display fade-in to complete
		  loadProgress_tm.addEventListener ("allTransitionsOutDone", lpFadeOutComplete);
    }
		
		/**
		 * Moves the category list into postion
		 * Loads the background graphic for the category list container
		 * Loads the instructions textfield into the category list container
		 * Calls the function drawVerticalRule()
		 * For each category in the XML object, a container with a textfield and calls the function drawHorizontalRule()
		 * this container is then added to the display list of the category list container
		 * The category highlight movieclip is created, and loaded with its graphic file and then
		 * added to the category list container
		 * The first category is then highlighted in the category list container
		 *
		 */
		public function buildCategoryListContainer ():void {
		  // Create category list container
		  categoryList_mc.x = 30;
		  categoryList_mc.y = 30;
		  loadAsset = new SimpleLoader(categoryList_mc, assetPath_String+"ui/category_list_bkg.png");
		  
		  // Create instruction textfield
		  var categoryListInstructionsTextField:TextField = new TextField();
		  categoryListInstructionsTextField.y = 15;
      categoryListInstructionsTextField.width = 193;
      categoryListInstructionsTextField.autoSize = TextFieldAutoSize.LEFT;
      categoryListInstructionsTextField.wordWrap = true;
      categoryListInstructionsTextField.multiline = true;
      categoryListInstructionsTextField.selectable = false;
      categoryListInstructionsTextField.styleSheet = cssStyleSheet;
      categoryListInstructionsTextField.htmlText = "<p class='instructions'>"+configXML_XML.p_XML.appContent.content[0]+"</p>";
      categoryList_mc.addChild(categoryListInstructionsTextField);
		  
		  // Create vertical rule
		  drawVerticalRule(categoryList_mc);
		  
		  // Create category buttons
		  var i:int = 1;
		  for each (var item in configXML_XML.p_XML.categories.category) {
		    var categoryItemContainer_mc:MovieClip = new MovieClip();
        categoryItemContainer_mc.name = item.@id;
        categoryItemContainer_mc.x = 0;   
        categoryItemContainer_mc.y = 48*i;
        categoryItemContainer_mc.mouseChildren = false;
        categoryItemContainer_mc.addEventListener(MouseEvent.MOUSE_UP, loadNewCategory);
		    // Create textfield
		    var categoryTextField:TextField = new TextField();
		    categoryTextField.x = 12;
		    categoryTextField.y = 15;
        categoryTextField.width = 200;
        categoryTextField.autoSize = TextFieldAutoSize.LEFT;
        categoryTextField.wordWrap = true;
        categoryTextField.multiline = true;
        categoryTextField.selectable = false;
        categoryTextField.styleSheet = cssStyleSheet;
        categoryTextField.htmlText = "<p class='category'>"+item+"</p>";
        categoryItemContainer_mc.addChild(categoryTextField);
        categoryList_mc.addChild(categoryItemContainer_mc);
        i++;
		    // Create horizontal rule
		    drawHorizontalRule(categoryItemContainer_mc);
      }
      
      // Highlight the first category in the list
      selectedCategoryTab_mc = new MovieClip();
      selectedCategoryTab_mc.name = "CategorySelectTab_mc";
      loadAsset = new SimpleLoader(selectedCategoryTab_mc, assetPath_String+"ui/category_selected.png");
      categoryList_mc.addChild(selectedCategoryTab_mc);
      
      highlightCategory(categoryArray_Array[0], "CategorySelectTab_mc");
		}
				
		/**
		 * ------ Tween and Transition Listeners ------
		 *
		 * Once the fade-ins of the accessory items are complete
		 * Check if the "next accessory" button is needed
		 * If so, call the function buildNextAccessoryBtn()
		 *
		 */
		public function fadeInsComplete (event:Event):void {
		  // When the fade-ins are completed remove the transition event listener
		  tm.removeEventListener ("allTransitionsInDone", fadeInsComplete);
		  // If there are more than 3 accessories in the list
		  // Load the "next accessory" button
		  if (itemCount > 3) {
		    buildNextAccessoryBtn ();
		  }
		}
		
		public function lpFadeOutComplete (event:Event):void {
		  if (contains(loadProgressDisplay)){
		    removeChild(loadProgressDisplay);
		  }
		  loadProgress_tm.removeEventListener ("allTransitionsInDone", lpFadeOutComplete);
		}
		
		/**
		 * ------ Category List functionality ------
		 *
		 * Creates a reference to "selectedCategoryTab_mc"
		 * Creates a reference to the category movieclip that was clicked
		 * Moves "selectedCategoryTab_mc" to the proper position of the selected category movieclip
		 * Positions "selectedCategoryTab_mc" behind the selected category movieclip in the display list
		 *
		 */
		public function highlightCategory(targetCategoryMovieClipName:String, targetTabMovieClipName:String):void {
      var selectedTabTarget:MovieClip = categoryList_mc.getChildByName(targetTabMovieClipName) as MovieClip;
      var currentCategoryTarget:MovieClip = categoryList_mc.getChildByName(targetCategoryMovieClipName) as MovieClip;
      
      selectedCategoryTab_mc.x = currentCategoryTarget.x+5;
      selectedCategoryTab_mc.y = currentCategoryTarget.y;
      
      categoryList_mc.setChildIndex(selectedTabTarget, 1);
		}
		
		/**
		 * Creates a reference to the category movieclip that was clicked
		 * Calls the highlight category function to "highlight" the movieclip reference
		 * Clears all children from the display list in the accessory item list container
		 * The selected category is passed to the function that loads the accessory items
		 *
		 */
		public function loadNewCategory(event:MouseEvent){
		  var selectedCategoryTarget:String = event.target.name;
		  highlightCategory(selectedCategoryTarget, "CategorySelectTab_mc");
		  
		  // Clear the accessory list container
		  clearContainer(accessoryListContainer_mc);
		  
		  loadAccessoryItems (selectedCategoryTarget);
		}
		
		/**
		 * ------ Accessory Item Functionality ------
		 *
		 * Checks the event target name against the product name in the accessories XML object
		 * If a match is found use the EIManager class to send a javascript alert to the browser
		 * Create a URL resquest for the accessory item's info page
		 * Open a new window and navigate to the URL
		 *
		 */
		public function navigateToAccessoryInfoURL (event:MouseEvent) {
		  for each (var item in accessoryXML_XML.p_XML.product){
		    if (item.name == event.target.name){
		      ei.sendAlert(event.target.name);
		      var request:URLRequest = new URLRequest(item.info);
		      navigateToURL(request);
		    }
		  }
		}
		
		/**
		 * ------ Accessory Item List Navigation ------
		 *
		 * Positions the "previous accessory" button container
		 * Loads the graphic asset into the container using the AssetLoader class
		 * Adds a MOUSE_UP listener to the container to call the function prevAccessory()
		 * Adds the container to the rootContainer display list
		 *
		 */
		public function buildPrevAccessoryBtn ():void {
		  prevAccessoryBtn_mc.x = 250;
		  prevAccessoryBtn_mc.y = 5;
		  prevAccessoryBtn_mc.mouseChildren = false;
		  loadAsset = new SimpleLoader(prevAccessoryBtn_mc, assetPath_String+"ui/prev_accessory_btn.png");
		  prevAccessoryBtn_mc.addEventListener(MouseEvent.MOUSE_UP, prevAccessory);
		  rootContainer_mc.addChild(prevAccessoryBtn_mc);
		}
		
		/**
		 * Removes the "previous accessory" button and button event listener, if it exists
		 */
		public function removePrevAccessoryBtn () {
      if (rootContainer_mc.contains(prevAccessoryBtn_mc)) {
        prevAccessoryBtn_mc.removeEventListener(MouseEvent.MOUSE_UP, prevAccessory);
        rootContainer_mc.removeChild(prevAccessoryBtn_mc);
      }
		}
		
		/**
		 * Initiates the accessory list container Tween based on itemSpacing if y < 0
		 * Adds listener to call function checkListPosition()
		 *
		 */
		public function prevAccessory (event:MouseEvent){
		  if (accessoryListContainer_mc.y < 0) {
		    prevAccessoryTween = new Tween(accessoryListContainer_mc, "y", Elastic.easeOut, accessoryListContainer_mc.y, accessoryListContainer_mc.y+itemSpacing, .25, true);
		    prevAccessoryTween.addEventListener(TweenEvent.MOTION_FINISH, checkListPosition);
		  }
		}
		
		/**
		 * Positions the "next accessory" button container
		 * Loads the graphic asset into the container using the AssetLoader class
		 * Adds a MOUSE_UP listener to the container to call the function nextAccessory()
		 * Adds the container to the rootContainer display list
		 *
		 */
		public function buildNextAccessoryBtn ():void {
		    nextAccessoryBtn_mc.x = 250;
		    nextAccessoryBtn_mc.y = 520;
		    nextAccessoryBtn_mc.mouseChildren = false;
		    loadAsset = new SimpleLoader(nextAccessoryBtn_mc, assetPath_String+"ui/next_accessory_btn.png");
		    nextAccessoryBtn_mc.addEventListener(MouseEvent.MOUSE_UP, nextAccessory);
		    rootContainer_mc.addChild(nextAccessoryBtn_mc);
		}
		
		/**
     * Remove the "next accessory" button and button event listener, if it exists
     *
     */
    public function removeNextAccessoryBtn () {
		  if (rootContainer_mc.contains(nextAccessoryBtn_mc)) {
		    nextAccessoryBtn_mc.removeEventListener(MouseEvent.MOUSE_UP, nextAccessory);
		    rootContainer_mc.removeChild(nextAccessoryBtn_mc);
		  }
		}
		
		/**
		 * Initiates the accessory list container Tween based on itemSpacing if y + list.height < itemSpacing*3
		 * Adds listener to call function checkListPosition()
		 *
		 */		
		public function nextAccessory (event:MouseEvent){
		  // If the "prev accessory" button does not exist, add it
		  if (!rootContainer_mc.contains(prevAccessoryBtn_mc)) {
		    buildPrevAccessoryBtn();
		  }
		  /**
		   * If the end of the accessory list has not been reached
		   * Move the accessory item container to the next item
		   * If the end of the accessory list has been reached
		   * Remove the "next accessory" button
		   *
		   */
		  if (accessoryListContainer_mc.y + accessoryListContainer_mc.height > itemSpacing*3) {
		    nextAccessoryTween = new Tween(accessoryListContainer_mc, "y", Elastic.easeOut, accessoryListContainer_mc.y, accessoryListContainer_mc.y-itemSpacing, .25, true);
		    nextAccessoryTween.addEventListener(TweenEvent.MOTION_FINISH, checkListPosition);
		  }
		}
		
		/**
		 * Once the Tween on the accessory list container is completed, checks the y position of the accessory list
		 * If at the end of the accessory list, remove the "next accessory" button, and listener
		 * Add the "previous accessory" button if neccessary
		 * If at the beginning of the accessory list, remove the "previous accessory" button and listener
		 * Add the "next accessory" button if neccesary
		 *
		 */
		public function checkListPosition (event:TweenEvent){
		  if (accessoryListContainer_mc.y + accessoryListContainer_mc.height <= itemSpacing*3) {
		    removeNextAccessoryBtn();
		    nextAccessoryTween.removeEventListener(TweenEvent.MOTION_FINISH, checkListPosition);
		  } else {
		    if (!rootContainer_mc.contains(nextAccessoryBtn_mc)) {
		      buildNextAccessoryBtn();
		    }
		  }
		  if (accessoryListContainer_mc.y >= 0) {
		    removePrevAccessoryBtn();
		    prevAccessoryTween.removeEventListener(TweenEvent.MOTION_FINISH, checkListPosition);
		  } else {
		    if (!rootContainer_mc.contains(prevAccessoryBtn_mc)) {
		      buildPrevAccessoryBtn();
		    }
		  }
		}
	}
}