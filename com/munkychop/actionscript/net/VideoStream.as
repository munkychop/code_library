package com.munkychop.actionscript.net
{
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	/**
	 * @author munkychop
	 */
	public class VideoStream extends NetStream
	{
		public static const READY_FOR_REMOVAL:String = "readyForRemoval";
		
		protected var _netConnection:NetConnection;
		protected var _video:Video;
		protected var _infoObject:Object;
		protected var _videoShouldLoop:Boolean;

		public function VideoStream (p_videoWidth:int = 320, p_videoHeight:int = 240, p_loop:Boolean = false)
		{
			_videoShouldLoop = p_loop;
						
			_netConnection = new NetConnection ();
			_netConnection.connect (null);

			super (_netConnection);
			_infoObject = new Object();
			this.client = _infoObject;

			_video = new Video (p_videoWidth, p_videoHeight);
			_video.attachNetStream (this);
			
			this.addEventListener (NetStatusEvent.NET_STATUS, netStatusHandler);
		}
		
		public function set loop (p_loop:Boolean):void
		{
			_videoShouldLoop = p_loop;
		}
		
		public function get video ():Video
		{
			return _video;
		}

		public function destroy ():void
		{
			if (_video.stage) _video.stage.removeChild (_video);
			this.close ();
			this.removeEventListener (NetStatusEvent.NET_STATUS, netStatusHandler);
			_netConnection = null;
			_video.attachNetStream (null);
			_video = null;

			// dispatch ready for removal event so parent class can set this class to null
			dispatchEvent (new Event (VideoStream.READY_FOR_REMOVAL));
		}

		protected function netStatusHandler (event:NetStatusEvent):void
		{
			if (event.info.code == "NetStream.Play.Stop")
			{
				if (_videoShouldLoop) this.seek (0);
			}
		}

		protected function metaDataHandler (infoObject:Object):void
		{
			trace ("meta data received:\n");
			
			trace (infoObject.info.metaData);
		}

		protected function cuePointHandler (infoObject:Object):void
		{
		}
	}
}
