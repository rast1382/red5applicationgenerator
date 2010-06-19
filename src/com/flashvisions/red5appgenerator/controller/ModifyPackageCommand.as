package com.flashvisions.red5appgenerator.controller 
{
	import com.flashvisions.red5appgenerator.ApplicationFacade;
	import com.flashvisions.red5appgenerator.model.ArchiveManagerProxy;
	import com.flashvisions.red5appgenerator.vo.ArchiveData;
	import deng.fzip.FZip;
	import org.puremvc.as3.interfaces.IAsyncCommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.AsyncCommand;
	
	/**
	 * ...
	 * @author Krishna
	 */
	public class ModifyPackageCommand extends AsyncCommand implements IAsyncCommand
	{
		
		public function ModifyPackageCommand() 
		{
			
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.IAsyncCommand */
		
		override public function execute(notification:INotification):void
		{
			var archiveManagerProxy:ArchiveManagerProxy = facade.retrieveProxy(ArchiveManagerProxy.NAME) as ArchiveManagerProxy;
			archiveManagerProxy.updateProperties();
			archiveManagerProxy.updateDescriptor();
			archiveManagerProxy.updateCustomStreamNameGenerator();
			
			sendNotification(ApplicationFacade.SAVE_GENERATED);
		}
		
	}

}