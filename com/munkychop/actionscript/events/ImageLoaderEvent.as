package com.munkychop.actionscript.events
{
	import flash.events.Event;
	
	public class ImageLoaderEvent extends Event
	{
		public static const LOAD_COMPLETE:String = "loadComplete";
		public static const TOTAL_LOAD_COMPLETE:String = "totalLoadComplete";
		
		public var data:Object;
	
		public function ImageLoaderEvent (type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super (type, bubbles, cancelable);
	
			this.data = data;
		}
	
		override public function clone ():Event
		{
			return new ImageLoaderEvent (type, data, bubbles, cancelable);
		}
	}
}