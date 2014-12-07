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
package X.World.Sprite {

// X classes
	import X.World.*;
	
// flash classes
	include "..\\..\\flash.h";
	
//------------------------------------------------------------------------------------------
	public class XSprite0 extends Sprite {
		public var m_xxx:XWorld;
				
//------------------------------------------------------------------------------------------
		public function XSprite0 () {
			super ();
			
			if (CONFIG::starling) {
			}
			else
			{
				mouseEnabled = false;
			}
		}
		
//------------------------------------------------------------------------------------------
		public function get xxx ():XWorld {
			return m_xxx;
		}
		
		public function set xxx (__XWorld:XWorld):void {
			m_xxx = __XWorld;
		}
		
//------------------------------------------------------------------------------------------
		public function get childList ():Sprite {
			return this;
		}
		
//------------------------------------------------------------------------------------------
		if (CONFIG::starling) {

			//------------------------------------------------------------------------------------------
			public override function get rotation ():Number {
				return super.rotation * 180/Math.PI;
			}
			
			//------------------------------------------------------------------------------------------
			public override function set rotation (__value:Number):void {
				super.rotation = __value * Math.PI/180;
			}
			
			//------------------------------------------------------------------------------------------
			public function get mouseX ():Number {
				return 0;
			}
			
			//------------------------------------------------------------------------------------------
			public function get mouseY ():Number {
				return 0;
			}
			
			//------------------------------------------------------------------------------------------
			public function set mouseEnabled (__value:Boolean):void {
			}
			
			//------------------------------------------------------------------------------------------
			public function get mouseEnabled ():Boolean {
				return true;
			}
			
			//------------------------------------------------------------------------------------------
			public function set mouseChildren (__value:Boolean):void {
			}

			//------------------------------------------------------------------------------------------
			public function get mouseChildren ():Boolean {
				return true;
			}
		}
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}
