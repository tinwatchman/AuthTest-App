package net.jonstout.authtest.theme
{
	import feathers.core.DisplayListWatcher;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	
	public class Theme extends DisplayListWatcher
	{
		protected var _scaleToDPI:Boolean;
		protected var _originalDPI:int;
		
		public function Theme(container:DisplayObjectContainer = null, scaleToDPI:Boolean = true)
		{
			if (!container) {
				container = Starling.current.stage;
			}
			super(container);
			this._scaleToDPI = scaleToDPI;
			preinitialize();
			initialize();
		}
		
		protected function preinitialize():void {	
		}
		
		protected function initialize():void {
		}
		
		public function get originalDPI():int {
			return this._originalDPI;
		}
	}
}