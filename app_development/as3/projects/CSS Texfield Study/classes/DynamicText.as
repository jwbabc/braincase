package {
  
  import flash.display.*;
  import flash.text.*;
  import flash.utils.*;
  import flash.events.*;
  import XMLLoader;
  import CSSLoader;
  
  public class DynamicText extends MovieClip {
    // Define the font class
    private var RegularItalicFontClass:Class;
    private var RegularItalicFontClass_fnt:Font;
    // Define the sytlesheet and styles
    private var myCSSLoader:CSSLoader;
    private var myCSSStyleSheet:StyleSheet;
    // Textfield
    private var prototypeText:TextField = new TextField();
    // XML variables
    private var xmlLoader:XMLLoader;
    private var xmlPath:String = "xml/test_string.xml";
    private var xmlString:String;
    
    public function DynamicText ():void {
      loadXMLString();
    }
    
    public function loadXMLString ():void {
      xmlLoader = new XMLLoader(xmlPath);
      xmlLoader.addEventListener (Event.COMPLETE, loadXMLString_Complete);
    }
    
    public function loadXMLString_Complete (event:Event):void {
      xmlString = xmlLoader.p_XML.title;
      addCSS();
      addTextField(xmlString);
    }
    
    public function addCSS ():void {
      myCSSLoader = new CSSLoader("css/dynamic_text.css");
      myCSSStyleSheet = myCSSLoader.p_styles;
    }
    
    public function addTextField (xmlFeed:String):void {
      var ti:TextField = new TextField();
      ti.x = 150;     
      ti.y = 150;
      ti.width = 300;
      ti.autoSize = TextFieldAutoSize.LEFT;
      ti.wordWrap = true;
      ti.multiline = true;
      ti.selectable = false;
      ti.styleSheet = myCSSStyleSheet;
      ti.htmlText = xmlFeed;
      addChild(ti);
    }
  }
}
