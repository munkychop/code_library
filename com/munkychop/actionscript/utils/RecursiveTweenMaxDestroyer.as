package com.munkychop.utils
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.describeType;


	/**
	 * @author ihayes
	 */
	public class RecursiveTweenMaxDestroyer
	{
		private var _kill:Boolean;
		private var _suppressEvents:Boolean;
		private var _skipRender:Boolean;

		// this class works on instances of both TweenLite and TweenMax, but utilizes some functionality of TweenMax to run ;)
		public function RecursiveTweenMaxDestroyer ()
		{
		}

		// destroys all tweens recursively starting at with the passed parent object
		// if 'kill' is passed as true then 'forceComplete' and 'skipRender' are ignored.
		public function destroyAllTweens (p_parentObject:Object, p_kill:Boolean, p_skipRender:Boolean = false, p_suppressEvents:Boolean = false):void
		{
			_kill = p_kill;
			_skipRender = p_skipRender;
			_suppressEvents = p_suppressEvents;

			destroyTweensAndChildTweensOf (p_parentObject);
		}
		
		// FIXME : add a param to pass in an array of method names to skip (as strings). 
		// destroys all delayed calls within the scope of the passed object.
		public function destroyAllDelayedCalls (p_parentObject:Object):void
		{
			trace ("destroying all delayed calls within scope: " + p_parentObject);
			var descriptionXML:XML = describeType (p_parentObject);
			
			for each (var methodName:String in descriptionXML["method"].@name)
			{
				trace ("destroying delayed call to: " + methodName);
				TweenMax.killDelayedCallsTo (p_parentObject[methodName]);
			}
		}

		private function destroyTweensAndChildTweensOf (p_object:Object):void
		{
			if (p_object is DisplayObjectContainer)
			{
				var displayObjectContainer:DisplayObjectContainer = p_object as DisplayObjectContainer;
				var currentTweenArray:Array;

				if (_kill)
				{
					TweenMax.killTweensOf (displayObjectContainer);
				}
				else
				{
					currentTweenArray = TweenMax.getTweensOf (displayObjectContainer);

					completeAllTweensInArray (currentTweenArray);
				}

				var i:int = 0;
				var length:uint = displayObjectContainer.numChildren;
				var currentChildObject:Object;
				var childDisplayObjectContainer:DisplayObjectContainer;
				var childDisplayObject:DisplayObject;
				
				trace ("RecursiveTweenMaxDestroyer:: [destroyTweensAndChildTweensOf] length = " + length);
				for (i; i < length; i++)
				{
					currentChildObject = displayObjectContainer.getChildAt (i);
					//trace ("RecursiveTweenMaxDestroyer:: [destroyTweensAndChildTweensOf] looping... currentChildObject = " + currentChildObject + " i = " + i + ", length = " + length);

					if (currentChildObject is DisplayObjectContainer)
					{
						childDisplayObjectContainer = currentChildObject as DisplayObjectContainer;

						if (_kill)
						{
							TweenMax.killTweensOf (childDisplayObjectContainer);
						}
						else
						{
							currentTweenArray = TweenMax.getTweensOf (childDisplayObjectContainer);

							completeAllTweensInArray (currentTweenArray);
						}

						destroyTweensAndChildTweensOf (childDisplayObjectContainer);
					}
					else if (currentChildObject is DisplayObject)
					{
						childDisplayObject = currentChildObject as DisplayObject;

						if (_kill)
						{
							TweenMax.killTweensOf (childDisplayObject);
						}
						else
						{
							currentTweenArray = TweenMax.getTweensOf (childDisplayObject);

							completeAllTweensInArray (currentTweenArray);
						}
					}
				}
			}
			else if (p_object is DisplayObject)
			{
				var displayObject:DisplayObject = p_object as DisplayObject;

				if (_kill)
				{
					TweenMax.killTweensOf (displayObject);
				}
				else
				{
					currentTweenArray = TweenMax.getTweensOf (displayObject);

					completeAllTweensInArray (currentTweenArray);
				}
			}
		}

		private function completeAllTweensInArray (p_array:Array):void
		{
			var i:int = 0;
			var length:uint = p_array.length;
			var currentTween:TweenLite;


			for (i; i < length; i++)
			{
				// TweenMax extends TweenLite, so we can cast the object as an instance of TweenLite.
				currentTween = p_array[i] as TweenLite;
				currentTween.complete (_skipRender, _suppressEvents);
			}
		}
	}
}
