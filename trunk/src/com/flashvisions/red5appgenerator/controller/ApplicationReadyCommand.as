package com.flashvisions.red5appgenerator.controller 
{
	import com.flashvisions.red5appgenerator.ApplicationFacade;
	import com.flashvisions.red5appgenerator.model.ApplicationProxy;
	import com.flashvisions.red5appgenerator.vo.ApplicationData;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * ...
	 * @author Krishna
	 */
	public class ApplicationReadyCommand extends SimpleCommand implements ICommand
	{
		
		public function ApplicationReadyCommand() 
		{
			super();
			
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.ICommand */
		
		override public function execute(notification:INotification):void
		{
			sendNotification(ApplicationFacade.UNLOCK);
		}
		
	}

}