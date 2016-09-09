package {

  import flash.display.MovieClip;
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.IEventDispatcher;
  import flash.events.IOErrorEvent;
  import flash.printing.PrintJob;
  
  public class PrintController extends EventDispatcher {
    
    private var _printJob:PrintJob;
    private var _result:Boolean;
    private var _page:MovieClip;
    
    public function PrintController():void {
      _printJob = new PrintJob();
    }
    
    public function printPage (container:MovieClip):void {
      try {
        _page = container;
        _result = _printJob.start();
        
        if (_result) {
          _printJob.addPage (_page);
          _printJob.send ();
        }
        
      } catch (e:Error) {
        trace("User does not have a printer connected, or user canceled the print action "+e);
      }
    }
  }
}