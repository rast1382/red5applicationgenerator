package com.flashvisions.red5appgenerator.model 
{
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	/**
	 * ...
	 * @author Krishna
	 */
	public class ConfigProxy extends Proxy implements IProxy
	{
		public static const NAME:String = 'ConfigProxy';
		
		public function ConfigProxy(proxyName:String = null, data:Object = null) 
		{
			super(proxyName, data);
			
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