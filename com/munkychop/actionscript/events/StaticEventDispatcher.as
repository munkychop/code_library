package com.munkychop.actionscript.events
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class StaticEventDispatcher extends EventDispatcher
	{
		//--Static Event Dispatcher
		//------------------------------------------------------------------------------------------
		
		protected static var _eventDispatcher:EventDispatcher;
		
		public static function addEventListener (p_type:String, p_listener:Function, p_useCapture:Boolean=false, p_priority:int=0, p_useWeakReference:Boolean=false):void
		{
			if (_eventDispatcher == null)
			{
				_eventDispatcher = new EventDispatcher ();
			}
			
			_eventDispatcher.addEventListener (p_type, p_listener, p_useCapture, p_priority, p_useWeakReference);
		}
		
		public static function removeEventListener (p_type:String, p_listener:Function, p_useCapture:Boolean=false):void
		{
			if (_eventDispatcher == null)
			{
				return;
			}
			
			_eventDispatcher.removeEventListener (p_type, p_listener, p_useCapture);
		}
		
		public static function dispatchEvent (p_event:Event):void
		{
			if (_eventDispatcher == null)
			{
				return;
			}
			
			_eventDispatcher.dispatchEvent (p_event);
		}
		
	}
}