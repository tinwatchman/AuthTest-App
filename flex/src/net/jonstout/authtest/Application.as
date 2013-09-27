package net.jonstout.authtest
{
	import feathers.controls.Label;
	
	import net.jonstout.authtest.core.Facade;
	import net.jonstout.authtest.core.Notification;
	import net.jonstout.authtest.data.ScreenId;
	import net.jonstout.authtest.theme.MinimalMobileTheme;
	import net.jonstout.authtest.theme.Theme;
	import net.jonstout.authtest.view.LoadingView;
	import net.jonstout.authtest.view.MainView;
	import net.jonstout.authtest.view.screens.ScreenEvent;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Application extends Sprite
	{
		private var theme:Theme;
		private var facade:Facade;
		private var loadingView:LoadingView;
		private var mainView:MainView;
		
		protected var label:Label;
		
		public function Application()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			theme = new MinimalMobileTheme();
			facade = Facade.getInstance();
			facade.addEventListener(Notification.STARTUP_COMPLETE, onStartupComplete);
			loadingView = new LoadingView();
			addChild(loadingView);
			facade.startup();
		}
		
		private function onStartupComplete(note:Notification):void {
			facade.removeEventListener(Notification.STARTUP_COMPLETE, onStartupComplete);
			removeChild(loadingView, true);
			loadingView = null;
			mainView = new MainView();
			mainView.addEventListener(ScreenEvent.EVENT, onScreenNotification);
			mainView.showScreen(ScreenId.START);
			addChild(mainView);
		}
		
		private function onScreenNotification(event:ScreenEvent):void {
			if (event.subtype == ScreenEvent.SEND_NOTIFICATION) {
				facade.notify(event.data.type, event.data.data);
			}
		}
	}
}