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
    private var _videoURL:String;
    private var _video:Video;
    private var _videoDuration:Number;
    private var _videoPosition:Number;
    private var _videoWidth:Number;
    private var _videoHeight:Number;
    private var _videoBytesLoaded:Number;
    private var _videoBytesTotal:Number;
    private var _nc:NetConnection;
    private var _ns:NetStream;  
    
    // Contructors/Initialization
    public function VideoLoader(serverUrl:String, flvUrl:String, flvDuration:Number, flvWidth:Number, flvHeight:Number):void {
      // Video attributes
      _videoURL = flvUrl;
      _videoDuration = flvDuration;
      _videoWidth = flvWidth;
      _videoHeight = flvHeight;
      
      // Create & connect NetConnection
      _nc = new NetConnection();
      _nc.connect(serverUrl);
      
      // Create NetStream object
      _ns = new NetStream(nc);
      _ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
      // Initialize the NetStream object
      _ns.play(videoURL);
      
      // Create Video object
      _video = new Video(videoWidth, videoHeight);
      
      // Attach the NetStream to the video object
      _video.attachNetStream(ns);
      addChild(_video);
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
      _ns.togglePause();            
    }
    
    public function closeFlv():void {
      _ns.close();
    }
    
    public function seekFlv(iFrame:Number) {
      _ns.seek(iFrame);
    }
    
    // Public varaibles
    public function get p_duration() {
      return _videoDuration;
    }
    
    public function get p_position() {
      _videoPosition = _ns.time;
      return _videoPosition;
    }
    
    public function get p_bytesLoaded() {
      _videoBytesLoaded = _ns.bytesLoaded;
      return _videoBytesLoaded;
    }
    
    public function get p_bytesTotal() {
      _videoBytesTotal = _ns.bytesTotal;
      return _videoBytesTotal;
    }
  }
}