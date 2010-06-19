package com.flashvisions.red5appgenerator.controller 
{
	import com.flashvisions.red5appgenerator.model.ApplicationProxy;
	import com.flashvisions.red5appgenerator.model.ArchiveManagerProxy;
	import com.flashvisions.red5appgenerator.model.ConfigProxy;
	import com.flashvisions.red5appgenerator.model.IOProxy;
	import com.flashvisions.red5appgenerator.view.StageMediator;
	import flash.display.Stage;
	import org.puremvc.as3.interfaces.IAsyncCommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.AsyncCommand;
	
	/**
	 * ...
	 * @author Krishna
	 */
	public class InitFrameworkCommand extends AsyncCommand implements IAsyncCommand
	{
		
		public function InitFrameworkCommand() 
		{
			
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.IAsyncCommand */
		
		override public function execute(notification:INotification):void
		{
			var stage:Stage = notification.getBody() as Stage ;
			var application:Main = stage.getChildAt(0) as Main;
			
			facade.registerMediator(new StageMediator(StageMediator.NAME, stage));
			facade.registerProxy(new IOProxy(IOProxy.NAME));
			facade.registerProxy(new ArchiveManagerProxy(ArchiveManagerProxy.NAME));
			facade.registerProxy(new ConfigProxy(ConfigProxy.NAME));
			facade.registerProxy(new ApplicationProxy(ApplicationProxy.NAME));
			
			commandComplete();
		}
		
	}

}