import CameraCapture;
import JPGEncoder;
import fl.controls.Slider;
import fl.controls.SliderDirection;
import fl.events.SliderEvent;

var stepTitle:StepTitle = new StepTitle();
var postcardMask:Shape = new Shape();
var postcardCamera:CameraCapture = new CameraCapture(1, 0, 0);
var postcardCameraContainer:MovieClip = new MovieClip
var postcardContainer:CaptureContainer = new CaptureContainer();
var postcardCaptureBtn:CaptureBtn = new CaptureBtn();
var postcardSlider:Slider = new Slider();

// Position the title
stepTitle.mouseChildren = false;
stepTitle.buttonMode = true;
stepTitle.x = 10;
stepTitle.y = 10;

// Build mask
postcardMask.x = postcardContainer.x;
postcardMask.y = postcardContainer.y;
postcardMask.graphics.beginFill(0xFF0000);
postcardMask.graphics.drawRect(0, 0, postcardContainer.width, postcardContainer.height);

// Position the postcard container
postcardContainer.mouseChildren = false;
postcardContainer.buttonMode = true;
postcardContainer.x = 402;
postcardContainer.y = 90;

postcardCameraContainer.x = 160;
postcardCameraContainer.y = 120;

postcardCamera.x = -(postcardCamera.width/2);
postcardCamera.y = -(postcardCamera.height/2);

// Assign the mask
postcardCamera.mask = postcardMask;

// Place capture button from library
postcardCaptureBtn.mouseChildren = false;
postcardCaptureBtn.buttonMode = true;
postcardCaptureBtn.x = 32;
postcardCaptureBtn.y = 230;
postcardCaptureBtn.addEventListener(MouseEvent.MOUSE_DOWN, captureAndSend);

// Build the slider bar
postcardSlider.width = 320;
postcardSlider.direction = SliderDirection.HORIZONTAL;
postcardSlider.liveDragging = true;
postcardSlider.minimum = 1;
postcardSlider.maximum = 10;
postcardSlider.snapInterval = .125;
postcardSlider.value = 1;
postcardSlider.move(402, 350);
postcardSlider.addEventListener(SliderEvent.CHANGE, adjustZoom);

function adjustZoom (event:Event):void {
  postcardCamera.scaleX = postcardSlider.value;
  postcardCamera.scaleY = postcardSlider.value;
  
  postcardCamera.x = -(postcardCamera.width/2);
  postcardCamera.y = -(postcardCamera.height/2);
}

function captureAndSend (event:Event):void {
  trace ("capturing");
  
  // create bitmap data 
  var jpgSource: BitmapData = new BitmapData(320, 240, false, 0xffffff); 
  // make copy
  jpgSource.draw(postcardContainer);
  
  var jpgEncoder:JPGEncoder = new JPGEncoder(85);
  var jpgStream:ByteArray = jpgEncoder.encode(jpgSource);
  
  var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
  var jpgURLRequest:URLRequest = new URLRequest("kiosks/postcard/step-02?kiosk="+root.loaderInfo.parameters["kioskID"]);
  
  jpgURLRequest.requestHeaders.push(header);
  jpgURLRequest.method = URLRequestMethod.POST;
  jpgURLRequest.data = jpgStream;
  navigateToURL(jpgURLRequest, "_parent");
}

/*
// Debug - Text field displays passed values from PHP
var tf:TextField = new TextField();
tf.autoSize = TextFieldAutoSize.LEFT;
tf.border = true;
tf.appendText("params:");
addChild(tf);

// AS3  
// get all the parameters values  
if (root.loaderInfo.parameters["kioskID"] != null){
  var value:String = root.loaderInfo.parameters["kioskID"];  
  tf.appendText(value);
} 
*/

addChild(stepTitle);
addChild(postcardContainer);
postcardCameraContainer.addChild(postcardCamera);
postcardContainer.addChild(postcardCameraContainer);
postcardContainer.addChild(postcardMask);
addChild(postcardCaptureBtn);
addChild(postcardSlider);
