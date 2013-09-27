package net.jonstout.authtest.view.screens
{
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	
	import net.jonstout.authtest.core.Notification;
	import net.jonstout.authtest.data.ScreenId;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.utils.Color;

	public class ViewPageScreen extends BaseScreen
	{
		private var background:Sprite;
		private var browser:StageWebView;
		
		public function ViewPageScreen()
		{
			super();
			this.title = "AuthTest > View Page";
			isBackButtonShown = true;
		}
		
		override protected function initialize():void {
			super.initialize();
			if (!background) {
				background = new Sprite();
				addChild(background);
			}
		}
		
		override protected function draw():void {
			super.draw();
			if (background && !browser) {
				background.x = MARGIN_LEFT;
				background.y = contentY;
				background.width = contentWidth;
				background.height = contentHeight;
				background.visible = true;
				background.removeChildren();
				var quad:Quad = new Quad(contentWidth, contentHeight, Color.GRAY);
				quad.x = 0;
				quad.y = 0;
				background.addChild(quad);
			} else if (browser) {
				background.visible = false;
				browser.viewPort = new Rectangle(MARGIN_LEFT, contentY, contentWidth, contentHeight);
			}
		}
		
		override public function onShow():void {
			notify(Notification.VIEW_PAGE, this);
			invalidate();
		}
				
		override protected function onBack():void {
			alert("Yaaaay!");
			navigateTo(ScreenId.START);
			tearDownBrowser();
		}
				
		public function setUpBrowser(rootStage:Stage):void {
			if (!browser) {
				browser = new StageWebView();
			}
			browser.stage = rootStage;
		}
		
		public function viewUrl(url:String):void {
			if (browser) {
				browser.loadURL(url);
			}
		}
		
		public function onPageError():void {
			onBack();
		}
		
		private function tearDownBrowser():void {
			if (browser) {
				browser.stage = null;
			}
		}		
	}
}