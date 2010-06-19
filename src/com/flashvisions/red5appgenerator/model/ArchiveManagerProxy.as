package com.flashvisions.red5appgenerator.model 
{
	import com.flashvisions.red5appgenerator.vo.ApplicationData;
	import com.flashvisions.red5appgenerator.vo.ArchiveData;
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;
	import flash.utils.ByteArray;
	import flash.xml.XMLDocument;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	/**
	 * ...
	 * @author Krishna
	 */
	public class ArchiveManagerProxy extends Proxy implements IProxy
	{
		public static const NAME:String = 'ArchiveManagerProxy';
		
		public function ArchiveManagerProxy(proxyName:String = null, data:Object = null) 
		{
			super(proxyName, new ArchiveData());
		}
		
		public function generateFromLoadedArchive():void
		{
			var archiveData:ArchiveData = this.getData() as ArchiveData;
			var loadedArchive:FZip = archiveData.archive;
			var contextName:String = archiveData.contextName;
			
			var newArchive:FZip = archiveData.newarchive = new FZip();
			
			for (var index:int = 0; index < loadedArchive.getFileCount(); index++)
			{
				var zipFileItem:FZipFile = loadedArchive.getFileAt(index);
				var zipFileItemName:String = zipFileItem.filename as String;
				var zipFileItemContent:ByteArray = zipFileItem.content;
				
				var firstIndex:int = zipFileItemName.indexOf('/');
				
				var newZipItemName:String = contextName + zipFileItemName.substr(firstIndex, zipFileItemName.length - 1);
				newArchive.addFile(newZipItemName, zipFileItemContent);
			}
			
			return;
		}
		
		
		public function updateProperties():void
		{
			var archiveData:ArchiveData = this.getData() as ArchiveData;
			var generatedArchive:FZip = archiveData.newarchive;
			var contextName:String = archiveData.contextName;
			var propertiesFile:FZipFile = generatedArchive.getFileByName(contextName + '/' + ArchiveData.APPROOT + '/' + ArchiveData.PROPERTIES_FILE);
			var content:String = "webapp.contextPath=/" + contextName + "\n" + "webapp.virtualHosts=localhost, 127.0.0.1, 192.168.1.2";
			propertiesFile.setContentAsString(content);
			
			return;
		}
		
		public function updateDescriptor():void
		{
			var xmlDecl:Object;
			var doc:XMLDocument;
			
			var archiveData:ArchiveData = this.getData() as ArchiveData;
			var generatedArchive:FZip = archiveData.newarchive;
			var contextName:String = archiveData.contextName;
			var contextParamPattern:String = "context-param";
			var displayNamePattern:String = "display-name";
			XML.ignoreWhitespace = true;
			XML.prettyPrinting = true;
			
			var descriptorFile:FZipFile = generatedArchive.getFileByName(contextName + '/' + ArchiveData.APPROOT + '/' + ArchiveData.DESCRIPTOR_FILE);
			var applicationDescriptor:XML = XML(descriptorFile.getContentAsString());
			applicationDescriptor.normalize();
			
			doc = new XMLDocument(descriptorFile.getContentAsString());
			xmlDecl = doc.xmlDecl; doc = null;
			
			var childNodes:XMLList = applicationDescriptor.children();
			
			for (var i:int = 0; i < childNodes.length(); i++)
			{
				var xmlItem:XML = childNodes[i] as XML;
					if (xmlItem.localName() == contextParamPattern){
						if (xmlItem.children()[0] == "webAppRootKey")
							xmlItem.children()[1].setChildren("/" + contextName);
					}else if (xmlItem.localName() == displayNamePattern) {
							xmlItem.setChildren(contextName);
					}
			}
			
			doc = new XMLDocument(applicationDescriptor.toXMLString());
			doc.xmlDecl = xmlDecl;
			applicationDescriptor = null;
			
			descriptorFile.setContentAsString(doc.toString());
			
			return;
		}
		
		public function updateCustomStreamNameGenerator():void
		{
			var xmlDecl:Object;
			var docTypeDecl:Object = "<!DOCTYPE beans PUBLIC \"-//SPRING//DTD BEAN//EN\" \"http://www.springframework.org/dtd/spring-beans.dtd\">";
			var doc:XMLDocument;
			
			var archiveData:ArchiveData = this.getData() as ArchiveData;
			var generatedArchive:FZip = archiveData.newarchive;
			var contextName:String = archiveData.contextName;
			XML.ignoreWhitespace = true;
			XML.prettyPrinting = true;
			
			var descriptorFile:FZipFile = generatedArchive.getFileByName(contextName + '/' + ArchiveData.APPROOT + '/' + ArchiveData.BEAN_DESCRIPTOR);
			var beanDescriptor:XML = XML(descriptorFile.getContentAsString());
			beanDescriptor.normalize();
			
			doc = new XMLDocument(descriptorFile.getContentAsString());
			xmlDecl = doc.xmlDecl; doc = null;
			
			var customFileNameGeneratorBean:XMLList = beanDescriptor.bean.(@id == "streamFilenameGenerator");
			var bean:XML = customFileNameGeneratorBean[0];
			
			var recordPathProperty:XMLList = bean.property.(@name == "recordPath");
			recordPathProperty[0].@value = archiveData.recordPath;
			
			var playbackPathProperty:XMLList = bean.property.(@name == "playbackPath");
			playbackPathProperty[0].@value = archiveData.streamPath;
			
			var absolutePathProperty:XMLList = bean.property.(@name == "absolutePath");
			absolutePathProperty[0].@value = archiveData.isAbsolutePath;
			
			doc = new XMLDocument(beanDescriptor.toXMLString());
			doc.xmlDecl = xmlDecl;
			doc.docTypeDecl = docTypeDecl;
			beanDescriptor = null;
			
			descriptorFile.setContentAsString(doc.toString());
			
			return;
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