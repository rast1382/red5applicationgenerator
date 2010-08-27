package com.flashvisions.red5appgenerator.view 
{
	import com.flashvisions.red5appgenerator.ApplicationFacade;
	import com.flashvisions.red5appgenerator.model.ApplicationProxy;
	import com.flashvisions.red5appgenerator.model.ArchiveManagerProxy;
	import com.flashvisions.red5appgenerator.model.IOProxy;
	import com.flashvisions.red5appgenerator.vo.ApplicationData;
	import com.flashvisions.red5appgenerator.vo.ArchiveData;
	import com.flashvisions.red5appgenerator.vo.IOParams;
	import fl.controls.Button;
	import fl.controls.ProgressBar;
	import fl.controls.ProgressBarMode;
	import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
	import fl.data.DataProvider;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import flash.text.TextField;
	import fl.controls.ComboBox;
	import fl.controls.TextInput;
	/**
	 * ...
	 * @author Krishna
	 */
	public class StageMediator extends Mediator implements IMediator
	{
		public static const NAME:String = 'StageMediator';
		private var application:Main;
		public var applicationSelector:ComboBox;
		public var txtContextName:TextInput;
		public var btnDownloader:Button;
		public var txtStreamDirectory:TextInput;
		public var txtRecordDirectory:TextInput;
		public var progressMonitor:ProgressBar;
		public var curtain:Sprite;
		 
		public function StageMediator(mediatorName:String = null, viewComponent:Object = null) 
		{
			super(mediatorName, viewComponent);
			init();
		}
		
		private function init():void
		{
			application = (this.viewComponent as Stage).getChildAt(0) as Main;
			curtain = new Sprite();
			viewComponent.addChild(curtain);
			progressMonitor = new ProgressBar();
			progressMonitor.indeterminate = true;
			viewComponent.addChild(progressMonitor);
			
			hideProgress();
		}
		
		private function showProgress():void
		{
			curtain.graphics.lineStyle(0, 0x000000, 1);
			curtain.graphics.beginFill(0x000000, .8);
			curtain.graphics.drawRect(0, 0, Stage(viewComponent).stageWidth, Stage(viewComponent).stageHeight);
			curtain.graphics.endFill();
			curtain.mouseChildren = false;
			
			progressMonitor.x = Stage(viewComponent).stageWidth / 2 - progressMonitor.width / 2;
			progressMonitor.y = Stage(viewComponent).stageHeight / 2 - progressMonitor.height / 2;
			
			progressMonitor.visible = true;
		}
		
		private function hideProgress():void
		{
			curtain.mouseChildren = true;
			curtain.graphics.clear();
			
			progressMonitor.visible = false;
		}
		
		/* INTERFACE org.puremvc.as3.interfaces.IMediator */
		
		override public function listNotificationInterests():Array
		{
			return [ApplicationFacade.LOCK,ApplicationFacade.UNLOCK,ApplicationFacade.READY,ApplicationFacade.ENABLEDOWLOAD,ApplicationFacade.DISABLEDOWLOAD,ApplicationFacade.LOAD_APPLICATION_START,ApplicationFacade.LOAD_SUCCESS,ApplicationFacade.LOAD_FAILED];
		}
		
		override public function onRegister():void
		{
			
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.LOCK:
				application.applicationSelector.enabled = application.txtContextName.enabled = application.btnDownloader.enabled = false;
				break;
				
				case ApplicationFacade.UNLOCK:
				application.applicationSelector.enabled = application.txtContextName.enabled = application.btnDownloader.enabled = true;
				break;
				
				case ApplicationFacade.READY:
				var appProxy:ApplicationProxy = facade.retrieveProxy(ApplicationProxy.NAME) as ApplicationProxy;
				var applicationData:ApplicationData = appProxy.getData() as ApplicationData;
				
				applicationSelector = application.applicationSelector;
				applicationSelector.dataProvider = new DataProvider(applicationData.applications);
				applicationSelector.addEventListener(Event.CHANGE, onSelectionChanged);
				
				txtContextName = application.txtContextName;
				txtContextName.restrict = "a-z A-Z 0-9 ^\u0020";
				txtContextName.addEventListener(Event.CHANGE , onTextChanged);
				txtContextName.text = ArchiveData.DEFAULT_CONTEXTNAME;
				
				btnDownloader = application.btnDownloader;
				btnDownloader.addEventListener(MouseEvent.CLICK, onDownloadRequest);
				
				txtStreamDirectory = application.txtStreamDirectory;
				txtStreamDirectory.restrict = "a-z A-Z 0-9 / _ ^\u0020 : ~";
				txtStreamDirectory.text = ArchiveData.DEFAULT_STREAMPATH;
				txtStreamDirectory.addEventListener(Event.CHANGE , onPlaybackPathChanged);
				
				txtRecordDirectory = application.txtRecordDirectory;
				txtRecordDirectory.restrict = "a-z A-Z 0-9 / _ ^\u0020 : ~";
				txtRecordDirectory.text = ArchiveData.DEFAULT_RECORDPATH;
				txtRecordDirectory.addEventListener(Event.CHANGE, onRecordPathChanged);
				
				var pathType:RadioButtonGroup = new RadioButtonGroup("pathType");
				pathType.addEventListener(Event.CHANGE, onPathTypeChanged);
				RadioButton(application.rbRelative).group = RadioButton(application.rbAbsolute).group = pathType;
				
				sendNotification(ApplicationFacade.DISABLEDOWLOAD);
				break;
				
				case ApplicationFacade.ENABLEDOWLOAD:
				btnDownloader.enabled  = true;
				break;
				
				case ApplicationFacade.DISABLEDOWLOAD:
				btnDownloader.enabled  = false;
				break;
				
				case ApplicationFacade.LOAD_APPLICATION_START:
				showProgress();
				break;
				
				case ApplicationFacade.LOAD_SUCCESS:
				hideProgress();
				break;
				
				case ApplicationFacade.LOAD_FAILED:
				hideProgress();
				break;
			}
		}
		
		override public function getMediatorName():String
		{
			return NAME;
		}
		
		override public function setViewComponent(viewComponent:Object):void
		{
			this.viewComponent = viewComponent;
		}
		
		override public function getViewComponent():Object
		{
			return this.viewComponent;
		}
		
		override public function onRemove():void
		{
			
		}
		
		/* Event Handlers */
		
		private function onSelectionChanged(e:Event):void
		{
			var appProxy:ApplicationProxy = facade.retrieveProxy(ApplicationProxy.NAME) as ApplicationProxy;
			var applicationData:ApplicationData = appProxy.getData() as ApplicationData;
				
			validateForm();
			application.txtDescription.htmlText = (applicationSelector.selectedItem.description != null)?applicationSelector.selectedItem.description:"";
		}
		
		private function onTextChanged(e:Event):void
		{
			validateForm();
		}
		
		private function onPlaybackPathChanged(e:Event):void
		{
			validateForm();
		}
		
		private function onRecordPathChanged(e:Event):void
		{
			validateForm();
		}
		
		private function onPathTypeChanged(e:Event):void
		{
			var archiveManagerProxy:ArchiveManagerProxy = facade.retrieveProxy(ArchiveManagerProxy.NAME) as ArchiveManagerProxy;
			var archiveData:ArchiveData = archiveManagerProxy.getData() as ArchiveData;
			archiveData.isAbsolutePath = RadioButtonGroup(e.target).selectedData;
		}
		
		private function onDownloadRequest(e:MouseEvent):void
		{
			var ioProxy:IOProxy = facade.retrieveProxy(IOProxy.NAME) as IOProxy;
			var ioparams:IOParams = ioProxy.getData() as IOParams;
			ioparams.archivePath = application.applicationSelector.selectedItem.path;
			
			var archiveManagerProxy:ArchiveManagerProxy = facade.retrieveProxy(ArchiveManagerProxy.NAME) as ArchiveManagerProxy;
			var archiveData:ArchiveData = archiveManagerProxy.getData() as ArchiveData;
			archiveData.contextName = txtContextName.text;
			archiveData.streamPath = (txtStreamDirectory.text.charAt(txtStreamDirectory.length - 1) != "/")?txtStreamDirectory.text + "/":txtStreamDirectory.text;
			archiveData.recordPath = (txtRecordDirectory.text.charAt(txtRecordDirectory.length - 1) != "/")?txtRecordDirectory.text + "/":txtRecordDirectory.text;
			if (ioparams.archivePath != null) sendNotification(ApplicationFacade.LOAD_APPLICATION);
		}
		
		private function validateForm():void
		{
			if ((txtContextName.length <= 2) || (applicationSelector.selectedItem.path == null) || (txtStreamDirectory.length <= 4) || (txtRecordDirectory.length <= 4))
			sendNotification(ApplicationFacade.DISABLEDOWLOAD);
			else
			sendNotification(ApplicationFacade.ENABLEDOWLOAD);
		}
	}

}