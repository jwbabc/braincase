// $Id$

/*
Usage:

var myCamera:CameraCapture = new CameraCapture(160, 120, 1, 0, 0);
addChild(myCamera);
*/

package
{
	import flash.display.*;
  import flash.events.*;
  import flash.media.Camera;
  import flash.media.Video;

	public class CameraCapture extends Sprite
	{
		private var camera:Camera;
		private var video:Video;
		private var videoContainer:MovieClip;
		private var bmpDataArray:Array;
		private var bmpDataObject:BitmapData;
		private var bmp:Bitmap;
		
		public function CameraCapture(vidWidth:Number, vidHeight:Number, vidScale:Number, vidContainer_x:Number, vidContainer_y:Number):void
		{
			// Init the camera object
			camera = Camera.getCamera();
			// Check to see if the Flash player believes that a camera is attached
			if(camera != null)
			{
				// Init the video window
				video = new Video(vidWidth, vidHeight);
				video.attachCamera(camera);
				video.scaleX = vidScale;
				video.scaleY = vidScale;
				video.smoothing = true;
				// Create the video container
				videoContainer = new MovieClip();
				videoContainer.x = vidContainer_x;
				videoContainer.y = vidContainer_y;
				videoContainer.addChild(video);
				addChild(videoContainer);
				// Create the bitmap data array
				bmpDataArray = new Array();
			}
			else
			{
				trace ("Camera is not enabled.");
			}
		}
		
		public function grabVideoData (bmpScale:Number, bmp_x:Number, bmp_y:Number, container):void
		{
			bmpDataObject = new BitmapData (video.width, video.height);
			bmpDataObject.draw (video);
			// Add the data to the top of the array stack
			bmpDataArray.unshift(bmpDataObject);
			// Add new bmp to container
			bmp = new Bitmap(bmpDataArray[0]);
			bmp.scaleX = bmpScale;
			bmp.scaleY = bmpScale;
			bmp.smoothing = true;
			bmp.x = bmp_x;
			bmp.y = bmp_y;
			container.addChild(bmp);
		}
	}
}
