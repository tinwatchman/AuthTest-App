package net.jonstout.authtest.control
{
	import flash.events.Event;
	
	import net.jonstout.authtest.Config;
	import net.jonstout.authtest.core.Command;
	import net.jonstout.authtest.core.Notification;
	import net.jonstout.authtest.data.AlertRequest;
	import net.jonstout.authtest.model.AuthProxy;
	import net.jonstout.authtest.model.LocalProxy;
	import net.jonstout.authtest.utils.Utils;
	import net.jonstout.authtest.view.screens.ViewPageScreen;
	
	public class ViewPageCommand extends Command
	{
		private var screen:ViewPageScreen;
		private var authProxy:AuthProxy;
		private var localProxy:LocalProxy;
		
		public function ViewPageCommand()
		{
			super(Notification.VIEW_PAGE);
		}
		
		override public function execute(data:Object=null):void {
			screen = data as ViewPageScreen;
			authProxy = facade.getProxy(AuthProxy);
			localProxy = facade.getProxy(LocalProxy);
			if (screen != null && localProxy.session != null && !localProxy.session.isExpired) {
				if (authProxy.isReAuthenticating) {
					authProxy.addEventListener(AuthProxy.REAUTHENTICATED, onReAuth);
					authProxy.addEventListener(AuthProxy.ERROR, onReAuthError);
				} else {
					showPage();
				}
			} else {
				trace("what the hell?");
			}
		}
		
		private function onReAuth(event:Event):void {
			authProxy.removeEventListener(AuthProxy.REAUTHENTICATED, onReAuth);
			authProxy.removeEventListener(AuthProxy.ERROR, onReAuthError);
			showPage();
		}
		
		private function onReAuthError(event:Event):void {
			authProxy.removeEventListener(AuthProxy.REAUTHENTICATED, onReAuth);
			authProxy.removeEventListener(AuthProxy.ERROR, onReAuthError);
			var alert:AlertRequest = new AlertRequest(AlertRequest.ALERT, Config.REAUTH_ERROR_MESSAGE);
			screen.onPageError();
			facade.notify(Notification.SHOW_ALERT, alert);
			clean();
		}
		
		private function showPage():void {
			var pageUrl:String = Utils.generateUrl(Config.PAGE_URL, { 'token':localProxy.session.token });
			screen.setUpBrowser(facade.rootApplication.stage);
			screen.viewUrl(pageUrl);
			clean();
		}
		
		private function clean():void {
			screen = null;
			authProxy = null;
			localProxy = null;
		}
		
		override public function dispose():void {
			super.dispose();
			clean();
		}
	}
}