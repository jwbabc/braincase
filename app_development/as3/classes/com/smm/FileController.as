package {

  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.IEventDispatcher;
  import flash.events.IOErrorEvent;
  import flash.events.ProgressEvent;
  import flash.events.OutputProgressEvent;
  import flash.filesystem.*;
  import flash.utils.ByteArray;
  
  public class FileController extends EventDispatcher {
  
    private var _source:File;
    private var _targetParent:File;
    private var _target:File;
    private var _fs:FileStream;
    
    public function FileController() {
      _fs = new FileStream();
      configureListeners(_fs);
    }
    
    public function save (data:ByteArray, fileName:String):void {
      try {
        _target = File.documentsDirectory.resolvePath(fileName);
        _fs.open(_target, FileMode.WRITE);
        _fs.writeBytes(data);
      } catch (error:Error) {
        trace("Failed to save file "+error);
      }
    }
    
    public function move (fileName:String, targetDirectory:String):void {
      try {
        _source = File.desktopDirectory.resolvePath(fileName);
        _target = File.documentsDirectory.resolvePath(targetDirectory+fileName);
        _targetParent = _target.parent;
        _targetParent.createDirectory();
        _source.moveTo(_target, true);
      } catch (e:Error) {
        trace("Failed to copy file "+e);
      }
    }
    
    private function configureListeners(dispatcher:IEventDispatcher):void {
      dispatcher.addEventListener(Event.OPEN, openHandler);
      dispatcher.addEventListener(Event.CLOSE, closeHandler);
      dispatcher.addEventListener(Event.COMPLETE, completeHandler);
      dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
      dispatcher.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, progressHandler);
    }
    
    private function openHandler(e:Event):void {
      trace("openHandler: " + e);
    }
    
    private function closeHandler(e:Event):void {
      trace("closeHandler: " + e);
    }
    
    private function completeHandler(e:Event):void {
      trace("completeHandler: " + e);
    }
        
    private function ioErrorHandler(e:IOErrorEvent):void {
      trace("ioErrorHandler: " + e);
    }
    
    private function progressHandler(e:ProgressEvent):void {
      trace("progressHandler: bytesLoaded=" + e.bytesLoaded + " bytesTotal=" + e.bytesTotal);
    }
  }
}
