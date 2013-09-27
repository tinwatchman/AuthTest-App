package net.jonstout.authtest.control
{
	import net.jonstout.authtest.core.Command;
	import net.jonstout.authtest.core.Notification;
	import net.jonstout.authtest.model.AuthProxy;
	import net.jonstout.authtest.view.screens.StartScreen;
	
	import starling.events.Event;
	
	public class LogOutCommand extends Command
	{
		private var screen:StartScreen;
		private var authProxy:AuthProxy;
		
		public function LogOutCommand()
		{
			super(Notification.LOG_OUT);
		}
		
		override public function execute(data:Object=null):void {
			screen = data as StartScreen;
			if (screen != null) {
				authProxy = facade.getProxy(AuthProxy);
				authProxy.addEventListener(AuthProxy.LOGGED_OUT, onLoggedOut);
				authProxy.addEventListener(AuthProxy.ERROR, onLogOutError);
				authProxy.logout();
			}
		}
		
		private function onLoggedOut(event:Event):void {
			facade.notify(Notification.UPDATE_APP_STATE);
			screen.onLogOut();
			clean();
		}
		
		private function onLogOutError(event:Event):void {
			//TODO: something here
			clean();
		}
		
		private function clean():void {
			authProxy.removeEventListener(AuthProxy.LOGGED_OUT, onLoggedOut);
			authProxy.removeEventListener(AuthProxy.ERROR, onLogOutError);
			screen = null;
			authProxy = null;
		}
	}
}