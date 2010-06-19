package com.flashvisions.red5appgenerator.controller 
{
	import com.flashvisions.red5appgenerator.ApplicationFacade;
	import com.flashvisions.red5appgenerator.model.IOProxy;
	import com.flashvisions.red5appgenerator.vo.IOParams;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * ...
	 * @author Krishna
	 */
	public class ApplicationLoadCommand extends SimpleCommand implements ICommand
	{
		
		public function ApplicationLoadCommand() 
		{
			super();
			
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.ICommand */
		
		override public function execute(notification:INotification):void
		{
			sendNotification(ApplicationFacade.LOCK);
			
			var ioProxy:IOProxy = facade.retrieveProxy(IOProxy.NAME) as IOProxy;
			var ioparams:IOParams = ioProxy.getData() as IOParams;
			ioProxy.loadArchive();
			
			
		}
		
	}

}