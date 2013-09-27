package net.jonstout.authtest.view.alerts
{
	import feathers.controls.Button;
	import feathers.controls.ScrollContainer;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;

	public class Confirm extends Message
	{
		public static const OKAY:String = "Confirm_OKAY";
		public static const CANCEL:String = "Confirm_CANCEL";
		
		protected var buttonContainer:ScrollContainer;
		protected var okayButton:Button;
		protected var okayLabel:String;
		protected var cancelButton:Button;
		protected var cancelLabel:String;
		
		public var verticalGap:Number = 10;
		public var horizontalGap:Number = 10;
		
		public function Confirm(text:String, okayLabel:String="OK", cancelLabel:String="Cancel")
		{
			super(text);
			this.okayLabel = okayLabel;
			this.cancelLabel = cancelLabel;
		}
		
		override protected function initialize():void {
			super.initialize();
			if (!buttonContainer || !okayButton || !cancelButton) {
				contentLayout.gap = verticalGap;
				contentLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
				contentLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
				
				buttonContainer = new ScrollContainer();
				buttonContainer.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
				buttonContainer.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
				buttonContainer.maxWidth = maxContentWidth;
				var layout:HorizontalLayout = new HorizontalLayout();
				layout.gap = horizontalGap;
				layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
				buttonContainer.layout = layout;
				
				cancelButton = new Button();
				cancelButton.addEventListener(Event.TRIGGERED, onCancelClicked);
				cancelButton.label = cancelLabel;
				cancelButton.width = (maxContentWidth*0.5)-horizontalGap;
				cancelButton.maxWidth = maxContentWidth*0.5;
				buttonContainer.addChild(cancelButton);
				
				okayButton = new Button();
				okayButton.addEventListener(Event.TRIGGERED, onOkayClicked);
				okayButton.label = okayLabel;
				okayButton.width = (maxContentWidth*0.5)-horizontalGap;
				okayButton.maxWidth = maxContentWidth*0.5;
				buttonContainer.addChild(okayButton);
								
				addChild(buttonContainer);
			}
		}
		
		override public function dispose():void {
			super.dispose();
			cancelButton.removeEventListener(Event.TRIGGERED, onCancelClicked);
			buttonContainer.removeChild(cancelButton, true);
			cancelButton = null;
			okayButton.removeEventListener(Event.TRIGGERED, onOkayClicked);
			buttonContainer.removeChild(okayButton, true);
			okayButton = null;
			removeChild(buttonContainer, true);
			buttonContainer = null;
			okayLabel = null;
			cancelLabel = null;
			verticalGap = 0;
			horizontalGap = 0;
		}
		
		protected function onOkayClicked(event:Event):void {
			dispatchEvent(new Event(OKAY));
		}
		
		protected function onCancelClicked(event:Event):void {
			dispatchEvent(new Event(CANCEL));
		}
	}
}