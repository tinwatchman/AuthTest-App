package net.jonstout.authtest.utils
{	
	import flash.crypto.generateRandomBytes;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	
	import mx.utils.SHA256;

	public class Utils
	{
		public static function generateDeviceId(randomPaddingLen:uint=16):String {
			var baseId:String = "ANDROID";
			/* if (isIOS) {
				baseId = "IOS";
			} */
			baseId += "|" + Capabilities.serverString + "|" + new Date().time;
			var id:ByteArray = new ByteArray();
			id.writeUTFBytes(baseId);
			id.writeBytes(flash.crypto.generateRandomBytes(randomPaddingLen));
			return SHA256.computeDigest(id);
		}
		
		public static function generateDevicePass(len:uint):String {	
			var rawlen:uint = Math.ceil(len*0.25*3);
			return Base64.encodeByteArray(flash.crypto.generateRandomBytes(rawlen)).substr(0, len);
		}
		
		public static function generateUrl(baseUrl:String, keyValuePairs:Object, encode:Boolean=true):String {
			var queryList:Array = new Array();
			for (var p:String in keyValuePairs) {
				if(encode){
					queryList.push(p + "=" + encodeURIComponent(keyValuePairs[p]));
				}else{
					queryList.push(p + "=" + keyValuePairs[p]);
				}
			}
			queryList.sort();
			var url:String = baseUrl;
			if ( url.indexOf("?") == -1 ) {
				url += "?";
			} else if ( url.indexOf("?") != url.length-1 && url.indexOf("&") != url.length-1 ) {
				url += "&";
			}
			url += queryList.join("&");			
			return url;
		}
		
		public static function parseServerError(raw:Object):String {
			var response:Object = JSON.parse(String(raw));
			if (response && response.error && response.error.code && response.error.message) {
				return "Server Error " + response.error.code + ": " + response.error.message;
			}
			return null;
		}
	}
}