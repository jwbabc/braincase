// $Id$

/*
// Usage -
import PhotoStack;

var gallery:PhotoStack = new PhotoStack("xml/gallery.xml", galleryContainer_mc, gallery_txt);
addChild(gallery);
*/

package 
{
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.text.*;
	import flash.xml.*;

	import XMLLoader;
	import PreLoader;
	
	public class PhotoStack extends MovieClip
	{
		private var itemList:XML;
		private var stackXMLPath:String;
		private var stackXMLLoader:XMLLoader;
		private var stackContainer:MovieClip;
		private var stackTxtField:TextField
		private var pics_Array:Array = new Array();
		private var picStack_Array:Array = new Array();
		
		private var picStackCount:Number;
		private var stackIncrement:Number;
		private var itemDescription:String;
		
		private var total_duration:Number;
		private var in_start:Number;
		private var in_stop:Number;
		private var in_duration:Number;
		private var out_start:Number;
		private var out_stop:Number;
		private var out_duration:Number;
		private var in_Tween:Tween;
		private var out_Tween:Tween;
	
		public function PhotoStack (xmlPath:String, container:MovieClip, txtField:TextField):void
		{
			stackXMLPath = xmlPath;
			stackContainer = container;
			stackTxtField = txtField;
			stackIncrement = 0;
			
			stackXMLLoader = new XMLLoader(stackXMLPath);
			stackXMLLoader.addEventListener (Event.COMPLETE, makeItemList);
		}

		private function loadContent (mc:MovieClip, mcName:String, mcScale:Number,  myPath:String):void
		{
			var stackLoader:PreLoader = new PreLoader(mc, mcName, mcScale,  myPath);
		}
		
		// Add the item information into the array
		private function makeItemList (event:Event):void
		{
			itemList = stackXMLLoader.p_XML;
			for (var i:Number = 0; i<itemList.children().length(); i++)
			{
				var item:Object = new Object;
				item.image_src = itemList.children()[i].children()[0].@src;
				item.image_width = itemList.children()[i].children()[0].@width;
				item.image_height = itemList.children()[i].children()[0].@height;
				item.image_description = itemList.children()[i].children()[1];
				pics_Array[pics_Array.length] = item;
			}
			// Reverse the array to display properly in the stack
			pics_Array.reverse();
			makeStack (stackContainer);
		}

		// Construct the frame and outline of the photos
		private function drawOutline (container:MovieClip, img_width:Number, img_height:Number):void
		{
			var wallx:Number = img_width/2+10;
			var wally:Number = img_height/2+10;
			var offset:Number = 4;
			// Shadow
			container.graphics.beginFill (0x000000, .2);
			container.graphics.moveTo (-wallx+offset, -wally+offset);
			container.graphics.lineTo (wallx+offset, -wally+offset);
			container.graphics.lineTo (wallx+offset, wally+offset);
			container.graphics.lineTo (-wallx+offset, wally+offset);
			container.graphics.lineTo (-wallx+offset, -wally+offset);
			// Outline
			container.graphics.beginFill (0xFFFFFF, 1);
			container.graphics.lineStyle (2, 0x333333, 1);
			container.graphics.moveTo (-wallx, -wally);
			container.graphics.lineTo (wallx, -wally);
			container.graphics.lineTo (wallx, wally);
			container.graphics.lineTo (-wallx, wally);
			container.graphics.lineTo (-wallx, -wally);
			container.graphics.endFill ();
		}		

		// Create the image stack
		private function makeStack (container:MovieClip):void
		{	
			for (var p:Number=0; p<pics_Array.length; p++)
			{	
				var frameContainer:MovieClip = new MovieClip();
				var img:MovieClip = new MovieClip();
				var imagePath:String = pics_Array[p].image_src.toString();
		
				// Draw the frame
				drawOutline (frameContainer, pics_Array[p].image_width, pics_Array[p].image_height);
				frameContainer.name = "frame_mc";
				frameContainer.x = pics_Array[p].image_width/2;
				frameContainer.y = pics_Array[p].image_height/2;
		
				img.addChild(frameContainer);
				img.name = "image"+p;
				img.smoothing = false;
				img.rotation = (Math.random()*16)-8;
				picStack_Array[picStack_Array.length] = img;
		
				loadContent (img, "image_mc", 1, imagePath);
				container.addChild(img);
				container.buttonMode = true;
				container.addEventListener (MouseEvent.CLICK, moveStack, false, 0, true);
			}
			picStackCount = picStack_Array.length-1;
			updateDescription ();
		}

		private function moveStack (event:MouseEvent)
		{
			pullOut (picStack_Array[picStackCount]);
			
			picStackCount--;
			
			if (picStackCount < 0)
			{
				picStackCount = picStack_Array.length-1;
			}
		}
		
		private function updateDescription ():void
		{
			if (stackTxtField != null)
			{
				trace ("Textfield is present.");
				var str:String = stackContainer.getChildAt(stackContainer.numChildren-1).name.toString();
				trace (str);
				stackIncrement = Number(str.substr(5));
				itemDescription = pics_Array[stackIncrement].image_description;
				stackTxtField.text = itemDescription;
			}
		}
		
		// Pull the image out of the stack
		private function pullOut (pull_mc:MovieClip):void
		{
			total_duration = .5;
			out_start = pull_mc.x;
			out_stop = 500;
			out_duration = total_duration;
	
			out_Tween = new Tween(pull_mc, "x", Regular.easeInOut, out_start, out_stop, out_duration, true);
			out_Tween.addEventListener (TweenEvent.MOTION_FINISH, moveToBottom, false, 0, true);
			
			// Move the image to the bottom of the stack
			function moveToBottom (TweenEvent:Event)
			{	
				stackContainer.setChildIndex(pull_mc, 0);
				pushIn (pull_mc);
			}
		}

		// Once moved out, execute the easeIn tween
		private function pushIn (push_mc):void
		{
			in_start = push_mc.x;
			in_stop = 0;
			in_duration = total_duration;
				
			in_Tween = new Tween(push_mc, "x", Regular.easeInOut, in_start, in_stop, in_duration, true);
			updateDescription ();
		}
	}
}