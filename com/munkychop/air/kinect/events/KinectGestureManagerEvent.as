package com.munkychop.air.kinect.events
{
	import com.munkychop.air.kinect.controller.KinectGestureManager;
	import flash.events.Event;

	/**
	 * @author munkychop
	 */
	public class KinectGestureManagerEvent extends Event
	{
		public static const READY_FOR_REMOVAL:String = "readyForRemoval";	
		
		public var gestureManager:KinectGestureManager;
		
		public function KinectGestureManagerEvent (type:String, gestureManager:KinectGestureManager, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super (type, bubbles, cancelable);
			
			this.gestureManager = gestureManager;
		}
		
		override public function clone ():Event
		{
			return new KinectGestureManagerEvent (type, gestureManager, bubbles, cancelable);
		}
	}
}
