package com.munkychop.actionscript.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
		
	public class ColourChanger extends EventDispatcher
	{
		public static const COLOUR_CHANGE:String = "ColourChange";
		
		private var _colourSpectrumImage:DisplayObject;
		private var _targetObject:DisplayObject;
		
		private var _bitmapData:BitmapData;
		private var _colourHex:uint;
		private var _colorTransform:ColorTransform = new ColorTransform ();
		
		public function ColourChanger (colourSpectrumImage:DisplayObject)
		{
			_bitmapData = new BitmapData (colourSpectrumImage.width,colourSpectrumImage.height);
			_bitmapData.draw (colourSpectrumImage);
			
			_colourSpectrumImage = colourSpectrumImage;
		}
		
		public function addColourListener ():void
		{	
			_colourSpectrumImage.addEventListener (MouseEvent.MOUSE_MOVE, setColour);
			_colourSpectrumImage.addEventListener (MouseEvent.MOUSE_DOWN, setColour);
		}
		
		public function removeColourListener ():void
		{			
			_colourSpectrumImage.removeEventListener (MouseEvent.MOUSE_MOVE, setColour);
			_colourSpectrumImage.removeEventListener (MouseEvent.MOUSE_DOWN, setColour);
		}

		public function setColour (e:MouseEvent):void
		{
			_colourHex = uint ("0x" + _bitmapData.getPixel(_colourSpectrumImage.mouseX, _colourSpectrumImage.mouseY).toString(16));
			
			//_colorTransform.color = _colourHex;
			
			dispatchEvent (new Event (ColourChanger.COLOUR_CHANGE));
		}
		
		public function getColour ():uint
		{
			return _colourHex;
		}
	}
}