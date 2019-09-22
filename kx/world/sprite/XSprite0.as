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
package kx.world.sprite {

// X classes
	import kx.world.*;
	import kx.geom.*;
	
// flash classes
	import flash.geom.*;
	
	include "..\\..\\flash.h";
	
//------------------------------------------------------------------------------------------
	public class XSprite0 extends Sprite {
		public var m_xxx:XWorld;
		public var rp:XPoint;
		
//------------------------------------------------------------------------------------------
		public function XSprite0 () {
			super ();
			
			mouseEnabled = false;
		}
		
//------------------------------------------------------------------------------------------
		/* @:get, set xxx XWorld */
		
		public function get xxx ():XWorld {
			return m_xxx;
		}
		
		public function set xxx (__XWorld:XWorld): /* @:set_type */ void {
			m_xxx = __XWorld;
			
			/* @:set_return m_xxx; */			
		}
		/* @:end */
		
//-----------------------------------------------------------------------------------------
		/* @:get, set childList Sprite */
	
		public function get childList ():Sprite {
			return this;
		}
		
		public function set childList (__val:Sprite): /* @:set_type */ void {
			
			/* @:set_return null; */			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		public function globalToParent():Point {
			// unused
			return null;
		}
		
//------------------------------------------------------------------------------------------
		public function setRegistration(x:Number=0, y:Number=0):void {
			rp.x = x;
			rp.y = y;
		}
		
//------------------------------------------------------------------------------------------
		public function getRegistration():XPoint {
			return rp;
		}
		
//------------------------------------------------------------------------------------------
		/* @:get, set x2 Float */
		
		public function get x2 ():Number {
			var p:Point = parent.globalToLocal (localToGlobal (rp));
			
			return p.x;
		}
		
		public function set x2 (value:Number): /* @:set_type */ void {
			var p:Point = parent.globalToLocal (localToGlobal (rp));
			
			this.x += value - p.x;
			
			/* @:set_return 0; */	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set y2 Float */
		
		[Inline]
		public function get y2():Number {
			var p:Point = parent.globalToLocal (localToGlobal (rp));
			
			return p.y;
		}
		
		[Inline]
		public function set y2(value:Number):  /* @:set_type */ void {
			var p:Point = parent.globalToLocal (localToGlobal (rp));
			
			this.y += value - p.y;
			
			/* @:set_return 0; */	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set scaleX2 Float */
		
		[Inline]
		public function get scaleX2():Number {
			return this.scaleX;
		}
		
		[Inline]
		public function set scaleX2(value:Number): /* @:set_type */ void {
			var a:Point = parent.globalToLocal (localToGlobal (rp));
			
			this.scaleX = value;
			
			var b:Point = parent.globalToLocal (localToGlobal (rp));
			
			this.x -= b.x - a.x;
			this.y -= b.y - a.y;
			
			/* @:set_return 0; */	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set scaleY2 Float */
		
		[Inline]
		public function get scaleY2():Number {
			return this.scaleY;
		}
		
		[Inline]
		public function set scaleY2(value:Number): /* @:set_type */ void {
			var a:Point = parent.globalToLocal (localToGlobal (rp));
			
			this.scaleY = value;
			
			var b:Point = parent.globalToLocal (localToGlobal (rp));
			
			this.x -= b.x - a.x;
			this.y -= b.y - a.y;
			
			/* @:set_return 0; */	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set rotation2 Float */
		
		[Inline]
		public function get rotation2():Number {
			return this.rotation;
		}
		
		[Inline]
		public function set rotation2(value:Number): /* @:set_type */ void {
			var a:Point = parent.globalToLocal (localToGlobal (rp));
			
			this.rotation = value;
			
			var b:Point = parent.globalToLocal (localToGlobal (rp));
			
			this.x -= b.x - a.x;
			this.y -= b.y - a.y;
			
			/* @:set_return 0; */	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set mouseX2 Float */
		
		public function get mouseX2():Number {
			return Math.round (this.mouseX - rp.x);
		}
		
		public function set mouseX2(value:Number): /* @:set_type */ void {	
			/* @:set_return 0; */	
		}
		/* @:end */		
		
//------------------------------------------------------------------------------------------
		/* @:get, set mouseY2 Float */
		
		public function get mouseY2():Number {
			return Math.round (this.mouseY - rp.y);
		}
		
		public function set mouseY2(value:Number): /* @:set_type */ void {	
			/* @:set_return 0; */	
		}
		/* @:end */	
		
//------------------------------------------------------------------------------------------
		public function setProperty2(prop:String, n:Number):void {			
			// unused
		}
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}
