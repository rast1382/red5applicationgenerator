package com.flashvisions.red5appgenerator.controller 
{
	import org.puremvc.as3.interfaces.IAsyncCommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.AsyncMacroCommand;
	
	/**
	 * ...
	 * @author Krishna
	 */
	public class StartUpCommand extends AsyncMacroCommand implements IAsyncCommand
	{
		
		public function StartUpCommand() 
		{
			super();
			
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.IAsyncCommand */
		
		override protected function initializeAsyncMacroCommand():void
		{
			this.addSubCommand(InitFrameworkCommand);
			this.addSubCommand(InitApplicationCommand);
		}
		
	}

}