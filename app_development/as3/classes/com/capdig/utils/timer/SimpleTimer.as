﻿package com.capdig.utils.timer{    import flash.utils.Timer;    import flash.events.TimerEvent;    import flash.events.Event;    import flash.events.EventDispatcher;    public class SimpleTimer extends EventDispatcher    {        public static const TIMING_COMPLETE:String = 'timing_completed';                private var sTimer:Timer;                public function SimpleTimer():void        {            //                   };                public function _initTimer(t:uint):void        {                           sTimer = new Timer(t);            sTimer.addEventListener(TimerEvent.TIMER, onTimeOut);            sTimer.start();        };                private function onTimeOut(evt:TimerEvent):void        {            sTimer.removeEventListener(TimerEvent.TIMER, onTimeOut);            this.dispatchEvent(new Event(SimpleTimer.TIMING_COMPLETE));        };            };}