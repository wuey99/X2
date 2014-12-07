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
	import X.Geom.*;
	import X.World.*;
	import X.*;
	
	import flash.geom.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------	
	public class XSprite extends XSprite0 implements XRegistration {
		public var m_scale:Number;
		public var m_visible:Boolean;
		public var m_pos:XPoint;
		public var m_rect:XRect;
		public var rp:XPoint;
		public static var g_XApp:XApp;
		
//------------------------------------------------------------------------------------------
		include "..\\Sprite\\XRegistration_impl.h";
				
//------------------------------------------------------------------------------------------
		public function XSprite () {
			super ();
		}

//------------------------------------------------------------------------------------------
		public function setup ():void {
			m_pos = g_XApp.getXPointPoolManager ().borrowObject () as XPoint;
			m_rect = g_XApp.getXRectPoolManager ().borrowObject () as XRect;
			rp = g_XApp.getXPointPoolManager ().borrowObject () as XPoint;	
			
			setRegistration ();
			
			m_scale = 1.0;
			m_visible = true;
		}
		
//------------------------------------------------------------------------------------------
		public function cleanup ():void {	
			g_XApp.getXPointPoolManager ().returnObject (m_pos);
			g_XApp.getXPointPoolManager ().returnObject (m_rect);
			g_XApp.getXPointPoolManager ().returnObject (rp);			
		}

//------------------------------------------------------------------------------------------
		public static function setXApp (__XApp:XApp):void {
			g_XApp = __XApp;
		}
		
//------------------------------------------------------------------------------------------
		public function globalToLocalXPoint (__p:XPoint):XPoint {
			var __x:Point = globalToLocal (__p.getPoint ());
		
			return new XPoint (__x.x, __x.y);
		}
	
//------------------------------------------------------------------------------------------
		public function globalToLocalXPoint2 (__src:XPoint, __dst:XPoint):XPoint {
			var __x:Point = globalToLocal (__src.getPoint ());
		
			__dst.x = __x.x;  __dst.y = __x.y;
			
			return __dst;
		}
		
//------------------------------------------------------------------------------------------
		public function viewPort (__canvasWidth:Number, __canvasHeight:Number):XRect {
			m_rect.x = -x/m_scale;
			m_rect.y = -y/m_scale;
			m_rect.width = __canvasWidth/m_scale;
			m_rect.height = __canvasHeight/m_scale;
			
			return m_rect;
		}
		
//------------------------------------------------------------------------------------------
		public function getPos ():XPoint {
			m_pos.x = x2;
			m_pos.y = y2;
			
			return m_pos;
		}

//------------------------------------------------------------------------------------------		
		public function setPos (__p:XPoint):void {
			x2 = __p.x;
			y2 = __p.y;
		}

//------------------------------------------------------------------------------------------
		public function setScale (__scale:Number):void {
			m_scale = __scale;
			
			scaleX2 = __scale;
			scaleY2 = __scale;
		}
		
//------------------------------------------------------------------------------------------
		public function getScale ():Number {
			return m_scale;
		}

//------------------------------------------------------------------------------------------	
		public function set visible2 (__visible:Boolean):void {
			m_visible = __visible;
		}

//------------------------------------------------------------------------------------------			
		public function get visible2 ():Boolean {
			return m_visible;
		}

//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
