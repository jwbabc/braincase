// $Id$/** * XML Loader Class * A class used for establishing communication with javascript within an html document * * ------ General Overview ------ * The class recieves a path to an XML file * A loader is created, and configures its listeners * The loader object then assigns the file path to a URLRequest and * initiates the request. *  * Once completed, the loader data is placed in the styles property. * it then dispatches an Event.COMPLETE to the event que *  * @access public * @author Joel Back <jwbabc@comcast.net> * @version 1.0 * * ------ Usage ------ * import XMLLoader; *  * var xmlObject:XML; // If you want it global *  * function loadXML(XMLFilename:String, xmlObject:XML) :void { *   var XMLPath:String = "xml/"; *   var myXMLLoader:XMLLoader = new XMLLoader(XMLPath + XMLFilename); *   myXMLLoader.addEventListener (Event.COMPLETE, makeXMLObject); * *   function makeXMLObject (event:Event):void { *    xmlObject = myXMLLoader.p_XML; *    trace (xmlObject); *    numChildren = xmlObject.child("*").length(); *   } * } * */package {  import flash.net.URLLoader;  import flash.net.URLRequest;  import flash.xml.*;  import flash.events.*;  public class XMLLoader extends EventDispatcher {    // The XML object for the XML feed    private var importedXML:XML;    // The loader object    private var loader:URLLoader;    // The XML percent loaded    private var percentLoaded:int = 0;    public function XMLLoader (dataPath:String) {      // Create a new loader instance      loader = new URLLoader();      // Configure listeners for loader debugging      configureListeners(loader);      // Assign the file path to the URLrequest      var request:URLRequest = new URLRequest(dataPath);      // Load the request data into the loader object      try {        loader.load (request);      } catch (error:SecurityError) {        trace ("SecurityError: "+error);      }    }    // Configure listeners for loader debugging    private function configureListeners(dispatcher:IEventDispatcher):void {      dispatcher.addEventListener(Event.COMPLETE, completeHandler);      dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);      dispatcher.addEventListener(Event.INIT, initHandler);      dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);      dispatcher.addEventListener(Event.OPEN, openHandler);      dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);    }        private function completeHandler(event:Event):void {      //trace("completeHandler: " + event);      try {        importedXML = new XML(loader.data);        dispatchEvent (new Event(Event.COMPLETE));      } catch (error:TypeError) {        trace ("XML parsing error:"+error);      }    }        private function httpStatusHandler(event:HTTPStatusEvent):void {      //trace("httpStatusHandler: " + event);    }        private function initHandler(event:Event):void {      //trace("initHandler: " + event);    }        private function ioErrorHandler(event:IOErrorEvent):void {      //trace("ioErrorHandler: " + event);    }        private function openHandler(event:Event):void {      //trace("openHandler: " + event);    }        private function progressHandler(event:ProgressEvent):void {      //trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);      var temp:int = Math.ceil((event.target.bytesLoaded / event.target.bytesTotal)*100);			// Avoid the precentage to drop			if (temp > percentLoaded) {				percentLoaded = temp;					}    }        // Property access    public function get p_XML ():XML {      return importedXML;    }        public function get p_Loaded ():int {      return percentLoaded;    }  }}