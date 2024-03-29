/*
Base64 - 1.1.0

Copyright (c) 2006 Steve Webster

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions: 

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
package net.jonstout.authtest.utils
{
	import flash.utils.ByteArray;

	public class Base64
	{
		private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
				
		public static function encode(data:String):String {
			// Convert string to ByteArray
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(data);
			
			// Return encoded ByteArray
			return encodeByteArray(bytes);
		}
		
		public static function encodeByteArray(data:ByteArray):String {
			// Initialise output
			var output:String = "";
			
			// Create data and output buffers
			var dataBuffer:Array;
			var outputBuffer:Array = new Array(4);
			
			// Rewind ByteArray
			data.position = 0;
			
			// while there are still bytes to be processed
			while (data.bytesAvailable > 0) {
				// Create new data buffer and populate next 3 bytes from data
				dataBuffer = new Array();
				for (var i:uint = 0; i < 3 && data.bytesAvailable > 0; i++) {
					dataBuffer[i] = data.readUnsignedByte();
				}
				
				// Convert to data buffer Base64 character positions and 
				// store in output buffer
				outputBuffer[0] = (dataBuffer[0] & 0xfc) >> 2;
				outputBuffer[1] = ((dataBuffer[0] & 0x03) << 4) | ((dataBuffer[1]) >> 4);
				outputBuffer[2] = ((dataBuffer[1] & 0x0f) << 2) | ((dataBuffer[2]) >> 6);
				outputBuffer[3] = dataBuffer[2] & 0x3f;
				
				// If data buffer was short (i.e not 3 characters) then set
				// end character indexes in data buffer to index of '=' symbol.
				// This is necessary because Base64 data is always a multiple of
				// 4 bytes and is basses with '=' symbols.
				for (var j:uint = dataBuffer.length; j < 3; j++) {
					outputBuffer[j + 1] = 64;
				}
				
				// Loop through output buffer and add Base64 characters to 
				// encoded data string for each character.
				for (var k:uint = 0; k < outputBuffer.length; k++) {
					output += BASE64_CHARS.charAt(outputBuffer[k]);
				}
			}
			
			// Return encoded data
			return output;
		}
	}
}