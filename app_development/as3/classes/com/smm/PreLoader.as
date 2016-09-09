// $Id$

package 
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.text.*;
	
	public class PreLoader extends EventDispatcher
	{
		private var loader:Loader = new Loader();
		private var loadProgress_txt:TextField = new TextField();
		private var loadProgress_fmt:TextFormat = new TextFormat();	
		private var mc:MovieClip;
		private var mcName:String;
		private var mcScale:Number;
		private var mcMask:MovieClip;
		
		public function PreLoader (myContainer:MovieClip, myName:String, myScale:Number, myPath:String)
		{
			mc = myContainer;
			mcName = myName;
			mcScale = myScale;
			var request:URLRequest = new URLRequest(myPath);
			
			try
			{
				loader.load (request);
			}
			catch (error:SecurityError)
			{
				trace ("SecurityError: A SecurityError has occurred.");
			}		
			
			configureListeners (loader.contentLoaderInfo);
		}
		
		private function configureListeners (dispatcher:IEventDispatcher):void
		{
			dispatcher.addEventListener (Event.INIT, initHandler);
			dispatcher.addEventListener (Event.OPEN, showPreloader);
			dispatcher.addEventListener (ProgressEvent.PROGRESS, showProgress);
			dispatcher.addEventListener (Event.COMPLETE, showLoadResult);
			dispatcher.addEventListener (HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.addEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);			
			dispatcher.addEventListener (Event.UNLOAD, unLoadHandler);
		}
		
		private function listDisplayItems (container:MovieClip)
		{
			var list:Array = new Array();
			for (var i:Number = 0; i < container.numChildren; i++)
			{
				list[i] = (container.getChildAt(i).name);
			}
			return list;
		}		     

		private function showPreloader(event:Event):void
		{
			//trace ("showPreloader: " + event);
			// Configure textFormat
			loadProgress_fmt.font = "Arno Pro";
			loadProgress_fmt.color = 0x000000;
			loadProgress_fmt.size = 18;

			loadProgress_txt.embedFonts = true;
			loadProgress_txt.background = false;
      loadProgress_txt.border = false;
      loadProgress_txt.multiline = true;
      loadProgress_txt.wordWrap = true;
      loadProgress_txt.selectable = false;
      loadProgress_txt.width = 250;
      loadProgress_txt.height = 120;
      loadProgress_txt.defaultTextFormat = loadProgress_fmt;
      
      mc.addChild(loadProgress_txt);
		}

		private function showProgress(event:ProgressEvent):void
		{
			//trace ("showProgress: " + event);
			loadProgress_txt.text = "loaded:"+event.bytesLoaded+" from "+event.bytesTotal;
		}

		private function showLoadResult(event:Event):void
		{
			try
			{
				//trace ("showLoadResult: " + event);
				// Remove the textfield
				mc.removeChild(loadProgress_txt);
				loader.scaleX = mcScale;
				loader.scaleY = mcScale;
				loader.name = mcName;
				mc.addChild(loader);
			
				// List movie clips inside the container
				var mcItems:Array = new Array();
				mcItems = listDisplayItems(mc);
				trace ("mcItems of "+mc.name+": "+mcItems);
		
				dispatchEvent (new Event(Event.COMPLETE));
			}
			catch (e:TypeError)
			{
				trace ("Could not load the external file.");
			}
		}
		
		private function initHandler (event:Event):void
		{
			//trace ("initHandler: " + event);
		}

		private function httpStatusHandler (event:HTTPStatusEvent):void
		{
			//trace ("httpStatusHandler: " + event);
		}

		private function ioErrorHandler (event:IOErrorEvent):void
		{
			//trace ("ioErrorHandler: " + event);
		}

		private function unLoadHandler (event:Event):void
		{
			//trace ("unLoadHandler: " + event);
		}
		
		public function get p_PreLoader_contentLoaderInfo ()
		{
			return loader.contentLoaderInfo;
		} 
	}
}