package com.munkychop.actionscript.loading
{
	import com.munkychop.actionscript.events.XMLLoaderEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	public class XMLLoader
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
				dispatchEvent (new XMLLoaderEvent (XMLLoaderEvent.LOAD_COMPLETE, event.target.data));
				
				urlLoader.removeEventListener (Event.COMPLETE, xmlLoaded);
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				urlLoader = null;
			}
			
			function errorHandler (event:IOErrorEvent):void
			{
				trace ("XMLLoader Error: " + event);
			}
		}
		
		public function addToBatch (xmlLocation:String, completeEventHandler:Function):void
		{
			_batchArray.push ({url:xmlLocation,eventHandler:completeEventHandler});
		}
		
		//pass in a series of data objects into this array, eg: batchLoadXML ({url: xml/someFile.xml, eventHandler: someEventHandler},{},{});
		public function batchLoadXML ():void
		{
			var currentIndex:int = 0;
			var urlLoader:URLLoader = new URLLoader ();
			var dataObject:Object = new Object ();
			
			urlLoader.addEventListener (Event.COMPLETE, xmlLoaded);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loadCurrentXML ();
			
			function loadCurrentXML ():void
			{
				urlLoader.load (new URLRequest (_batchArray[currentIndex].url));
			}
			
			function xmlLoaded (event:Event):void
			{
				dataObject.xml = event.target.data;
				dataObject.eventHandler = _batchArray[currentIndex].eventHandler;
				dispatchEvent (new XMLLoaderEvent (XMLLoaderEvent.BATCH_ITEM_LOAD_COMPLETE, dataObject));
				
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
	}
}