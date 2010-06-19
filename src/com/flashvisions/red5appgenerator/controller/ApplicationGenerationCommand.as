package com.flashvisions.red5appgenerator.controller 
{
	import org.puremvc.as3.interfaces.IAsyncCommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.AsyncMacroCommand;
	import org.puremvc.as3.patterns.command.MacroCommand;
	
	/**
	 * ...
	 * @author Krishna
	 */
	public class ApplicationGenerationCommand extends AsyncMacroCommand implements IAsyncCommand
	{
		
		public function ApplicationGenerationCommand() 
		{
			super();
			
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.IAsyncCommand */
		
		override protected function initializeAsyncMacroCommand():void
		{
			this.addSubCommand(CopyArchiveCommand);
			this.addSubCommand(ModifyPackageCommand);
		}
		
	}

}