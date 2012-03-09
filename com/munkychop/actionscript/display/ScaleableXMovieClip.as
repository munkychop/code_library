// TODO : add logic to use a gradient for the moviclip colour
// TODO : add logic to use an outline

package com.munkychop.display
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class ScaleableXMovieClip extends MovieClip
	{
		// -----------------------------------------------------
		// constructor vars
		// -----------------------------------------------------
		private var _rectWidth:Number;
		private var _rectHeight:Number;
		private var _labelColour:uint;
		private var _label:String;
		private var _textFormat:TextFormat;
		private var _embedFonts:Boolean;
		private var _autoScale:Boolean;

		// -----------------------------------------------------


		private var _width:Number;
		private var _labelTextField:TextField;
		private var _middleSprite:Sprite;
		private var _leftPanel:DisplayObject;
		private var _rightPanel:DisplayObject;
		private var _middlePanel:DisplayObject;
		private var _leftPanelRollOver:DisplayObject;
		private var _rightPanelRollOver:DisplayObject;
		private var _middlePanelRollOver:DisplayObject;


		public function ScaleableXMovieClip (p_rectWidth:Number, p_leftPanel:DisplayObject, p_rightPanel:DisplayObject, p_middlePanel:DisplayObject = null, p_leftPanelRollOver:DisplayObject = null, p_rightPanelRollOver:DisplayObject = null, p_middlePanelRollOver:DisplayObject = null,  p_textFormat:TextFormat = null, p_embedFonts:Boolean = false, p_label:String = null, p_labelColour:uint = 0x0, p_autoScaleToTextSize:Boolean = true)
		{
			_rectWidth = p_rectWidth;
			_leftPanel = p_leftPanel;
			_rightPanel = p_rightPanel;
			_middlePanel = p_middlePanel;
			_leftPanelRollOver = p_leftPanelRollOver;
			_rightPanelRollOver = p_rightPanelRollOver;
			_middlePanelRollOver = p_middlePanelRollOver;
			_textFormat = p_textFormat;
			_embedFonts = p_embedFonts;
			_label = p_label;
			_labelColour = p_labelColour;
			_autoScale = p_autoScaleToTextSize;

			addChild (_leftPanel);
			addChild (_rightPanel);
			
			if (_middlePanel)
			{
				_middlePanel.x = _leftPanel.width;
				addChild (_middlePanel);
				
				_rightPanel.x = _middlePanel.x + _middlePanel.width;
			}
			
			if (_leftPanelRollOver)
			{
				_leftPanelRollOver.alpha = 0;
				addChild (_leftPanelRollOver);
			}
			
			if (_rightPanelRollOver)
			{
				_rightPanelRollOver.alpha = 0;
				addChild (_rightPanelRollOver);
			}
			
			if (_middlePanelRollOver)
			{
				_middlePanelRollOver.alpha = 0;
				addChild (_middlePanelRollOver);
			}

			init ();
		}

		override public function set width (p_width:Number):void
		{
			_width = p_width;

			if (_middlePanel)
			{
				_middlePanel.width = _width - _rightPanel.width - _leftPanel.width;
				_rightPanel.x = _middlePanel.x + _middlePanel.width;
			}
			else
			{
				_middleSprite.width = _width - _rightPanel.width - _leftPanel.width;
				_rightPanel.x = _middleSprite.x + _middleSprite.width;
			}

			positionLabel ();
		}

		public function get label ():String
		{
			return _label;
		}

		public function set label (p_label:String):void
		{
			_label = p_label;
			_labelTextField.htmlText = _label;

			if (_autoScale)
			{
				this.width = _labelTextField.width + _leftPanel.width + _rightPanel.width;

				positionLabel ();
			}
		}
		
		public function get leftPanel ():DisplayObject
		{
			return _leftPanel;
		}
		
		public function get rightPanel ():DisplayObject
		{
			return _rightPanel;
		}
		
		public function get middlePanel ():DisplayObject
		{
			return _middlePanel;
		}
		
		public function get leftPanelRollOver ():DisplayObject
		{
			return _leftPanelRollOver;
		}
		
		public function get rightPanelRollOver ():DisplayObject
		{
			return _rightPanelRollOver;
		}
		
		public function get middlePanelRollOver ():DisplayObject
		{
			return _middlePanelRollOver;
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
			_labelTextField.htmlText = "";
		}

		private function positionLabel ():void
		{
			_labelTextField.x = (this.width - _labelTextField.width) * .5;
			_labelTextField.y = (this.height - _labelTextField.height) * .5;
		}

		private function init ():void
		{
			_rectHeight = _leftPanel.height;

			if (!_middlePanel)
			{
				_middleSprite = new Sprite ();
				_middleSprite.x = _leftPanel.x;
				_middleSprite.graphics.beginFill (_labelColour);
				_middleSprite.graphics.drawRect (0, 0, _rectWidth, _rectHeight);
				_middleSprite.graphics.endFill ();
				addChild (_middleSprite);
			}

			_labelTextField = new TextField ();
			_labelTextField.autoSize = TextFieldAutoSize.LEFT;
			_labelTextField.selectable = false;
			_labelTextField.antiAliasType = AntiAliasType.ADVANCED;
			_labelTextField.embedFonts = _embedFonts;
			if (_textFormat) _labelTextField.defaultTextFormat = _textFormat;
			if (_label) label = _label;
			addChild (_labelTextField);
		}
	}
}