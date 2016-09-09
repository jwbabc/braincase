import com.adobe.images.JPGEncoder;

// Create the ByteArray
var jpgSource:BitmapData = new BitmapData (sketch_mc.width, sketch_mc.height);
jpgSource.draw(sketch_mc);

var jpgEncoder:JPGEncoder = new JPGEncoder(85);
var jpgStream:ByteArray = jpgEncoder.encode(jpgSource);

// Write the file to the hard drive
// set a filename
var filename:String = "cool-image.jpg";

// get current path
var file:File = File.applicationDirectory.resolvePath( filename );

// get the native path
var wr:File = new File( file.nativePath );

// create filestream
var stream:FileStream = new FileStream();

//  open/create the file, set the filemode to write in order to save.
stream.open( wr , FileMode.WRITE);

// write your byteArray into the file.
stream.writeBytes ( byteArray, 0, byteArray.length );

// close the file.
stream.close();

// That’s it.
