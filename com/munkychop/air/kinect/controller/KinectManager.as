/**
 * @author munkychop
 */

package com.munkychop.air.kinect.controller
{
	import com.munkychop.air.kinect.events.KinectGestureManagerEvent;
	import be.aboutme.as3osceleton.data.User;
	import be.aboutme.as3osceleton.events.UserEvent;
	import be.aboutme.as3osceleton.OSCeletonTuioCursorListener;

	import flash.display.Sprite;
	import flash.events.Event;

	import org.tuio.osc.OSCManager;
	import org.tuio.connectors.UDPConnector;

	public class KinectManager extends Sprite
	{
		protected var _trackGestures:Boolean;
		protected var _interactiveObjectArray:Array;
		
		private var _connector:UDPConnector;
		private var _oscManager:OSCManager;
		protected var _oscListener:OSCeletonTuioCursorListener;

		public function KinectManager (p_interactiveObjectArray:Array)
		{
			_trackGestures = false;
			_interactiveObjectArray = p_interactiveObjectArray;
			
			this.addEventListener (Event.ADDED_TO_STAGE, init);
		}

		private function init (event:Event):void
		{
			this.removeEventListener (Event.ADDED_TO_STAGE, init);

			_connector = new UDPConnector ("127.0.0.1", 7110);
			_oscManager = new OSCManager (_connector);
			_oscListener = new OSCeletonTuioCursorListener ();

			_oscManager.addMsgListener (_oscListener);

			_oscListener.osceletonManager.addEventListener (UserEvent.USER_JOINED, userJoinedHandler);
			_oscListener.osceletonManager.addEventListener (UserEvent.USER_LEFT, userLeftHandler);

			this.addEventListener (Event.ENTER_FRAME, update);
		}
		
		public function set trackGestures (p_value:Boolean):void
		{
			_trackGestures = p_value; 
		}
		
		public function set interactiveObjectArray (p_interactiveObjectArray:Array):void
		{
			_interactiveObjectArray = p_interactiveObjectArray;
		}

		protected function userJoinedHandler (event:UserEvent):void
		{
			trace ("KinectManager:: user joined");
			
			var user:User = event.user;
			user.addEventListener (UserEvent.SKELETON_CREATED, skeletonCreatedHandler);
		}

		protected function skeletonCreatedHandler (event:UserEvent):void
		{
			trace ("KinectManager:: skeleton created");

			var leftHand:Sprite = new Sprite ();

			leftHand.graphics.beginFill (0x0);
			leftHand.graphics.drawCircle (0, 0, 20);
			leftHand.graphics.endFill ();
			leftHand.name = "leftHand" + event.user.id;
			leftHand.x = (event.user.skeleton.r_hand.x * stage.stageWidth) - (leftHand.width * .5);
			leftHand.y = (event.user.skeleton.r_hand.y * stage.stageHeight)- (leftHand.height * .5);

			var rightHand:Sprite = new Sprite ();

			rightHand.graphics.beginFill (0x0);
			rightHand.graphics.drawCircle (0, 0, 20);
			rightHand.graphics.endFill ();
			rightHand.name = "rightHand" + event.user.id;
			rightHand.x = (event.user.skeleton.l_hand.x * stage.stageWidth) - (rightHand.width * .5);
			rightHand.y = (event.user.skeleton.l_hand.y * stage.stageHeight) - (rightHand.height * .5);

			addChild (leftHand);
			addChild (rightHand);
			
			if (_trackGestures)
			{
				var gestureManager:KinectGestureManager = new KinectGestureManager (event.user.id, leftHand, rightHand, _interactiveObjectArray);
				gestureManager.name = "gestureManager" + event.user.id;
				addChild (gestureManager);
			}
		}

		protected function userLeftHandler (event:UserEvent):void
		{
			trace ("KinectManager:: user left");
			
			var leftHand:Sprite = this.getChildByName ("leftHand" + event.user.id) as Sprite;
			var rightHand:Sprite = this.getChildByName ("rightHand" + event.user.id) as Sprite;
			var gestureManager:KinectGestureManager = this.getChildByName ("gestureManager" + event.user.id) as KinectGestureManager;

			if (leftHand) this.removeChild (leftHand);
			if (rightHand) this.removeChild (rightHand);

			if (gestureManager)
			{
				gestureManager.addEventListener (KinectGestureManagerEvent.READY_FOR_REMOVAL, removeGestureManager);
				gestureManager.destroy ();
			}
		}
		
		protected function removeGestureManager (event:KinectGestureManagerEvent):void
		{
			trace ("KinectManager:: gestureManager instance destroyed");
			this.removeChild (event.gestureManager);
		}

		protected function update (event:Event):void
		{
			for each (var user:User in _oscListener.osceletonManager.users)
			{
				var leftHand:Sprite = this.getChildByName ("leftHand" + user.id) as Sprite;
				var rightHand:Sprite = this.getChildByName ("rightHand" + user.id) as Sprite;
				var gestureManager:KinectGestureManager = this.getChildByName ("gestureManager" + user.id) as KinectGestureManager;

				if (leftHand)
				{
					leftHand.x = (user.skeleton.r_hand.x * stage.stageWidth) - (leftHand.width * .5);
					leftHand.y = (user.skeleton.r_hand.y * stage.stageHeight) - (leftHand.height * .5);
					leftHand.z = user.skeleton.r_hand.z;
				}

				if (rightHand)
				{
					rightHand.x = (user.skeleton.l_hand.x * stage.stageWidth) - (rightHand.width * .5);
					rightHand.y = (user.skeleton.l_hand.y * stage.stageHeight) - (rightHand.height * .5);
					rightHand.z = user.skeleton.l_hand.z;
				}

				if (_trackGestures && leftHand && rightHand && gestureManager) gestureManager.update ();
			}
		}
	}
}
