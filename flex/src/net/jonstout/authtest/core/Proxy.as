package net.jonstout.authtest.core
{
	import starling.events.EventDispatcher;
	
	public class Proxy extends EventDispatcher
	{
		private var _ref:Class;
		protected var facade:Facade;
		
		public function Proxy(topLevelClassReference:Class)
		{
			super();
			_ref = topLevelClassReference;
			facade = Facade.getInstance();
		}
				
		public function get ref():Class
		{
			return _ref;
		}
		
		public function start():void {
			// override in subclasses
		}
		
		public function notify(type:String, data:Object=null):void {
			facade.notify(type, data);
		}
		
		public function dispose():void {
			_ref = null;
			facade = null;
		}
	}
}