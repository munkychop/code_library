package com.munkychop.air.events
{
	import flash.events.Event;
	
	public class SVNEvent extends Event
	{
		//-------------------------------------------------------------------------------
		//--public event constants
		//-------------------------------------------------------------------------------
		public static const CLEANUP_COMMAND_STARTED:String = "cleanupCommandStarted";
		public static const CLEANUP_COMMAND_DATA_RECIEVED:String = "cleanupCommandDataRecieved";
		public static const CLEANUP_COMMAND_COMPLETE:String = "cleanupCommandComplete";
		
		public static const LIST_COMMAND_STARTED:String = "listCommandStarted";
		public static const LIST_COMMAND_DATA_RECIEVED:String = "listCommandDataRecieved";
		public static const LIST_COMMAND_COMPLETE:String = "listCommandComplete";
		
		public static const CHECKOUT_COMMAND_STARTED:String = "checkoutCommandStarted";
		public static const CHECKOUT_COMMAND_PROGRESS:String = "checkoutCommandProgress";
		public static const CHECKOUT_COMMAND_COMPLETE:String = "checkoutCommandComplete";
		
		public static const EXPORT_COMMAND_STARTED:String = "exportCommandStarted";
		public static const EXPORT_COMMAND_PROGRESS:String = "exportCommandProgress";
		public static const EXPORT_COMMAND_COMPLETE:String = "exportCommandComplete";
		
		
		public static const LOGIN_FAILED:String = "loginFailed";
		
		public static const READY_TO_EXIT:String = "readyToExit";
		//-------------------------------------------------------------------------------
		//--public properties
		//-------------------------------------------------------------------------------
		public var data:Object;
		
		//-------------------------------------------------------------------------------
		//--public methods
		//-------------------------------------------------------------------------------
		public function SVNEvent (type:String, data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super (type, bubbles, cancelable);
	
			this.data = data;
		}
	
		override public function clone ():Event
		{
			return new SVNEvent (type, data, bubbles, cancelable);
		}
	}
}