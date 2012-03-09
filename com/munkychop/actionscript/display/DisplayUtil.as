package com.munkychop.actionscript.display
{
	import flash.display.DisplayObjectContainer;

	/**
	 * @author munkychop
	 */
	public class DisplayUtil extends DisplayObjectContainer
	{
		public static function addChildrenInto (p_parent:DisplayObjectContainer, p_children:Array):void
		{
			var i:int = 0;

			while (i < p_children.length)
			{
				p_parent.addChild (p_children[i]);
				i++;
			}
		}

		public static function removeChildrenFrom (p_parent:DisplayObjectContainer, p_children:Array, p_setToNull:Boolean = false):void
		{
			var i:int = 0;

			while (i < p_children.length)
			{
				if (p_children[i])
				{
					p_parent.removeChild (p_children[i]);

					if (p_setToNull) p_children[i] = null;
				}
				
				i++;
			}
		}
	}
}
