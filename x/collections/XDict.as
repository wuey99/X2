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
package x.collections {
	
//------------------------------------------------------------------------------------------
// <HAXE>
/* --
	class XDict {
		public function new () {
		}
	}
-- */
// </HAXE>

//------------------------------------------------------------------------------------------
// <AS3>
	import flash.utils.Dictionary;
	
//------------------------------------------------------------------------------------------
	public class XDict extends Object {
		private var m_dict:Dictionary;
		
//------------------------------------------------------------------------------------------
		public function XDict () {
			super ();
			
			m_dict = new Dictionary ();
		}

//------------------------------------------------------------------------------------------
		public function setup ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}

//------------------------------------------------------------------------------------------
		[Inline]
		public function exists (__key:*):Boolean {
			return __key in m_dict;
		}

//------------------------------------------------------------------------------------------
		[Inline]
		public function get (__key:*):* {
			return m_dict[__key];
		}
	
//------------------------------------------------------------------------------------------
		[Inline]
		public function set (__key:*, __val:*):void {
			m_dict[__key] = __val;
		}	
		
//------------------------------------------------------------------------------------------
		[Inline]
		public function remove (__key:*):void {
			delete m_dict[__key];
		}

//------------------------------------------------------------------------------------------
		public function removeAllKeys ():void {
			var __key:*;
			
			for (__key in m_dict) {
				remove (__key);
			}
		}

//------------------------------------------------------------------------------------------
		public function dict ():Dictionary {
			return m_dict;
		}
		
//------------------------------------------------------------------------------------------
		public function length ():int {
			return m_dict.length;
		}

//------------------------------------------------------------------------------------------
		public function forEach (__callback:Function):void {
			var __key:*;
			
			for (__key in m_dict) {
				__callback (__key);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function doWhile (__callback:Function):void {
			var __key:*;
			
			for (__key in m_dict) {
				if (!__callback (__key)) {
					return;
				}
			}
		}
		
//------------------------------------------------------------------------------------------
		public function __hash (__key:Object):String {
			return "";
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// </AS3>
	
//------------------------------------------------------------------------------------------
}