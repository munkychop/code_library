package com.munkychop.actionscript.events
{
	import flash.events.Event;
	
	public class WebcamEvent extends Event
	{
		public static const ADD_ACTIVATE_BUTTON:String = "addActivateButton";
		public static const REMOVE_ACTIVATE_BUTTON:String = "removeActivateButton";
		public static const WEBCAM_ACTIVATED:String = "webcamActivated";
		public static const WEBCAM_ACCESS_DENIED:String = "webcamAccessDenied";
		
		//public static const WEBCAM_ALLOWED:String = "webcamAllowed";
		//public static const WEBCAM_INACCESSIBLE:String = "webcamInaccessible";
		public var data:Object;
	
		public function WebcamEvent (type:String, data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super (type, bubbles, cancelable);
	
			this.data = data;
		}
	
		override public function clone ():Event
		{
			return new WebcamEvent (type, data, bubbles, cancelable);
		}
	}
}