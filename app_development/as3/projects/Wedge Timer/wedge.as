#include "drawWedge.as"
createEmptyMovieClip("circle",1);
circle._x = 150;
circle._y = 150;
var counter = 0;
this.onEnterFrame = function() {
	if (counter <= 360) {
		counter += 5;
	} else {
		counter = 0;
	}
	circle.clear();
	trace (counter);
	circle.lineStyle(1, 0xB51284, 80);
	circle.drawWedge(0, 0, 0, counter, 50);
}