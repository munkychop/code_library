package com.munkychop.actionscript.events
{
	import flash.events.Event;

	public class XMLLoaderEvent extends Event
	{
		public static const LOAD_COMPLETE:String = "loadComplete";
		public static const BATCH_ITEM_LOAD_COMPLETE:String = "batchItemLoadComplete";
		public static const BATCH_TOTAL_LOAD_COMPLETE:String = "batchTotalLoadComplete";

		public var xml:XML;
		public var data:Object;
		public var onCompleteHandler:Function;

		public function XMLLoaderEvent (type:String, xml:XML = null, onCompleteHandler:Function = null, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super (type, bubbles, cancelable);

			this.xml = xml;
			this.onCompleteHandler = onCompleteHandler;
			this.data = data;
		}

		override public function clone ():Event
		{
			return new XMLLoaderEvent (type, xml, onCompleteHandler, data, bubbles, cancelable);
		}
	}
}