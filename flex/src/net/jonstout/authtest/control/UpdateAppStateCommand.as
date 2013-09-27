package net.jonstout.authtest.control
{
	import net.jonstout.authtest.core.Command;
	import net.jonstout.authtest.core.Facade;
	import net.jonstout.authtest.core.Notification;
	import net.jonstout.authtest.model.LocalProxy;
	
	public class UpdateAppStateCommand extends Command
	{		
		public function UpdateAppStateCommand()
		{
			super(Notification.UPDATE_APP_STATE);
		}
		
		override public function execute(data:Object=null):void {
			var localProxy:LocalProxy = facade.getProxy(LocalProxy);
			if (localProxy.isSupported && localProxy.hasSession && !localProxy.session.isExpired) {
				facade.state = Facade.APP_STATE_LOGGED_IN;
			} else if (localProxy.isSupported) {
				facade.state = Facade.APP_STATE_LOGGED_OUT;
			} else {
				facade.state = Facade.APP_STATE_NO_LOCAL_STORAGE;
			}
			trace("app state: " + facade.state);
		}
	}
}