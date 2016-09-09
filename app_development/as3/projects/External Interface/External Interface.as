// ------External Interface------
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
    } catch {
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
  ExternalInterface.addCallback("newMessage", newMessage); 
  ExternalInterface.addCallback("getStatus", getStatus); 
  // Notify the container that the SWF is ready to be called. 
  ExternalInterface.call("setSWFIsReady"); 
}

// ------External Variables------
// This function will be called when the swf finished loading.
// Suppose I have a movie clip names "mc" on the stage, this rootComplete() function will load the 
// imageFilename specified in the FlashVars.
function loaderComplete(myEvent:Event)
{
  var flashVars=this.root.loaderInfo.parameters;
  imageFilenameTextField.text=flashVars.imageFilename;
  var loader = new Loader(); 
  mc.addChild(loader); 
  loader.load(new URLRequest(flashVars.imageFilename)); 
}

// This assigns the callback to be called when the movie has finished loading.
this.loaderInfo.addEventListener(Event.COMPLETE, loaderComplete)