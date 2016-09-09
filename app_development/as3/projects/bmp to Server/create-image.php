<?php
error_reporting(0);
set_error_handler("throwError");

function throwError( $err, $str, $file, $line )
{
	header("content-type:text/plain");
	echo "Error: {$err}\n";
	echo "Status: {$str}\n";
	echo "Line: {$line}";
	exit;
}

$binary = gzuncompress(file_get_contents("php://input"));
$unpacked = unpack("nwidth/nheight/ntransparent/A32filename/N*bitmap", $binary);

$width = array_shift($unpacked);
$height = array_shift($unpacked);
$transparent = array_shift($unpacked) == 1;
$filename = array_shift($unpacked);
$extension = substr($filename, -3, 3);

if ($transparent)
{
	$image = imagecreatetruecolortransparent($width, $height);
	$background = imagecolorallocatealpha($image, 0, 0, 0, 127);
}
else
{
	$image = imagecreatetruecolor($width, $height);
	$background = imagecolorallocate($image, 0, 0, 0);
}
$y = $height;
while ($y--)
{
	$x = $width;
	while ($x--)
	{
		setPixel($image, $x, $y, array_pop($unpacked));
	}
}

if ($extension == "gif")
{
	imagegif($image, $filename);
}
else if ($extension == "jpg")
{
	imagejpeg($image, $filename, 100);
}
else if ($extension == "png")
{
	imagepng($image, $filename);
}
    
imagedestroy($image);
header("content-type:text/plain");
echo "OK";
exit;

function setPixel( $image, $x, $y, $dec ) {
  $a = ($dec >> 24) & 255;
  $r = ($dec >> 16) & 255;
  $g = ($dec >> 8) & 255;
  $b = $dec & 255;
  $c = imagecolorallocatealpha($image, $r, $g, $b, 127 - floor($a / 2));
	imagesetpixel($image, $x, $y, $c);
}

function imagecreatetruecolortransparent( $x, $y ) {
  $i = imagecreatetruecolor($x, $y);
  $b = imagecreatefromstring(base64_decode(blankpng()));
  imagealphablending($i, false);
  imagesavealpha($i, true);
  imagecopyresized($i, $b, 0, 0, 0, 0, $x, $y, imagesx($b), imagesy($b));
	return $i;
}

function blankpng()
{
	$c  = "iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29m";
	$c .= "dHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAADqSURBVHjaYvz//z/DYAYAAcTEMMgBQAANegcCBNCg";
	$c .= "dyBAAA16BwIE0KB3IEAADXoHAgTQoHcgQAANegcCBNCgdyBAAA16BwIE0KB3IEAADXoHAgTQoHcgQAAN";
	$c .= "egcCBNCgdyBAAA16BwIE0KB3IEAADXoHAgTQoHcgQAANegcCBNCgdyBAAA16BwIE0KB3IEAADXoHAgTQ";
	$c .= "oHcgQAANegcCBNCgdyBAAA16BwIE0KB3IEAADXoHAgTQoHcgQAANegcCBNCgdyBAAA16BwIE0KB3IEAA";
	$c .= "DXoHAgTQoHcgQAANegcCBNCgdyBAgAEAMpcDTTQWJVEAAAAASUVORK5CYII=";
	return $c;
}
?>