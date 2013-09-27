package net.jonstout.authtest.core
{
	public class Command
	{
		protected var facade:Facade;
		private var _trigger:String;
		
		public function Command(trigger:String)
		{
			_trigger = trigger;
			facade = Facade.getInstance();
		}
		
		public function get trigger():String {
			return _trigger;
		}
		
		protected function set trigger(value:String):void {
			_trigger = value;
		}
		
		public function execute(data:Object=null):void {
			// override in subclasses
		}
		
		public function dispose():void {
			facade = null;
			_trigger = null;
		}
	}
}