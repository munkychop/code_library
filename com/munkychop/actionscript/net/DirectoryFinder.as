﻿package com.munkychop.actionscript.net
{
	import flash.display.MovieClip;
	import flash.system.Capabilities;
	
	public class DirectoryFinder extends MovieClip
	{
		private var _currentOS:String;
		private var _mainStage:MovieClip;
		private var _swfPath:String;
		private var _initialPath:String;
		private var _domainRoot:String;
		private var _fileSeperator:String;
		
		//-------------------------------------------------------------------------------
		//--constructor
		//-------------------------------------------------------------------------------
		public function DirectoryFinder (mainStage:MovieClip)
		{
			_currentOS = Capabilities.os;
			_mainStage = mainStage;
			_swfPath = mainStage.root.loaderInfo.url;
			
			// if running online or on a Mac set the file seperator to a forward slash,
			// otherwise set it to a backslash.
			//
			// NOTE: for an OS that is not Mac it is neccessary to escape the backslash,
			// so it effectively becomes a single backslash.
			
			_currentOS.indexOf ("Mac") != -1 ? _fileSeperator = "/" : _fileSeperator = "\\";
			
			_swfPath.indexOf ("file:") == -1 || _currentOS.indexOf ("Win") == -1 ? _fileSeperator = "/" : _fileSeperator = "\\";
			
			_initialPath = _swfPath.substring (_swfPath.lastIndexOf (_fileSeperator), 0) + _fileSeperator;
			
			// gets the root domain from the full swf path, so: http://www.munkychop.com/some-folder/some-file.swf
			// becomes: http://www.munkychop.com
			setDomainRoot (_swfPath);
		}
		
		public function get swfPath ():String
		{
			return _swfPath;
		}
		
		public function get initialPath ():String
		{
			return _initialPath;
		}
		
		public function get fileSeperator ():String
		{
			return _fileSeperator;
		}
		
		public function get domainRoot ():String
		{			
			return _domainRoot;			
		}
		
		private function setDomainRoot (p_swfPath:String):void
		{
			var firstSlash:uint = p_swfPath.indexOf ("/");
			var thirdSlash:int = p_swfPath.indexOf ("/", firstSlash + 2);
			
			_domainRoot = p_swfPath.substring (0, thirdSlash);
		}
	}
}
