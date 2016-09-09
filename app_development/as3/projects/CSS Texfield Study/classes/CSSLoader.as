// $Id$

/*
Usage:
var myCSSLoader:CSSLoader = new CSSLoader("/css/mycssfile.css");
*/

package {
  import flash.display.Sprite;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  import flash.text.StyleSheet;
  import flash.text.TextField;
  import flash.text.TextFieldAutoSize;
  import flash.events.IOErrorEvent;
  import flash.events.Event;
  
  public class CSSLoader {
    private var loader:URLLoader = new URLLoader();
    private var styles:StyleSheet = new StyleSheet();
    
    public function CSSLoader (cssPath:String) {
      var req:URLRequest = new URLRequest(cssPath);
      loader.load(req);
      loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
      loader.addEventListener(Event.COMPLETE, CSSLoader_Complete);
    }
    
    public function errorHandler(e:IOErrorEvent):void {
      trace("Couldn't load the style sheet file. "+e);
    }
    
    public function CSSLoader_Complete(event:Event):void {
      styles.parseCSS(loader.data);
    }
    
    public function get p_styles():StyleSheet {
      return styles;
    }
  }
}