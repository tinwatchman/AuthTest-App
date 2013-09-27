package net.jonstout.authtest.view.screens
{
	import starling.events.Event;
	
	public class ScreenEvent extends Event
	{
		/**
		 * Master type. Listen for this above the Screen level. 
		 */
		public static const EVENT:String = "ScreenEVENT";
		
		// SUBTYPES
		public static const SEND_NOTIFICATION:String = "ScreenEvent_SEND_NOTIFICATION";
		public static const NAVIGATE:String = "ScreenEvent_NAVIGATE";
		
		private var _subtype:String;
		private var _screen:BaseScreen;
		
		public function ScreenEvent(subtype:String, screen:BaseScreen, data:Object=null)
		{
			_subtype = subtype;
			_screen = screen;
			super(EVENT, false, data);
		}

		public function get subtype():String
		{
			return _subtype;
		}
		
		public function get screen():BaseScreen
		{
			return _screen;
		}
		
		public function clone():ScreenEvent
		{
			return new ScreenEvent(_subtype, _screen, data);
		}
	}
}