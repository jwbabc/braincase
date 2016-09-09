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
*/

package com.motobug.loaders {
  import flash.display.Sprite;
  import flash.display.Loader;
  import flash.events.*;
  import flash.net.*;
  import org.flashdevelop.utils.FlashConnect;
  
  public class AssetLoader extends Sprite {
    // Holds the the loaded files
    public var _objectsArray:Array = new Array();
    // Defaults the loaded percentage to 0
    public var _percentLoaded:int = 0;
    // Holds all the items to be loaded
    private var _items:Array = new Array();
    // Holds the total items to be preloaded	
    private var _totalItems:int;
    // Defaults the current preloaded item to 1
    private var _currentItem:int = 1;
    
    // AssetLoader constructor
    public function AssetLoader() {
    }
    
    public function loadItems (assetList:Array):void {
      _objectsArray = [];
      _items = [];
      _percentLoaded = 0;
      _items = [];
      _totalItems = 0;
      _currentItem = 1;
      _items = assetList;
      _totalItems = _items.length;
      
      // Load the first item
      loadOne(_currentItem - 1, _items);
    }
    
    private function loadOne(what:int, items:Array):void {
      // Create a new loader instance
      var _loader:Loader = new Loader();
      // Configure listeners for loader debugging
      configureListeners(_loader.contentLoaderInfo);
      // Initiate the URLrequest
      var _request:URLRequest = new URLRequest(items[what].toString());
      // Load the request data into the loader object
      try {
        _loader.load (_request);
      } catch (e:SecurityError) {
        trace ("SecurityError: "+e);
      }
    }
    
    // Configure listeners for loader debugging
    private function configureListeners(dispatcher:IEventDispatcher):void {
      dispatcher.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
      dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
      dispatcher.addEventListener(Event.INIT, initHandler, false, 0, true);
      dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
      dispatcher.addEventListener(Event.OPEN, openHandler, false, 0, true);
      dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
    }
    
    private function completeHandler(e:Event):void {
      // Add a loaded object to the objects array
      _objectsArray.push(e.target.content);
      // increment the current item to be loaded
      _currentItem += 1;
      // When all objects are loaded, call the parent class
      if (_objectsArray.length == _totalItems) {
        e.target.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
        e.target.removeEventListener(Event.COMPLETE, completeHandler);
        dispatchEvent(new Event("preloadComplete", true, false));
      } else {
        // Load the next one
        loadOne(_currentItem - 1, _items);
      }
    }
    
    private function httpStatusHandler(e:HTTPStatusEvent):void {
      //trace("httpStatusHandler: " + e);
    }
    
    private function initHandler(e:Event):void {
      //trace("initHandler: " + e);
    }
    
    private function ioErrorHandler(e:IOErrorEvent):void {
      //trace("ioErrorHandler: " + e);
    }
    
    private function openHandler(e:Event):void {
      //trace("openHandler: " + e);
    }
    
    private function progressHandler(e:ProgressEvent):void {
      //trace("progressHandler: bytesLoaded=" + e.bytesLoaded + " bytesTotal=" + e.bytesTotal);
      var _temp:int = Math.ceil((((e.target.bytesLoaded / e.target.bytesTotal)*100 * _currentItem) / _totalItems));
      if (_temp > _percentLoaded) {
        // Avoid the precentage to drop
        _percentLoaded = _temp;
      }
      //trace(_percentLoaded);
      // Call the parent class with a progress update
      dispatchEvent(new Event("preloadProgress", true, false));
    }
  
    public function get loaded():int
    {
      // Returns the loaded percentage of all files to be preloaded
      return _percentLoaded;
    }
    
    public function get objects():Array
    {
      // Returns the loaded files as an array
      return _objectsArray;
    }
  }
}
