/*
BitmapLinkingLoader class

author:		munkychop
website:	www.munkychop.com
date:		07/11/2010 (11:29pm GMT)
version:	1.0
license:	MIT - open source :)

*/

package com.munkychop.actionscript.loading
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	
	public class BitmapLinkingLoader extends EventDispatcher
	{
		//-------------------------------------------------------------------------------
		//--public event constants
		//-------------------------------------------------------------------------------
		public static const ALL_IMAGES_LOADED:String = "allImagesLoaded";
		
		//-------------------------------------------------------------------------------
		//--private properties
		//-------------------------------------------------------------------------------
		private var _imageIndex:int;
		private var _totalImages:int;
		private var _loader:Loader;
		private var _currentLoadedBitmap:Bitmap;
		private var _dataObjectArray:Array;
		
		//-------------------------------------------------------------------------------
		//--constructor
		//-------------------------------------------------------------------------------
		public function BitmapLinkingLoader ()
		{
			
		}
		
		//-------------------------------------------------------------------------------
		//--public methods
		//-------------------------------------------------------------------------------
		
		//syntax: loadImages ([[imageURL,associatedBitmap]], "someInitialPath/");
		public function loadImages (inputArray:Array, initialPath:String="") : void
		{
			_totalImages = inputArray.length;
			_imageIndex = 0;
			_loader = new Loader ();
			_dataObjectArray = new Array ();
			
			_loader.contentLoaderInfo.addEventListener (Event.COMPLETE, imageLoaded);
			
			loadImage ();
			
			function loadImage ():void
			{
				_loader.load (new URLRequest (initialPath + inputArray[_imageIndex][0]));
			}
			
			function imageLoaded (event:Event):void
			{
				_currentLoadedBitmap = event.currentTarget.content as Bitmap;
				
				var dataObject:Object = new Object ();
				dataObject.bitmap = _currentLoadedBitmap
				dataObject.name = inputArray[_imageIndex][1];
				
				_dataObjectArray.push (dataObject);
				
				if (_imageIndex < _totalImages -1)
				{
					_imageIndex++;
					loadImage ();
				}
				else
				{
					dispatchEvent (new Event (ALL_IMAGES_LOADED));
					
					_loader.removeEventListener (Event.COMPLETE, imageLoaded);
					_loader = null;
				}
			}
		}
		
		public function getDataObjectArray ():Array
		{
			return _dataObjectArray;
		}
	}
}