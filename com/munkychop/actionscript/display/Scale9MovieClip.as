// TODO : add logic to use a gradient for the moviclip colour
// TODO : add logic to use an outline

package com.munkychop.display
{
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.display.MovieClip;

	public class Scale9MovieClip extends MovieClip
	{
		// -----------------------------------------------------
		// constructor vars
		// -----------------------------------------------------

		private var _rectWidth:Number;
		private var _rectHeight:Number;
		private var _ellipseSize:Number;
		private var _colour:uint;
		private var _label:String;
		private var _textFormat:TextFormat;
		private var _autoScale:Boolean;

		// -----------------------------------------------------


		private var _width:Number;
		private var _height:Number;
		private var _labelTextField:TextField;

		private var _spriteContainer:Sprite;
		private var _centreSprite:Sprite;
		private var _topSprite:Sprite;
		private var _rightSprite:Sprite;
		private var _bottomSprite:Sprite;
		private var _leftSprite:Sprite;
		private var _topLeftSprite:Sprite;
		private var _topRightSprite:Sprite;
		private var _bottomRightSprite:Sprite;
		private var _bottomLeftSprite:Sprite;


		public function Scale9MovieClip (p_rectWidth:Number, p_rectHeight:Number, p_ellipseSize:Number = 6, p_colour:uint = 0x0, p_label:String = null, p_textFormat:TextFormat = null, p_autoScaleToTextSize:Boolean = true)
		{
			_rectWidth = p_rectWidth;
			_rectHeight = p_rectHeight;
			_ellipseSize = p_ellipseSize;
			_colour = p_colour;
			_label = p_label;
			_textFormat = p_textFormat;
			_autoScale = p_autoScaleToTextSize;

			_spriteContainer = new Sprite ();
			addChild (_spriteContainer);

			_labelTextField = new TextField ();
			_labelTextField.autoSize = TextFieldAutoSize.LEFT;
			if (_textFormat) _labelTextField.defaultTextFormat = _textFormat;
			addChild (_labelTextField);

			init ();
		}

		override public function set width (p_width:Number):void
		{
			_width = p_width;

			_centreSprite.width = _topSprite.width = _bottomSprite.width = _width;
			_rightSprite.x = _topRightSprite.x = _bottomRightSprite.x = _centreSprite.x + _centreSprite.width;
			
			positionLabel ();
		}

		override public function set height (p_height:Number):void
		{
			_height = p_height;

			_centreSprite.height = _leftSprite.height = _rightSprite.height = _height;
			_bottomSprite.y = _bottomLeftSprite.y = _bottomRightSprite.y = _centreSprite.y + _centreSprite.height;
			
			positionLabel ();
		}

		public function get label ():String
		{
			return _label;
		}

		public function set label (p_label:String):void
		{
			_label = p_label;
			_labelTextField.text = _label;

			if (_autoScale)
			{
				this.width = _labelTextField.width + (_ellipseSize * 2);
				this.height = _labelTextField.height + (_ellipseSize * 2);
				
				positionLabel ();
			}
		}
		
		public function hideLabel ():void
		{
			_labelTextField.alpha = 0;
		}
		
		public function showLabel ():void
		{
			_labelTextField.alpha = 1;
		}
		
		public function clearLabel ():void
		{
			_labelTextField.text = "";
		}
		
		private function positionLabel ():void
		{
			_labelTextField.x = (this.width - _labelTextField.width) * .5;
			_labelTextField.y = (this.height - _labelTextField.height) * .5;
		}

		private function init ():void
		{
			_centreSprite = new Sprite ();
			_centreSprite.x = _ellipseSize;
			_centreSprite.y = _ellipseSize;
			_centreSprite.graphics.beginFill (_colour);
			_centreSprite.graphics.drawRect (0, 0, _rectWidth - (_ellipseSize * 2), _rectHeight - (_ellipseSize * 2));
			_centreSprite.graphics.endFill ();
			_spriteContainer.addChild (_centreSprite);

			_topSprite = new Sprite ();
			_topSprite.x = _ellipseSize;
			_topSprite.graphics.beginFill (_colour);
			_topSprite.graphics.drawRect (0, 0, _centreSprite.width, _ellipseSize);
			_topSprite.graphics.endFill ();
			_spriteContainer.addChild (_topSprite);

			_rightSprite = new Sprite ();
			_rightSprite.x = _ellipseSize + _centreSprite.width;
			_rightSprite.y = _ellipseSize;
			_rightSprite.graphics.beginFill (_colour);
			_rightSprite.graphics.drawRect (0, 0, _ellipseSize, _centreSprite.height);
			_rightSprite.graphics.endFill ();
			_spriteContainer.addChild (_rightSprite);

			_bottomSprite = new Sprite ();
			_bottomSprite.x = _ellipseSize;
			_bottomSprite.y = _ellipseSize + _centreSprite.height;
			_bottomSprite.graphics.beginFill (_colour);
			_bottomSprite.graphics.drawRect (0, 0, _centreSprite.width, _ellipseSize);
			_bottomSprite.graphics.endFill ();
			_spriteContainer.addChild (_bottomSprite);

			_leftSprite = new Sprite ();
			_leftSprite.y = _ellipseSize;
			_leftSprite.graphics.beginFill (_colour);
			_leftSprite.graphics.drawRect (0, 0, _ellipseSize, _centreSprite.height);
			_leftSprite.graphics.endFill ();
			_spriteContainer.addChild (_leftSprite);


			_topLeftSprite = new Sprite ();
			_topLeftSprite.graphics.beginFill (_colour);
			_topLeftSprite.graphics.moveTo (_ellipseSize, 0);
			_topLeftSprite.graphics.lineTo (_ellipseSize, _ellipseSize);
			_topLeftSprite.graphics.lineTo (0, _ellipseSize);
			_topLeftSprite.graphics.curveTo (0, 0, _ellipseSize, 0);
			_topLeftSprite.graphics.endFill ();
			_spriteContainer.addChild (_topLeftSprite);

			_topRightSprite = new Sprite ();
			_topRightSprite.x = _ellipseSize + _centreSprite.width;
			_topRightSprite.graphics.beginFill (_colour);
			_topRightSprite.graphics.curveTo (_ellipseSize, 0, _ellipseSize, _ellipseSize);
			_topRightSprite.graphics.lineTo (0, _ellipseSize);
			_topRightSprite.graphics.lineTo (0, 0);
			_spriteContainer.addChild (_topRightSprite);

			_bottomRightSprite = new Sprite ();
			_bottomRightSprite.x = _topRightSprite.x;
			_bottomRightSprite.y = _centreSprite.height + _ellipseSize;
			_bottomRightSprite.graphics.beginFill (_colour);
			_bottomRightSprite.graphics.lineTo (_ellipseSize, 0);
			_bottomRightSprite.graphics.curveTo (_ellipseSize, _ellipseSize, 0, _ellipseSize);
			_bottomRightSprite.graphics.lineTo (0, 0);
			_spriteContainer.addChild (_bottomRightSprite);

			_bottomLeftSprite = new Sprite ();
			_bottomLeftSprite.y = _bottomRightSprite.y;
			_bottomLeftSprite.graphics.beginFill (_colour);
			_bottomLeftSprite.graphics.lineTo (_ellipseSize, 0);
			_bottomLeftSprite.graphics.lineTo (_ellipseSize, _ellipseSize);
			_bottomLeftSprite.graphics.curveTo (0, _ellipseSize, 0, 0);
			_bottomLeftSprite.graphics.endFill ();
			_spriteContainer.addChild (_bottomLeftSprite);
		}
	}
}