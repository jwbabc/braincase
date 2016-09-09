import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.utils.*;
import nutrox.utils.BitmapBin;

// Create a test bitmap.
var bitmap:BitmapData = new BitmapData(200, 100, true, 0xA0000000);
bitmap.fillRect(new Rectangle(0, 0, 100, 100), 0xFFFFFFFF);

// Create a new BitmapBin object.
//
//  * The file name should not be any longer than 32 characters
//    including the file extension.
//
//  * The file extension needs to be one of the following:
//    GIF, JPG, PNG
//
//  * The file name is converted to lower-case.
//
// As the bitmap is semi-transparent the best
// image format to use is PNG
var bitmapBin:BitmapBin = new BitmapBin(bitmap, "my-image.png");

// Create the URLRequest object.
var url:URLRequest = new URLRequest("http://127.0.0.1/create-image.php");
url.method = "POST"; // required for ByteArray objects.
url.data = bitmapBin;

// Create the URLLoader object.
var loader:URLLoader = new URLLoader();
loader.addEventListener(Event.COMPLETE, completeHandler);
loader.load(url);

// Invoked when a result has been received from PHP.
function completeHandler( e:Event ):void
{
	trace(loader.data);
} 