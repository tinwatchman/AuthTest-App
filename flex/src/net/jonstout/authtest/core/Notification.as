package net.jonstout.authtest.core
{
	import starling.events.Event;
	
	public class Notification extends Event
	{
		public static const STARTUP_COMPLETE:String = "STARTUP_COMPLETE";
		public static const SHOW_ALERT:String = "SHOW_ALERT";
		public static const HIDE_ALERT:String = "HIDE_ALERT";
		public static const REGISTER:String = "REGISTER";
		public static const LOG_IN:String = "LOG_IN";
		public static const LOG_OUT:String = "LOG_OUT";
		public static const UPDATE_APP_STATE:String = "UPDATE_APP_STATE";
		public static const REFRESH_START_SCREEN:String = "REFRESH_START_SCREEN";
		public static const VIEW_PAGE:String = "VIEW_PAGE";
		
		public function Notification(type:String, data:Object=null)
		{
			super(type, false, data);
		}
	}
}