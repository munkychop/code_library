﻿package com.munkychop.actionscript.display
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class Dragger
	{		
		//-------------------------------------------------------------------------------
		//--protected properties
		//-------------------------------------------------------------------------------
		protected var _bounds:Object;
		protected var _currentTargetObject:DisplayObject;
		protected var _draggableObjectArray:Array;
		protected var _offsetPoint:Point;
		protected var _stage:Stage;
		
		
		private var _constrainedObjectArray:Array;
		private var _currentTargetObjectIsConstrainedToStage:Boolean;
		private var _currentTargetObjectIndex:int;
		private var _currentBoundsTop:Number;
		private var _currentBoundsRight:Number;
		private var _currentBoundsBottom:Number;
		private var _currentBoundsLeft:Number;
		
		//-------------------------------------------------------------------------------
		//--constructor
		//-------------------------------------------------------------------------------
		public function Dragger ()
		{
			_offsetPoint = new Point ();
			_bounds = new Object ();
			_constrainedObjectArray = new Array ();
			_draggableObjectArray = new Array ();
		}
		
		//-------------------------------------------------------------------------------
		//--public API
		//-------------------------------------------------------------------------------
		public function makeDraggable (p_objectToDrag:DisplayObject, p_constrainToStage:Boolean=false, p_boundsTop:Number=NaN, p_boundsRight:Number=NaN, p_boundsBottom:Number=NaN, p_boundsLeft:Number=NaN):void
		{
			if (p_constrainToStage)
			{
				_constrainedObjectArray.push (p_objectToDrag);
			}
			
			_draggableObjectArray.push ({draggableObject:p_objectToDrag, boundsTop:p_boundsTop, boundsRight:p_boundsRight, boundsBottom:p_boundsBottom, boundsLeft:p_boundsLeft});
			
			p_objectToDrag.addEventListener (MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		public function release (p_objectToRelease:DisplayObject):void
		{
			p_objectToRelease.removeEventListener (MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
			var constrainedObjectArrayIndex:int = _constrainedObjectArray.indexOf (p_objectToRelease);
			var draggableObjectArrayIndex:int;
						
			for (var i:int = 0; i < _draggableObjectArray.length; i++)
			{
				if (_draggableObjectArray[i].draggableObject == p_objectToRelease)
				{
					draggableObjectArrayIndex = i;
					break;
				}
				else
				{
					draggableObjectArrayIndex = -1;
				}
			}
			
			if (draggableObjectArrayIndex != -1) _draggableObjectArray.splice (draggableObjectArrayIndex, 1);
			if (constrainedObjectArrayIndex != -1) _constrainedObjectArray.splice (constrainedObjectArrayIndex, 1);
		}
		
		public function releaseAll ():void
		{
			var draggableObjectArrayIndex:int = _draggableObjectArray.length - 1;
			
			while (_draggableObjectArray.length > 0)
			{
				_draggableObjectArray[draggableObjectArrayIndex].draggableObject.removeEventListener (MouseEvent.MOUSE_DOWN, mouseDownHandler);
				_draggableObjectArray.pop ();
				
				draggableObjectArrayIndex--;				
			}
			
			while (_constrainedObjectArray.length > 0) _constrainedObjectArray.pop ();				
		}
		
		// TODO: create the startMultiDrag method.
		public function startMultiDrag (p_keyObjectToDrag:DisplayObject, p_otherObjectsToDragArray:Array):void
		{
			
		}
		
		//-------------------------------------------------------------------------------
		//--protected methods
		//-------------------------------------------------------------------------------
		protected function mouseDownHandler (event:MouseEvent):void
		{
			_currentTargetObject = event.currentTarget as DisplayObject;			
			_currentTargetObject.removeEventListener (MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
			_stage = _currentTargetObject.root.stage;
			
			_offsetPoint.x = _stage.mouseX - _currentTargetObject.x;
			_offsetPoint.y = _stage.mouseY - _currentTargetObject.y;
			
			_currentTargetObjectIsConstrainedToStage = _constrainedObjectArray.indexOf (_currentTargetObject) == 0;
			
			for (var i:int = 0; i < _draggableObjectArray.length; i++)
			{
				if (_draggableObjectArray[i].draggableObject == _currentTargetObject)
				{
					_currentTargetObjectIndex = i;
					break;
				}
			}
				
			_currentBoundsTop = _draggableObjectArray[_currentTargetObjectIndex].boundsTop;
			_currentBoundsRight = _draggableObjectArray[_currentTargetObjectIndex].boundsRight;
			_currentBoundsBottom = _draggableObjectArray[_currentTargetObjectIndex].boundsBottom;
			_currentBoundsLeft = _draggableObjectArray[_currentTargetObjectIndex].boundsLeft;
			
			_stage.addEventListener (MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			_stage.addEventListener (MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		protected function mouseMoveHandler (event:MouseEvent):void
		{
			_currentTargetObject.x = _stage.mouseX - _offsetPoint.x;
			_currentTargetObject.y = _stage.mouseY - _offsetPoint.y;
			
			if (_currentTargetObjectIsConstrainedToStage)
			{
				if (_currentTargetObject.x < 0)
				{
					_currentTargetObject.x = 0;
				}
				else if (_currentTargetObject.x > _stage.stageWidth - _currentTargetObject.width)
				{
					_currentTargetObject.x = _stage.stageWidth - _currentTargetObject.width;
				}
				
				if (_currentTargetObject.y < 0)
				{
					_currentTargetObject.y = 0;
				}
				else if (_currentTargetObject.y > _stage.stageHeight - _currentTargetObject.height)
				{
					_currentTargetObject.y = _stage.stageHeight - _currentTargetObject.height;
				}
			}
			else
			{
				if (!isNaN (_currentBoundsLeft))
				{
					if (_currentTargetObject.x < _currentBoundsLeft) _currentTargetObject.x = _currentBoundsLeft;
				}
				
				if (!isNaN (_currentBoundsRight))
				{
					if (_currentTargetObject.x > _currentBoundsRight - _currentTargetObject.width) _currentTargetObject.x = _currentBoundsRight - _currentTargetObject.width;
				}
				
				if (!isNaN (_currentBoundsTop))
				{
					if (_currentTargetObject.y < _currentBoundsTop) _currentTargetObject.y = _currentBoundsTop;
				}
				
				if (!isNaN (_currentBoundsBottom))
				{
					if (_currentTargetObject.y > _currentBoundsBottom - _currentTargetObject.height) _currentTargetObject.y = _currentBoundsBottom - _currentTargetObject.height;
				}
			}
			
			event.updateAfterEvent ();
		}
		
		protected function mouseUpHandler (event:MouseEvent):void
		{
			_stage.removeEventListener (MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			_stage.removeEventListener (MouseEvent.MOUSE_UP, mouseUpHandler);
			_currentTargetObject.addEventListener (MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
	}
}