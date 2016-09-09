package {
  import flash.display.Loader;
  import flash.display.Sprite;
  import flash.display.MovieClip;
  import flash.events.*;
  import flash.net.URLRequest;

  public class AssetLoader extends Sprite {
    private var _url:String;
    private var _mc:MovieClip;

    public function AssetLoader (target:MovieClip, filePath:String) {
      var _loader:Loader = new Loader();
      configureListeners(_loader.contentLoaderInfo);

      _url = filePath
      var _request:URLRequest = new URLRequest(_url);
      _loader.load(_request);
      
      _mc = target;
      _mc.addChild(_loader);
    }

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
