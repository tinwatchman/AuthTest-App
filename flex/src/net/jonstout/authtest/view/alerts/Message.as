package net.jonstout.authtest.view.alerts
{
	import feathers.controls.Label;
	import feathers.controls.ScrollContainer;
	import feathers.layout.VerticalLayout;
	
	public class Message extends ScrollContainer
	{
		protected var contentLayout:VerticalLayout;
		protected var textDisplay:Label;
		protected var text:String;
		
		public var maxContentWidth:Number=150;
		public var contentPaddingTop:Number=20;
		public var contentPaddingLeft:Number=20;
		public var contentPaddingRight:Number=20;
		public var contentPaddingBottom:Number=20;
		public var textRendererProperties:Object=null;
		
		public function Message(text:String)
		{
			super();
			this.text = text;
		}
		
		override protected function initialize():void {
			super.initialize();
			this.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			if (!textDisplay) {
				contentLayout = new VerticalLayout();
				contentLayout.paddingTop = contentPaddingTop;
				contentLayout.paddingLeft = contentPaddingLeft;
				contentLayout.paddingRight = contentPaddingRight;
				contentLayout.paddingBottom = contentPaddingBottom;
				this.layout = contentLayout;
				
				textDisplay = new Label();
				textDisplay.text = text;
				textDisplay.maxWidth = maxContentWidth;
				textDisplay.textRendererProperties = textRendererProperties;
				addChild(textDisplay);
				textDisplay.validate();
			}
		}
		
		public function set contentPadding(value:Number):void {
			contentPaddingTop = contentPaddingLeft = contentPaddingRight = contentPaddingBottom = value;
		}
		
		override public function dispose():void {
			super.dispose();
			contentLayout = null;
			removeChild(textDisplay);
			textDisplay = null;
			text = null;
			contentPaddingTop=0;
			contentPaddingLeft=0;
			contentPaddingRight=0;
			contentPaddingBottom=0;
		}
	}
}