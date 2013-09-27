package net.jonstout.authtest.model
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import starling.events.EventDispatcher;
	
	public class Service extends EventDispatcher
	{		
		private var loader:URLLoader;
		private var lastStatus:int=-1;
		
		public function Service()
		{
			super();
			loader = new URLLoader();
		}
		
		public function load(url:String, params:Object=null, method:String=URLRequestMethod.GET):void {
			// prep request
			var request:URLRequest = new URLRequest(url);
			if (params != null) {
				var paramData:URLVariables = new URLVariables();
				for (var key:String in params) {
					paramData[key] = params[key];
				}
				request.data = paramData;
			}
			request.method = method;
			request.cacheResponse = false;
			// prep loader
			loader.addEventListener(Event.COMPLETE, onLoaded);
			loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onResponseStatus);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			// load
			loader.load(request);
		}
		
		private function onLoaded(event:Event):void {
			removeLoaderEventListeners();
			if (lastStatus >= 400) {
				dispatchEvent(new ServiceEvent(ServiceEvent.ERROR, loader.data, lastStatus));
			} else {
				dispatchEvent(new ServiceEvent(ServiceEvent.LOADED, loader.data, lastStatus));
			}
			clear();
		}
		
		private function onResponseStatus(event:HTTPStatusEvent):void {
			trace("onResponseStatus! - " + event.status + ", responseUrl: " + event.responseURL);
			this.lastStatus = event.status;
		}
		
		private function onSecurityError(event:SecurityErrorEvent):void {
			removeLoaderEventListeners();
			trace("onSecurityError!");
			clear();
		}
		
		private function onIOError(event:IOErrorEvent):void {
			removeLoaderEventListeners();
			trace("onIOError!");
			dispatchEvent(new ServiceEvent(ServiceEvent.ERROR, event));
			clear();
		}
		
		private function removeLoaderEventListeners():void {
			loader.removeEventListener(Event.COMPLETE, onLoaded);
			loader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onResponseStatus);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}
		
		private function clear():void {
			loader.data = null;
			lastStatus = -1;
		}
	}
}