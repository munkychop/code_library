package com.munkychop.actionscript.loading
{
	import com.munkychop.actionscript.events.XMLLoaderEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	public class XMLLoader extends EventDispatcher
	{
		private var _batchArray:Array;
		
		//------------------------------------------------------------------------------------------
		//--Public API
		//------------------------------------------------------------------------------------------
		
		public function XMLLoader ()
		{
			_batchArray = new Array ();
		}
		
		public function loadXML (xmlLocation:String):void
		{
			var urlLoader:URLLoader = new URLLoader ();
			var urlRequest:URLRequest = new URLRequest (xmlLocation);
			
			urlLoader.addEventListener (Event.COMPLETE, xmlLoaded);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			urlLoader.load (urlRequest);
			
			function xmlLoaded (event:Event):void
			{
				var xml:XML = new XML (event.target.data);
				
				dispatchEvent (new XMLLoaderEvent (XMLLoaderEvent.LOAD_COMPLETE, xml));
				
				urlLoader.removeEventListener (Event.COMPLETE, xmlLoaded);
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				urlLoader = null;
				xml = null;
			}
			
			function errorHandler (event:IOErrorEvent):void
			{
				trace ("XMLLoader Error: " + event);
			}
		}
		
		public function addToBatch (p_xmlLocation:String, p_onCompleteHandler:Function = null):void
		{
			_batchArray.push ({url:p_xmlLocation,onCompleteHandler:p_onCompleteHandler});
		}
		
		public function batchLoadXML ():void
		{
			if (_batchArray.length > 0)
			{
				var currentIndex:int = 0;
				var urlLoader:URLLoader = new URLLoader ();
				var xml:XML;
				var onCompleteHandler:Function;
				
				urlLoader.addEventListener (Event.COMPLETE, xmlLoaded);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				loadCurrentXML ();
				
				function loadCurrentXML ():void
				{
					urlLoader.load (new URLRequest (_batchArray[currentIndex].url));
				}
				
				function xmlLoaded (event:Event):void
				{
					xml = new XML (event.target.data);
					onCompleteHandler = _batchArray[currentIndex].onCompleteHandler;
					
					dispatchEvent (new XMLLoaderEvent (XMLLoaderEvent.BATCH_ITEM_LOAD_COMPLETE, xml, onCompleteHandler));
					
					xml = null;
					onCompleteHandler = null;
					
					if (currentIndex < _batchArray.length -1)
					{
						currentIndex++;
						loadCurrentXML ();
					}
					else
					{
						dispatchEvent (new XMLLoaderEvent (XMLLoaderEvent.BATCH_TOTAL_LOAD_COMPLETE));
						
						urlLoader.removeEventListener (Event.COMPLETE, xmlLoaded);
						urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
						urlLoader = null;
					}
				}
				
				function errorHandler (event:IOErrorEvent):void
				{
					trace ("XMLLoader Error: " + event);
				}
			}
		}
		
		/*
		//------------------------------------------------------------------------------------------
		//--Static Event Dispatcher
		//------------------------------------------------------------------------------------------
		
		protected var _eventDispatcher:EventDispatcher;
		
		public function addEventListener (p_type:String, p_listener:Function, p_useCapture:Boolean=false, p_priority:int=0, p_useWeakReference:Boolean=false):void
		{
			if (_eventDispatcher == null)
			{
				_eventDispatcher = new EventDispatcher ();
			}
			
			_eventDispatcher.addEventListener (p_type, p_listener, p_useCapture, p_priority, p_useWeakReference);
		}
		
		public function removeEventListener (p_type:String, p_listener:Function, p_useCapture:Boolean=false):void
		{
			if (_eventDispatcher == null)
			{
				return;
			}
			
			_eventDispatcher.removeEventListener (p_type, p_listener, p_useCapture);
		}
		
		public function dispatchEvent (p_event:Event):void
		{
			if (_eventDispatcher == null)
			{
				return;
			}
			
			_eventDispatcher.dispatchEvent (p_event);
		}
		
		//------------------------------------------------------------------------------------------
		 * 
		 */
	}
}