package net.jonstout.authtest.data
{
	public class AlertRequest
	{
		private var _type:uint;
		private var _text:String;
		private var _okText:String;
		private var _cancelText:String;
		private var _responder:Object;
		private var _okHandler:Function;
		private var _cancelHandler:Function;
		
		public static const MESSAGE:uint = 0;
		public static const ALERT:uint = 1;
		public static const CONFIRM:uint = 2;
		public static const PROMPT:uint = 3;
		
		public function AlertRequest(type:uint, text:String, okText:String=null, cancelText:String=null, responder:Object=null, okHandler:Function=null, cancelHandler:Function=null)
		{
			_type = type;
			_text = text;
			_okText = okText;
			_cancelText = cancelText;
			_responder = responder;
			_okHandler = okHandler;
			_cancelHandler = cancelHandler;
		}
		
		public function setResponder(responder:Object, okHandler:Function, cancelHandler:Function=null):void {
			_responder = responder;
			_okHandler = okHandler;
			_cancelHandler = cancelHandler;
		}

		public function get type():uint
		{
			return _type;
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
		}
		
		public function get okText():String
		{
			return _okText;
		}

		public function set okText(value:String):void
		{
			_okText = value;
		}

		public function get cancelText():String
		{
			return _cancelText;
		}

		public function set cancelText(value:String):void
		{
			_cancelText = value;
		}
		
		public function ok(input:String=null):void {
			if (_type == PROMPT && _responder && _okHandler) {
				_okHandler.apply(_responder, [input]);
			} else if (_responder && _okHandler) {
				_okHandler.apply(_responder, []);
			}
		}
		
		public function cancel():void {
			if (_responder && _cancelHandler) {
				_cancelHandler.apply(_responder, []);
			}
		}
		
		public function clear():void {
			_text = null;
			_okText = null;
			_cancelText = null;
			_responder = null;
			_okHandler = null;
			_cancelHandler = null;
		}
	}
}