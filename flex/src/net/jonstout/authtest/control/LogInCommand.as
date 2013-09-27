package net.jonstout.authtest.control
{
	import net.jonstout.authtest.core.Command;
	import net.jonstout.authtest.core.Notification;
	import net.jonstout.authtest.data.Credentials;
	import net.jonstout.authtest.model.AuthProxy;
	import net.jonstout.authtest.utils.Utils;
	import net.jonstout.authtest.view.screens.LogInScreen;
	
	import starling.events.Event;
	
	public class LogInCommand extends Command
	{
		private var screen:LogInScreen;
		private var authProxy:AuthProxy;
		
		public function LogInCommand()
		{
			super(Notification.LOG_IN);
		}
		
		override public function execute(data:Object=null):void {
			screen = data.screen as LogInScreen;
			var creds:Credentials = data.credentials as Credentials;
			authProxy = facade.getProxy(AuthProxy);
			authProxy.addEventListener(AuthProxy.LOGGED_IN, onLoggedIn);
			authProxy.addEventListener(AuthProxy.ERROR, onError);
			authProxy.login(creds);
		}
		
		private function onLoggedIn(event:Event):void {
			if (screen != null) {
				facade.notify(Notification.UPDATE_APP_STATE);
				screen.onLoggedIn();
			}
			clean();
		}
		
		private function onError(event:Event):void {
			if (event.data && String(event.data).indexOf("Invalid user credentials") > -1) {
				screen.onBadCredentials();
			} else if (event.data && String(event.data).indexOf("error") > -1) {
				screen.onLogInError( Utils.parseServerError(event.data) );
			}
			clean();
		}
		
		private function clean():void {
			authProxy.removeEventListener(AuthProxy.LOGGED_IN, onLoggedIn);
			authProxy.removeEventListener(AuthProxy.ERROR, onError);
			screen = null;
			authProxy = null;
		}
	}
}