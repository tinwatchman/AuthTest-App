package net.jonstout.authtest.model
{
	import flash.data.EncryptedLocalStore;
	import flash.utils.ByteArray;
	
	import net.jonstout.authtest.core.Proxy;
	import net.jonstout.authtest.data.Session;
	
	public class LocalProxy extends Proxy
	{
		private var _userId:String;
		private var _deviceId:String;
		private var _devicePass:String;
		private var _session:Session;
		
		public static const COMPLETE:String = "LocalProxy_COMPLETE";
		
		private static const USER_ID_KEY:String = "userId";
		private static const DEVICE_ID_KEY:String = "deviceId";
		private static const DEVICE_PASS_KEY:String = "devicePass";
		private static const SESSION_TOKEN_KEY:String = "session_token";
		private static const SESSION_EXPIRE_KEY:String = "session_expire";
		
		public function LocalProxy()
		{
			super(LocalProxy);
		}
		
		override public function start():void {
			if (EncryptedLocalStore.isSupported) {
				if (EncryptedLocalStore.getItem(USER_ID_KEY) != null) {
					_userId = read(USER_ID_KEY);
				}
				if (EncryptedLocalStore.getItem(DEVICE_ID_KEY) != null) {
					_deviceId = read(DEVICE_ID_KEY);
				}
				if (EncryptedLocalStore.getItem(DEVICE_PASS_KEY) != null) {
					_devicePass = read(DEVICE_PASS_KEY);
				}
				if (EncryptedLocalStore.getItem(SESSION_TOKEN_KEY) != null) {
					var token:String = read(SESSION_TOKEN_KEY);
					var expire:Number = Number(read(SESSION_EXPIRE_KEY));
					session = new Session(token, expire);
				}
			}
			notify(COMPLETE);
		}
		
		public function reset():void {
			if (EncryptedLocalStore.isSupported) {
				EncryptedLocalStore.removeItem(USER_ID_KEY);
				EncryptedLocalStore.removeItem(DEVICE_PASS_KEY);
				EncryptedLocalStore.removeItem(SESSION_TOKEN_KEY);
				EncryptedLocalStore.removeItem(SESSION_EXPIRE_KEY);
				_userId = null;
				_devicePass = null;
				_session = null;
			}
		}
		
		public function get userId():String
		{
			return _userId;
		}
		
		public function set userId(value:String):void
		{
			_userId = value;
			write(USER_ID_KEY, _userId);
		}
		
		public function get deviceId():String
		{
			return _deviceId;
		}
		
		public function set deviceId(value:String):void
		{
			_deviceId = value;
			write(DEVICE_ID_KEY, _deviceId);
		}
		
		public function get devicePass():String
		{
			return _devicePass;
		}
		
		public function set devicePass(value:String):void
		{
			_devicePass = value;
			write(DEVICE_PASS_KEY, _devicePass);
		}
		
		public function get session():Session
		{
			return _session;
		}
		
		public function set session(value:Session):void
		{
			_session = value;
			if (hasSession) {
				write(SESSION_TOKEN_KEY, _session.token);
				write(SESSION_EXPIRE_KEY, _session.expireTime.toString());
			} else {
				EncryptedLocalStore.removeItem(SESSION_TOKEN_KEY);
				EncryptedLocalStore.removeItem(SESSION_EXPIRE_KEY);
			}
		}
		
		public function get isSupported():Boolean 
		{
			return EncryptedLocalStore.isSupported;
		}
		
		public function get hasUserId():Boolean
		{
			return (_userId != null && _userId != "");
		}
		
		public function get hasDeviceId():Boolean
		{
			return (_deviceId != null && _deviceId != "");
		}
		
		public function get hasDevicePass():Boolean
		{
			return (_devicePass != null && _devicePass != "");
		}
		
		public function get hasSession():Boolean
		{
			return (_session != null && _session.token != null && _session.token != "");
		}
		
		private function read(key:String):String {
			return EncryptedLocalStore.getItem(key).readUTF();
		}
		
		private function write(key:String, value:String=null):void {
			var binaryValue:ByteArray = new ByteArray();
			if (value != null) {
				binaryValue.writeUTF(value);
			}
			EncryptedLocalStore.setItem(key, binaryValue);
		}	
	}
}