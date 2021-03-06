package com.munkychop.actionscript.display
{
	import flash.display.DisplayObject;
	import com.greensock.TweenLite;
	
	import fl.motion.Color;

	public class ManipulateImage
	{
		public static function setTint (object:DisplayObject, colourHex:Number = 0x000000, tintStrength:Number = 1):void
		{
			var colour:Color = new Color ();
			colour.setTint (colourHex, tintStrength);
			object.transform.colorTransform = colour;
		}
		
		public static function tweenTint (object:DisplayObject, speed:Number, colourHex:Number = 0x000000, tintStrength:Number = 1):void
		{
			TweenLite.to (object, speed, {colorTransform:{tint:colourHex, tintAmount:tintStrength}});
		}
	}
}