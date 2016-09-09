package com.capdig.utils.randomizer
{
    public class Randomizer
    {
        public var number:Number;
        
        // Constructor
        public function Randomizer ()
        {
            //
        }
        
        public function _randomize (min:Number, max:Number):void
        {
            number = Math.floor(Math.random() * (max - min + 1)) + min;
        }
        
        public function get _randomNum ():Number
        {
            return number;
        }
    }
}