﻿package com.capdig.cursor{    import flash.display.Stage;    import flash.display.MovieClip;    import flash.display.DisplayObject;    import flash.events.MouseEvent;    import flash.geom.Point;    import flash.ui.Mouse;    import Cursor;        public class CustomCursor extends MovieClip    {        private var stageRef:Stage;        private var customCursor:Cursor;                public function CustomCursor(stageRef:Stage)        {            Mouse.hide();            mouseEnabled = false;            mouseChildren = false;                        // Assign stage references            this.stageRef = stageRef;            // Add the cursor asset to the stage            customCursor = new Cursor();            addChild(customCursor);            // Position the asset            x = stageRef.mouseX;            y = stageRef.mouseY;            // Listen for mouse movement            stageRef.addEventListener(MouseEvent.MOUSE_MOVE, _updateMouse);        }         private function _updateMouse(event:MouseEvent) : void        {            x = stageRef.mouseX;            y = stageRef.mouseY;             event.updateAfterEvent();        }    }}