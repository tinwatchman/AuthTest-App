package net.jonstout.authtest.control
{
	import net.jonstout.authtest.core.Command;
	import net.jonstout.authtest.core.Notification;
	import net.jonstout.authtest.view.screens.StartScreen;
	
	/**
	 * Command to access exisiting model data and refresh view
	 */
	public class RefreshStartScreenCommand extends Command
	{
		public function RefreshStartScreenCommand()
		{
			super(Notification.REFRESH_START_SCREEN);
		}
		
		override public function execute(data:Object=null):void {
			trace("refresh start screen");
			var screen:StartScreen = data as StartScreen;
			if (screen != null) {
				screen.data = {'state':facade.state};
			}
		}
	}
}