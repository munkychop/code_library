/*
KeyboardInput class

author:		munkychop
website:	www.munkychop.com
date:		20/10/2009 (6:42pm GMT)
version:	1.0
license:	MIT - open source :)

*/

package com.munkychop.actionscript.ui
{
	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
    public class KeyboardInput
	{
		//-------------------------------------------------------------------------------
		//--private properties
		//-------------------------------------------------------------------------------
		private var _pressUp:Boolean = false;
        private var _pressRight:Boolean = false;
        private var _pressDown:Boolean = false;
		private var _pressLeft:Boolean = false;
		private var _pressShift:Boolean = false;
		private var _pressSpacebar:Boolean = false;
		
		private var _pressW:Boolean = false;
		private var _pressD:Boolean = false;
		private var _pressS:Boolean = false;
		private var _pressA:Boolean = false;
		private var _pressL:Boolean = false;
		
		//-------------------------------------------------------------------------------
		//--constructor
		//-------------------------------------------------------------------------------
        public function KeyboardInput (stageForTheKeyboard:DisplayObjectContainer)
		{
			//trace ("[KeyboardInput] OK");
            stageForTheKeyboard.stage.addEventListener (KeyboardEvent.KEY_DOWN, keyIsDown);
            stageForTheKeyboard.stage.addEventListener (KeyboardEvent.KEY_UP, keyIsUp);
        }
		
		//-------------------------------------------------------------------------------
		//--public API
		//-------------------------------------------------------------------------------
        public function isLeftKey ():Boolean
		{
            return _pressLeft;
        }
		
        public function isRightKey ():Boolean
		{
            return _pressRight;
        }
		
        public function isUpKey ():Boolean
		{
            return _pressUp;
        }
		
        public function isDownKey ():Boolean
		{
            return _pressDown;
        }
		
		public function isLKey ():Boolean
		{
            return _pressL;
        }
		
		public function isAKey ():Boolean
		{
            return _pressA;
        }
		
		public function isDKey ():Boolean
		{
            return _pressD;
        }
		
		public function isWKey ():Boolean
		{
            return _pressW;
        }
		
		public function isSKey ():Boolean
		{
            return _pressS;
        }
		
		public function isShiftKey ():Boolean
		{
			return _pressShift;
		}
		
		public function isSpacebar ():Boolean
		{
            return _pressSpacebar;
        }
		
		//-------------------------------------------------------------------------------
		//--private methods
		//-------------------------------------------------------------------------------
        private function keyIsDown (event:KeyboardEvent):void
		{
			//trace (event.keyCode);
			
			switch (event.keyCode)
			{
				case 	Keyboard.UP		:	_pressUp = true;
				break;
				
				case 	Keyboard.RIGHT	:	_pressRight = true;
				break;
				
				case 	Keyboard.LEFT	:	_pressLeft = true;
				break;
				
				case 	Keyboard.DOWN	:	_pressDown = true;
				break;
				
				case 	Keyboard.SHIFT	:	_pressShift = true;
				break;
				
				case 	Keyboard.SPACE	:	_pressSpacebar = true;
				break;
				
				case 	87				:	_pressW = true; // key: W
				break;
				
				case 	68				:	_pressD = true; // key: D
				break;
				
				case 	83				:	_pressS = true; // key: S
				break;
				
				case 	65				:	_pressA = true; // key: A
				break;
				
				case 	76				:	_pressL = true; // key: L
				break;
			}
        }
		
        private function keyIsUp (event:KeyboardEvent):void
		{
			//trace (event.keyCode);
			
			switch (event.keyCode)
			{
				case 	Keyboard.UP		:	_pressUp = false;
				break;
				
				case 	Keyboard.RIGHT	:	_pressRight = false;
				break;
				
				case 	Keyboard.LEFT	:	_pressLeft = false;
				break;
				
				case 	Keyboard.DOWN	:	_pressDown = false;
				break;
				
				case 	Keyboard.SHIFT	:	_pressShift = false;
				break;
				
				case 	Keyboard.SPACE	:	_pressSpacebar = false;
				break;
				
				case 	87				:	_pressW = false; // key: W
				break;
				
				case 	68				:	_pressD = false; // key: D
				break;
				
				case 	83				:	_pressS = false; // key: S
				break;
				
				case 	65				:	_pressA = false; // key: A
				break;
				
				case 	76				:	_pressL = false; // key: L
				break;
			}
        }
    }
}