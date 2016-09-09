/*-------------------------------------------------------------	mc.drawWedge is a method for drawing pie shaped	wedges. Very useful for creating charts. Special	thanks to: Robert Penner, Eric Mueller and Michael	Hurwicz for their contributions.-------------------------------------------------------------*/MovieClip.prototype.drawWedge = function(x, y, startAngle, arc, radius, yRadius) {	// ==============	// mc.drawWedge() - by Ric Ewing (ric@formequalsfunction.com) - version 1.3 - 6.12.2002	//	// x, y = center point of the wedge.	// startAngle = starting angle in degrees.	// arc = sweep of the wedge. Negative values draw clockwise.	// radius = radius of wedge. If [optional] yRadius is defined, then radius is the x radius.	// yRadius = [optional] y radius for wedge.	// ==============	// Thanks to: Robert Penner, Eric Mueller and Michael Hurwicz for their contributions.	// ==============	if (arguments.length<5) {		return;	}	// move to x,y position	this.moveTo(x, y);	// if yRadius is undefined, yRadius = radius	if (yRadius == undefined) {		yRadius = radius;	}	// Init vars	var segAngle, theta, angle, angleMid, segs, ax, ay, bx, by, cx, cy;	// limit sweep to reasonable numbers	if (Math.abs(arc)>360) {		arc = 360;	}	// Flash uses 8 segments per circle, to match that, we draw in a maximum	// of 45 degree segments. First we calculate how many segments are needed	// for our arc.	segs = Math.ceil(Math.abs(arc)/45);	// Now calculate the sweep of each segment.	segAngle = arc/segs;	// The math requires radians rather than degrees. To convert from degrees	// use the formula (degrees/180)*Math.PI to get radians.		theta = -(segAngle/180)*Math.PI;	// convert angle startAngle to radians	angle = -(startAngle/180)*Math.PI;	// draw the curve in segments no larger than 45 degrees.	if (segs>0) {		// draw a line from the center to the start of the curve		ax = x+Math.cos(startAngle/180*Math.PI)*radius;		ay = y+Math.sin(-startAngle/180*Math.PI)*yRadius;		this.lineTo(ax, ay);		// Loop for drawing curve segments		for (var i = 0; i<segs; i++) {			angle += theta;			angleMid = angle-(theta/2);			bx = x+Math.cos(angle)*radius;			by = y+Math.sin(angle)*yRadius;			cx = x+Math.cos(angleMid)*(radius/Math.cos(theta/2));			cy = y+Math.sin(angleMid)*(yRadius/Math.cos(theta/2));			this.curveTo(cx, cy, bx, by);					}		// close the wedge by drawing a line to the center		this.lineTo(x, y);	}};