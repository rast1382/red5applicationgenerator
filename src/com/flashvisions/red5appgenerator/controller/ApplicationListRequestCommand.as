package com.flashvisions.red5appgenerator.controller 
{
	import com.flashvisions.red5appgenerator.model.IOProxy;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * ...
	 * @author Krishna
	 */
	public class ApplicationListRequestCommand extends SimpleCommand implements ICommand
	{
		
		public function ApplicationListRequestCommand() 
		{
			super();
			
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.ICommand */
		
		override public function execute(notification:INotification):void
		{
			var ioProxy:IOProxy = facade.retrieveProxy(IOProxy.NAME) as IOProxy;
			ioProxy.loadApplicationsList();
		}
		
	}

}