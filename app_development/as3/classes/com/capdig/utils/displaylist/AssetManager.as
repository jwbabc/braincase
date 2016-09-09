package com.capdig.utils.displaylist
{
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.display.Sprite;
        
    public class AssetManager extends MovieClip
    {
        function AssetManager ()
        {
            //
        }
        
        // Traces the contents of the target container
        public function _listContainer (container:Object):void
        {
            trace ('+ number of DisplayObject: ' + (container).numChildren + '  --------------------------------');
            for (var i:uint = 0; i < (container).numChildren; i++){
            	trace ('\t|\t ' +i+'.\t name:' + (container).getChildAt(i).name + '\t type:' + typeof ((container).getChildAt(i))+ '\t' + (container).getChildAt(i));
            }
        }
        
        // Clears all children from the target container
        public function _clearContainer (container:Object):void
        {
            while (container.numChildren > 0) 
            {
                container.removeChildAt (container.numChildren-1);
            }
        }
        
        // Adds objects from the asset loader array to the target container's display list
        public function _addToContainer(mc:MovieClip, o:Array)
        {
            for (var i:int=0; i<o.length; i++)
            {
                mc.addChild(o[i]);
            }
        }
    }
}