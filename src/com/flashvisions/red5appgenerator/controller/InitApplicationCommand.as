package com.flashvisions.red5appgenerator.controller 
{
	import com.flashvisions.red5appgenerator.ApplicationFacade;
	import com.flashvisions.red5appgenerator.model.ConfigProxy;
	import com.flashvisions.red5appgenerator.model.IOProxy;
	import com.flashvisions.red5appgenerator.view.StageMediator;
	import com.flashvisions.red5appgenerator.vo.IOParams;
	import com.yahoo.astra.fl.managers.AlertManager;
	import flash.display.Stage;
	import com.flashvisions.utils.URLUtil;
	import flash.external.ExternalInterface;
	import org.puremvc.as3.interfaces.IAsyncCommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.AsyncCommand;
	
	/**
	 * ...
	 * @author Krishna
	 */
	public class InitApplicationCommand extends AsyncCommand implements IAsyncCommand
	{
		
		public function InitApplicationCommand() 
		{
			
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.IAsyncCommand */
		
		override public function execute(notification:INotification):void
		{
			/* process flashvars */
			var stage:Stage = facade.retrieveMediator(StageMediator.NAME).getViewComponent() as Stage;
			var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			configProxy.setData(stage.loaderInfo.parameters);
			
			/* set parameters */
			var ioProxy:IOProxy = facade.retrieveProxy(IOProxy.NAME) as IOProxy;
			var ioparams:IOParams = ioProxy.getData() as IOParams;
			
			ioparams.applicationPath = configProxy.getData().repositoryDescriptor;
			
			try {
				var full:String = ExternalInterface.call("window.location.href.toString");
				var htmldomain:String = URLUtil.getServerName(full);
				var swfdomain:String = URLUtil.getServerName(stage.loaderInfo.loaderURL);
				
				if ((swfdomain != "flashvisions.com") && (htmldomain != "flashvisions.com")) throw new Error ("Stealing content from other sites is illegal. This content is created by Rajdeep Rath: @ flashvisions.com");
				sendNotification(ApplicationFacade.REQUEST_APPLICATIONS);
			}catch(e:Error){
				AlertManager.createAlert(stage.getChildAt(0), e.message);
				AlertManager.textColor = 0x000000;
				sendNotification(ApplicationFacade.LOCK);
			}
		}
		
	}

}