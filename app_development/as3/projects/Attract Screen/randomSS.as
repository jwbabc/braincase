//Screensaver core code
//Variables for screensaver
var delay:Number = 180 * 1000;
var start_time:Number = getTimer();
var myMouse:Object = new Object();
//Variables for place_me
var logo_x:Number = 0;
var logo_y:Number = 0;

//Adds the mouse listener
myMouse.onMouseMove = function() {
	if (_root._currentframe <> 8) {
		trace("reset!");
		start_time = getTimer();
	}
	if (_root._currentframe == 8) {
		trace("coming home!");
		gotoAndPlay("Core", "load");
	}
};
Mouse.addListener(myMouse);

//Places logo onto stage at random location within limits.
//logo x and y are used to calculate and plot the position before actually
//plotting the x and y of the movie clip. Kinda kooky I know.
place_me = function() {
	_root.logo_x = random(Stage.width);
	_root.logo_y = random(Stage.height);
	//Offset the left side for the width of the logo
	if (_root.logo_x<_root.logo1._x) {
		_root.logo_x = _root.logo1._x;
	}
	//Offest the right side for the width of the logo
	if (_root.logo_x>(Stage.width-(_root.logo1._x-_root.logo1._width))) {
		_root.logo_x = (Stage.width-(_root.logo1._x-_root.logo1._width));
	}
	//Offset the top of the logo
	if (_root.logo_y<_root.logo1._y) {
		_root.logo_y = _root.logo1._y;
	}
	//Offset the botom of the logo
	if (_root.logo_y>(Stage.height-(_root.logo1._y-_root.logo1._height))) {
		_root.logo_y = (Stage.height-(_root.logo1._y-_root.logo1._height));
	}
	_root.logo1._x = logo_x;
	_root.logo1._y = logo_y;
	trace("placing image at "+logo_x+", "+logo_y+".");
}

//Goes in each frame
//Screensaver
onEnterFrame = function () {
	if ((getTimer() - start_time) > delay) {
		trace("Time's up!");
		gotoAndStop("Screensaver");
	}
};