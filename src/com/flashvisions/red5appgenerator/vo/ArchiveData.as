package com.flashvisions.red5appgenerator.vo 
{
	import deng.fzip.FZip;
	/**
	 * ...
	 * @author Krishna
	 */
	public class ArchiveData
	{
		public static const APPROOT:String = "WEB-INF";
		public static const DESCRIPTOR_FILE:String = "web.xml";
		public static const PROPERTIES_FILE:String = "red5-web.properties";
		public static const BEAN_DESCRIPTOR:String = "red5-web.xml";
		public static const DEFAULT_CONTEXTNAME:String = "appname";
		public static const DEFAULT_STREAMPATH:String = "recordedStreams/";
		public static const DEFAULT_RECORDPATH:String = "recordedStreams/";
		
		public var archive:FZip;
		public var newarchive:FZip;
		public var contextName:String;
		public var streamPath:String;
		public var recordPath:String;
		public var isAbsolutePath:Object;
		
		public function ArchiveData() 
		{
			
		}
		
	}

}