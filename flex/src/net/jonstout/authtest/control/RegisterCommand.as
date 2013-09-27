package net.jonstout.authtest.control
{
	import net.jonstout.authtest.core.Command;
	import net.jonstout.authtest.core.Notification;
	import net.jonstout.authtest.data.Credentials;
	import net.jonstout.authtest.model.AuthProxy;
	import net.jonstout.authtest.utils.Utils;
	import net.jonstout.authtest.view.screens.RegisterScreen;
	
	import starling.events.Event;
	
	public class RegisterCommand extends Command
	{
		private var view:RegisterScreen;
		private var authProxy:AuthProxy;
		
		public function RegisterCommand()
		{
			super(Notification.REGISTER);
		}
		
		override public function execute(data:Object=null):void {
			view = data.screen as RegisterScreen;
			var creds:Credentials = data.credentials as Credentials;
			authProxy = facade.getProxy(AuthProxy);
			authProxy.addEventListener(AuthProxy.LOGGED_IN, onRegistered);
			authProxy.addEventListener(AuthProxy.ERROR, onRegistrationError);
			authProxy.register(creds);
		}
		
		private function onRegistered(event:Event):void {
			if (view != null) {
				facade.notify(Notification.UPDATE_APP_STATE);
				view.onRegistrationComplete();
			}
			clean();
		}
		
		private function onRegistrationError(event:Event):void {
			if (event.data && String(event.data).indexOf("User already registered") > -1) {
				view.onAlreadyRegistered();
			} else if (event.data && String(event.data).indexOf("error") > -1) {
				view.onRegistrationFailed( Utils.parseServerError(event.data) );
			}
			clean();
		}
		
		private function clean():void {
			authProxy.removeEventListener(AuthProxy.LOGGED_IN, onRegistered);
			authProxy.removeEventListener(AuthProxy.ERROR, onRegistrationError);
			view = null;
			authProxy = null;
		}
	}
}