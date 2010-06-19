package com.flashvisions.red5appgenerator.controller 
{
	import caurina.transitions.properties.DisplayShortcuts;
	import com.flashvisions.red5appgenerator.model.ArchiveManagerProxy;
	import com.flashvisions.red5appgenerator.model.IOProxy;
	import com.flashvisions.red5appgenerator.vo.ArchiveData;
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;
	import flash.utils.ByteArray;
	import org.puremvc.as3.interfaces.IAsyncCommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.AsyncCommand;
	
	/**
	 * ...
	 * @author Krishna
	 */
	public class CopyArchiveCommand extends AsyncCommand implements IAsyncCommand
	{
		
		public function CopyArchiveCommand() 
		{
			
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.IAsyncCommand */
		
		override public function execute(notification:INotification):void
		{
			/* STEP 1  - Create Copy*/
			var archiveManagerProxy:ArchiveManagerProxy = facade.retrieveProxy(ArchiveManagerProxy.NAME) as ArchiveManagerProxy;
			archiveManagerProxy.generateFromLoadedArchive();
			
			this.commandComplete();
		}
		
	}

}