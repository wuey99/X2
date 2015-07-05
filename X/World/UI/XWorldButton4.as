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
package X.World.UI {
	
	// X classes
	import X.*;
	import X.Signals.*;
	import X.Task.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	import X.World.UI.*;
	import X.Geom.*;
	
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------
	public class XWorldButton4 extends XWorldButton {
		public var m_x1:Number;
		public var m_y1:Number;
		public var m_x2:Number;
		public var m_y2:Number;
		
		//------------------------------------------------------------------------------------------
		public function XWorldButton4 () {
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array /* <Dynamic> */):void {
			super.setup (__xxx, args);
			
			m_x1 = getArg (args, 1);
			m_y1 = getArg (args, 2);
			m_x2 = getArg (args, 3);
			m_y2 = getArg (args, 4);
		}
				
		//------------------------------------------------------------------------------------------
		protected override function isMouseInRange ():Boolean {
			var __button:XPoint = getWorldCoordinates ();
			
			var __mouse:XPoint = xxx.getXWorldLayer (getLayer ()).globalToLocalXPoint (new XPoint (xxx.mouseX, xxx.mouseY));
			
			var __dx:Number = __mouse.x - __button.x;
			var __dy:Number = __mouse.y - __button.y;
	
//			trace (": XWorldButton (mouseX, mouseY): ", xxx.mouseX, xxx.mouseY, __mouse.x, __mouse.y, __button.x, __button.y);
			
			if (__dx < m_x1 || __dx > m_x2) {
				return false;
			}
			
			if (__dy < m_y1 || __dy > m_y2) {
				return false;
			}
			
			return true;
		}

	//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
