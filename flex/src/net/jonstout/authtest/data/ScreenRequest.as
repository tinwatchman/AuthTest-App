package net.jonstout.authtest.data
{
	public class ScreenRequest
	{
		private var _id:String;
		private var _data:Object;
		
		public function ScreenRequest(id:String, data:Object=null)
		{
			_id = id;
			_data = data;
		}

		public function get id():String
		{
			return _id;
		}

		public function get data():Object
		{
			return _data;
		}
	}
}