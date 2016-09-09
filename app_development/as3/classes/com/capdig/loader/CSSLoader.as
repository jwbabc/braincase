package com.capdig.loader
{
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.xml.*;
    import flash.events.*;
    import com.capdig.loader.BaseLoader;
  
    public class CSSLoader extends BaseLoader
    {
        private var styles:StyleSheet;
    
        public function CSSLoader (cssPath:String)
        {
            trace ('CSSLoader loaded');
            
            // Configure listeners for loader debugging
            _configureListeners(_loader);
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
            trace("CSSLoader completeHandler: " + event);
            
            try
            {
                // Parse the CSS data into the StyleSheet object
                styles:StyleSheet = new StyleSheet();
                styles.parseCSS(loader.data);
                // Dispatch the Event.COMPLETE event to the event dispatcher
                dispatchEvent (new Event(Event.COMPLETE));
            } 
            catch (error:TypeError)
            {
                trace ("CSS parsing error:" + error);
            }
        }
    
        // Access to properties
        public function get _styles():StyleSheet
        {
            return styles;
        }
    }
}