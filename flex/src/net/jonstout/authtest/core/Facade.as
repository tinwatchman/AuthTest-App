package net.jonstout.authtest.core
{
	import flash.utils.Dictionary;
	
	import net.jonstout.authtest.control.LocalProxyCompleteCommand;
	import net.jonstout.authtest.control.LogInCommand;
	import net.jonstout.authtest.control.LogOutCommand;
	import net.jonstout.authtest.control.RefreshStartScreenCommand;
	import net.jonstout.authtest.control.RegisterCommand;
	import net.jonstout.authtest.control.ShowAlertCommand;
	import net.jonstout.authtest.control.UpdateAppStateCommand;
	import net.jonstout.authtest.control.ViewPageCommand;
	import net.jonstout.authtest.model.AuthProxy;
	import net.jonstout.authtest.model.LocalProxy;
	
	import starling.events.EventDispatcher;
	
	public class Facade extends EventDispatcher
	{		
		private static var instance:Facade;
		
		public static const APP_STATE_LOGGED_IN:String = "loggedIn";
		public static const APP_STATE_LOGGED_OUT:String = "loggedOut";
		public static const APP_STATE_NO_LOCAL_STORAGE:String = "noLocalStorage";
		
		private var _rootApplication:AuthTest;
		private var _state:String;
		private var commandMap:Dictionary;
		private var proxyMap:Dictionary;
		
		public static function getInstance():Facade {
			if (instance == null) {
				instance = new Facade(new SingletonEnforcer());
			}
			return instance;
		}
		
		public function Facade(enforcer:SingletonEnforcer)
		{
			super();
			commandMap = new Dictionary();
			proxyMap = new Dictionary();
		}
		
		public function setRootApplication(app:AuthTest):void {
			_rootApplication = app;
		}
		
		public function startup():void {
			// register commands here
			addCommand(new LocalProxyCompleteCommand());
			addCommand(new ShowAlertCommand());
			addCommand(new RegisterCommand());
			addCommand(new LogInCommand());
			addCommand(new RefreshStartScreenCommand());
			addCommand(new UpdateAppStateCommand());
			addCommand(new ViewPageCommand());
			addCommand(new LogOutCommand());
			
			// register proxies
			addProxy(new AuthProxy());
			addProxy(new LocalProxy());
			// see LocalProxyCompleteCommand for startup completion
		}
		
		public function get rootApplication():AuthTest
		{
			return _rootApplication;
		}
		
		public function get state():String
		{
			return _state;
		}
		
		public function set state(value:String):void
		{
			_state = value;
		}
				
		public function notify(type:String, data:Object=null):void {
			if (commandMap[type] != null) {
				(commandMap[type] as Command).execute(data);
			} else {
				dispatchEvent(new Notification(type, data));
			}
		}
		
		public function addCommand(command:Command):void {
			commandMap[command.trigger] = command;
		}
		
		public function removeCommand(command:Command):void {
			if (commandMap[command.trigger] != null) {
				(commandMap[command.trigger] as Command).dispose();
				delete commandMap[command.trigger];
			}
		}
		
		public function removeCommandTrigger(trigger:String):void {
			if (commandMap[trigger] != null) {
				removeCommand((commandMap[trigger] as Command));
			}
		}
		
		public function addProxy(proxy:Proxy):void {
			proxyMap[proxy.ref] = proxy;
			proxy.start();
		}
		
		public function getProxy(ref:Class):* {
			if (proxyMap[ref]) {
				return (proxyMap[ref] as ref);
			}
			return null;
		}
		
		public function removeProxy(ref:Class):* {
			if (proxyMap[ref]) {
				(proxyMap[ref] as Proxy).dispose();
				delete proxyMap[ref];
			}
		}
	}
} class SingletonEnforcer {}