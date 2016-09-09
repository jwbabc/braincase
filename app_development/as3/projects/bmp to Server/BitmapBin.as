package
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	public class BitmapBin extends ByteArray
	{
  
  	public function BitmapBin( bitmap:BitmapData, filename:String ):void
  	{
  		while (filename.length < 32)
  		{
  			filename += " ";
      }
      var pix:ByteArray = bitmap.getPixels(bitmap.rect);
			writeShort(bitmap.width);
			writeShort(bitmap.height);
			writeShort(bitmap.transparent ? 1 : 0);
			writeUTFBytes(filename.toLowerCase());
			writeBytes(pix, 0, pix.bytesAvailable);
			compress();
		}
	}
} 