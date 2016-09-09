package {

  import flash.display.MovieClip;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  import flash.events.*;
  import flash.text.TextField;
  import flash.text.TextFormat;

  public class CustomKeyboard extends MovieClip {

    static var keyData:XML = new XML;
    static var myKey:KeyButton = new KeyButton;
    static var keyHolder:MovieClip = new MovieClip;
    static var textScreen:TextField = new TextField;
    static var shift:Boolean = false;
    static var caps:Boolean = false;

    public function CustomKeyboard() {
      loadKeyboardinfo();
      setupKeyHolder();
    }
    static public function capsToggle():void {
      if (caps) {
        caps = false;
      } else {
        caps = true;
      }
    }
    static public function shiftToggle():void {
      if (shift) {
        shift = false;
      } else {
        shift = true;
      }
      if(caps){
        caps = false;
      }
    }
    public function buildTextScreen(target_mc:MovieClip):void {
      textScreen.width = 200;
      textScreen.height = 20;
      textScreen.x = 50;
      textScreen.y = 50;
      textScreen.text = "";
      textScreen.wordWrap = true;
      textScreen.selectable = false;
      textScreen.border = true;
      textScreen.background = true;
      target_mc.addChild(textScreen);
    }
    private function loadKeyboardinfo():void {
      var xmlLoader:URLLoader = new URLLoader;
      var xmlRequester:URLRequest = new URLRequest("assets/xml/keys.xml");
      xmlLoader.addEventListener(Event.COMPLETE,xmlLoaded);
      xmlLoader.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
      xmlLoader.load(xmlRequester);
    }
    private function ioErrorHandler(event:IOErrorEvent):void {
      trace("ioErrorHandler: " + event);
    }
    private function xmlLoaded(event:Event):void {
      var loader:URLLoader=URLLoader(event.target);
      keyData = new XML(loader.data);
      //trace(keyData);
      buildKeyboard();
    }
    private function setupKeyHolder():void {
      addChild(keyHolder);
    }
    private function buildKeyboard():void {
      var numKeys:Number = getNumberOfKeys();
      var xPlacement:Number = 0;
      for (var i = 0; i < keyData.row.length(); i++) {
        for (var j = 0; j < keyData.row[i].key.length(); j++) {
          var newKey:KeyButton = new KeyButton;
          newKey.code = keyData.row[i].key[j].code;
          newKey.char = keyData.row[i].key[j].char;
          newKey.shiftChar = keyData.row[i].key[j].shiftChar;
          newKey.keyWidth = checkWidth(keyData.row[i].key[j].char);
          newKey.x = xPlacement + 5;
          newKey.y = (newKey.keyHeight + 5) * i;
          newKey.build();
          xPlacement += newKey.keyWidth + 5;
          keyHolder.addChild(newKey);
        }
        xPlacement = 0;
      }
    }
    private function checkWidth(code:String):Number {
      var mediumKeys:Array = new Array('Tab','Enter','Backspace','Caps Lock');
      var shiftKey:String = "Shift";
      var spaceKey:String = "Space Bar";
      for (var m = 0; m < mediumKeys.length; m++) {
        if (code == mediumKeys[m]) {
          return 75;
        }
      }
      if (code == shiftKey) {
        return 95;
      }
      if (code == spaceKey) {
        return keyHolder.width;
      }
      return 35;
    }
    private function getNumberOfKeys():Number {
      var keyCounter:Number = 0;
      for (var i = 0; i < keyData.row.length(); i++) {
        keyCounter += keyData.row[i].key.length();
      }
      return keyCounter;
    }
  }
}