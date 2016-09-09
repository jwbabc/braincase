/*
ScrollBar Class provided by Valentino Tombesi at http://www.fuoridalcerchio.net
XML capability provided by SimplicIT at http://lab.simplicit.co.za
*/

package
{
	import flash.display.*;
	import flash.events.Event;
	import flash.text.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class scrollMain extends Sprite {
		
		public function scrollMain()
		{
			//Load ScrollBar functionality
			import Scrollbar;
			var sc:Scrollbar = new Scrollbar(scrollMC, maskMC, scrollbarMC.ruler, scrollbarMC.background, Area, /*true,*/ 6); 
			function scInit(e:Event):void
			{
				sc.init();
			}
			sc.addEventListener(Event.ADDED, scInit); 
			addChild(sc); 
			
			//Load XML
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, xmlLoaded);
			var request:URLRequest = new URLRequest("scrollcontent.xml");
			loader.load(request);
			function xmlLoaded(event:Event):void
			{
   			var myXML:XML = new XML(loader.data);
   			headerTxt.htmlText = myXML.sectiontitle;
   			scrollTxt.htmlText = myXML.sectioncontent;
			}
			
			//Create textfields
			var headerTxt:TextField = new TextField();
			headingMC.addChild(headerTxt);
			var scrollTxt:TextField = new TextField();
			scrollMC.addChild(scrollTxt);
			
			//Set textfield width
			scrollTxt.width = 300;

			//Tell the textfields to expand to fit the inserted text
			scrollTxt.autoSize = "left";
			headerTxt.autoSize = "left";
			
			//Do not place a border around the text. Set to "true" for a  border
			scrollTxt.border = false;
			headerTxt.border = false;
			
			//Set the required textfields as multiline
			scrollTxt.multiline = true;
			headerTxt.multiline = false;
			
			//Set the multiline textfield content to wrap
			scrollTxt.wordWrap = true;
			headerTxt.wordWrap = false;
		} // End Public Function
	} // End Public Class
} // End Package