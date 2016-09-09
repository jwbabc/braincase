// $Id$

/**
 * External Interface Manager Class
 * A class used for establishing communication with javascript within an html document
 *
 * ------ General Overview ------
 * This class ensures that communication is enabled between javascript functions within
 * a "container" (i.e. an HTML document where the *.swf file is embedded) and the
 * functions within the *.swf file itself.
 *
 * First the class checks the "container" status to see if the page is fully loaded in
 * the brower. if not it initiates a timer to check on the load progress of the "container".
 *
 * Once the "container" is loaded, the class establishes callbacks to AS3 functions
 * defined in the class, which can be used as calls to javaScript functions in the "container'. 
 * 
 * @access public
 * @author Joel Back <jwbabc@comcast.net>
 * @version 1.0
 *
 * ------ Usage ------
 * import EIManager;
 * var myEIManager:EIManager = new EIManager();
 *
 */

package {
	
	import flash.events.EventDispatcher;
  import flash.events.TimerEvent;
  import flash.external.ExternalInterface;
  import flash.utils.Timer;
	
	public class EIManager {
		
		public function EIManager ():void {
		  checkContainerStatus();
		}
		
    // ------ External Interface ------
    public function checkContainerStatus() { 
      // Check if the container is able to use the external API. 
      if (ExternalInterface.available) { 
        try {
          // This calls the isContainerReady() method, which in turn calls 
          // the container to see if Flash Player has loaded and the container 
          // is ready to receive calls from the SWF. 
          var containerReady:Boolean = isContainerReady(); 
          if (containerReady) { 
            // If the container is ready, register the SWF's functions. 
            setupCallbacks(); 
          } else { 
            // If the container is not ready, set up a Timer to call the 
            // container at 100ms intervals. Once the container responds that 
            // it's ready, the timer will be stopped. 
            var readyTimer:Timer = new Timer(100); 
            readyTimer.addEventListener(TimerEvent.TIMER, timerHandler); 
            readyTimer.start(); 
          } 
        } catch (event:TypeError) {
          trace ("External Interface Error:" + event);
        } 
      } else { 
        trace("External interface is not available for this container."); 
      }
    }

    // Calls the container to see if Flash Player has loaded and the container 
    // is ready to receive calls from the SWF.
    private function isContainerReady():Boolean { 
      var result:Boolean = ExternalInterface.call("isReady"); 
      return result; 
    }

    private function timerHandler(event:TimerEvent):void { 
      // Check if the container is now ready. 
      var isReady:Boolean = isContainerReady();
      if (isReady) {
        // If the container has become ready, we don't need to check anymore, 
        // so stop the timer. 
        Timer(event.target).stop(); 
        // Set up the ActionScript methods that will be available to be 
        // called by the container. 
        setupCallbacks();
      }   
    }

    private function setupCallbacks():void { 
      // Register the SWF client functions with the container
      // Notify the container that the SWF is ready to be called. 
      ExternalInterface.call("setSWFIsReady");
    }
    
    public function sendAlert (alertMessage:String) {
      var js_String:String = "alert('"+alertMessage+"')";
      ExternalInterface.call(js_String);
    }
	}
}