package com.flashvisions.red5appgenerator.controller 
{
	import com.flashvisions.red5appgenerator.ApplicationFacade;
	import com.flashvisions.red5appgenerator.model.IOProxy;
	import com.flashvisions.red5appgenerator.view.StageMediator;
	import com.flashvisions.red5appgenerator.vo.IOParams;
	import com.yahoo.astra.fl.managers.AlertManager;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import org.puremvc.as3.interfaces.IAsyncCommand;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.AsyncCommand;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * ...
	 * @author Krishna
	 */
	public class PromptDownloadCommand extends SimpleCommand implements ICommand
	{
		
		public function PromptDownloadCommand() 
		{
			
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.IAsyncCommand */
		
		override public function execute(notification:INotification):void
		{
			sendNotification(ApplicationFacade.UNLOCK);
			
			var stageMediator:StageMediator = facade.retrieveMediator(StageMediator.NAME) as StageMediator;
			var stage:Stage = stageMediator.getViewComponent() as Stage;
			
			AlertManager.createAlert(stage.getChildAt(0), "Application Generated !. Click \"ok\" to download !", "Status",["Ok","Cancel"],onConfirmDownload);
			AlertManager.textColor = 0x000000;
		}
		
		public function onConfirmDownload(event:MouseEvent):void
		{
			var ioProxy:IOProxy = facade.retrieveProxy(IOProxy.NAME) as IOProxy;
			var ioparams:IOParams = ioProxy.getData() as IOParams;
			switch(event.target.name)
			{
				case "Ok":
				ioProxy.downloadArchive();
				break;
				
				case "Cancel":
				// NOOP
				break;
			}
			
		}
		
	}

}