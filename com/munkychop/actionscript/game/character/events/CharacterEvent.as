package com.munkychop.actionscript.game.character.events
{
	import flash.events.Event;
	
	public class CharacterEvent extends Event
	{
		//-------------------------------------------------------------------------------
		//--public event constants
		//-------------------------------------------------------------------------------
		public static const CHARACTER_ADDED_TO_STAGE:String = "characterAddedToStage";
		
		//-------------------------------------------------------------------------------
		//--public properties
		//-------------------------------------------------------------------------------
		public var data:Object;
		
		//-------------------------------------------------------------------------------
		//--constructor
		//-------------------------------------------------------------------------------
		public function CharacterEvent (type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super (type, bubbles, cancelable);
			
			this.data = data;
		}
		
		//-------------------------------------------------------------------------------
		//--public overrides
		//-------------------------------------------------------------------------------
		override public function clone ():Event
		{
			return new CharacterEvent (type, data, bubbles, cancelable);
		}
	}
}