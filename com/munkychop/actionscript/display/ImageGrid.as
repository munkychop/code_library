//-----------------------------------------------------------------
//
//ImageGrid by Ivan Hayes
//
//last updated:	30 July 2010 6:53am
//
//-----------------------------------------------------------------


package com.munkychop.actionscript.display
{
	import com.munkychop.actionscript.ui.CustomScrollBar;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	
	public class ImageGrid extends MovieClip
	{
		//--------------------------------------------------------------------------------------------
		//--Private Properties
		//--------------------------------------------------------------------------------------------
		private var _scrollBar:CustomScrollBar;
		
		private var _scrollBarAdded:Boolean;
		private var _gridSpacing:int;
		private var _maxWidth:int;
		private var _maxHeight:int;
		private var _gridHolder:MovieClip;
		private var _previousImage:MovieClip;
		private var _gridMask:Sprite;
		private var _gridOrientation:String;
		private var _scrollBarAlignment:String;
		private var _useScrollBar:Boolean;
		
		//--------------------------------------------------------------------------------------------
		//--Constructor
		//--------------------------------------------------------------------------------------------
		public function ImageGrid (maxWidth:int, maxHeight:int, gridOrientation:String = "vertical", useScrollBar:Boolean = true, scrollBarAlignment:String = "right", gridSpacing:int = 4)
		{
			_maxWidth = maxWidth;
			_maxHeight = maxHeight;
			_gridOrientation = gridOrientation;
			_useScrollBar = useScrollBar;
			_scrollBarAlignment = scrollBarAlignment;
			_gridSpacing = gridSpacing;
			
			init ();
		}
		
		//--------------------------------------------------------------------------------------------
		//--Initialization
		//--------------------------------------------------------------------------------------------
		private function init ():void
		{			
			_scrollBarAdded = false;
			
			_gridHolder = new MovieClip ();
			_gridMask = new Sprite ();
			
			_gridMask.graphics.beginFill (0x000000);
			_gridMask.graphics.drawRect (0,0,_maxWidth,_maxHeight);
			_gridMask.graphics.endFill ();
			
			_gridHolder.cacheAsBitmap = true;
			_gridMask.cacheAsBitmap = true;
			
			_gridHolder.mask = _gridMask;
			
			addChild (_gridHolder);
			addChild (_gridMask);
		}
		
		//--------------------------------------------------------------------------------------------
		//--Getter/Setter Methods
		//--------------------------------------------------------------------------------------------
		public function get maxWidth ():int
		{
			return _maxWidth;
		}
		
		public function set maxWidth (maxWidth:int):void
		{
			_maxWidth = maxWidth;
		}
		
		public function get maxHeight ():int
		{
			return _maxHeight;
		}
		
		public function set maxHeight (maxHeight:int):void
		{
			_maxHeight = maxHeight;
		}
		
		public function get draggingScrollBar ():Boolean
		{
			return _scrollBar.dragging;
		}
		
		public function set draggingScrollBar (booleanValue:Boolean):void
		{
			_scrollBar.dragging = booleanValue;
		}
		
		public function get gridMaskWidth ():int
		{
			return _gridMask.width;
		}
		
		public function set gridMaskWidth (newMaskWidth:int):void
		{
			_gridMask.width = newMaskWidth;
		}
		
		public function get gridMaskHeight ():int
		{
			return _gridMask.height;
		}
		
		public function set gridMaskHeight (newMaskHeight:int):void
		{
			_gridMask.height = newMaskHeight;
		}
		
		public function get scrollBarAdded ():Boolean
		{
			return _scrollBarAdded;
		}
		
		public function set scrollBarAdded (newValue:Boolean):void
		{
			_scrollBarAdded = newValue;
		}
		
		
		
		//--------------------------------------------------------------------------------------------
		//--Public Methods
		//--------------------------------------------------------------------------------------------
		public function addImage (image:MovieClip):void
		{
			if (_gridOrientation == "vertical")
			{
				if (_previousImage != null)
				{
					image.x = _previousImage.x + _previousImage.width + _gridSpacing;
					image.y = _previousImage.y;
				}
				
				if (image.x + image.width > _maxWidth)
				{
					//put image on the next line
					image.x = 0;
					image.y += image.height + _gridSpacing;
				}
				
				if (useScrollBar && !_scrollBarAdded && image.y + image.height > _maxHeight)
				{
					_scrollBarAdded = true;
					addScrollBar ();
				}
			}
			else if (_gridOrientation == "horizontal")
			{
				if (_previousImage != null)
				{
					image.x = _previousImage.x;
					image.y = _previousImage.y + _previousImage.height + _gridSpacing;;
				}
				
				if (image.y + image.height > _maxHeight)
				{
					//puts image on the next line
					image.x += image.width + _gridSpacing;
					image.y = 0;
				}
				
				if (_useScrollBar && !_scrollBarAdded && image.x + image.width > _maxWidth)
				{
					_scrollBarAdded = true;
					addScrollBar ();
				}
			}
			
			_gridHolder.addChild (image);
			
			_previousImage = image;
		}
		
		public function addScrollBar ():void
		{
			if (_gridOrientation == "vertical")
			{
				_scrollBar = new CustomScrollBar (_gridHolder, _maxHeight, _maxHeight, _gridOrientation);
				
				if (_scrollBarAlignment == "right")
				{
					_scrollBar.x = _gridHolder.x + _gridHolder.width + _gridSpacing;
				}
				else if (_scrollBarAlignment == "left")
				{
					_scrollBar.x = _gridHolder.x - _scrollBar.width - _gridSpacing;
				}
			}
			else if (_gridOrientation == "horizontal")
			{
				_scrollBar = new CustomScrollBar (_gridHolder, _maxWidth, _maxWidth, _gridOrientation);
				
				if (_scrollBarAlignment == "top")
				{
					_scrollBar.y = _gridHolder.y - _scrollBar.height - _gridSpacing;
				}
				else if (_scrollBarAlignment == "bottom")
				{
					_scrollBar.y = _gridHolder.y + _gridHolder.height + _gridSpacing;
				}
			}
			
			addChild (_scrollBar);
		}
		
		public function removeScrollBar ():void
		{
			_scrollBar.removeAllListeners ();
			removeChild (_scrollBar);
			_scrollBar = null;
			
			_scrollBarAdded = false;
		}
	}
}