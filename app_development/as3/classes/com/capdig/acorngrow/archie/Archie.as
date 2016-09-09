package com.capdig.acorngrow.archie
{
    import flash.display.MovieClip;
    import flash.filters.DropShadowFilter;
    import com.capdig.acorngrow.archie.Face;
        
    public class Archie extends MovieClip
    {
        private var archieDS:DropShadowFilter;
        private var archieFace:Face;
        
        // Constructor
        public function Archie ()
        {
            // Init the filter
            archieDS = new DropShadowFilter (1,45,0x000000,.60,5,5,2);
            // Init the drop shadow
            filters=[archieDS];
            // Init archie's face
            archieFace = new Face();
        }
        
        public function _move(xPos:int, yPos:int)
        {
            x = xPos;
            y = yPos;
        }
        
        // Property access
        public function get _face ():Object
        {
            return archieFace;
        }
    }
}