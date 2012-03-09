package com.munkychop.actionscript.loading
{
	import com.munkychop.actionscript.events.ImageLoaderEvent;

	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	
	public class ImageLoader
	{
		private var _loadedBitmapArray:Array;
		private var _bitmapCount:int;
		
		public function ImageLoader  ()
		{
			_loadedBitmapArray = new Array ();
		}
		
		//------------------------------------------------------------------------------------------
		//--getter/setter methods
		//------------------------------------------------------------------------------------------
		public function get loadedBitmapArray ():Array
		{
			return _loadedBitmapArray;
		}
		
		public function get bitmapCount ():int
		{
			return _bitmapCount;
		}
		
		//------------------------------------------------------------------------------------------
		//--API
		//------------------------------------------------------------------------------------------		
		public function loadImageList (imageList:XMLList, nodeName:String, initialPath:String = "", props:Array=null):void
		{
			var listIndex:int = 0;
			var listCount:int = 1;
			var dataObject:Object;
			loopThroughXML ();
			
			function loopThroughXML ():void
			{
				if (imageList[listIndex] != undefined && imageList[listIndex][nodeName] != "")
				{
					var urlRequest:URLRequest = new URLRequest ((initialPath != "none" ? initialPath : "")  + imageList[listIndex][nodeName]);
					//trace (urlRequest.url);
					var loader:Loader = new Loader ();
					dataObject = new Object ();
						
					if (props != null)
					{						
						for each (var subPropArray:Array in props)
						{
							var prop:String = subPropArray[0];
							var useInitialPath:Boolean = subPropArray[1];
							
							if (useInitialPath == true)
							{
								dataObject[prop] = initialPath + imageList[listIndex][prop];
							}
							else
							{
								dataObject[prop] = imageList[listIndex][prop];
							}
						}
					}
						
					if (listIndex < imageList.length () - 1)
					{
						loader.contentLoaderInfo.addEventListener (Event.COMPLETE, imageLoaded);
					}
					else if (listIndex == imageList.length () - 1)
					{
						loader.contentLoaderInfo.addEventListener (Event.COMPLETE, allImagesLoaded);
					}
					
					loader.contentLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR, errorHandler);
					loader.load (urlRequest);
				}
				else
				{
					trace ("imageList " + listIndex + " is undefined!");
				}
			}
			
			function imageLoaded (event:Event)
			{
				_loadedBitmapArray.push (event.currentTarget.content);
				
				dataObject.bitmap = event.currentTarget.content;
				dataObject.bitmapIndex = listIndex;
				dataObject.bitmapCount = listCount;
				
				dispatchEvent (new ImageLoaderEvent (ImageLoaderEvent.LOAD_COMPLETE, dataObject));
				
				listIndex++;
				listCount++;
				loopThroughXML ();
			}
			
			function allImagesLoaded (event:Event)
			{
				_loadedBitmapArray.push (event.currentTarget.content);
				_bitmapCount = listCount;
				
				dataObject.bitmap = event.currentTarget.content;
				dataObject.bitmapIndex = listIndex;
				dataObject.bitmapCount = listCount;
				dataObject.bitmapArray = _loadedBitmapArray;
				
				dispatchEvent (new ImageLoaderEvent (ImageLoaderEvent.LOAD_COMPLETE, dataObject));
				dispatchEvent (new ImageLoaderEvent (ImageLoaderEvent.TOTAL_LOAD_COMPLETE, dataObject));
			}
			
			function errorHandler (event:IOErrorEvent):void
			{
				trace ("ImageLoader Error: " + event);
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