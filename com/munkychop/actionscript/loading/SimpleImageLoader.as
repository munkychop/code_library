/*
SimpleImageLoader class

author:		munkychop
website:	www.munkychop.com
date:		07/11/2010 (2:13pm GMT)
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
	
	public class SimpleImageLoader extends EventDispatcher
	{
		//-------------------------------------------------------------------------------
		//--public event constants
		//-------------------------------------------------------------------------------
		public static const IMAGE_LOADED:String = "imageLoaded";
		public static const ALL_IMAGES_LOADED:String = "allImagesLoaded";
		
		//-------------------------------------------------------------------------------
		//--private properties
		//-------------------------------------------------------------------------------
		
		/*
		variables to keep track of the loaded image index, the total length of the
		'url' Array, and the Loader object should be created OUTSIDE the function
		scope and so will be available to all functions within this class.
		*/
		private var _imageIndex:int;
		private var _totalImages:int;
		private var _loader:Loader;
		private var _currentLoadedBitmap:Bitmap;
		private var _loadedBitmapArray:Array;
		
		//-------------------------------------------------------------------------------
		//--constructor
		//-------------------------------------------------------------------------------
		public function SimpleImageLoader ()
		{
			
		}
		
		//-------------------------------------------------------------------------------
		//--public methods
		//-------------------------------------------------------------------------------
		
		/*
		set the initial path to your images seperately from the 'url' Array so you
		don't need to mess around with your _imageIndex variable.
		*/
		public function loadImages (imageURLArray:Array, initialPath:String="") : void
		{
			/*
			set the _totalImages variable to the length of the array, as we will
			need to use this variable within the 'imageLoaded' function below.
			*/
			_totalImages = imageURLArray.length;
			
			//an array to store all the loaded bitmap images
			_loadedBitmapArray = new Array ();
			
			/*
			set the initial image index to load. We will also need this variable
			in the 'imageLoaded' function below.
			*/
			_imageIndex = 0;
			
			//create one single Loader object which will save memory
			_loader = new Loader ();
			
			/*
			if you set the 'useWeakReference' option to 'true' within the addEventListener
			call the garbage collector will take care of destroying the listener when it
			isn't needed anymore.
			
			otherwise you can do it manually, (or do both) which is more efficient... see the
			'imageLoaded' function below for an example of doing so manually.
			*/
			
			//--------------------------------------------------------------useWeakReference : true
			_loader.contentLoaderInfo.addEventListener (Event.COMPLETE, imageLoaded, false, 0, true);
			
			//load the first image
			loadImage ();
			
			function loadImage ():void
			{
				_loader.load (new URLRequest (initialPath + imageURLArray[_imageIndex]));
			}
			
			function imageLoaded (event:Event):void
			{
				//get the bitmap from the event object
				_currentLoadedBitmap = event.currentTarget.content as Bitmap;
				
				//add the bitmap to the array of all loaded bitmaps
				_loadedBitmapArray.push (_currentLoadedBitmap);
				
				//dispatch an event to notify any classes that are listening
				dispatchEvent (new Event (IMAGE_LOADED));
				
				/*
				check if the image index is less than the number of images in the array and
				if so, increase the _imageIndex variable and call the 'loadImage' function,
				which loads an image from the array at the index of this variable.
				
				otherwise, if the image index is equal to the number of images in the array we
				know all the images have been loaded, and so we can destroy the Loader object.
				*/
				if (_imageIndex < _totalImages -1)
				{
					_imageIndex++;
					loadImage ();
				}
				else
				{
					//dispatch an event to notify any classes that are listening
					dispatchEvent (new Event (ALL_IMAGES_LOADED));
					
					/*
					immediately get rid of the event listener on the Loader object manually and
					then destroy it by setting it to 'null'
					*/
					_loader.removeEventListener (Event.COMPLETE, imageLoaded);
					_loader = null;
				}
			}
		}
		
		public function getCurrentBitmap ():Bitmap
		{
			return _currentLoadedBitmap;
		}
		
		public function getBitmapArray ():Array
		{
			return _loadedBitmapArray;
		}
	}
}