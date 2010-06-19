package com.flashvisions.red5appgenerator.model 
{
	import com.flashvisions.red5appgenerator.vo.ApplicationData;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	/**
	 * ...
	 * @author Krishna
	 */
	public class ApplicationProxy extends Proxy implements IProxy
	{
		
		
		public static const NAME:String = 'ApplicationProxy';
		
		public function ApplicationProxy(proxyName:String = null, data:Object = null) 
		{
			super(proxyName, new ApplicationData());
			
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