package com.capdig.loader
{
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.events.*;
    
    public class BaseLoader extends EventDispatcher
    {
        private var loader:URLLoader;
        private var percentLoaded:int = 0;
        
        public function BaseLoader ():void
        {
            // Create a new loader instance
            loader = new URLLoader();
        }
        
        public function _loadAsset (dataPath:String):void
        {
            // Assign the file path to the URLrequest
            var request:URLRequest = new URLRequest(dataPath);
            
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
        
        public function _progressHandler(event:ProgressEvent):void
        {
            //trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
            var temp:int = Math.ceil((event.target.bytesLoaded / event.target.bytesTotal)*100);
            // Avoid the precentage to drop
            if (temp > percentLoaded)
            {
                percentLoaded = temp;		
            }
            dispatchEvent (new ProgressEvent(ProgressEvent.PROGRESS));
        }
        
        public function _httpStatusHandler(event:HTTPStatusEvent):void
        {
            //trace("BaseLoader httpStatusHandler: " + event);
        }
        
        public function _id3Handler(e:Event):void
        {
            //trace("id3Handler: " + e);
        }
        
        public function _initHandler(event:Event):void
        {
            //trace("BaseLoader initHandler: " + event);
        }
        
        public function _ioErrorHandler(event:IOErrorEvent):void
        {
            //trace("BaseLoader ioErrorHandler: " + event);
        }
        
        public function _openHandler(event:Event):void
        {
            //trace("BaseLoader openHandler: " + event);
        }
        
        // Property access
        public function get _loader ():URLLoader
        {
            return loader;
        }
        
        public function get _loaded ():int
        {
            return percentLoaded;
        }
    }
}