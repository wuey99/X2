//------------------------------------------------------------------------------------------
// <$begin$/>
// The MIT License (MIT)
//
// The "X-Engine"
//
// Copyright (c) 2014 Jimmy Huey (wuey99@gmail.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// <$end$/>
//------------------------------------------------------------------------------------------
package x.datasource {
	
// flash classes
	import flash.utils.ByteArray;

//------------------------------------------------------------------------------------------
	public class XDatasource extends Object {
						
//------------------------------------------------------------------------------------------
		public function XDatasource () {	
			super ();
		}

//------------------------------------------------------------------------------------------
//		public function setup ():void {
//		}
		
//------------------------------------------------------------------------------------------
//		public function open ():void {
//		}
		
//------------------------------------------------------------------------------------------
		public function close ():void {
		}

//------------------------------------------------------------------------------------------
		/* @:get, set position Int */
		
		public function get position ():int {
			return 0;
		}
		
		public function set position (__position:int): /* @:set_type */ void {
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------	
		public function readByte ():int {
			return 0;
		}
		
//------------------------------------------------------------------------------------------	
		public function readBytes (__offset:int, __length:int):ByteArray {
			return null;
		}
		
//------------------------------------------------------------------------------------------	
		public function writeByte (__val:int):void {
		}
		
//------------------------------------------------------------------------------------------	
		public function writeBytes (__bytes:ByteArray, __offset:int, __length:int):void {
		}

//------------------------------------------------------------------------------------------
		public function readUTFBytes (__length:int):String {
			return null;
		}

//------------------------------------------------------------------------------------------	
		public function writeUTFBytes (__val:String):void {
		}		
		
//------------------------------------------------------------------------------------------		
	}
	
//------------------------------------------------------------------------------------------
}