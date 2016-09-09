// $Id$

/**
* Asset Loader Class
* A class used for loading assets (graphics) into movieclips
*
* ------ General Overview ------
*	Preloads multiple swfs and/or images
*	Accepts an array with strings containing the files to be loaded
*	Dispatches a progress event when loading is in progress
*	Returns the total precentage loaded with getter method 'AssetLoader.p_Loaded'
*	Dispatches a complete event when total loading is complete
*	Returns an array with objects with the loaded files
*	get the array through getter method 'AssetLoader.objects'
* 
* @access public
* @author Joel Back <jwbabc@comcast.net>
* @version 1.0
*
* ------ Usage ------
* import AssetLoader;
*	var pre:AssetLoader = new AssetLoader(["1.jpg","2.jpg","3.jpg"]);
*	pre.addEventListener("preloadProgress", onPreloadProgress);
*	pre.addEventListener("preloadComplete", onPreloadComplete);
*
*/

package {
  import flash.display.Sprite;
  import flash.display.Loader;
  import flash.events.*;
  import flash.net.URLRequest;
  
  public class AssetLoader extends Sprite {
    // Holds the the loaded files
    public var objectsArray:Array = new Array();
    // Defaults the loaded percentage to 0
    public var percentLoaded:int = 0;
    // Holds all the items to be loaded
    private var items:Array = new Array();
    // Holds the total items to be preloaded	
    private var totalItems:int;
    // Defaults the current preloaded item to 1
    private var currentItem:int = 1;
    
    
    // AssetLoader constructor
    public function AssetLoader(assetList:Array) {
      objectsArray	= [];
      items	= [];
      percentLoaded		= 0;
      items = [];
      totalItems 	= 0;
      currentItem 	= 1;
      
      items = assetList;
      totalItems = items.length;
      
      // Load the first item
      loadOne(currentItem - 1, items);
    }
    
    private function loadOne(what:int, items:Array):void {
      // Create a new loader instance
      var loader:Loader = new Loader();
      // Configure listeners for loader debugging
      configureListeners(loader.contentLoaderInfo);
      // Initiate the URLrequest
      var request:URLRequest = new URLRequest(items[what].toString());
      // Load the request data into the loader object
      try {
        loader.load (request);
      } catch (error:SecurityError) {
        trace ("SecurityError: "+error);
      }
    }
    
    // Configure listeners for loader debugging
    private function configureListeners(dispatcher:IEventDispatcher):void {
      dispatcher.addEventListener(Event.COMPLETE, completeHandler);
      dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
      dispatcher.addEventListener(Event.INIT, initHandler);
      dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
      dispatcher.addEventListener(Event.OPEN, openHandler);
      dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
    }
    
    private function completeHandler(event:Event):void {
      //trace("completeHandler: " + event);
      // Add a loaded object to the objects array
      objectsArray.push(event.target.content);
      // increment the current item to be loaded
      currentItem += 1;
      // When all objects are loaded, call the parent class
      if (objectsArray.length == totalItems) {
        event.target.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
        event.target.removeEventListener(Event.COMPLETE, completeHandler);
        dispatchEvent(new Event("preloadComplete"));
      } else {
        // Load the next one
        loadOne(currentItem - 1, items);
      }
      //trace("complete");
    }
    
    private function httpStatusHandler(event:HTTPStatusEvent):void {
      //trace("httpStatusHandler: " + event);
    }
    
    private function initHandler(event:Event):void {
      //trace("initHandler: " + event);
    }
    
    private function ioErrorHandler(event:IOErrorEvent):void {
      //trace("ioErrorHandler: " + event);
    }
    
    private function openHandler(event:Event):void {
      //trace("openHandler: " + event);
    }
    
    private function progressHandler(event:ProgressEvent):void {
      //trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
      var temp:int = Math.ceil((((event.target.bytesLoaded / event.target.bytesTotal)*100 * currentItem) / totalItems));
      if (temp > percentLoaded) {
        // Avoid the precentage to drop
        percentLoaded = temp;
      }
      //trace(percentLoaded);
      // Call the parent class with a progress update
      dispatchEvent(new Event("preloadProgress"));
    }
    
    // Property access
    public function get p_Loaded():int
    {
      // Returns the loaded percentage of all files to be preloaded
      return percentLoaded;
    }
    
    public function get p_Objects():Array
    {
      // Returns the loaded files as an array
      return objectsArray;
    }
  }
}
