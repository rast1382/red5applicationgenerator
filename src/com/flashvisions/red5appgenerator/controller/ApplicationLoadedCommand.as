package com.flashvisions.red5appgenerator.controller 
{
	import com.flashvisions.red5appgenerator.ApplicationFacade;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * ...
	 * @author Krishna
	 */
	public class ApplicationLoadedCommand extends SimpleCommand implements ICommand
	{
		
		public function ApplicationLoadedCommand() 
		{
			super();
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.ICommand */
		
		override public function execute(notification:INotification):void
		{
			sendNotification(ApplicationFacade.GENERATE_NEW);
		}
		
	}

}