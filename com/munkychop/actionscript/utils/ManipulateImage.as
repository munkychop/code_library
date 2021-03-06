package com.munkychop.actionscript.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Video;
	

	public class ManipulateImage
	{
		public static function getSnapshot (video:Video):Bitmap
		{
			var snapshot:BitmapData = new BitmapData(video.width,video.height);
			snapshot.draw (video, new Matrix());

			var bitmap:Bitmap = new Bitmap(snapshot);

			return bitmap;
		}

		public static function getAverageColour (source:BitmapData):uint
		{
			var red:Number = 0;
			var green:Number = 0;
			var blue:Number = 0;

			var count:Number = 0;
			var pixel:Number;

			for (var xPixel:int = 0; xPixel < source.width; xPixel++)
			{
				for (var yPixel:int = 0; yPixel < source.height; yPixel++)
				{
					pixel = source.getPixel(xPixel,yPixel);

					red += pixel >> 16 & 0xFF;
					green+=pixel>>8&0xFF;
					blue+=pixel&0xFF;

					count++;
				}
			}

			red/=count;
			green/=count;
			blue/=count;

			var avaerageColour:int=red<<16|green<<8|blue;

			trace ("avaerage colour: " + avaerageColour);
			trace ("red: " + red);
			trace ("green: " + green);
			trace ("blue: " + blue);

			return avaerageColour;
		}

		public static function cropBitmapData (image:Bitmap, xPos:Number, yPos:Number, cropWidth:Number, cropHeight:Number):Bitmap
		{
			//create a rectangle
			var cropRect:Rectangle=new Rectangle(xPos,yPos,cropWidth,cropHeight);
			//create new bitmap data - because BitmapData's width/height are read only
			var bmpData:BitmapData=new BitmapData(cropWidth,cropHeight);

			bmpData.copyPixels ( image.bitmapData, cropRect, new Point(xPos, yPos));
			//assign the cropped bitmap data to the image.

			var bitmap:Bitmap=new Bitmap(bmpData);

			//flip the bitmap so it is mirrored, like the camera
			bitmap.scaleX=-1;
			//the registration point is now the top-right corner, so push the bitmap's x to its width to effectively move it to 0.0.
			bitmap.x=bitmap.width;

			return bitmap;
		}

		public static function makeGreyscale (image:MovieClip):void
		{
			// Make Grey
			var r:Number = 0.212671;
			var g:Number = 0.715160;
			var b:Number = 0.072169;

			var matrix:Array = new Array ();
			matrix = matrix.concat([r,g,b,0,0]);// red
			matrix = matrix.concat([r,g,b,0,0]);// green
			matrix = matrix.concat([r,g,b,0,0]);// blue
			matrix = matrix.concat([0,0,0,1,0]);// alpha
			
			image.filters = [new ColorMatrixFilter(matrix)];

			//To return the image to the default state just clear the ColorMatrixFilter:
			//image.filters = [new ColorMatrixFilter()];
		}
		
		public static function setTint (object:MovieClip, tintAmount:Number = 1, colourHex:Number = 0xF87738):void
		{
			var colour:Color = new Color ();
			colour.setTint (colourHex, tintAmount);
			//var colourTransform:ColorTransform = object.transform.colorTransform;
			object.transform.colorTransform = colour;
		}
		
		public static function setBlendMode (object:MovieClip, blendType:String):void
		{
			object.blendMode = BlendMode[blendType];
		}
		
		public static function addOverlay (objectX:Number, objectY:Number, objectWidth:Number, objectHeight:Number, objectAlpha:Number = 1):MovieClip
		{
			var object:MovieClip = new MovieClip ();
			
			
			//I could add the 'overlay' blendmode to the 'object' mc from here instead of in a separate function,
			//since this function is called 'addOverlay'!
			
			object.alpha = objectAlpha;
			object.graphics.beginFill (0xFFFFFF);
            object.graphics.drawRect (objectX, objectY, objectWidth, objectHeight);
          	object.graphics.endFill ();
			
			return object;
		}
		
		public static function addHitArea (objectX:Number, objectY:Number, objectWidth:Number, objectHeight:Number):MovieClip
		{
			var object:MovieClip = new MovieClip ();
			object.graphics.beginFill (0xFFFFFF);
            object.graphics.drawRect (objectX, objectY, objectWidth, objectHeight);
          	object.graphics.endFill ();
			return object;
		}
	}
}