package com.flashvisions.red5appgenerator.model 
{
	import com.adobe.webapis.flickr.methodgroups.Urls;
	import com.flashvisions.red5appgenerator.ApplicationFacade;
	import com.flashvisions.red5appgenerator.view.StageMediator;
	import com.flashvisions.red5appgenerator.vo.ApplicationData;
	import com.flashvisions.red5appgenerator.vo.ArchiveData;
	import com.flashvisions.red5appgenerator.vo.IOParams;
	import deng.fzip.FZip;
	import deng.fzip.FZipEvent;
	import fl.controls.ProgressBar;
	import fl.controls.ProgressBarMode;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.yahoo.astra.fl.managers.AlertManager;
	
	/**
	 * ...
	 * @author Krishna
	 */
	public class IOProxy extends Proxy implements IProxy
	{
		private var listLoader:URLLoader;
		private var archiveLoader:FZip;
		public static const NAME:String = 'IOProxy';
		private var preloader:ProgressBar;
		private var curtain:Sprite;
		
		public function IOProxy(proxyName:String = null, data:Object = null) 
		{
			super(proxyName, new IOParams());
		}
		
		public function loadApplicationsList():void
		{
			var stageMediator:StageMediator = facade.retrieveMediator(StageMediator.NAME) as StageMediator;
			var stage:Stage = stageMediator.getViewComponent() as Stage;
			var ioParams:IOParams = this.getData() as IOParams;
			
			if (!listLoader) listLoader = new URLLoader();
			if (!listLoader.hasEventListener(Event.COMPLETE)) listLoader.addEventListener(Event.COMPLETE, onListLoaded);
			if (!listLoader.hasEventListener(IOErrorEvent.IO_ERROR)) listLoader.addEventListener(IOErrorEvent.IO_ERROR, onListError);
			if (!listLoader.hasEventListener(Event.OPEN)) listLoader.addEventListener(Event.OPEN, onListLoadStart);
			
		
			try{
			listLoader.load(new URLRequest(ioParams.applicationPath));
			}catch (e:Error) {
				AlertManager.createAlert(stage.getChildAt(0), e.message, "Error");
				AlertManager.textColor = 0x000000;
			}
		}
		
		public function loadArchive():void
		{
			var ioParams:IOParams = this.getData() as IOParams;
			var archiveManagerProxy:ArchiveManagerProxy = facade.retrieveProxy(ArchiveManagerProxy.NAME) as ArchiveManagerProxy;
			var archiveData:ArchiveData = archiveManagerProxy.getData() as ArchiveData;
			var archiveURL:String = ioParams.archivePath;
			
			if (!archiveData.archive) archiveData.archive = new FZip();
			if (!archiveData.archive.hasEventListener(Event.COMPLETE)) archiveData.archive.addEventListener(Event.COMPLETE, onArchiveLoaded);
			if (!archiveData.archive.hasEventListener(IOErrorEvent.IO_ERROR)) archiveData.archive.addEventListener(IOErrorEvent.IO_ERROR, onArchiveLoadError);
			
			archiveData.archive.load(new URLRequest(archiveURL));
			sendNotification(ApplicationFacade.LOAD_APPLICATION_START);
		}
		
		public function downloadArchive():void 
		{
			var archiveManagerProxy:ArchiveManagerProxy = facade.retrieveProxy(ArchiveManagerProxy.NAME) as ArchiveManagerProxy;
			var archiveData:ArchiveData = archiveManagerProxy.getData() as ArchiveData;
			var generatedArchive:FZip = archiveData.newarchive;
			var contextName:String = archiveData.contextName;
			
			var ioParams:IOParams = this.getData() as IOParams;
			var fref:FileReference = ioParams.generated;
			if (!fref) fref = ioParams.generated = new FileReference();
			if (!fref.hasEventListener(Event.COMPLETE)) fref.addEventListener(Event.COMPLETE, onArchiveSaveComplete);
			if (!fref.hasEventListener(Event.CANCEL)) fref.addEventListener(Event.CANCEL, onArchiveSaveCancelled);
			
			var ba:ByteArray = new ByteArray();
			generatedArchive.serialize(ba);
			
			fref.save(ba,contextName+".zip");
		}
		
		
		
		
		/* Event Handlers */
		
		private function onArchiveSaveComplete(e:Event):void
		{
			var stageMediator:StageMediator = facade.retrieveMediator(StageMediator.NAME) as StageMediator;
			var stage:Stage = stageMediator.getViewComponent() as Stage;
			var fref:FileReference = e.target as FileReference;
			fref = null;
			
			
			AlertManager.createAlert(stage.getChildAt(0), "Application Downloaded !", "Status");
			AlertManager.textColor = 0x000000;
		}
		
		private function onArchiveSaveCancelled(e:Event):void
		{
			var fref:FileReference = e.target as FileReference;
			fref = null;
		}
		
		private function onArchiveLoaded(e:Event):void
		{
			sendNotification(ApplicationFacade.LOAD_SUCCESS);
		}
		
		private function onArchiveLoadError(e:IOErrorEvent):void
		{
			sendNotification(ApplicationFacade.LOAD_FAILED);
		}
		
		private function onListLoadStart(e:Event):void
		{
			sendNotification(ApplicationFacade.LOCK);
		}
		
		private function onListError(e:IOErrorEvent):void
		{
			sendNotification(ApplicationFacade.FAILED);
		}
		
		private function onListLoaded(e:Event):void
		{
			XML.ignoreWhitespace = true;
			var listdata:XML = XML(URLLoader(e.target).data);
			var applications:XMLList = listdata.application;
			var appProxy:ApplicationProxy = facade.retrieveProxy(ApplicationProxy.NAME) as ApplicationProxy;
			var applicationData:ApplicationData = appProxy.getData() as ApplicationData;
			
			applicationData.applications.push({label:"Select",description:null,path:null});
			
			for (var i:int = 0; i < applications.length(); i++)
			{
				var appobject:Object = new Object();
				appobject.label = applications[i].title;
				appobject.description = applications[i].description;
				appobject.path = applications[i].path;
				
				applicationData.applications.push(appobject);
			}
			
			sendNotification(ApplicationFacade.READY);
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.IProxy */
		
		override public function getData():Object
		{
			return data;
		}
		
		override public function onRegister():void
		{
			
		}
		
		override public function getProxyName():String
		{
			return NAME;
		}
		
		override public function onRemove():void
		{
			
		}
		
		override public function setData(data:Object):void
		{
			this.data = data;
		}
		
	}

}