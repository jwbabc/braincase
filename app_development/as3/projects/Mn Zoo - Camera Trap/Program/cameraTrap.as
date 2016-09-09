import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.ColorTransform;
import fl.transitions.*;
import fl.transitions.easing.*;

// Init the camera object
var camera:Camera = Camera.getCamera();

// hContainer array
var hContainerArray:Array = new Array();
hContainerArray[0] = hStrip_mc.history1;
hContainerArray[1] = hStrip_mc.history2;
hContainerArray[2] = hStrip_mc.history3;
hContainerArray[3] = hStrip_mc.history4;
hContainerArray[4] = hStrip_mc.history5;
hContainerArray[5] = hStrip_mc.history6;
// aContainer array
var aContainerArray:Array = new Array();
aContainerArray[0] = aStrip_mc.animal1;
aContainerArray[1] = aStrip_mc.animal2;
aContainerArray[2] = aStrip_mc.animal3;
aContainerArray[3] = aStrip_mc.animal4;
aContainerArray[4] = aStrip_mc.animal5;
aContainerArray[5] = aStrip_mc.animal6;
// current animal bitmap array
var currentAnimalBmpArray:Array = new Array();
currentAnimalBmpArray[0] = "animal1.jpg";
currentAnimalBmpArray[1] = "animal2.jpg";
currentAnimalBmpArray[2] = "animal3.jpg";
currentAnimalBmpArray[3] = "animal4.jpg";
currentAnimalBmpArray[4] = "animal5.jpg";
currentAnimalBmpArray[5] = "animal6.jpg";
// animal bitmap array
var animalBmpArray:Array = new Array();
animalBmpArray[0] = "animal1.jpg";
animalBmpArray[1] = "animal2.jpg";
animalBmpArray[2] = "animal3.jpg";
animalBmpArray[3] = "animal4.jpg";
animalBmpArray[4] = "animal5.jpg";
animalBmpArray[5] = "animal6.jpg";
animalBmpArray[6] = "animal7.jpg";
animalBmpArray[7] = "animal8.jpg";
animalBmpArray[8] = "animal9.jpg";
animalBmpArray[9] = "animal10.jpg";
animalBmpArray[10] = "animal11.jpg";
animalBmpArray[11] = "animal12.jpg";
animalBmpArray[12] = "animal13.jpg";
animalBmpArray[13] = "animal14.jpg";
animalBmpArray[14] = "animal15.jpg";
animalBmpArray[15] = "animal16.jpg";
animalBmpArray[16] = "animal17.jpg";
animalBmpArray[17] = "animal18.jpg";
animalBmpArray[18] = "animal19.jpg";
// Increment for animal container
var aContainerIncrement:Number = 0;
// Increment for current animal container
var currentAnimalBmpArrayIncrement:Number = 0;
// Increment for animal image
var animalBmpIncrement:Number = 5;
// Bitmap data array
var bmpDataArray:Array = new Array();
// Number of history containers
var maxImages:Number = hContainerArray.length;

function addTransition (mc:MovieClip):void
{
	gotoAndPlay("film");
	TransitionManager.start (mc, {type:Photo, direction:Transition.IN, duration:1, easing:None.easeNone});
}

// External media loader function

function loadImage (img:String, mc:MovieClip, scale:Number):void
{
	var loader:Loader = new Loader();
	var url:String = img;
	var urlReq:URLRequest = new URLRequest(url);
	loader.load (urlReq);
  loader.scaleX = scale;
  loader.scaleY = scale;
	mc.addChild (loader);
}

// Grab video data
function grabVideoData (event:KeyboardEvent) :void
{
	var bmpDataObject:BitmapData = new BitmapData (640, 480);
	bmpDataObject.draw (video);
	// Add the data to the top of the array stack
	bmpDataArray.unshift(bmpDataObject);
	updateBitmapData();
}

function updateBitmapData ():void
{	
	// Position the containers for the tween
	for (var i:Number = 0; i < hContainerArray.length; i++)
	{
		// Clean up bitmap array
		if(bmpDataArray.length > maxImages)
		{
			// Remove the data at the bottom of the stack
			bmpDataArray.pop().dispose();
		}
		// and containers
		if (hContainerArray[i].numChildren > maxImages)
		{
			var bmpChild:Number = hContainerArray[i].numChildren;
			while (bmpChild--)
			{
				hContainerArray[i].removeChildAt(bmpChild);
			}
		}
		// Add new bmp to container
		var bmp:Bitmap = new Bitmap(bmpDataArray[i]);
		bmp.scaleX = .37;
		bmp.scaleY = .37;
		bmp.smoothing = true;
		hContainerArray[i].addChild(bmp);
	}
	// Update the animal bitmaps after every photo is taken
	updateAnimalBitmaps();
	
}

function updateAnimalBitmaps () :void
{
	// Reset the container variables
	aContainerIncrement = 0;
	currentAnimalBmpArrayIncrement = 0;
	
	if (animalBmpIncrement >= animalBmpArray.length)
	{
		animalBmpIncrement = 0;
	}
	// Place the new animal image at the beginning of the array
	currentAnimalBmpArray.unshift(animalBmpArray[animalBmpIncrement]);
	// Remove the last item in the array
	currentAnimalBmpArray.pop();
	
	// Update the animal containers with the images from the current array
	for (var i:Number = 0; i < aContainerArray.length; i++)
	{
		// and containers
		aContainerArray[aContainerIncrement].removeChildAt(0);
		loadImage ("animals/"+currentAnimalBmpArray[currentAnimalBmpArrayIncrement], aContainerArray[aContainerIncrement], .37);
		aContainerIncrement++;
		currentAnimalBmpArrayIncrement++;
	}
	// Increment for the next animal photo
	animalBmpIncrement++;
	// Add the transition to the first animal container
	addTransition(aContainerArray[0]);
}
        
// Check to see if the Flash player believes that a camera is attached
if(camera != null)
{
	var video = new Video(640, 480);
	video.attachCamera(camera);
	video.scaleX = .37;
	video.scaleY = .37;
	video.smoothing = true;
	video_mc.addChild(video);
	loadImage ("initial_captures/capture000.jpg", hContainerArray[0], .37);
	loadImage ("initial_captures/capture001.jpg", hContainerArray[1], .37);
	loadImage ("initial_captures/capture002.jpg", hContainerArray[2], .37);
	loadImage ("initial_captures/capture000.jpg", hContainerArray[3], .37);
	loadImage ("initial_captures/capture001.jpg", hContainerArray[4], .37);
	loadImage ("initial_captures/capture002.jpg", hContainerArray[5], .37);
	loadImage ("animals/"+animalBmpArray[0], aContainerArray[0], .37);
	loadImage ("animals/"+animalBmpArray[1], aContainerArray[1], .37);
	loadImage ("animals/"+animalBmpArray[2], aContainerArray[2], .37);
	loadImage ("animals/"+animalBmpArray[3], aContainerArray[3], .37);
	loadImage ("animals/"+animalBmpArray[4], aContainerArray[4], .37);
	loadImage ("animals/"+animalBmpArray[5], aContainerArray[5], .37);
	stage.addEventListener(KeyboardEvent.KEY_DOWN, grabVideoData, false, 0, true);
}
