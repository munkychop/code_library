package com.munkychop.actionscript.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;

	//- LIBRARIES ---------------------------------------------------------------------------------------------


	public class ImageDisplacement extends MovieClip
	{

		//- PRIVATE & PROTECTED VARIABLES -------------------------------------------------------------------------

		private var _image:MovieClip;
		private var _bitmapData:BitmapData;
		private var _imageHolder:MovieClip;
		
		private var _bitmapOfImage:Bitmap;
		private var _bitmapDataCopy:BitmapData;
		private var _bitmapDataCopyOutput:BitmapData;
		
		private var _smearMatrix:Matrix = new Matrix ();
		private var _displacementMapFilter:DisplacementMapFilter;
		
		private var _smearBrush:Sprite = new Sprite ();
		private var _brushSize:int;
		
		private var _bitmapMouseX:Number;
		private var _bitmapMouseY:Number;

		//- PUBLIC & INTERNAL VARIABLES ---------------------------------------------------------------------------



		//- CONSTRUCTOR -------------------------------------------------------------------------------------------

		public function ImageDisplacement (image:MovieClip, brushSize:int = 128):void
		{
			_image = image;
			_brushSize = brushSize;
			
			_bitmapData = new BitmapData (_image.width, _image.height);
			_bitmapData.draw (_image);
			
			_bitmapOfImage = new Bitmap (_bitmapData);
			
			_imageHolder = new MovieClip ();
			_imageHolder.addChild (_bitmapOfImage);
			_imageHolder.addChild (_smearBrush);
			
			addChild (_imageHolder);

			init ();
		}

		//- PRIVATE & PROTECTED METHODS ---------------------------------------------------------------------------
		
		private function init ():void
		{
			_bitmapDataCopy = new BitmapData (_bitmapOfImage.width,_bitmapOfImage.height,false,0x000000);
			_bitmapDataCopyOutput = new BitmapData (_bitmapOfImage.width,_bitmapOfImage.height,false,0x000000);
			
			//new DisplacementMapFilter --> (bitmapData instance,Point instance,component x,component y,scaleX,scaleY,"clamp");
			_displacementMapFilter = new DisplacementMapFilter (_bitmapDataCopy,new Point (),2,4,48,48,"clamp");
			
			_bitmapMouseX = _imageHolder.mouseX;
			_bitmapMouseY = _imageHolder.mouseY;
			
			displaceBitmap ();
		}

		//- PUBLIC & INTERNAL METHODS -----------------------------------------------------------------------------
		
		public function getBitmapHolder ():MovieClip
		{
			return _imageHolder;
		}
		
		public function reset ():void
		{
			init ();
		}
		
		public function addEnterFrame ():void
		{
			_imageHolder.addEventListener (Event.ENTER_FRAME, displaceBitmap);
		}
		
		public function removeEnterFrame ():void
		{
			_imageHolder.removeEventListener (Event.ENTER_FRAME, displaceBitmap);
		}
		
		private function displaceBitmap (event:Event = null):void
		{
			_smearMatrix.createGradientBox (_brushSize,_brushSize,0,_imageHolder.mouseX - (_brushSize / 2),_imageHolder.mouseY - (_brushSize / 2));

			_smearBrush.graphics.beginGradientFill ("radial",[Math.abs((_bitmapMouseX - _imageHolder.mouseX) * 4) << 8,0],[100,0],[0,255],_smearMatrix);
			_smearBrush.graphics.drawRect (_imageHolder.mouseX - _brushSize,_imageHolder.mouseY - _brushSize,_brushSize * 2,_brushSize * 2);
			_smearBrush.graphics.endFill ();
			
			_bitmapDataCopy.draw (_smearBrush,new Matrix (),null,((_bitmapMouseX - _imageHolder.mouseX) > 0) ? "add":"subtract");
			_smearBrush.graphics.clear ();

			_smearBrush.graphics.beginGradientFill ("radial",[Math.abs((_bitmapMouseY - _imageHolder.mouseY) * 4) << 0,0],[100,0],[0,255],_smearMatrix);
			_smearBrush.graphics.drawRect (_imageHolder.mouseX - _brushSize,_imageHolder.mouseY - _brushSize,_brushSize * 2,_brushSize * 2);
			_smearBrush.graphics.endFill ();
			
			_bitmapDataCopy.draw (_smearBrush,new Matrix (),null,((_bitmapMouseY - _imageHolder.mouseY) > 0) ? "add":"subtract");
			_smearBrush.graphics.clear ();
			
			_bitmapMouseX = _imageHolder.mouseX;
			_bitmapMouseY = _imageHolder.mouseY;
			
			_bitmapDataCopyOutput.applyFilter (_bitmapData,_bitmapData.rect,new Point (),_displacementMapFilter);
			_bitmapOfImage.bitmapData = _bitmapDataCopyOutput;
		}
	}
}