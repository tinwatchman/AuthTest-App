package net.jonstout.authtest.model
{
	import flash.events.TimerEvent;
	import flash.net.URLRequestMethod;
	import flash.utils.Timer;
	
	import net.jonstout.authtest.Config;
	import net.jonstout.authtest.core.Proxy;
	import net.jonstout.authtest.data.Credentials;
	import net.jonstout.authtest.data.Session;
	import net.jonstout.authtest.utils.Utils;
	
	import starling.events.Event;
	
	public class AuthProxy extends Proxy
	{
		public static const LOGGED_IN:String = "AuthProxy_LOGGED_IN";
		public static const LOGGED_OUT:String = "AuthProxy_LOGGED_OUT";
		public static const REAUTHENTICATED:String = "AuthProxy_REAUTHENTICATED";
		public static const ERROR:String = "AuthProxy_ERROR";
		
		private var service:Service;
		private var timer:Timer;
		private var _isReAuthenticating:Boolean=false;
		
		public function AuthProxy()
		{
			super(AuthProxy);
			service = new Service();
		}
		
		public function get isReAuthenticating():Boolean
		{
			return _isReAuthenticating;
		}
		
		public function register(credentials:Credentials):void {
			var params:Object = getRegistrationParameters(credentials);
			service.addEventListener(ServiceEvent.LOADED, onRegistered);
			service.addEventListener(ServiceEvent.ERROR, onError);
			service.load(Config.REGISTER_URL, params, URLRequestMethod.POST);
		}
		
		public function login(credentials:Credentials):void {
			var params:Object = getRegistrationParameters(credentials);
			service.addEventListener(ServiceEvent.LOADED, onRegistered);
			service.addEventListener(ServiceEvent.ERROR, onError);
			service.load(Config.LOGIN_URL, params, URLRequestMethod.POST);
		}
				
		public function checkAuthentication():void {
			var localProxy:LocalProxy = facade.getProxy(LocalProxy);
			if (localProxy.session != null && !localProxy.session.isExpired) {
				var params:Object = {
					'token':localProxy.session.token
				};
				service.addEventListener(ServiceEvent.LOADED, onCheckAuth);
				service.addEventListener(ServiceEvent.ERROR, onCheckFailed);
				service.load(Config.CHECK_URL, params, URLRequestMethod.POST);
			} else if (localProxy.session && localProxy.session.isExpired) {
				// attempt to reauthenticate
				_isReAuthenticating = true;
				requestAuthentication();
			}
		}
		
		public function logout():void {
			var localProxy:LocalProxy = facade.getProxy(LocalProxy);
			if (localProxy.session != null) {
				var params:Object = {
						'userId': localProxy.userId,
						'deviceId': localProxy.deviceId,
						'devicePass': localProxy.devicePass,
						'token': localProxy.session.token
				};
				service.addEventListener(ServiceEvent.LOADED, onLoggedOut);
				service.addEventListener(ServiceEvent.ERROR, onError);
				service.load(Config.END_URL, params, URLRequestMethod.POST);
			}
		}
		
		private function onRegistered(event:ServiceEvent):void {
			service.removeEventListener(ServiceEvent.LOADED, onRegistered);
			service.removeEventListener(ServiceEvent.ERROR, onError);
			var localProxy:LocalProxy = facade.getProxy(LocalProxy);
			try {
				var response:Object = JSON.parse(String(event.data));
				if (response.success == "true" && response.deviceId == localProxy.deviceId) {
					localProxy.userId = response.userId;
					_isReAuthenticating = false;
					requestAuthentication();
				}
			}catch(e:Error){
			}			
		}
		
		private function onError(event:ServiceEvent):void {
			service.removeEventListener(ServiceEvent.LOADED, onRegistered);
			service.removeEventListener(ServiceEvent.LOADED, onLoggedIn);
			service.removeEventListener(ServiceEvent.LOADED, onLoggedOut);
			service.removeEventListener(ServiceEvent.ERROR, onError);
			dispatchEvent(new Event(ERROR, false, event.data));
		}
		
		private function requestAuthentication():void {
			var localProxy:LocalProxy = facade.getProxy(LocalProxy);
			var params:Object = {
				'userId': localProxy.userId,
				'deviceId': localProxy.deviceId,
				'devicePass': localProxy.devicePass
			};
			service.addEventListener(ServiceEvent.LOADED, onLoggedIn);
			service.addEventListener(ServiceEvent.ERROR, onError);
			service.load(Config.START_URL, params, URLRequestMethod.POST);
		}
		
		private function onLoggedIn(event:ServiceEvent):void {
			service.removeEventListener(ServiceEvent.LOADED, onLoggedIn);
			service.removeEventListener(ServiceEvent.ERROR, onError);
			var localProxy:LocalProxy = facade.getProxy(LocalProxy);
			try {
				var raw:Object = JSON.parse(String(event.data));
				if (raw && raw.success == "true" && raw.userId && raw.userId == localProxy.userId && raw.deviceId && raw.deviceId == localProxy.deviceId && raw.session && raw.session.token && raw.session.expires) {
					trace("auth success!");
					// create and save session
					var session:Session = new Session();
					session.token = raw.session.token;
					session.expireTime = Number(raw.session.expires)*1000;
					localProxy.session = session;
					// create timer to refresh session on expire
					var ttl:Number = session.expireTime - new Date().time - 10000;
					timer = new Timer(ttl);
					timer.addEventListener(TimerEvent.TIMER_COMPLETE, onSessionExpire);
					timer.start();
					// notify
					if (_isReAuthenticating) {
						_isReAuthenticating = false;
						dispatchEvent(new Event(REAUTHENTICATED));
					} else {
						dispatchEvent(new Event(LOGGED_IN));
					}
				}
			}catch(e:Error){
				trace("whoops, parsing error");
			}
		}
				
		private function onCheckAuth(event:ServiceEvent):void {
			service.removeEventListener(ServiceEvent.LOADED, onCheckAuth);
			service.removeEventListener(ServiceEvent.ERROR, onCheckFailed);
			var isAuthenticationStillValid:Boolean=false;
			try {
				var raw:Object = JSON.parse(String(event.data));
				if (event.statusCode == 200 && raw && raw.success == "true") {
					isAuthenticationStillValid=true;
				}
			}catch (e:Error){
			}
			if (isAuthenticationStillValid) {
				dispatchEvent(new Event(REAUTHENTICATED));
			} else {
				dispatchEvent(new Event(LOGGED_OUT));
			}
		}
		
		private function onCheckFailed(event:ServiceEvent):void {
			service.removeEventListener(ServiceEvent.LOADED, onCheckAuth);
			service.removeEventListener(ServiceEvent.ERROR, onCheckFailed);
			if (event.statusCode == 401 && String(event.data).indexOf("token expired") > -1) {
				// if token is expired, try to restart the session automatically
				_isReAuthenticating = true;
				requestAuthentication();
			} else {
				dispatchEvent(new Event(ERROR, false, event.data));
			}
		}
				
		private function onLoggedOut(event:ServiceEvent):void {
			service.removeEventListener(ServiceEvent.LOADED, onLoggedOut);
			service.removeEventListener(ServiceEvent.ERROR, onError);
			try {
				var raw:Object = JSON.parse(String(event.data));
				if (event.statusCode == 200 && raw && raw.success == "true") {
					var localProxy:LocalProxy = facade.getProxy(LocalProxy);
					localProxy.reset();
					dispatchEvent(new Event(LOGGED_OUT));
					return;
				}
			}catch(e:Error){
			}
			dispatchEvent(new Event(ERROR));
		}
		
		private function onSessionExpire(event:TimerEvent):void {
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onSessionExpire);
			timer.stop();
			_isReAuthenticating = true;
			trace("reauthenticating");
			requestAuthentication();
		}
		
		private function getRegistrationParameters(credentials:Credentials):Object {
			var localProxy:LocalProxy = facade.getProxy(LocalProxy);
			if (!localProxy.hasDevicePass) {
				localProxy.devicePass = Utils.generateDevicePass(Config.DEVICE_PASS_LENGTH);
			}
			return {
					'userEmail': credentials.email,
					'userPass': credentials.pass,
					'deviceId': localProxy.deviceId,
					'devicePass': localProxy.devicePass
					};
		}		
	}
}