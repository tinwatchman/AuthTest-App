package net.jonstout.authtest.view
{
	import feathers.controls.Label;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class LoadingView extends Sprite
	{
		private var label:Label;
		
		public function LoadingView()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			label = new Label();
			label.text = "Loading...";
			label.addEventListener(Event.RESIZE, onLabelResize);
			addChild(label);
			label.validate();
			positionLabel();
		}
		
		private function onLabelResize(event:Event):void {
			positionLabel();
		}
		
		override public function dispose():void {
			super.dispose();
			label.removeEventListener(Event.RESIZE, onLabelResize);
			label = null;
		}
		
		private function positionLabel():void {
			label.x = (stage.stageWidth - label.width) * 0.5;
			label.y = (stage.stageHeight - label.height) * 0.5;
		}
	}
}