﻿package {		// import Utils;		public class CurvePoint {				private var _startpoint	:Number = 0		private var _range		:Number = 0		private var _angle		:Number = 0		private var _x			:Number = 0		private var _y			:Number = 0		private var _inc		:Number = 0.1				public function CurvePoint(x:Number = 0, y:Number = 0, startpoint:Number = 0, range:Number = 40) {			_x			= x;			_y			= y;			_startpoint	= y;			_range		= range - Math.random()*10*((range/10));			_angle		= Math.random();			_inc		= Math.random()*0.2		}				public function get startpoint():Number { return _startpoint; }		public function get range():Number { return _range; }		public function get angle():Number { return _angle; }		public function get x():Number { return _x; }		public function get y():Number { return _y; }		public function get inc():Number { return _inc; }		public function set y(value:Number) { _y = value; }		public function set angle(value:Number) { _angle = value; }			}	}