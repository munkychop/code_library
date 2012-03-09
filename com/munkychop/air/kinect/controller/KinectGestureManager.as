// FIXME : if users move their hands down when a button is active it sometimes gets pushed. So store the y-pos of the hand when the button is activated and only trigger the push event if the hand is still at roughly the same y-pos.

package com.munkychop.air.kinect.controller
{
	import be.aboutme.as3osceleton.data.Joint;
	import com.munkychop.air.kinect.events.KinectGestureManagerEvent;
	import com.munkychop.air.kinect.events.KinectGestureEvent;

	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author munkychop
	 */
	public class KinectGestureManager extends Sprite
	{
		private static const ACTIVATION_DELAY:Number = .5;
		private static const DETECT_GESTURE_COUNTDOWN:Number = .8;
		private static const PUSH_GESTURE_DISTANCE:Number = 8;

		protected var _leftHandTrackerSprite:Sprite;
		protected var _rightHandTrackerSprite:Sprite;

		private var _id:int;
		private var _head:Sprite;
		private var _torso:Sprite;
		private var _leftHand:Sprite;
		private var _rightHand:Sprite;
		private var _interactiveObjectArray:Array;

		private var _leftHandPushGesturesShouldBeTracked:Boolean;
		private var _rightHandPushGesturesShouldBeTracked:Boolean;
		private var _torsoCrouchGesturesShouldBeTracked:Boolean;
		private var _rightHandBlockGesturesShouldBeTracked:Boolean;
		private var _leftHandBlockGesturesShouldBeTracked:Boolean;
		private var _leftAndRightHandBlockHeadGesturesShouldBeTracked:Boolean;

		private var _currentlyTrackingLeftHandPushGestures:Boolean;
		private var _currentlyTrackingRightHandPushGestures:Boolean;
		private var _currentlyTrackingTorsoCrouchGestures:Boolean;
		private var _currentlyTrackingRightHandBlockGestures:Boolean;
		private var _currentlyTrackingLeftHandBlockGestures:Boolean;
		private var _currentlyTrackingLeftAndRightHandBlockHeadGestures:Boolean;

		private var _leftHandInteractiveObjectActivationTimer:Timer;
		private var _rightHandInteractiveObjectActivationTimer:Timer;
		private var _crouchGestureTimer:Timer;

		private var _leftHandPushGestureTimer:Timer;
		private var _rightHandPushGestureTimer:Timer;

		private var _currentLeftHandInteractiveObject:DisplayObject;
		private var _currentRightHandInteractiveObject:DisplayObject;

		private var _leftHandTrackingStartPosZ:Number;
		private var _rightHandTrackingStartPosZ:Number;
		private var _rightHandIsStillOnCurrentLeftHandActiveObject:Boolean;
		private var _leftHandIsStillOnCurrentRightHandActiveObject:Boolean;

		public function KinectGestureManager (p_id:int, p_head:Sprite, p_torso:Sprite, p_leftHand:Sprite, p_rightHand:Sprite, p_interactiveObjectArray:Array)
		{
			_id = p_id;
			_head = p_head;
			_torso = p_torso;
			_leftHand = p_leftHand;
			_rightHand = p_rightHand;
			_interactiveObjectArray = p_interactiveObjectArray;

			_leftHandPushGesturesShouldBeTracked = false;
			_rightHandPushGesturesShouldBeTracked = false;
			_torsoCrouchGesturesShouldBeTracked = false;
			_rightHandBlockGesturesShouldBeTracked = false;
			_leftHandBlockGesturesShouldBeTracked = false;
			_leftAndRightHandBlockHeadGesturesShouldBeTracked = false;

			_currentlyTrackingLeftHandPushGestures = false;
			_currentlyTrackingRightHandPushGestures = false;
			_currentlyTrackingTorsoCrouchGestures = false;
			_currentlyTrackingRightHandBlockGestures = false;
			_currentlyTrackingLeftHandBlockGestures = false;
			_currentlyTrackingLeftAndRightHandBlockHeadGestures = false;

			_leftHandInteractiveObjectActivationTimer = new Timer (ACTIVATION_DELAY * 1000, 1);
			// TODO : don't add this listener here... add/remove it whenever necessary instead.
			_leftHandInteractiveObjectActivationTimer.addEventListener (TimerEvent.TIMER, leftHandActivationTimerComplete);

			_rightHandInteractiveObjectActivationTimer = new Timer (ACTIVATION_DELAY * 1000, 1);
			// TODO : don't add this listener here... add/remove it whenever necessary instead.
			_rightHandInteractiveObjectActivationTimer.addEventListener (TimerEvent.TIMER, rightHandActivationTimerComplete);

			_leftHandPushGestureTimer = new Timer (DETECT_GESTURE_COUNTDOWN * 1000, 1);
			// TODO : don't add this listener here... add/remove it whenever necessary instead.
			_leftHandPushGestureTimer.addEventListener (TimerEvent.TIMER, leftHandGestureTimerComplete);

			_rightHandPushGestureTimer = new Timer (DETECT_GESTURE_COUNTDOWN * 1000, 1);
			// TODO : don't add this listener here... add/remove it whenever necessary instead.
			_rightHandPushGestureTimer.addEventListener (TimerEvent.TIMER, rightHandGestureTimerComplete);

			createTrackerSprites ();
		}

		public function get id ():int
		{
			return _id;
		}

		public function set interactiveObjectArray (p_interactiveObjectArray:Array):void
		{
			_interactiveObjectArray = p_interactiveObjectArray;
		}

		public function update ():void
		{
			_leftHandTrackerSprite.x = _leftHand.x;
			_leftHandTrackerSprite.y = _leftHand.y;

			_rightHandTrackerSprite.x = _rightHand.x;
			_rightHandTrackerSprite.y = _rightHand.y;

			if (_leftHandPushGesturesShouldBeTracked || _rightHandPushGesturesShouldBeTracked) interactiveObjectActivationHitTest ();
			if (_torsoCrouchGesturesShouldBeTracked) checkForCrouchGesture ();

		}

		public function activateCrouchGestureCheck (p_countdownTime:Number):void
		{
			if (!_currentlyTrackingTorsoCrouchGestures)
			{
				trace ("KinectGestureManager:: crouch gesture check activation successful");
				
				_currentlyTrackingTorsoCrouchGestures = true;
				_torsoCrouchGesturesShouldBeTracked = true;

				_crouchGestureTimer.delay = p_countdownTime * 1000;
				_crouchGestureTimer.addEventListener (TimerEvent.TIMER, crouchGestureTimerComplete);
				_crouchGestureTimer.start ();
			}
			else
			{
				trace ("KinectGestureManager:: failed to activate crouch gesture check... crouch gestures are being tracked already!");
			}

		}

		protected function crouchGestureTimerComplete (event:TimerEvent):void
		{
			_crouchGestureTimer.removeEventListener (TimerEvent.TIMER, crouchGestureTimerComplete);
			
			_currentlyTrackingTorsoCrouchGestures = false;
			_torsoCrouchGesturesShouldBeTracked = false;
		}

		protected function checkForCrouchGesture ():void
		{
			// if torso is at same y pos as knees
			{
				// dispatch event
				_crouchGestureTimer.stop ();
				_crouchGestureTimer.removeEventListener (TimerEvent.TIMER, crouchGestureTimerComplete);
				
				_currentlyTrackingTorsoCrouchGestures = false;
				_torsoCrouchGesturesShouldBeTracked = false;

				trace ("KinectGestureManager:: crouch gesture detected");
			}

		}

		public function addInteractiveObject (p_interactiveObject:DisplayObject):void
		{
			_interactiveObjectArray.push (p_interactiveObject);
		}

		public function removeInteractiveObject (p_interactiveObject:DisplayObject):void
		{
			if (_interactiveObjectArray.indexOf (p_interactiveObject) != -1)
			{
				for (var i:int = 0; i < _interactiveObjectArray.length; i++)
				{
					if (_interactiveObjectArray[i] == p_interactiveObject) _interactiveObjectArray.splice (i, 1);

					return;
				}
			}
		}

		public function destroy ():void
		{
			// FIXME : this class may need a 'getureManagerIsBeingDestroyed' Boolean in-case the update method continues to be called from the parent class even after the destroy method has been called.

			_leftHandInteractiveObjectActivationTimer.stop ();
			_leftHandInteractiveObjectActivationTimer.removeEventListener (TimerEvent.TIMER, leftHandActivationTimerComplete);
			_leftHandInteractiveObjectActivationTimer = null;

			_rightHandInteractiveObjectActivationTimer.stop ();
			_rightHandInteractiveObjectActivationTimer.removeEventListener (TimerEvent.TIMER, rightHandActivationTimerComplete);
			_rightHandInteractiveObjectActivationTimer = null;

			_leftHandPushGestureTimer.removeEventListener (TimerEvent.TIMER, leftHandGestureTimerComplete);
			_leftHandPushGestureTimer.stop ();
			_leftHandPushGestureTimer = null;

			_rightHandPushGestureTimer.removeEventListener (TimerEvent.TIMER, rightHandGestureTimerComplete);
			_rightHandPushGestureTimer.stop ();
			_rightHandPushGestureTimer = null;

			this.removeEventListener (Event.ENTER_FRAME, leftHandPushGestureStep);
			this.removeEventListener (Event.ENTER_FRAME, rightHandPushGestureStep);

			_leftHandTrackerSprite = null;
			_rightHandTrackerSprite = null;
			_leftHand = null;
			_rightHand = null;
			_interactiveObjectArray = null;

			_currentLeftHandInteractiveObject = null;
			_currentRightHandInteractiveObject = null;

			dispatchEvent (new KinectGestureManagerEvent (KinectGestureManagerEvent.READY_FOR_REMOVAL, this));
		}

		protected function createTrackerSprites ():void
		{
			// TODO : set the alpha property of the tracker objects to 0 within 'beginFill'
			_leftHandTrackerSprite = new Sprite ();
			_leftHandTrackerSprite.graphics.beginFill (0x00FF00);
			_leftHandTrackerSprite.graphics.drawRect (0, 0, 1, 1);
			_leftHandTrackerSprite.graphics.endFill ();

			addChild (_leftHandTrackerSprite);

			_rightHandTrackerSprite = new Sprite ();
			_rightHandTrackerSprite.graphics.beginFill (0x00FF00);
			_rightHandTrackerSprite.graphics.drawRect (0, 0, 1, 1);
			_rightHandTrackerSprite.graphics.endFill ();

			addChild (_rightHandTrackerSprite);
		}

		protected function interactiveObjectActivationHitTest ():void
		{
			for (var i:int = 0; i < _interactiveObjectArray.length; i++)
			{
				var interactiveObject:DisplayObject = _interactiveObjectArray[i] as DisplayObject;

				if (_leftHandPushGesturesShouldBeTracked && !_currentlyTrackingLeftHandPushGestures)
				{
					if (_leftHandTrackerSprite.hitTestObject (interactiveObject))
					{
						_currentlyTrackingLeftHandPushGestures = true;
						_currentLeftHandInteractiveObject = interactiveObject;
						_leftHandInteractiveObjectActivationTimer.reset ();
						_leftHandInteractiveObjectActivationTimer.start ();
					}
				}

				if (_rightHandPushGesturesShouldBeTracked && !_currentlyTrackingRightHandPushGestures)
				{
					if (_rightHandTrackerSprite.hitTestObject (interactiveObject))
					{
						_currentlyTrackingRightHandPushGestures = true;
						_currentRightHandInteractiveObject = interactiveObject;
						_rightHandInteractiveObjectActivationTimer.reset ();
						_rightHandInteractiveObjectActivationTimer.start ();
					}
				}
			}

			if (_leftHandPushGesturesShouldBeTracked)
			{
				if (_currentlyTrackingLeftHandPushGestures && !_leftHandTrackerSprite.hitTestObject (_currentLeftHandInteractiveObject))
				{
					trace ("left hand has moved off the current interactive object");
					_leftHandInteractiveObjectActivationTimer.stop ();
					_leftHandInteractiveObjectActivationTimer.reset ();
					_currentlyTrackingLeftHandPushGestures = false;

					// TODO : first check if this event listener exists before removing it... maybe setup a 'currentEnterFrame' object and remove any it contains
					this.removeEventListener (Event.ENTER_FRAME, leftHandPushGestureStep);

					_currentRightHandInteractiveObject == _currentLeftHandInteractiveObject ? _rightHandIsStillOnCurrentLeftHandActiveObject = true : _rightHandIsStillOnCurrentLeftHandActiveObject = false;

					_currentLeftHandInteractiveObject.dispatchEvent (new KinectGestureEvent (KinectGestureEvent.LEFT_HAND_OBJECT_INACTIVE, _id, {objectShouldStayActive:_rightHandIsStillOnCurrentLeftHandActiveObject}));
					_currentLeftHandInteractiveObject = null;
				}
			}

			if (_rightHandPushGesturesShouldBeTracked)
			{
				if (_currentlyTrackingRightHandPushGestures && !_rightHandTrackerSprite.hitTestObject (_currentRightHandInteractiveObject))
				{
					trace ("right hand has moved off the current interactive object");
					_rightHandInteractiveObjectActivationTimer.stop ();
					_rightHandInteractiveObjectActivationTimer.reset ();
					_currentlyTrackingRightHandPushGestures = false;

					// TODO : first check if this event listener exists before removing it... maybe setup a 'currentEnterFrame' object and remove any it contains
					this.removeEventListener (Event.ENTER_FRAME, rightHandPushGestureStep);

					_currentLeftHandInteractiveObject == _currentRightHandInteractiveObject ? _leftHandIsStillOnCurrentRightHandActiveObject = true : _leftHandIsStillOnCurrentRightHandActiveObject = false;

					_currentRightHandInteractiveObject.dispatchEvent (new KinectGestureEvent (KinectGestureEvent.RIGHT_HAND_OBJECT_INACTIVE, _id, {objectShouldStayActive:_leftHandIsStillOnCurrentRightHandActiveObject}));
					_currentRightHandInteractiveObject = null;
				}
			}
		}

		private function leftHandActivationTimerComplete (event:TimerEvent):void
		{
			activateLeftHand ();
		}

		private function rightHandActivationTimerComplete (event:TimerEvent):void
		{
			activateRightHand ();
		}

		private function activateLeftHand ():void
		{
			trace ("GestureManager:: activateLeftHand");

			_currentLeftHandInteractiveObject.dispatchEvent (new KinectGestureEvent (KinectGestureEvent.LEFT_HAND_OBJECT_ACTIVE, _id));
			checkForLeftHandPushGesture ();
		}

		private function activateRightHand ():void
		{
			trace ("GestureManager:: activateRightHand");

			_currentRightHandInteractiveObject.dispatchEvent (new KinectGestureEvent (KinectGestureEvent.RIGHT_HAND_OBJECT_ACTIVE, _id));
			checkForRightHandPushGesture ();
		}

		private function checkForLeftHandPushGesture ():void
		{
			_leftHandTrackingStartPosZ = Math.round (_leftHand.z * 100);

			// _leftHandGestureTimer.start ();

			this.addEventListener (Event.ENTER_FRAME, leftHandPushGestureStep);
		}

		private function checkForRightHandPushGesture ():void
		{
			_rightHandTrackingStartPosZ = Math.round (_rightHand.z * 100);

			// _rightHandGestureTimer.start ();

			this.addEventListener (Event.ENTER_FRAME, rightHandPushGestureStep);
		}

		private function leftHandPushGestureStep (event:Event):void
		{
			trace ("GestureManager:: left hand z = " + Math.round (_leftHand.z * 100));

			if (Math.round (_leftHand.z * 100) <= _leftHandTrackingStartPosZ - PUSH_GESTURE_DISTANCE)
			{
				trace ("GestureManager:: left hand push detected");
				this.removeEventListener (Event.ENTER_FRAME, leftHandPushGestureStep);

				// _currentLeftHandInteractiveObject.dispatchEvent (new KinectGestureEvent (KinectGestureEvent.LEFT_HAND_PUSH, _id, {interactiveObject:_currentLeftHandInteractiveObject}));
				_currentLeftHandInteractiveObject.dispatchEvent (new KinectGestureEvent (KinectGestureEvent.LEFT_HAND_PUSH, _id));
			}
		}

		private function rightHandPushGestureStep (event:Event):void
		{
			trace ("GestureManager:: right hand z = " + Math.round (_rightHand.z * 100));

			if (Math.round (_rightHand.z * 100) <= _rightHandTrackingStartPosZ - PUSH_GESTURE_DISTANCE)
			{
				trace ("GestureManager:: right hand push detected");
				this.removeEventListener (Event.ENTER_FRAME, rightHandPushGestureStep);

				_currentRightHandInteractiveObject.dispatchEvent (new KinectGestureEvent (KinectGestureEvent.RIGHT_HAND_PUSH, _id));
			}
		}

		private function leftHandGestureTimerComplete (event:TimerEvent):void
		{
			// TODO : first check if this event listener exists before removing it
			this.removeEventListener (Event.ENTER_FRAME, leftHandPushGestureStep);

			trace ("no push detected within " + DETECT_GESTURE_COUNTDOWN + " seconds");
		}

		private function rightHandGestureTimerComplete (event:TimerEvent):void
		{
			// TODO : first check if this event listener exists before removing it
			this.removeEventListener (Event.ENTER_FRAME, rightHandPushGestureStep);

			trace ("no push detected within " + DETECT_GESTURE_COUNTDOWN + " seconds");
		}
	}
}
