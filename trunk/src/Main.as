package 
{
	import com.flashvisions.red5appgenerator.ApplicationFacade;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Krishna
	 */
	public class Main extends Sprite 
	{
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			ApplicationFacade.getInstance().startup(this.stage);
		}
		
	}
	
}