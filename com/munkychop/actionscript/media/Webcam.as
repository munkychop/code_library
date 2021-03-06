///////////////////////////////////--Webcam Class--///////////////////////////////////////
//-------------------------------------------------
//Author:	munkychop (Ivan Hayes)
//Date:		10/08/2010
//-------------------------------------------------
//Website:	munkychop.com
//Contact:	info@munkychop.com
//-------------------------------------------------
//////////////////////////////////////////////////////////////////////////////////////////

package com.munkychop.actionscript.media
{
	import com.munkychop.actionscript.events.WebcamEvent;
	import com.munkychop.actionscript.events.WebcamEventDispatcher;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.system.Capabilities;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	

	public class Webcam
	{
		public static function activate (videoWidth:Number = 320, videoHeight:Number = 240):void
		{
			var camera:Camera;
			var video:Video;
			var currentCameraName:String;
			var currentOS:String = Capabilities.os;
			var activateButton:MovieClip;
			
			//check if the operating system name contains the word "Mac"
			//and return true or false depending on this.
			var isMacOS:Boolean = currentOS.indexOf ("Mac") != -1;
		
			if (isMacOS)
			{
				//display the current operating system in the output panel.
				trace ("the current Mac OS is: " + currentOS);
				
				//loop through the 'Camera.names' array, which contains camera driver names (of type 'String').
				for (var i:int = 0; i < Camera.names.length; i++)
				{
					if (Camera.names[i] == "USB Video Class Video")
					{
						currentCameraName = String (i);
						
						trace ("mac usb cam");
						addCamera ();
						
						break;
					}
					else
					{
						if (i == Camera.names.length)
						{
							trace ("no usb cam found");
							addCamera ();
						}
					}
				}
			}
			else
			{
				trace ("not Mac OS");
				addCamera ();
			}
			
			function addCamera ():void
			{
				camera = Camera.getCamera (currentCameraName);
				video = new Video (videoWidth,videoHeight);
				video.attachCamera (camera);
				
				if (camera.muted)
				{
					addActivateButton ();
				}
				else
				{
					WebcamEventDispatcher.dispatchEvent (new WebcamEvent (WebcamEvent.WEBCAM_ACTIVATED, {camera: camera, video: video}));
				}
			}
			
			function addActivateButton ():void
			{
				activateButton = new MovieClip ();
				activateButton.graphics.beginFill (0xCCCCCC);
				activateButton.graphics.drawRoundRect (0,0,200,100,12);
				activateButton.graphics.endFill ();
				activateButton.buttonMode = true;
				
				activateButton.addEventListener (MouseEvent.CLICK, activateButtonClicked);
				WebcamEventDispatcher.dispatchEvent (new WebcamEvent (WebcamEvent.ADD_ACTIVATE_BUTTON, {activateButton: activateButton}));
				
				camera.addEventListener (StatusEvent.STATUS, cameraStatusEvent);
			}
			
			function cameraStatusEvent (event:StatusEvent):void
			{
				if (event.code == "Camera.Unmuted")
				{
					camera.removeEventListener (StatusEvent.STATUS, cameraStatusEvent);
					activateButton.removeEventListener (MouseEvent.CLICK, activateButtonClicked);
				
					WebcamEventDispatcher.dispatchEvent (new WebcamEvent (WebcamEvent.WEBCAM_ACTIVATED, {camera: camera, video: video}));
					WebcamEventDispatcher.dispatchEvent (new WebcamEvent (WebcamEvent.REMOVE_ACTIVATE_BUTTON, {activateButton: activateButton}));
				}
				else
				{
					WebcamEventDispatcher.dispatchEvent (new WebcamEvent (WebcamEvent.WEBCAM_ACCESS_DENIED));
				}
			}
			
			function activateButtonClicked (event:MouseEvent):void
			{
				Security.showSettings (SecurityPanel.PRIVACY);
			}
		}
	}
}