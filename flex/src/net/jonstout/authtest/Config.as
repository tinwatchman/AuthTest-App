package net.jonstout.authtest
{
	public class Config
	{		
		public static const DEVICE_PASS_LENGTH:uint = 64;
		public static const REGISTER_URL:String = "https://localhost:443/project_location/php/register.php";
		public static const LOGIN_URL:String = "https://localhost:443/project_location/php/login.php";
		public static const START_URL:String = "https://localhost:443/project_location/php/start.php";
		public static const CHECK_URL:String = "https://localhost:443/project_location/php/check.php";
		public static const END_URL:String = "https://localhost:443/project_location/php/end.php";
		public static const PAGE_URL:String = "https://localhost:443/project_location/php/page.php";
		
		public static const REAUTH_ERROR_MESSAGE:String = "Your authentication has been rejected by the server. Please try again. If you receive this message again, try logging out and logging back in.";
	}
}