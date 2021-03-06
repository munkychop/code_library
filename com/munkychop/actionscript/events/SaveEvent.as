package com.munkychop.actionscript.events
{
	import flash.events.Event;
	
	public class SaveEvent extends Event
	{
		public static const OPEN:String = "open";
		public static const PROGRESS:String = "progress";
		public static const COMPLETE:String = "complete";
		public static const CANCEL:String = "cancel";
		
		public var data:Object;
	
		public function SaveEvent (type:String, data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super (type, bubbles, cancelable);
	
			this.data = data;
		}
	
		override public function clone ():Event
		{
			return new SaveEvent (type, data, bubbles, cancelable);
		}
	}
}