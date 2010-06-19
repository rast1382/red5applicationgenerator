package com.flashvisions.red5appgenerator.controller 
{
	import com.flashvisions.red5appgenerator.ApplicationFacade;
	import com.flashvisions.red5appgenerator.view.StageMediator;
	import com.yahoo.astra.fl.managers.AlertManager;
	import flash.display.Stage;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * ...
	 * @author Krishna
	 */
	public class ApplicationLoadFailedCommand extends SimpleCommand implements ICommand
	{
		
		public function ApplicationLoadFailedCommand() 
		{
			super();
			
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.ICommand */
		
		override public function execute(notification:INotification):void
		{
			sendNotification(ApplicationFacade.UNLOCK);
			
			var stageMediator:StageMediator = facade.retrieveMediator(StageMediator.NAME) as StageMediator;
			var stage:Stage = stageMediator.getViewComponent() as Stage;
			
			AlertManager.createAlert(stage.getChildAt(0), "Application load failed !", "Status");
			AlertManager.textColor = 0x000000;
		}
		
	}

}