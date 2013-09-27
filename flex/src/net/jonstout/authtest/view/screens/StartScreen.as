package net.jonstout.authtest.view.screens
{
	import feathers.controls.List;
	import feathers.data.ListCollection;
	
	import net.jonstout.authtest.core.Notification;
	import net.jonstout.authtest.data.ScreenId;
	
	import starling.events.Event;

	public class StartScreen extends BaseScreen
	{	
		private var list:List;
		private var isListSet:Boolean=false;
		
		private static const LOG_IN_OPTION:String = "logInOption";
		private static const REGISTER_OPTION:String = "registerOption";
		private static const VIEW_PAGE_OPTION:String = "viewPageOption";
		private static const LOG_OUT_OPTION:String = "logOutOption";
		
		public function StartScreen()
		{
			super();
			this.title = "AuthTest";
		}
		
		override protected function initialize():void {
			super.initialize();
			if (!list) {
				list = new List();
				list.itemRendererProperties.labelField = "label";
				list.addEventListener(Event.CHANGE, onListChange);
				addChild(list);
			}
		}
		
		override protected function draw():void {
			super.draw();
			if (list) {
				list.width = contentWidth;
				list.height = contentHeight;
				list.x = MARGIN_LEFT;
				list.y = contentY;
				if (!isListSet && data && data.state && data.state == "loggedIn") {
					list.dataProvider = new ListCollection();
					list.dataProvider.addItem({'label':'View Page', 'value':VIEW_PAGE_OPTION});
					list.dataProvider.addItem({'label':'Log Out', 'value':LOG_OUT_OPTION});
					isListSet = true;
				} else if (!isListSet && data) {
					list.dataProvider = new ListCollection();
					list.dataProvider.addItem({'label':'Log In', 'value':LOG_IN_OPTION});
					list.dataProvider.addItem({'label':'Register New Account', 'value':REGISTER_OPTION});
					isListSet = true;
				}
			}
		}
		
		override public function onShow():void {
			notify(Notification.REFRESH_START_SCREEN, this);
		}
		
		override public function set data(value:Object):void {
			if (data != value && value != null) {
				super.data = value;
				isListSet = false;
				invalidate(INVALIDATION_FLAG_ALL);
			}
		}
		
		public function onLogOut():void {
			notify(Notification.REFRESH_START_SCREEN, this);
			hideLoadingMessage();
		}
		
		private function onListChange(event:Event):void {
			if (list.selectedItem) {
				switch (list.selectedItem.value) {
					case REGISTER_OPTION:
						navigateTo(ScreenId.REGISTER);
						break;
					case LOG_IN_OPTION:
						navigateTo(ScreenId.LOG_IN);
						break;
					case VIEW_PAGE_OPTION:
						navigateTo(ScreenId.VIEW_PAGE);
						break;
					case LOG_OUT_OPTION:
						confirm("Are you sure you want to log out?", "OK", onLogoutConfirmed);
						break;
				}
				list.selectedIndex = -1;
			}
		}
		
		private function onLogoutConfirmed():void {
			message("Logging out...", true);
			notify(Notification.LOG_OUT, this);
		}
	}
}