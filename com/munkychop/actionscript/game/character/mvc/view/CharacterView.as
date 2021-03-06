package com.munkychop.actionscript.game.character.mvc.view
{
	import com.munkychop.actionscript.events.StaticEventDispatcher;
	import com.munkychop.actionscript.game.character.events.CharacterEvent;

	import flash.display.MovieClip;
	import flash.events.Event;
	
	

	public class CharacterView extends MovieClip
	{
		//-------------------------------------------------------------------------------
		//--constructor
		//-------------------------------------------------------------------------------
		public function CharacterView ()
		{
			trace ("[CharacterView] constructed.");
			this.addEventListener (Event.ADDED_TO_STAGE, init);
		}
		
		//-------------------------------------------------------------------------------
		//--initialization
		//-------------------------------------------------------------------------------
		private function init (event:Event):void
		{
			this.removeEventListener (Event.ADDED_TO_STAGE, init);
			
			dispatchAddedToStage ();
		}
		
		//-------------------------------------------------------------------------------
		//--public API
		//-------------------------------------------------------------------------------
		
		// TODO: Create centreRegistrationPoint method, which needs to put the character in a container in some way. How will references get to the character?
		public function centreRegistrationPoint ():void
		{
		}
		
		//-------------------------------------------------------------------------------
		//--protected methods
		//-------------------------------------------------------------------------------
		protected function dispatchAddedToStage ():void
		{
			trace ("[CharacterView] added to display list");
			trace ("[CharacterView] dispatching CHARACTER_ADDED_TO_STAGE event");
			StaticEventDispatcher.dispatchEvent (new CharacterEvent (CharacterEvent.CHARACTER_ADDED_TO_STAGE));
		}
	}
}