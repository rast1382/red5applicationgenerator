package com.flashvisions.red5appgenerator
{
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	import com.flashvisions.red5appgenerator.controller.*;
	
	/**
	 * ...
	 * @author Krishna
	 */
	
	public class ApplicationFacade extends Facade implements IFacade
	{
		public static const STARTUP:String  = "onStartUp";
		public static const REQUEST_APPLICATIONS:String  = "onApplicationListRequest";
		public static const LOAD_APPLICATION:String  = "onLoadApplicationArchive";
		public static const LOAD_APPLICATION_START:String  = "onApplicationArchiveLoadStart";
		public static const LOAD_FAILED:String  = "onApplicationLoadFailed";
		public static const LOAD_SUCCESS:String  = "onApplicationLoaded";
		public static const GENERATE_NEW:String  = "onApplicationArchiveCreate";
		public static const SAVE_GENERATED:String  = "onApplicationSave";
		public static const LOCK:String  = "onLockApplication";
		public static const UNLOCK:String  = "onUnLockApplication";
		public static const READY:String  = "onApplicationReady";
		public static const FAILED:String  = "onApplicationFailed";
		public static const ENABLEDOWLOAD:String  = "onDownloadEnabled";
		public static const DISABLEDOWLOAD:String  = "onDownloadDisabled";
		
		
		
		private static var instance:ApplicationFacade = null;
		
		public function ApplicationFacade() 
		{
			
		}
		
		
		/**
         * Singleton ApplicationFacade Factory Method
         */
		public static function getInstance() : ApplicationFacade {
            if ( instance == null ) instance = new ApplicationFacade( );
            return instance as ApplicationFacade;
        }

        
		/**
         * Register Commands with the Controller 
         */
		
	    override protected function initializeController( ) : void 
        {
            super.initializeController();
			
            registerCommand( STARTUP, StartUpCommand );
			registerCommand(REQUEST_APPLICATIONS, ApplicationListRequestCommand);
			registerCommand(READY, ApplicationReadyCommand);
			registerCommand(LOAD_APPLICATION, ApplicationLoadCommand);
			registerCommand(LOAD_SUCCESS, ApplicationLoadedCommand);
			registerCommand(GENERATE_NEW, ApplicationGenerationCommand);
			registerCommand(SAVE_GENERATED, PromptDownloadCommand);
			registerCommand(LOAD_FAILED, ApplicationLoadFailedCommand);
        }
        
        
		public function startup( stage:Object ):void
        {
        	sendNotification( STARTUP, stage);
        }
		
	}

}