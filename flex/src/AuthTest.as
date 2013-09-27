package
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import net.jonstout.authtest.Application;
	import net.jonstout.authtest.core.Facade;
	
	import starling.core.Starling;
	
	public class AuthTest extends Sprite
	{
		private var _starling:Starling;
		
		public function AuthTest()
		{
			super();
			if (stage) {
				startup();
			} else {
				this.loaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			}
		}
		
		private function onLoadComplete(event:Event):void {
			this.loaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			startup();
		}
		
		private function startup():void {
			stage.addEventListener(Event.RESIZE, onResize);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onAppDeactivate);
			Facade.getInstance().setRootApplication(this);
			_starling = new Starling(Application, stage);
			_starling.start();
		}
		
		private function onResize(event:Event):void {
			if (_starling) {
				_starling.stage.stageWidth = this.stage.stageWidth;
				_starling.stage.stageHeight = this.stage.stageHeight;
				// try to adjust viewport
				var viewPort:Rectangle = _starling.viewPort;
				viewPort.width = stage.stageWidth;
				viewPort.height = stage.stageHeight;
				try {
					_starling.viewPort = viewPort;
				} catch (e:Error) {
				}
			}
		}
		
		private function onAppDeactivate(event:Event):void
		{
			_starling.stop();
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onAppReactivate);
		}
		
		private function onAppReactivate(event:Event):void
		{
			NativeApplication.nativeApplication.removeEventListener(Event.ACTIVATE, onAppReactivate);
			_starling.start();
		}
	}
}