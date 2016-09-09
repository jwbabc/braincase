/**
* Asset Loader Class
* A class used for loading assets (graphics) into movieclips
*
* ------ General Overview ------
*	Preloads multiple swfs and/or images
*	Accepts an array with strings containing the files to be loaded
*	Dispatches a progress event when loading is in progress
*	Returns the total precentage loaded with getter method 'AssetLoader._loaded'
*	Dispatches a complete event when total loading is complete
*	Returns an array with objects with the loaded files
*	get the array through getter method 'AssetLoader._objects'
* 
* @access public
* @author Joel Back <jwbabc@comcast.net>
* @version 1.0
*
* ------ Usage ------
*   import AssetLoader;
*	var pre:AssetLoader = new AssetLoader(["1.jpg","2.jpg","3.jpg"]);
*	pre.addEventListener("preloadProgress", onPreloadProgress);
*	pre.addEventListener("preloadComplete", onPreloadComplete);
*
*/

package com.capdig.loader
{
    import flash.display.Sprite;
    import flash.display.MovieClip;
    import flash.display.Loader;
    import flash.events.*;
    import flash.net.URLRequest;
  
    public class AssetLoader extends Sprite
    {
        // Event dispatcher
        public static const PRELOAD_COMPLETE:String = 'preload complete';
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
        public function AssetLoader(assetList:Array)
        {
            objectsArray = [];
            items = [];
            percentLoaded = 0;
            totalItems = 0;
            currentItem = 1;
            items = assetList;
            totalItems = items.length;
            
            // Load the first item
            _loadOne(currentItem - 1, items);
        }
        
        private function _loadOne(what:int, items:Array):void
        {
            // Create a new loader instance
            var loader:Loader = new Loader();
            // Configure listeners for loader debugging
            _configureListeners(loader.contentLoaderInfo);
            // Initiate the URLrequest
            var request:URLRequest = new URLRequest(items[what].toString());
            
            // Load the request data into the loader object
            try
            {
                loader.load (request);
            }
            catch (error:SecurityError)
            {
                trace ("SecurityError: "+error);
            }
        }
    
        // Configure listeners for loader debugging
        private function _configureListeners(dispatcher:IEventDispatcher):void
        {
            dispatcher.addEventListener(Event.COMPLETE, _completeHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, _httpStatusHandler);
            dispatcher.addEventListener(Event.INIT, _initHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler);
            dispatcher.addEventListener(Event.OPEN, _openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, _progressHandler);
        }
    
        private function _completeHandler(event:Event):void
        {
            //trace("completeHandler: " + event);
            
            // Add a loaded object to the objects array
            objectsArray.push(event.target.content);
            
            // increment the current item to be loaded
            currentItem += 1;
            
            // When all objects are loaded, call the parent class
            if (objectsArray.length == totalItems)
            {
                event.target.removeEventListener(ProgressEvent.PROGRESS, _progressHandler);
                event.target.removeEventListener(Event.COMPLETE, _completeHandler);
                dispatchEvent(new Event(AssetLoader.PRELOAD_COMPLETE));
            }
            else
            {
                // Load the next one
                _loadOne(currentItem - 1, items);
            }
        }
        
        // Adds objects from the asset loader array to the target container's display list
        public function _addToContainer(mc:MovieClip, o:Array)
        {
            for (var i:int=0; i<o.length; i++)
            {
                mc.addChild(o[i]);
            }
        }
        
        private function _httpStatusHandler(event:HTTPStatusEvent):void
        {
            //trace("httpStatusHandler: " + event);
        }
    
        private function _initHandler(event:Event):void
        {
            //trace("initHandler: " + event);
        }
        
        private function _ioErrorHandler(event:IOErrorEvent):void
        {
            //trace("ioErrorHandler: " + event);
        }
        
        private function _openHandler(event:Event):void
        {
            //trace("openHandler: " + event);
        }
    
        private function _progressHandler(event:ProgressEvent):void
        {
            //trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
            var temp:int = Math.ceil((((event.target.bytesLoaded / event.target.bytesTotal)*100 * currentItem) / totalItems));
            if (temp > percentLoaded)
            {
                // Avoid the precentage to drop
                percentLoaded = temp;
            }
            // Call the parent class with a progress update
            dispatchEvent (new ProgressEvent(ProgressEvent.PROGRESS));
        }
    
        // Property access
        public function get _loaded ():int
        {
            // Returns the loaded percentage of all files to be preloaded
            return percentLoaded;
        }
        
        public function get _objects ():Array
        {
            // Returns the loaded files as an array
            return objectsArray;
        }
    }
}
