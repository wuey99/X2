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
package X.Geom {
	
	import flash.geom.*;
	
//------------------------------------------------------------------------------------------
	public class XRect extends Rectangle {
		
//------------------------------------------------------------------------------------------
		public function XRect (__x:Number = 0, __y:Number = 0, __width:Number = 0, __height:Number = 0) {
			super (__x, __y, __width, __height);
		}	

//------------------------------------------------------------------------------------------
		public function setRect (__x:Number, __y:Number, __width:Number, __height:Number):void {
			x = __x;
			y = __y;
			width = __width;
			height = __height;
		}
		
//------------------------------------------------------------------------------------------
		public function cloneX ():XRect {
			var __rect:Rectangle = clone ();
			
			return new XRect (__rect.x, __rect.y, __rect.width, __rect.height);
		}

//------------------------------------------------------------------------------------------
		public function copy2 (__rect:XRect):void {
			__rect.x = x;
			__rect.y = y;
			__rect.width = width;
			__rect.height = height;
		}
				
//------------------------------------------------------------------------------------------
		public function getRectangle ():Rectangle {
			return this as Rectangle;
		}
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}

