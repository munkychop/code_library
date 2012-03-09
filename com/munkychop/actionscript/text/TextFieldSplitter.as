package com.munkychop.actionscript.text
{
	import com.greensock.TweenLite;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	
	public class TextFieldSplitter
	{
		//-------------------------------------------------------------------------------
		//--private static constants
		//-------------------------------------------------------------------------------
		private static const DEFAULT_GUTTER_SIZE:int = 2;
		
		//-------------------------------------------------------------------------------
		//--public static methods
		//-------------------------------------------------------------------------------
		// TODO: improve by allowing arrays of textfields to be passed in.
		public static function splitToSpritesWithTextFields (p_textField:TextField, p_textFormat:TextFormat=null):Sprite
		{
			var container:Sprite = new Sprite ();
			container.graphics.beginFill (0x000000, 0);
			container.graphics.drawRect (0,0,p_textField.width, p_textField.height);
			container.graphics.endFill ();
			
			for (var i:int = 0; i < p_textField.length; i++)
			{
				var charSprite:Sprite = new Sprite ();
				var charTextField:TextField = new TextField ();
				
				charTextField.embedFonts = true;
				charTextField.antiAliasType = AntiAliasType.ADVANCED;
				charTextField.autoSize = TextFieldAutoSize.LEFT;
				
				p_textFormat != null ? charTextField.defaultTextFormat = p_textFormat : charTextField.defaultTextFormat =  p_textField.defaultTextFormat;
				
				charTextField.text = p_textField.text.charAt (i);
				
				charSprite.x = p_textField.getCharBoundaries (i).x - DEFAULT_GUTTER_SIZE * 2;
				charSprite.y = p_textField.getCharBoundaries (i).y - DEFAULT_GUTTER_SIZE;
								
				//trace (p_textField.getCharBoundaries (i));
				
				//if (i == p_textField.length -1) trace ("\n\n");
				
				charSprite.addChild (charTextField);
				container.addChild (charSprite);
			}
			
			return container;
		}
		
		public static function splitToSpritesWithBitmaps (p_textField:TextField):Sprite
		{
			var container:Sprite = new Sprite ();
			
			for (var i:int = 0; i < p_textField.length; i++)
			{
				var bmd:BitmapData = new BitmapData (p_textField.getCharBoundaries (i).width + DEFAULT_GUTTER_SIZE, p_textField..getCharBoundaries (i).height + DEFAULT_GUTTER_SIZE, true, 0x00000000);
				bmd.draw (p_textField);
				
				var bitmap:Bitmap = new Bitmap (bmd);
				var charSprite:Sprite = new Sprite ();
				
				charSprite.x = p_textField.getCharBoundaries (i).x - DEFAULT_GUTTER_SIZE * 2;
				charSprite.y = p_textField.getCharBoundaries (i).y - DEFAULT_GUTTER_SIZE;
				
				charSprite.addChild (bitmap);
				container.addChild (charSprite);
			}
			
			return container;
		}
		
		public static function explode (p_object:Sprite, p_speed:Number, p_delay:Number=0, p_minRangeX:int=-100, p_maxRangeX:int=100, p_minRangeY:int=-100, p_maxRangeY:int=100):void
		{
			TweenLite.to (p_object, p_speed, {x:String (randomRange (p_minRangeX, p_maxRangeX)), y:String (randomRange (p_minRangeY, p_maxRangeY)), delay:p_delay, alpha:0})
		}
		
		public static function explodeChildren (p_containerSprite:Sprite, p_speed:Number, p_delay:Number=0, p_minRangeX:int=-100, p_maxRangeX:int=100, p_minRangeY:int=-100, p_maxRangeY:int=100):void
		{
			for (var i:int = 0; i < p_containerSprite.numChildren; i++)
			{				
				TweenLite.to (p_containerSprite.getChildAt(i), p_speed, {x:String (randomRange (p_minRangeX, p_maxRangeX)), y:String (randomRange (p_minRangeY, p_maxRangeY)), delay:p_delay, alpha:0})
			}
		}
		
		//-------------------------------------------------------------------------------
		//--private static methods
		//-------------------------------------------------------------------------------
		private static function randomRange (p_min:Number, p_max:Number):Number
		{
			var randomNum:Number = Math.floor (Math.random () * (p_max - p_min + 1)) + p_min;
			return randomNum;
		}
	}
}