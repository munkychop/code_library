package com.munkychop.actionscript.game.character.mvc.model
{
	import flash.events.EventDispatcher;
	
	public class CharacterModel extends EventDispatcher
	{
		//-------------------------------------------------------------------------------
		//--protected properties
		//-------------------------------------------------------------------------------
		protected var _startY:Number;
		protected var _jumpHeight:Number;
		protected var _characterSpeed:Number;
		protected var _velocityY:Number;
		protected var _gravity:Number;
		protected var _jumping:Boolean = false;
		
		public function CharacterModel ()
		{
			trace ("[CharacterModel] OK!");
			
			init ();
		}
		
		//-------------------------------------------------------------------------------
		//--initialization
		//-------------------------------------------------------------------------------
		protected function init ():void
		{
			_characterSpeed = 5;
			_jumpHeight = 24;
			_velocityY = _jumpHeight;
			_gravity = 2;
		}
		
		//-------------------------------------------------------------------------------
		//--getter/setter methods
		//-------------------------------------------------------------------------------
		
		public function get startY ():Number
		{
			return _startY;
		}
		
		public function set startY (value:Number):void
		{
			_startY = value;
		}
		
		public function get jumpHeight ():Number
		{
			return _jumpHeight;
		}
		
		public function set jumpHeight (value:Number):void
		{
			_jumpHeight = value;
		}
		
		public function get characterSpeed ():Number
		{
			return _characterSpeed;
		}
		
		public function set characterSpeed (value:Number):void
		{
			_characterSpeed = value;
		}
		
		public function get velocityY ():Number
		{
			return _velocityY;
		}
		
		public function set velocityY (value:Number):void
		{
			_velocityY = value;
		}
		
		public function get gravity ():Number
		{
			return _gravity;
		}
		
		public function set gravity (value:Number):void
		{
			_gravity = value;
		}
		
		public function get jumping ():Boolean
		{
			return _jumping;
		}
		
		public function set jumping (value:Boolean):void
		{
			_jumping = value;
		}
	}
}