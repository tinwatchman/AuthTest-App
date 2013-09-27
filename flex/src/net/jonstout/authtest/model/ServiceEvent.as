package net.jonstout.authtest.model
{
	import starling.events.Event;
	
	public class ServiceEvent extends Event
	{
		public static const LOADED:String = "ServiceLoaded";
		public static const ERROR:String = "ServiceError";
		
		private var _statusCode:int=-1;
		
		public function ServiceEvent(type:String, data:Object=null, statusCode:int=-1)
		{
			_statusCode = statusCode;
			super(type, false, data);
		}

		public function get statusCode():int
		{
			return _statusCode;
		}
		
		public function get text():String
		{
			return (data as String);
		}
	}
}