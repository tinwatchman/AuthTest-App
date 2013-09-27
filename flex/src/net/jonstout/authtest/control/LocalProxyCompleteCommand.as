package net.jonstout.authtest.control
{
	import net.jonstout.authtest.core.Command;
	import net.jonstout.authtest.core.Facade;
	import net.jonstout.authtest.core.Notification;
	import net.jonstout.authtest.model.AuthProxy;
	import net.jonstout.authtest.model.LocalProxy;
	import net.jonstout.authtest.utils.Utils;
	
	import starling.events.Event;
	
	public class LocalProxyCompleteCommand extends Command
	{
		public function LocalProxyCompleteCommand()
		{
			super(LocalProxy.COMPLETE);
		}
		
		override public function execute(data:Object=null):void {
			var localProxy:LocalProxy = facade.getProxy(LocalProxy);
			var authProxy:AuthProxy = facade.getProxy(AuthProxy);
			if (localProxy.isSupported) {
				if (!localProxy.hasDeviceId) {
					// generate device id
					localProxy.deviceId = Utils.generateDeviceId();
				}
				if (localProxy.hasUserId && localProxy.hasSession) {
					authProxy.addEventListener(AuthProxy.REAUTHENTICATED, onCheckAuthentication);
					authProxy.addEventListener(AuthProxy.LOGGED_OUT, onInvalidSession);
					authProxy.checkAuthentication();
					return;
				} else {
					facade.state = Facade.APP_STATE_LOGGED_OUT;
				}
			} else {
				facade.state = Facade.APP_STATE_NO_LOCAL_STORAGE;
			}
			facade.notify(Notification.STARTUP_COMPLETE);
		}
		
		private function onCheckAuthentication(event:Event):void {
			var authProxy:AuthProxy = facade.getProxy(AuthProxy);
			authProxy.removeEventListener(AuthProxy.REAUTHENTICATED, onCheckAuthentication);
			authProxy.removeEventListener(AuthProxy.LOGGED_OUT, onInvalidSession);
			facade.state = Facade.APP_STATE_LOGGED_IN;
			facade.notify(Notification.STARTUP_COMPLETE);
		}
		
		private function onInvalidSession(event:Event):void {
			var authProxy:AuthProxy = facade.getProxy(AuthProxy);
			authProxy.removeEventListener(AuthProxy.REAUTHENTICATED, onCheckAuthentication);
			authProxy.removeEventListener(AuthProxy.LOGGED_OUT, onInvalidSession);
			facade.state = Facade.APP_STATE_LOGGED_OUT;
			facade.notify(Notification.STARTUP_COMPLETE);
		}
	}
}