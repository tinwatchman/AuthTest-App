package net.jonstout.authtest.view.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Screen;
	
	import net.jonstout.authtest.core.Notification;
	import net.jonstout.authtest.data.AlertRequest;
	import net.jonstout.authtest.data.ScreenRequest;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class BaseScreen extends Screen
	{
		protected var titleBar:Header;
		protected var backButton:Button;
		
		protected var isBackButtonShown:Boolean=false;
		protected var isAlertShown:Boolean=false;
		protected var isLoading:Boolean=false;
		
		private var _title:String;
		private var _data:Object;
		
		protected static const MARGIN_TOP:int = 20;
		protected static const MARGIN_LEFT:int = 20;
		protected static const MARGIN_BOTTOM:int = 20;
		protected static const MARGIN_RIGHT:int = 20;
		protected static const TITLEBAR_HEIGHT:int = 50;
		protected static const TITLEBAR_LEFT_GAP:int = 20;
		protected static const TITLEBAR_BOTTOM_PADDING:int = 20;
		
		public function BaseScreen()
		{
			super();
			this.backButtonHandler = backHandler;
		}
		
		override protected function initialize():void {
			super.initialize();
			
			titleBar = new Header();
			titleBar.title = _title;
			
			if (isBackButtonShown) {
				backButton = new Button();
				backButton.label = "Back";
				backButton.addEventListener(Event.TRIGGERED, onBackButtonPressed);
				titleBar.leftItems = Vector.<DisplayObject>([ backButton ]);
				titleBar.rightItems = new Vector.<DisplayObject>();
			}
			
			addChild(titleBar);
		}
		
		override protected function draw():void {
			super.draw();
			if (titleBar) {
				titleBar.x = MARGIN_LEFT;
				titleBar.y = MARGIN_TOP;
				titleBar.title = _title;
				titleBar.width = contentWidth;
				titleBar.height = TITLEBAR_HEIGHT;
				titleBar.titleAlign = Header.TITLE_ALIGN_PREFER_LEFT;
				titleBar.verticalAlign = Header.VERTICAL_ALIGN_MIDDLE;
				if (isBackButtonShown) {
					titleBar.padding = 0;
					titleBar.gap = 0;
					titleBar.titleGap = TITLEBAR_LEFT_GAP;
				}
				titleBar.validate();
			}
		}
		
		override public function dispose():void {
			super.dispose();
			if (isBackButtonShown) {
				backButton.removeEventListener(Event.TRIGGERED, onBackButtonPressed);
				titleBar.leftItems = new Vector.<DisplayObject>();
				backButton = null;
			}
			removeChild(titleBar);
			titleBar = null;
			_title = null;
			_data = null;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
		}
		
		public function onShow():void {
			// override as necessary in subclasses
		}
		
		protected function get title():String
		{
			return _title;
		}

		protected function set title(value:String):void
		{
			if (_title != value) {
				_title = value;
				if (!this.isInvalid()) {
					validate();
				}
			}
		}
		
		protected function get contentWidth():Number {
			return this.width - MARGIN_LEFT - MARGIN_RIGHT;
		}
		
		protected function get contentHeight():Number {
			return this.height - MARGIN_TOP - TITLEBAR_HEIGHT - TITLEBAR_BOTTOM_PADDING - MARGIN_BOTTOM;
		}
				
		protected function get contentY():Number {
			return TITLEBAR_HEIGHT + MARGIN_TOP + TITLEBAR_BOTTOM_PADDING;
		}
		
		protected function notify(type:String, data:Object=null):void {
			dispatchEvent(new ScreenEvent(ScreenEvent.SEND_NOTIFICATION, this, {'type':type, 'data':data})); 
		}
		
		protected function navigateTo(screenId:String, data:Object=null):void {
			dispatchEvent(new ScreenEvent(ScreenEvent.NAVIGATE, this, new ScreenRequest(screenId, data)));
		}
				
		protected function message(text:String, isLoadingMessage:Boolean=false, onClose:Function=null):void {
			var request:AlertRequest = new AlertRequest(AlertRequest.MESSAGE, text);
			if (onClose == null) {
				request.setResponder(this, onAlertClosed);
			} else {
				request.setResponder(this, onClose);
			}
			isAlertShown = true;
			isLoading = isLoadingMessage;
			notify(Notification.SHOW_ALERT, request);
		}
		
		protected function hideLoadingMessage():void {
			if (isAlertShown && isLoading) {
				notify(Notification.HIDE_ALERT);
				isLoading = false;
			}
		}
		
		protected function alert(text:String, okButtonLabel:String="OK", onOkay:Function=null):void {
			var request:AlertRequest = new AlertRequest(AlertRequest.ALERT, text, okButtonLabel);
			if (onOkay == null) {
				request.setResponder(this, onAlertClosed);
			} else {
				request.setResponder(this, onOkay);
			}
			isAlertShown = true;
			notify(Notification.SHOW_ALERT, request);
		}
		
		protected function confirm(text:String, okButtonLabel:String="OK", onOkay:Function=null, cancelButtonLabel:String="Cancel", onCancel:Function=null):void {
			var request:AlertRequest = new AlertRequest(AlertRequest.CONFIRM, text, okButtonLabel, cancelButtonLabel);
			if (onOkay == null) {
				request.setResponder(this, onAlertClosed, onAlertClosed);
			} else if (onOkay && onCancel) {
				request.setResponder(this, onOkay, onCancel);
			} else if (!onOkay && onCancel) {
				request.setResponder(this, onAlertClosed, onCancel);
			} else {
				request.setResponder(this, onOkay, onAlertClosed);
			}
			isAlertShown = true;
			notify(Notification.SHOW_ALERT, request);
		}
		
		private function backHandler():void {
			if (isAlertShown && !isLoading) {
				notify(Notification.HIDE_ALERT);
			} else if (!isAlertShown) {
				onBack();
			}
		}
		
		protected function onBack():void {
			// override in subclass
		}
		
		protected function onAlertClosed():void {
			isAlertShown = false;
		}
		
		private function onBackButtonPressed(event:Event):void {
			onBack();
		}
	}
}