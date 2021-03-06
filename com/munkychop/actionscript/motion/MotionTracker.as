package com.munkychop.actionscript.motion
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.Timer;

	/**
	 * @author munkychop
	 */

	public class MotionTracker extends EventDispatcher
	{
		// -------------------------------------------------------------------------------
		// --public event constants
		// -------------------------------------------------------------------------------
		public static const READY:String = "ready";
		
		// -------------------------------------------------------------------------------
		// --private constants
		// -------------------------------------------------------------------------------
		private static const STARTUP_TIME:int = 3;
		
		// -------------------------------------------------------------------------------
		// --private properties
		// -------------------------------------------------------------------------------
		private var _startupTimer:Timer;
		private var _differenceBitmapData:BitmapData;
		private var _previousBitmapData:BitmapData;
		private var _camWidth:int;
		private var _camera:Camera;
		private var _camHeight:int;
		private var _video:Video;
		private var _videoContainer:Sprite;
		private var _camIsMirrored:Boolean;
		private var _camFPS:int;
		private var _isTracking:Boolean;
		private var _point:Point;
		private var _blurFilter:BlurFilter;
		private var _outputBitmapData:BitmapData;
		private var _rect:Rectangle;
		private var _outputBitmap:Bitmap;
		private var _stepTimer:Timer;
		private var _renderFrequency:int;
		private var _interactiveTouchObjectArray:Array;
		private var _ignoreInitialTouchTimer:Timer;
		
		// -------------------------------------------------------------------------------
		// --constructor
		// -------------------------------------------------------------------------------
		public function MotionTracker (p_camWidth:int = 320, p_camHeight:int = 240, p_camFPS:int = 15, p_renderFrequency:int = 200, p_camMirrored:Boolean = true)
		{
			_camWidth = p_camWidth;
			_camHeight = p_camHeight;
			_camFPS = p_camFPS;
			_renderFrequency = p_renderFrequency;
			_camIsMirrored = p_camMirrored;
			
			init ();

			trace ("motion tracker running!");
		}
		
		// -------------------------------------------------------------------------------
		// --initialization
		// -------------------------------------------------------------------------------
		private function init ():void
		{
			setupCamera ();
			setupStartupTimer ();
		}

		// -------------------------------------------------------------------------------
		// --getter/setter methods
		// -------------------------------------------------------------------------------
		public function get videoContainer ():Sprite
		{
			return _videoContainer;
		}

		public function get outputBitmap ():Bitmap
		{
			return _outputBitmap;
		}

		public function set renderFrequency (p_frequency:int):void
		{
			_renderFrequency = p_frequency;
		}
		
		//_motionTrackerInstance.interactiveTouchObjectArray = [{interactiveTouchObject:someBitmap, eventName:SomeEventStringToDispatch}];
		public function set interactiveTouchObjectArray (p_interactiveTouchObjectArray:Array):void
		{
			_interactiveTouchObjectArray = p_interactiveTouchObjectArray;
		}

		//------------------------------------------------------------------------------------------
		//--
		//										  --API--
		//--
		//------------------------------------------------------------------------------------------
		//_motionTrackerInstance.startInitialTracking ([{interactiveTouchObject:someBitmap, eventName:SomeEventStringToDispatch}]);
		public function startInitialTracking (p_interactiveTouchObjectArray:Array = null):void
		{
			if (!_isTracking)
			{
				_isTracking = true;
				_interactiveTouchObjectArray = p_interactiveTouchObjectArray;
				setupTrackingObjects ();
			}
		}
		
		public function startTracking ():void
		{
			if (!_isTracking)
			{
				_isTracking = true;
				
				if (_interactiveTouchObjectArray)
				{					
					createInteractiveObjectPoints ();
					
					_stepTimer.addEventListener (TimerEvent.TIMER, stepTimerRenderAndDetectHandler);
					_stepTimer.start ();
				}
				else
				{
					_stepTimer.addEventListener (TimerEvent.TIMER, stepTimerRenderHandler);
				}
				
				_stepTimer.start ();
			}
		}

		public function stopTracking ():void
		{
			if (_isTracking)
			{
				_isTracking = false;
				_stepTimer.removeEventListener (TimerEvent.TIMER, stepTimerRenderAndDetectHandler);
				_stepTimer.stop ();
			}
		}

		// -------------------------------------------------------------------------------
		// --private methods
		// -------------------------------------------------------------------------------
		private function setupCamera ():void
		{
			_camera = Camera.getCamera ();

			// my iSight max FPS is about 15 ;)
			_camera.setMode (_camWidth, _camHeight, 15);

			_video = new Video (_camWidth, _camHeight);
			_videoContainer = new Sprite ();

			_video.attachCamera (_camera);

			if (_camIsMirrored)
			{
				_video.scaleX = -1;
				_video.x = _video.width;
			}

			_videoContainer.addChild (_video);
		}
		
		private function setupStartupTimer ():void
		{
			_startupTimer = new Timer (STARTUP_TIME * 1000, 1);
			_startupTimer.addEventListener (TimerEvent.TIMER, startupTimerCompleteHandler);
			_startupTimer.start ();
		}
		
		private function startupTimerCompleteHandler (event:TimerEvent):void
		{
			_startupTimer.removeEventListener (TimerEvent.TIMER, startupTimerCompleteHandler);
			_startupTimer = null;
			
			dispatchEvent (new Event (MotionTracker.READY));
		}

		private function setupTrackingObjects ():void
		{
			_blurFilter = new BlurFilter (15, 15);
			_point = new Point ();
			_rect = new Rectangle (0, 0, _camWidth, _camHeight);

			_previousBitmapData = new BitmapData (_camWidth, _camHeight);
			_differenceBitmapData = new BitmapData (_camWidth, _camHeight);
			_outputBitmapData = new BitmapData (_camWidth, _camHeight, true, 0x00000000);

			_outputBitmap = new Bitmap ();
			_outputBitmap.bitmapData = _outputBitmapData;
			
			_ignoreInitialTouchTimer = new Timer (_renderFrequency, 1)
			_stepTimer = new Timer (_renderFrequency);

			if (_interactiveTouchObjectArray)
			{
				createInteractiveObjectPoints ();
				ignoreInitialTouch ();
			}
			else
			{
				_stepTimer.addEventListener (TimerEvent.TIMER, stepTimerRenderHandler);
			}
		}

		private function ignoreInitialTouch ():void
		{
			render ();
			
			for (var i:int = 0; i < _interactiveTouchObjectArray.length; i++)
			{
				if (_outputBitmapData.hitTest (_point, 0xFF, _interactiveTouchObjectArray[i].interactiveTouchObject.bitmapData, _interactiveTouchObjectArray[i].point))
				{
					trace ("Motion Tracker: initial touch detected");
					_stepTimer.addEventListener (TimerEvent.TIMER, stepTimerRenderAndDetectHandler);
					_stepTimer.start ();
				}
			}
		}

		private function stepTimerRenderHandler (event:TimerEvent):void
		{
			render ();
		}

		private function stepTimerRenderAndDetectHandler (event:TimerEvent):void
		{
			render ();
			detectBlobs (_outputBitmapData);
		}

		private function createInteractiveObjectPoints ():void
		{
					
			for (var i:int = 0; i < _interactiveTouchObjectArray.length; i++)
			{
				var pointOffsetX:Number = 0;
				var pointOffsetY:Number = 0; 
				
				if (_interactiveTouchObjectArray[i].containerArrayToRootLevel)
				{
					for (var j:int = 0; j < _interactiveTouchObjectArray[i].containerArrayToRootLevel.length; j++)
					{
						pointOffsetX += _interactiveTouchObjectArray[i].containerArrayToRootLevel[j].x;
						pointOffsetY += _interactiveTouchObjectArray[i].containerArrayToRootLevel[j].y;
					}
				}
				_interactiveTouchObjectArray[i].point = new Point (pointOffsetX + _interactiveTouchObjectArray[i].interactiveTouchObject.x, pointOffsetY + _interactiveTouchObjectArray[i].interactiveTouchObject.y);
			}
		}

		private function render ():void
		{
			_differenceBitmapData.draw (_videoContainer);
			_differenceBitmapData.draw (_previousBitmapData, null, null, "difference");
			_differenceBitmapData.applyFilter (_differenceBitmapData, _differenceBitmapData.rect, _point, _blurFilter);

			_outputBitmapData.fillRect (_rect, 0x00000000);
			_outputBitmapData.threshold (_differenceBitmapData, _differenceBitmapData.rect, _point, ">", 0xFF110000, 0xFF000000, 0xFFFFFFFF);

			_previousBitmapData.draw (_videoContainer);
		}

		private function detectBlobs (src:BitmapData):void
		{
			if (_interactiveTouchObjectArray)
			{
				// if (camera.activity...)
				
				for (var i:int = 0; i < _interactiveTouchObjectArray.length; i++)
				{
					if (src.hitTest (_point, 0xFF, _interactiveTouchObjectArray[i].interactiveTouchObject.bitmapData, _interactiveTouchObjectArray[i].point))
					{
						dispatchEvent (new Event (_interactiveTouchObjectArray[i].eventName));
					}
				}
			 }
		}
	}
}
