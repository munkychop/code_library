package com.munkychop.actionscript.game.character.mvc.controller
{
	import com.munkychop.actionscript.events.StaticEventDispatcher;
	import com.munkychop.actionscript.game.character.events.CharacterEvent;
	import com.munkychop.actionscript.game.character.mvc.model.CharacterModel;
	import com.munkychop.actionscript.ui.KeyboardInput;

	import flash.display.DisplayObject;
	import flash.events.Event;
	
	
    public class CharacterController
	{
		//-------------------------------------------------------------------------------
		//--protected properties
		//-------------------------------------------------------------------------------
		protected var _character:DisplayObject;
		protected var _characterModel:CharacterModel;
		protected var _keyboardInput:KeyboardInput;
		
		//-------------------------------------------------------------------------------
		//--constructor
		//-------------------------------------------------------------------------------
        public function CharacterController (character:DisplayObject)
		{
			_character = character;
			trace ("[CharacterController] constructed.");
			
			listenForCharacterAdded ();
        }
				
		//-------------------------------------------------------------------------------
		//--protected initialization
		//-------------------------------------------------------------------------------
		protected function listenForCharacterAdded ():void
		{
			trace ("[CharacterController] listening to static dispatcher for CHARACTER_ADDED_TO_STAGE event");
			StaticEventDispatcher.addEventListener (CharacterEvent.CHARACTER_ADDED_TO_STAGE, onCharacterAdded);
		}
		
		protected function onCharacterAdded (event:CharacterEvent):void
		{
			trace ("[CharacterController] CHARACTER_ADDED_TO_STAGE event received");
			init ();
		}
		
		protected function init ():void
		{
			trace ("[CharacterController] initializing keyboard for character: " + _character);
			_keyboardInput = new KeyboardInput (_character.stage);
			addModel ();
			_character.stage.addEventListener (Event.ENTER_FRAME, checkKeys);
		}
		
		//-------------------------------------------------------------------------------
		//--protected methods
		//-------------------------------------------------------------------------------
		protected function addModel ():void
		{
			trace ("[CharacterController] creating an instance of model: " + _characterModel);
			_characterModel = new CharacterModel ();
		}
		
		protected function setCharacterAttributes (characterSpeed:Number, jumpHeight:Number, gravity:Number, velocityY:Number):void
		{
			trace ("[CharacterController] setting character attributes for current model");
			_characterModel.characterSpeed = characterSpeed;
			_characterModel.jumpHeight = jumpHeight;
			_characterModel.gravity = gravity;
			_characterModel.velocityY = velocityY;
		}
		
		protected function getKeyboardInput ():void
		{
			if (_keyboardInput.isLeftKey ())
			{
				moveLeft ();
			}
			
			if (_keyboardInput.isRightKey ())
			{
				moveRight ();
			}
			
			if (_keyboardInput.isUpKey ())
			{
				jump ();
			}
		}
		
		protected function moveLeft ():void
		{
			_character.x -= _characterModel.characterSpeed;
		}
		
		protected function moveRight ():void
		{
			_character.x += _characterModel.characterSpeed;
		}
		
		protected function jump ():void
		{
			if (!_characterModel.jumping)
			{
				_characterModel.jumping = true;
				_characterModel.startY = _character.y;
				_character.addEventListener (Event.ENTER_FRAME, jumpLoop);
			}
		}
		
		
		//-------------------------------------------------------------------------------
		//--private methods
		//-------------------------------------------------------------------------------
		private function checkKeys (event:Event):void
		{
			getKeyboardInput ();
		}
		
		private function jumpLoop (event:Event):void
		{
			_characterModel.velocityY -= _characterModel.gravity;
			_character.y -= _characterModel.velocityY;
			
			if (_character.y >= _characterModel.startY)
			{
				_character.removeEventListener (Event.ENTER_FRAME, jumpLoop);
				
				_character.y = _characterModel.startY;
				_characterModel.velocityY = _characterModel.jumpHeight;
				_characterModel.jumping = false;
			}
		}
    }
}