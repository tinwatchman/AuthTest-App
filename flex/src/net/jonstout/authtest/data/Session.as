package net.jonstout.authtest.data
{
	public class Session
	{
		private var _token:String;
		private var _expireTime:Date;
		
		public function Session(token:String=null, expireTime:Number=-1)
		{
			_token = token;
			_expireTime = new Date();
			if (expireTime > -1) {
				_expireTime.time = expireTime;
			}
		}

		public function get token():String
		{
			return _token;
		}

		public function set token(value:String):void
		{
			_token = value;
		}
		
		public function get expireTime():Number
		{
			return _expireTime.time;
		}
		
		public function set expireTime(value:Number):void
		{
			_expireTime.time = value;
		}
		
		public function get isExpired():Boolean
		{
			if (new Date().time >= _expireTime.time) {
				return true;
			}
			return false;
		}		
	}
}