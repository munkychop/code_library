package com.munkychop.air.kinect.events
{
	import flash.events.Event;

	/**
	 * @author munkychop
	 */
	public class KinectGestureEvent extends Event
	{
		public static const LEFT_HAND_OBJECT_ACTIVE:String = "leftHandObjectActive";
		public static const RIGHT_HAND_OBJECT_ACTIVE:String = "rightHandObjectActive";
		
		public static const LEFT_HAND_OBJECT_INACTIVE:String = "leftHandObjectInactive";
		public static const RIGHT_HAND_OBJECT_INACTIVE:String = "rightHandObjectInactive";
		
		public static const LEFT_HAND_PUSH:String = "leftHandPush";
		public static const RIGHT_HAND_PUSH:String = "rightHandPush";		
		
		public var data:Object;
		public var id:int;
		
		public function KinectGestureEvent (type:String, id:int, data:Object=null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super (type, bubbles, cancelable);
			
			this.data = data;
			this.id = id;
		}
		
		override public function clone ():Event
		{
			return new KinectGestureEvent (type, id, data, bubbles, cancelable);
		}
	}
}
