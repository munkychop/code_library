package com.munkychop.air.net
{
	import com.munkychop.air.events.SVNEvent;

	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	
	
	// TODO : set _nativeProcess, _nativeProcessStartupInfo, and _nativeProcessArgsVector to null within each exit handler below

	public class SVNConnection extends EventDispatcher
	{
		//-------------------------------------------------------------------------------
		//--private properties
		//-------------------------------------------------------------------------------
		private var _localSupportDirectory:File;
		private var _localRepoDirectory:File;
		private var _workingDirectory:File;
		private var _executableFile:File;
		private var _nativeProcess:NativeProcess;
		private var _nativeProcessStartupInfo:NativeProcessStartupInfo;
		private var _nativeProcessArgsVector:Vector.<String>;
		private var _nativeProcessEventHandlerObject:Object;
		
		private var _nativeProcessRunning:Boolean;
		
		//client/resources/trims/pngs/large_3_4_280x169
		//-------------------------------------------------------------------------------
		//--constructor
		//-------------------------------------------------------------------------------
		public function SVNConnection (localSupportDirectoryToCreate:File)
		{
			_nativeProcessRunning = false;
			
			// TODO : check the OS and assign the appropriate system location of SVN
			_executableFile = new File ("/usr/bin/svn");
			
			_localSupportDirectory = localSupportDirectoryToCreate;
			//_localSupportDirectory = File.applicationStorageDirectory.resolvePath ("repo");
			
			//this method automatically checks whether or not the specified file (directory) exists.
			//If it does exist this method does nothing, otherwise the directory is created.
			_localSupportDirectory.createDirectory ();
			
			_localRepoDirectory = _localSupportDirectory.resolvePath ("repo");
			
			//this method automatically checks whether or not the specified file (directory) exists.
			//If it does exist this method does nothing, otherwise the directory is created.
			_localRepoDirectory.createDirectory ();
			
			trace (_localSupportDirectory.nativePath);
			
			_nativeProcessEventHandlerObject = new Object ();
		}
		
		//-------------------------------------------------------------------------------
		//--public methods
		//-------------------------------------------------------------------------------
		public function listBranchNames (url:String, username:String, password:String):void
		{
			_nativeProcessArgsVector = new Vector.<String>;
			_nativeProcessArgsVector.push ("list");
			_nativeProcessArgsVector.push (url);
			_nativeProcessArgsVector.push ("--username");
			_nativeProcessArgsVector.push (username);
			_nativeProcessArgsVector.push ("--password");
			_nativeProcessArgsVector.push (password);
			
			_nativeProcessStartupInfo = new NativeProcessStartupInfo ();
			_nativeProcessStartupInfo.workingDirectory = _localSupportDirectory;
			_nativeProcessStartupInfo.executable = _executableFile;
			_nativeProcessStartupInfo.arguments = _nativeProcessArgsVector;
			
			_nativeProcess = new NativeProcess ();
			
			_nativeProcessEventHandlerObject.standardOutputDataHandler = listBranchNamesOutputDataHandler;
			//_nativeProcessEventHandlerObject.stabdardInputProgressHandler = undefined;
			_nativeProcessEventHandlerObject.exitHandler = listBranchNamesExitHandler;
			_nativeProcessEventHandlerObject.standardErrorDataHandler = standardErrorDataHandler;
			_nativeProcessEventHandlerObject.standardErrorIOErrorHandler = standardErrorIOErrorHandler;
			
			_nativeProcess.addEventListener (ProgressEvent.STANDARD_OUTPUT_DATA, _nativeProcessEventHandlerObject.standardOutputDataHandler, false, 0, true);
			//_nativeProcess.addEventListener (ProgressEvent.STANDARD_INPUT_PROGRESS, _nativeProcessEventHandlerObject.stabdardInputProgressHandler);
			_nativeProcess.addEventListener (NativeProcessExitEvent.EXIT, _nativeProcessEventHandlerObject.exitHandler, false, 0, true);
			_nativeProcess.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, _nativeProcessEventHandlerObject.standardErrorDataHandler, false, 0, true);
			_nativeProcess.addEventListener (IOErrorEvent.STANDARD_ERROR_IO_ERROR, _nativeProcessEventHandlerObject.standardErrorIOErrorHandler, false, 0, true);
			
			_nativeProcess.start (_nativeProcessStartupInfo);
			
			dispatchEvent (new SVNEvent (SVNEvent.LIST_COMMAND_STARTED));
		}
		
		public function cleanupLocalRepo (localBranchDirectory:String):void
		{
			_nativeProcessRunning = true;
			
			trace ("current local branch directory: " + localBranchDirectory);
			trace ("current working directory: " + _workingDirectory.nativePath);
			
			_nativeProcessArgsVector = new Vector.<String>;
			_nativeProcessArgsVector.push ("cleanup");
			_nativeProcessArgsVector.push (localBranchDirectory);
			
			_nativeProcessStartupInfo = new NativeProcessStartupInfo ();
			_nativeProcessStartupInfo.workingDirectory = _workingDirectory;
			_nativeProcessStartupInfo.executable = _executableFile;
			_nativeProcessStartupInfo.arguments = _nativeProcessArgsVector;
			
			_nativeProcess = new NativeProcess ();
			
			_nativeProcessEventHandlerObject.standardOutputDataHandler = cleanupLocalRepoOutputDataHandler;
			//_nativeProcessEventHandlerObject.stabdardInputProgressHandler = undefined;
			_nativeProcessEventHandlerObject.exitHandler = cleanupLocalRepoExitHandler;
			_nativeProcessEventHandlerObject.standardErrorDataHandler = standardErrorDataHandler;
			_nativeProcessEventHandlerObject.standardErrorIOErrorHandler = standardErrorIOErrorHandler;
			
			addNativeProcessListeners ();
			
			_nativeProcess.start (_nativeProcessStartupInfo);
			
			dispatchEvent (new SVNEvent (SVNEvent.CLEANUP_COMMAND_STARTED));
		}
		
		public function checkoutRepo (url:String, username:String=null, password:String=null):void
		{
			_nativeProcessRunning = true;
			
			_nativeProcessArgsVector = new Vector.<String>;
			_nativeProcessArgsVector.push ("co");
			_nativeProcessArgsVector.push (url);
			_nativeProcessArgsVector.push (_workingDirectory.nativePath);
			
			if (username != null && password != null)
			{
				_nativeProcessArgsVector.push ("--username");
				_nativeProcessArgsVector.push (username);
				_nativeProcessArgsVector.push ("--password");
				_nativeProcessArgsVector.push (password);
			}
			
			_nativeProcessStartupInfo = new NativeProcessStartupInfo ();
			_nativeProcessStartupInfo.workingDirectory = _workingDirectory;
			_nativeProcessStartupInfo.executable = _executableFile;
			_nativeProcessStartupInfo.arguments = _nativeProcessArgsVector;
			
			_nativeProcess = new NativeProcess ();
			
			_nativeProcessEventHandlerObject.standardOutputDataHandler = checkoutRepoOutputDataHandler;
			//_nativeProcessEventHandlerObject.stabdardInputProgressHandler = undefined;
			_nativeProcessEventHandlerObject.exitHandler = checkoutRepoExitHandler;
			_nativeProcessEventHandlerObject.standardErrorDataHandler = standardErrorDataHandler;
			_nativeProcessEventHandlerObject.standardErrorIOErrorHandler = standardErrorIOErrorHandler;
			
			addNativeProcessListeners ();
			
			_nativeProcess.start (_nativeProcessStartupInfo);
			
			dispatchEvent (new SVNEvent (SVNEvent.CHECKOUT_COMMAND_STARTED));
		}
		
		public function exportFile (url:String, username:String=null, password:String=null):void
		{
			_nativeProcessRunning = true;			
			
			_nativeProcessArgsVector = new Vector.<String>;
			_nativeProcessArgsVector.push ("export");
			_nativeProcessArgsVector.push (url);
			//_nativeProcessArgsVector.push (_workingDirectory.nativePath + File.separator);
			
			if (username != null && password != null)
			{
				_nativeProcessArgsVector.push ("--username");
				_nativeProcessArgsVector.push (username);
				_nativeProcessArgsVector.push ("--password");
				_nativeProcessArgsVector.push (password);
			}
			
			_nativeProcessStartupInfo = new NativeProcessStartupInfo ();
			_nativeProcessStartupInfo.workingDirectory = _workingDirectory;
			_nativeProcessStartupInfo.executable = _executableFile;
			_nativeProcessStartupInfo.arguments = _nativeProcessArgsVector;
			
			_nativeProcess = new NativeProcess ();
			
			_nativeProcessEventHandlerObject.standardOutputDataHandler = exportFileOutputDataHandler;
			//_nativeProcessEventHandlerObject.stabdardInputProgressHandler = undefined;
			_nativeProcessEventHandlerObject.exitHandler = exportFileExitHandler;
			_nativeProcessEventHandlerObject.standardErrorDataHandler = standardErrorDataHandler;
			_nativeProcessEventHandlerObject.standardErrorIOErrorHandler = standardErrorIOErrorHandler;
			
			addNativeProcessListeners ();
			
			_nativeProcess.start (_nativeProcessStartupInfo);
			
			dispatchEvent (new SVNEvent (SVNEvent.EXPORT_COMMAND_STARTED));
		}
		
		public function exitCurrentProcess ():void
		{
			trace ("application close");
			
			if (_nativeProcessRunning)
			{
				if (_nativeProcess.hasEventListener(NativeProcessExitEvent.EXIT))
				{
					_nativeProcess.removeEventListener (NativeProcessExitEvent.EXIT, _nativeProcessEventHandlerObject.exitHandler);
				}
				
				_nativeProcess.exit ();
			}
			
			dispatchEvent (new SVNEvent (SVNEvent.READY_TO_EXIT));
			
			/*
			_localSupportDirectory.addEventListener (Event.COMPLETE, dispatchExitEvent);
			_localSupportDirectory.deleteDirectoryAsync (true);
			
			function dispatchExitEvent (event:Event):void
			{
				dispatchEvent (new SVNEvent (SVNEvent.READY_TO_EXIT));
				trace ("temporary directory deleted");
			}
			*/
		}
		
		//-------------------------------------------------------------------------------
		//--get/set methods
		//-------------------------------------------------------------------------------
		public function get nativeProcessRunning ():Boolean
		{
			return _nativeProcessRunning;
		}
		
		public function set nativeProcessRunning (booleanState:Boolean):void
		{
			_nativeProcessRunning = booleanState;
		}
		
		public function get localSupportDirectory ():File
		{
			return _localSupportDirectory;
		}
		
		public function set localSupportDirectory (localSupportDirectory:File):void
		{
			_localSupportDirectory = localSupportDirectory;
			_localSupportDirectory.createDirectory ();
		}
		
		public function get localRepoDirectory ():File
		{
			return _localRepoDirectory;
		}
		
		public function set localRepoDirectory (localRepoDirectory:File):void
		{
			_localRepoDirectory = localRepoDirectory;
		}
		
		public function get workingDirectory ():File
		{
			return _workingDirectory;
		}
		
		public function set workingDirectory (directoryFile:File):void
		{
			_workingDirectory = directoryFile;
		}
		
		//-------------------------------------------------------------------------------
		//--private methods
		//-------------------------------------------------------------------------------
		private function cleanupLocalRepoOutputDataHandler (event:ProgressEvent):void
		{
			var output:String = _nativeProcess.standardOutput.readUTFBytes (_nativeProcess.standardOutput.bytesAvailable);
			
			trace ("cleanup output: " + output);
			dispatchEvent (new SVNEvent (SVNEvent.CLEANUP_COMMAND_DATA_RECIEVED));
		}
		
		private function cleanupLocalRepoExitHandler (event:NativeProcessExitEvent):void
		{
			_nativeProcess.removeEventListener (ProgressEvent.STANDARD_OUTPUT_DATA, cleanupLocalRepoOutputDataHandler);
			_nativeProcess.removeEventListener (NativeProcessExitEvent.EXIT, cleanupLocalRepoExitHandler);
			_nativeProcess.removeEventListener(ProgressEvent.STANDARD_ERROR_DATA, standardErrorDataHandler);
			_nativeProcess.removeEventListener (IOErrorEvent.STANDARD_ERROR_IO_ERROR, standardErrorIOErrorHandler);
			
			clearNativeProcessEventHandlerObject ();
			
			dispatchEvent (new SVNEvent (SVNEvent.CLEANUP_COMMAND_COMPLETE, {exitCode:event.exitCode}));
		}
		
		
		
		private function listBranchNamesOutputDataHandler (event:ProgressEvent):void
		{
			var output:String = _nativeProcess.standardOutput.readUTFBytes (_nativeProcess.standardOutput.bytesAvailable);
			
			var pattern:RegExp = new RegExp(".+[\/]", "ig");
			var branchArray:Array = output.match (pattern);
			
			dispatchEvent (new SVNEvent (SVNEvent.LIST_COMMAND_DATA_RECIEVED, {outputDataArray:branchArray}));
		}
		
		private function listBranchNamesExitHandler (event:NativeProcessExitEvent):void
		{
			_nativeProcess.removeEventListener (ProgressEvent.STANDARD_OUTPUT_DATA, listBranchNamesOutputDataHandler);
			_nativeProcess.removeEventListener (NativeProcessExitEvent.EXIT, listBranchNamesExitHandler);
			_nativeProcess.removeEventListener(ProgressEvent.STANDARD_ERROR_DATA, standardErrorDataHandler);
			_nativeProcess.removeEventListener (IOErrorEvent.STANDARD_ERROR_IO_ERROR, standardErrorIOErrorHandler);
			
			clearNativeProcessEventHandlerObject ();
			
			dispatchEvent (new SVNEvent (SVNEvent.LIST_COMMAND_COMPLETE, {exitCode:event.exitCode}));
		}
		
		private function checkoutRepoOutputDataHandler (event:ProgressEvent):void
		{
			var output:String = _nativeProcess.standardOutput.readUTFBytes (_nativeProcess.standardOutput.bytesAvailable);
			
			trace ("checkoutRepoOutputDataHandler \n" + output);
			
			dispatchEvent (new SVNEvent (SVNEvent.CHECKOUT_COMMAND_PROGRESS, {outputData:output}));
		}
		
		private function checkoutRepoExitHandler (event:NativeProcessExitEvent):void
		{
			_nativeProcess.removeEventListener (ProgressEvent.STANDARD_OUTPUT_DATA, checkoutRepoOutputDataHandler);
			_nativeProcess.removeEventListener (NativeProcessExitEvent.EXIT, checkoutRepoExitHandler);
			_nativeProcess.removeEventListener(ProgressEvent.STANDARD_ERROR_DATA, standardErrorDataHandler);
			_nativeProcess.removeEventListener (IOErrorEvent.STANDARD_ERROR_IO_ERROR, standardErrorIOErrorHandler);
			
			clearNativeProcessEventHandlerObject ();
			
			_nativeProcessRunning = false;
			
			dispatchEvent (new SVNEvent (SVNEvent.CHECKOUT_COMMAND_COMPLETE, {exitCode:event.exitCode}));
		}
		
		private function exportFileOutputDataHandler (event:ProgressEvent):void
		{
			var output:String = _nativeProcess.standardOutput.readUTFBytes (_nativeProcess.standardOutput.bytesAvailable);
			
			trace ("exportFileOutputDataHandler \n" + output);
			
			dispatchEvent (new SVNEvent (SVNEvent.EXPORT_COMMAND_PROGRESS, {outputData:output}));
		}
		
		private function exportFileExitHandler (event:NativeProcessExitEvent):void
		{
			_nativeProcess.removeEventListener (ProgressEvent.STANDARD_OUTPUT_DATA, exportFileOutputDataHandler);
			_nativeProcess.removeEventListener (NativeProcessExitEvent.EXIT, exportFileExitHandler);
			_nativeProcess.removeEventListener(ProgressEvent.STANDARD_ERROR_DATA, standardErrorDataHandler);
			_nativeProcess.removeEventListener (IOErrorEvent.STANDARD_ERROR_IO_ERROR, standardErrorIOErrorHandler);
			
			clearNativeProcessEventHandlerObject ();
			
			_nativeProcessRunning = false;
			
			dispatchEvent (new SVNEvent (SVNEvent.EXPORT_COMMAND_COMPLETE, {exitCode:event.exitCode}));
		}
		
		//-------------------------------------------------------------------------------
		//--shared private methods
		//-------------------------------------------------------------------------------
		private function standardErrorDataHandler (event:ProgressEvent):void
		{
			var errorString:String = _nativeProcess.standardError.readUTFBytes (_nativeProcess.standardError.bytesAvailable);
			
			trace (errorString);
			
			if (errorString.indexOf ("Authorisation") > -1)
			{
				dispatchEvent (new SVNEvent (SVNEvent.LOGIN_FAILED));
			}
		}
		
		private function standardErrorIOErrorHandler (event:IOErrorEvent):void
		{
			trace ("onIOError \n" + event.toString());
		}
		
		private function addNativeProcessListeners ():void
		{
			_nativeProcess.addEventListener (ProgressEvent.STANDARD_OUTPUT_DATA, _nativeProcessEventHandlerObject.standardOutputDataHandler, false, 0, true);
			//_nativeProcess.addEventListener (ProgressEvent.STANDARD_INPUT_PROGRESS, _nativeProcessEventHandlerObject.stabdardInputProgressHandler);
			_nativeProcess.addEventListener (NativeProcessExitEvent.EXIT, _nativeProcessEventHandlerObject.exitHandler, false, 0, true);
			_nativeProcess.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, _nativeProcessEventHandlerObject.standardErrorDataHandler, false, 0, true);
			_nativeProcess.addEventListener (IOErrorEvent.STANDARD_ERROR_IO_ERROR, _nativeProcessEventHandlerObject.standardErrorIOErrorHandler, false, 0, true);
		}
		
		private function clearNativeProcessEventHandlerObject ():void
		{
			_nativeProcessEventHandlerObject.standardOutputDataHandler = undefined;
			_nativeProcessEventHandlerObject.exitHandler = undefined;
			_nativeProcessEventHandlerObject.standardErrorDataHandler = undefined;
			_nativeProcessEventHandlerObject.standardErrorIOErrorHandler = undefined;
		}
	}
}