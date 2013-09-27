package net.jonstout.authtest.view
{
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	
	import net.jonstout.authtest.data.ScreenId;
	import net.jonstout.authtest.view.screens.BaseScreen;
	import net.jonstout.authtest.view.screens.LogInScreen;
	import net.jonstout.authtest.view.screens.RegisterScreen;
	import net.jonstout.authtest.view.screens.ScreenEvent;
	import net.jonstout.authtest.view.screens.StartScreen;
	import net.jonstout.authtest.view.screens.ViewPageScreen;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class MainView extends Sprite
	{
		private var navigator:ScreenNavigator;
		private var transitionManager:ScreenSlidingStackTransitionManager;
		private var firstViewId:String;
		private var firstViewData:Object;
		
		public function MainView()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			navigator = new ScreenNavigator();
			navigator.autoSizeMode = ScreenNavigator.AUTO_SIZE_MODE_STAGE;
			transitionManager = new ScreenSlidingStackTransitionManager(navigator);
			// add screens here
			navigator.addScreen(ScreenId.START, new ScreenNavigatorItem(new StartScreen()));
			navigator.addScreen(ScreenId.REGISTER, new ScreenNavigatorItem(new RegisterScreen()));
			navigator.addScreen(ScreenId.LOG_IN, new ScreenNavigatorItem(new LogInScreen()));
			navigator.addScreen(ScreenId.VIEW_PAGE, new ScreenNavigatorItem(new ViewPageScreen()));
			// navigator.addScreen("button", new ScreenNavigatorItem(ButtonScreen));
			// navigator.addScreen("helloWorld", new ScreenNavigatorItem(HelloWordScreen));
			addChild(navigator);
			// navigator.showScreen("button").addEventListener(ButtonScreen.BUTTON_CLICKED, onScreenButtonClicked);
			if (firstViewId != null) {
				showScreen(firstViewId, firstViewData);
				firstViewData = null;
			}
		}
		
		public function showScreen(screenId:String, data:Object=null):void {
			if (stage) {
				getScreen(screenId).data = data;
				changeScreen(screenId);
			} else {
				firstViewId = screenId;
				firstViewData = data;
			}
		}
		
		private function onScreenEvent(event:ScreenEvent):void {
			switch (event.subtype) {
				case ScreenEvent.NAVIGATE:
					showScreen(event.data.id, event.data.data);
					break;
				case ScreenEvent.SEND_NOTIFICATION:
					dispatchEvent(event.clone());
					break;
			}
		}
				
		private function changeScreen(id:String):void {
			if (navigator.activeScreen != null) {
				getActiveScreen().removeEventListener(ScreenEvent.EVENT, onScreenEvent);
			}
			getScreen(id).addEventListener(ScreenEvent.EVENT, onScreenEvent);
			navigator.showScreen(id);
			getScreen(id).onShow();
		}
		
		private function getScreen(id:String):BaseScreen {
			if (navigator.getScreen(id) != null) {
				return navigator.getScreen(id).screen as BaseScreen;
			}
			return null;
		}
		
		private function getActiveScreen():BaseScreen {
			if (navigator.activeScreen != null) {
				return navigator.activeScreen as BaseScreen;
			}
			return null;
		}
	}
}