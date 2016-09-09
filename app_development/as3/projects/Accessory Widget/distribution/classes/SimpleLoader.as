// $Id$

/**
 * Asset Loader Class
 * A class used for loading assets (graphics) into movieclips
 *
 * ------ General Overview ------
 * The class recieves a target container and the path to the file
 * A loader is created, and configures its listeners
 * The loader object then assigns the file path to a URLRequest and
 * initiates the request.
 * 
 * Once completed, the loader data is sent to the target container.
 * 
 * @access public
 * @author Joel Back <jwbabc@comcast.net>
 * @version 1.0
 *
 * ------ Usage ------
 * import AssetLoader;
 * var myAssetLoader = new AssetLoader(myContainer, myFilePath);
 *
 */

package {
  import flash.display.Loader;
  import flash.display.Sprite;
  import flash.display.MovieClip;
  import flash.events.*;
  import flash.net.URLRequest;

  public class SimpleLoader extends Sprite {
    // The path to the asset
    private var url:String;
    // The target container
    private var mc:MovieClip;
    // The loader object
    private var loader:Loader;

    // AssetLoader constructor
    public function SimpleLoader (target:MovieClip, filePath:String) {
      // Create a new loader instance
      loader = new Loader();
      // Configure listeners for loader debugging
      configureListeners(loader.contentLoaderInfo);
      // Assign the file path to the url string
      url = filePath;
      // Assign the target container
      mc = target;
      // Initiate the URLrequest
      var request:URLRequest = new URLRequest(url);
      // Load the request data into the loader object
      // Load the request data into the loader object
      try {
        loader.load (request);
      } catch (error:SecurityError) {
        trace ("SecurityError: "+error);
      }
      // Place the loader object in the target container's display list
      mc.addChild(loader);
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
    }
  }
}
