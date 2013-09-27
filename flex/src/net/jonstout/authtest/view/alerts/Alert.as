package net.jonstout.authtest.view.alerts
{
	import feathers.controls.Button;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;

	public class Alert extends Message
	{
		public static const OKAY:String = "Alert_OKAY";
		
		protected var okayButton:Button;
		protected var okayLabel:String;
		
		public var gap:Number = 10;
		
		public function Alert(text:String, okayLabel:String = "OK")
		{
			super(text);
			this.okayLabel = okayLabel;
		}
		
		override protected function initialize():void {
			super.initialize();
			if (!okayButton) {
				contentLayout.gap = gap;
				contentLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
				
				okayButton = new Button();
				okayButton.addEventListener(Event.TRIGGERED, onOkayClicked);
				okayButton.label = okayLabel;
				okayButton.width = maxContentWidth*0.9;
				okayButton.maxWidth = maxContentWidth;
				addChild(okayButton);
			}
		}
		
		protected function onOkayClicked(event:Event):void {
			dispatchEvent(new Event(OKAY));
		}
		
		override public function dispose():void {
			super.dispose();
			okayButton.removeEventListener(Event.TRIGGERED, onOkayClicked);
			removeChild(okayButton);
			okayButton = null;
			okayLabel = null;
			gap = 0;
		}
	}
}