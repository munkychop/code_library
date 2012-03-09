/*
SimpleSWFLoader class

author:		munkychop
website:	www.munkychop.com
date:		08/05/2011 (11:11am GMT)
version:	1.0
license:	MIT - open source :)

*/

package com.munkychop.actionscript.loading
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	
	public class SimpleSWFLoader extends EventDispatcher
	{
		//-------------------------------------------------------------------------------
		//--public event constants
		//-------------------------------------------------------------------------------
		public static const SINGLE_ITEM_LOADED:String = "singleItemLoaded";
		public static const ITEM_LOADED:String = "itemLoaded";
		public static const ALL_ITEMS_LOADED:String = "allItemsLoaded";
		
		//-------------------------------------------------------------------------------
		//--private properties
		//-------------------------------------------------------------------------------
		private var _itemIndex:int;
		private var _totalItems:int;
		private var _loader:Loader;
		private var _currentLoadedItem:MovieClip;
		private var _loadedItemArray:Array;
		
		//-------------------------------------------------------------------------------
		//--constructor
		//-------------------------------------------------------------------------------
		public function SimpleSWFLoader (){}
		
		//-------------------------------------------------------------------------------
		//--getter/setter methods
		//-------------------------------------------------------------------------------
		public function get currentLoadedItem ():MovieClip
		{
			return _currentLoadedItem;
		}
		
		public function get loadedItemArray ():Array
		{
			return _loadedItemArray;
		}
		
		//------------------------------------------------------------------------------------------
		//--API
		//------------------------------------------------------------------------------------------
		public function loadSingleItem (itemURL:String, initialPath:String="") : void
		{
			var loader:Loader = new Loader ();
			
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, singleItemLoaded);
			loader.load (new URLRequest (initialPath + itemURL));
			
			function singleItemLoaded (event:Event):void
			{
				event.currentTarget.loader.contentLoaderInfo.removeEventListener (Event.COMPLETE, singleItemLoaded);
				_currentLoadedItem = event.currentTarget.content as MovieClip;
				
				dispatchEvent (new Event (SINGLE_ITEM_LOADED));
				
				trace ("SimpleSWFLoader: single item loaded");
				loader = null;
			}
		}
		
		
		public function loadItems (itemURLArray:Array, initialPath:String="") : void
		{
			_totalItems = itemURLArray.length;
			_itemIndex = 0;
			_loadedItemArray = new Array ();
			_loader = new Loader ();
			
			_loader.contentLoaderInfo.addEventListener (Event.COMPLETE, itemLoaded, false, 0, true);
			
			loadImage ();
			
			function loadImage ():void
			{
				_loader.load (new URLRequest (initialPath + itemURLArray[_itemIndex]));
			}
			
			function itemLoaded (event:Event):void
			{
				_currentLoadedItem = event.currentTarget.content as MovieClip;
				
				_loadedItemArray.push (_currentLoadedItem);
				
				dispatchEvent (new Event (ITEM_LOADED));
				
				if (_itemIndex < _totalItems -1)
				{
					_itemIndex++;
					loadImage ();
				}
				else
				{
					dispatchEvent (new Event (ALL_ITEMS_LOADED));
					
					_loader.removeEventListener (Event.COMPLETE, itemLoaded);
					_loader = null;
				}
			}
		}
	}
}