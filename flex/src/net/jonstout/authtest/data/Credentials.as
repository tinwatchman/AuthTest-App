package net.jonstout.authtest.data
{
	public class Credentials
	{
		private var _email:String;
		private var _pass:String;
		
		public function Credentials(email:String, password:String)
		{
			_email = email;
			_pass = password;
		}

		public function get email():String
		{
			return _email;
		}

		public function get pass():String
		{
			return _pass;
		}
	}
}