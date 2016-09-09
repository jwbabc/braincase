// $Id$

/*
// Usage:
// Create the streaming video object
var streamingVideo:videoLoader = new videoLoader(null,"video/find.flv",15,720,480);
video_mc.vidContainer_mc.addChild (streamingVideo);
video_mc.vidContainer_mc.scaleX = .583;
video_mc.vidContainer_mc.scaleY = .583;

// Calculate current video position (graphically)
video_mc.videoControls_mc.videoScrub_mc.x = streamingVideo.p_position/(streamingVideo.p_duration/video_mc.videoControls_mc.videoBar_mc.width);

// Calculate video buffer (graphically)
video_mc.videoControls_mc.videoBytes_mc.scaleX = streamingVideo.p_bytesLoaded/(streamingVideo.p_bytesTotal/video_mc.videoControls_mc.videoBar_mc.scaleX);
*/

package {
  import flash.events.*;
  import flash.media.Video;
  import flash.display.Sprite;
  import flash.net.*;
  
  public class VideoLoader extends Sprite {
    private var videoURL:String;
    private var video:Video;
    private var videoDuration:Number;
    private var videoPosition:Number;
    private var videoWidth:Number;
    private var videoHeight:Number;
    private var videoBytesLoaded:Number;
    private var videoBytesTotal:Number;
    private var nc:NetConnection;
    private var ns:NetStream;  
    
    // Contructors/Initialization
    public function VideoLoader(serverUrl:String, flvUrl:String, flvDuration:Number, flvWidth:Number, flvHeight:Number):void {
      // Video attributes
      videoURL = flvUrl;
      videoDuration = flvDuration;
      videoWidth = flvWidth;
      videoHeight = flvHeight;
      
      // Create & connect NetConnection
      nc = new NetConnection();
      nc.connect(serverUrl);
      
      // Create NetStream object
      ns = new NetStream(nc);
      ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
      // Initialize the NetStream object
      ns.play(videoURL);
      
      // Create Video object
      video = new Video(videoWidth, videoHeight);
      
      // Attach the NetStream to the video object
      video.attachNetStream(ns);
      addChild(video);
    }
    
    // NetStream actions and events
    public function asyncErrorHandler(event:AsyncErrorEvent):void {
      trace ("event:AsyncErrorEvent "+event);
    }
    
    private function videoPlayComplete():void {
      pauseFlv();
    }
    
    // Playback control
    public function pauseFlv():void {
      ns.togglePause();            
    }
    
    public function closeFlv():void {
      ns.close();
    }
    
    public function seekFlv(iFrame:Number) {
      ns.seek(iFrame);
    }
    
    // Public varaibles
    public function get p_duration() {
      return videoDuration;
    }
    
    public function get p_position() {
      videoPosition = ns.time;
      return videoPosition;
    }
    
    public function get p_bytesLoaded() {
      videoBytesLoaded = ns.bytesLoaded;
      return videoBytesLoaded;
    }
    
    public function get p_bytesTotal() {
      videoBytesTotal = ns.bytesTotal;
      return videoBytesTotal;
    }
  }
}