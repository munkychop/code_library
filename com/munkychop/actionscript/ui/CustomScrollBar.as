//-----------------------------------------------------------------
//
//CustomScrollBar by Ivan Hayes
//
//last updated:	30 July 2010 6:53am
//
//-----------------------------------------------------------------


package com.munkychop.actionscript.ui
{
	import com.greensock.TweenLite;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class CustomScrollBar extends MovieClip
	{
		//--------------------------------------------------------------------------------------------
		//--Public constants
		//--------------------------------------------------------------------------------------------
		public static const VERTICAL:String = "vertical";
		public static const HORIZONTAL:String = "horizontal";
		
		//--------------------------------------------------------------------------------------------
		//--Private Properties
		//--------------------------------------------------------------------------------------------
		private var _objectToMove:DisplayObject;
		private var _maskSize:Number;
		private var _scrollBarSize:Number;
		private var _barGraphic:MovieClip;
		private var _scrollBarOrientation:String;
		
		private var _bar:MovieClip;
		private var _line:Sprite;
		private var _initialObjectPos:Number;
		private var _minPos:int;
		private var _maxPos:Number;
		private var _mouseOffset:Number;
		private var _barPosPercentage:Number;
		
		private var _dragging:Boolean;
		
		//--------------------------------------------------------------------------------------------
		//--Constructor
		//--------------------------------------------------------------------------------------------
		public function CustomScrollBar (objectToMove:DisplayObject, maskSize:Number, scrollBarSize:Number, scrollBarOrientation:String = VERTICAL, barGraphic:MovieClip = null)
		{
			_objectToMove = objectToMove;
			_maskSize = maskSize;
			_scrollBarSize = scrollBarSize;
			_scrollBarOrientation = scrollBarOrientation;
			_barGraphic = barGraphic;
			
			init ();
		}
		
		//--------------------------------------------------------------------------------------------
		//--Getter/Setter Methods
		//--------------------------------------------------------------------------------------------
		public function get dragging ():Boolean
		{
			return _dragging;
		}
		
		public function set dragging (booleanValue:Boolean):void
		{
			_dragging = booleanValue;
		}
		
		//--------------------------------------------------------------------------------------------
		//--Initialization
		//--------------------------------------------------------------------------------------------
		private function init ():void
		{
			_dragging = false;
			
			if (_barGraphic == null)
			{
				_barGraphic = new MovieClip ();
				
				if (_scrollBarOrientation == VERTICAL)
				{
					_barGraphic.graphics.beginFill (0x333333);
					_barGraphic.graphics.drawRoundRect (0,0,10,30,10);
					_barGraphic.graphics.endFill ();
				}
				else
				{
					_barGraphic.graphics.beginFill (0x333333);
					_barGraphic.graphics.drawRoundRect (0,0,30,10,10);
					_barGraphic.graphics.endFill ();
				}
			}
			
			_barGraphic.buttonMode = true;
			
			_bar = new MovieClip ();
			_line = new Sprite ();
			
			_bar.addChild (_barGraphic);
			
			_minPos = 0;
			_line.graphics.lineStyle (1,0xC4C4C4);
			
			checkOrientation ();
			
			addChild (_line);
			addChild (_bar);
			
			this.addEventListener (Event.ADDED_TO_STAGE, makeDraggable);
		}
		
		//--------------------------------------------------------------------------------------------
		//--Public Methods
		//--------------------------------------------------------------------------------------------
		public function removeAllListeners ():void
		{
			this.stage.removeEventListener (MouseEvent.MOUSE_UP, mouseUpHandler);
			this.stage.removeEventListener (MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			_bar.removeEventListener (MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		//--------------------------------------------------------------------------------------------
		//--Private Methods
		//--------------------------------------------------------------------------------------------
		private function makeDraggable (event:Event):void
		{
			this.removeEventListener (Event.ADDED_TO_STAGE, makeDraggable);
			
			_bar.addEventListener (MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		private function checkOrientation ():void
		{
			if (_scrollBarOrientation == VERTICAL)
			{
				_initialObjectPos = _objectToMove.y;
				_maxPos = _scrollBarSize - _bar.height;
				_line.x = _bar.width/2;
				_line.graphics.lineTo (0,_scrollBarSize);
				
			}
			else if (_scrollBarOrientation == HORIZONTAL)
			{
				_initialObjectPos = _objectToMove.x;
				_maxPos = _scrollBarSize - _bar.width;
				
				_line.y = _bar.height/2;
				_line.graphics.lineTo (_scrollBarSize,0);
			}
		}
		
		private function mouseDownHandler (event:MouseEvent):void
		{
			_bar.removeEventListener (MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.stage.addEventListener (MouseEvent.MOUSE_UP, mouseUpHandler);
			
			_dragging = true;
			
			if (_scrollBarOrientation == VERTICAL)
			{
				_mouseOffset = mouseY - event.currentTarget.y;
			}
			else if (_scrollBarOrientation == HORIZONTAL)
			{
				_mouseOffset = mouseX - event.currentTarget.x;
			}
			
			this.stage.addEventListener (MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		private function mouseUpHandler (event:MouseEvent):void
		{
			this.stage.removeEventListener (MouseEvent.MOUSE_UP, mouseUpHandler);
			this.stage.removeEventListener (MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			
			_dragging = false;
			
			_bar.addEventListener (MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
		}
		
		private function mouseMoveHandler (event:MouseEvent):void
		{
			if (_scrollBarOrientation == VERTICAL)
			{
				_bar.y = mouseY - _mouseOffset;
			
				if (_bar.y <= _minPos)
				{
					_bar.y = _minPos;
				}
				
				if (_bar.y >= _maxPos)
				{
					_bar.y = _maxPos;
				}
				
				_barPosPercentage = _bar.y / _maxPos;
				
				//either use TweenLite or the algorythm below
				TweenLite.to (_objectToMove, .4, {y: _initialObjectPos -_barPosPercentage * (_objectToMove.height - _maskSize)});
				//_objectToMove.y = _initialObjectPos -_barPosPercentage * (_objectToMove.height - _maskSize);
			}
			else if (_scrollBarOrientation == HORIZONTAL)
			{
				_bar.x = mouseX - _mouseOffset;
			
				if (_bar.x <= _minPos)
				{
					_bar.x = _minPos;
				}
				
				if (_bar.x >= _maxPos)
				{
					_bar.x = _maxPos;
				}
				
				_barPosPercentage = _bar.x / _maxPos;
				
				//either use TweenLite or the algorythm below
				TweenLite.to (_objectToMove, .4, {x: _initialObjectPos -_barPosPercentage * (_objectToMove.width - _maskSize)});
				//_objectToMove.x = _initialObjectPos -_barPosPercentage * (_objectToMove.width - _maskSize);
			}
			
			event.updateAfterEvent ();
		}
	}
}