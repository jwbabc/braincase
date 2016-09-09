// $Id$

/**
 * CSS Loader Class
 * A class used for loading assets (graphics) into movieclips
 *
 * ------ General Overview ------
 * The class recieves a path to the CSS file
 * A loader is created, and configures its listeners
 * The loader object then assigns the file path to a URLRequest and
 * initiates the request.
 * 
 * Once completed, the loader data is placed in the styles property.
 * It then dispatches an Event.COMPLETE to the event dispatcher
 * 
 * @access public
 * @author Joel Back <jwbabc@comcast.net>
 * @version 1.0
 *
 * ------ Usage ------
 * import CSSLoader;
 * var myCSSLoader:CSSLoader = new CSSLoader("/css/mycssfile.css");
 *
 */

package {
  import flash.display.Sprite;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  import flash.text.StyleSheet;
  import flash.text.TextField;
  import flash.text.TextFieldAutoSize;
  import flash.events.*;
  
  // CSSLoader constructor
  public class CSSLoader extends EventDispatcher {
    // The loader object
    private var loader:URLLoader = new URLLoader();
    // The StyleSheet object
    private var styles:StyleSheet = new StyleSheet();
    // The XML percent loaded
    private var percentLoaded:int = 0;
    
    public function CSSLoader (cssPath:String) {
      // Configure listeners for loader debugging
      configureListeners(loader);
      // Initiate the URLrequest
      var request:URLRequest = new URLRequest(cssPath);
      // Load the request data into the loader object
      try {
        loader.load (request);
      } catch (error:TypeError) {
        trace ("CSS parsing error: "+error);
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
      try {
        // Parse the CSS data into the StyleSheet object
        styles.parseCSS(loader.data);
        // Dispatch the Event.COMPLETE event to the event dispatcher
        dispatchEvent (new Event(Event.COMPLETE));
      } catch (error:TypeError) {
        trace ("CSS parsing error:" + error);
      }
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
      var temp:int = Math.ceil((event.target.bytesLoaded / event.target.bytesTotal)*100);
			// Avoid the precentage to drop
			if (temp > percentLoaded) {
				percentLoaded = temp;		
			}
    }
    
    // Access to properties
    public function get p_styles():StyleSheet {
      return styles;
    }
    
    public function get p_Loaded ():int {
      return percentLoaded;
    }
  }
}