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
package kx.world.collision {
	
	import kx.collections.*;
	import kx.geom.*;
	import kx.pool.*;
	import kx.world.logic.*;
	import kx.world.XWorld;
	import kx.xmap.*;
	import kx.type.*;
	
//------------------------------------------------------------------------------------------
	public class XObjectCollisionList extends Object {
		protected var xxx:XWorld;
		protected var m_rects:Array; // <Map<XLogicObject, XRect>>
		protected var m_XSubRectPoolManager:XSubObjectPoolManager;
		
//------------------------------------------------------------------------------------------
		public function XObjectCollisionList () {
			super ();
			
			xxx = null;
		}
		
//------------------------------------------------------------------------------------------
		public function setup (__xxx:XWorld):void {
			xxx = __xxx;		
			m_rects = new Array (); // <Map<XLogicObject, XRect>>
			
			var i:int;
			
			for (i=0; i < xxx.getMaxLayers (); i++) {
				m_rects[i] = new XDict (); // <XLogicObject, XRect>
			}
			
			m_XSubRectPoolManager = new XSubObjectPoolManager (xxx.getXRectPoolManager ());
			
			clear ();
		}
		
//------------------------------------------------------------------------------------------
		public function cleanup ():void {
			clear ();
		}

//------------------------------------------------------------------------------------------		
		public function clear ():void {
			var i:int;

			for (i=0; i < xxx.getMaxLayers (); i++) {
				m_rects[i].removeAllKeys ();
			}
			
			m_XSubRectPoolManager.returnAllObjects ();
		}
	
//------------------------------------------------------------------------------------------
		public function addCollision (
			__layer:int,
			__logicObject:XLogicObject,
			__srcPoint:XPoint, __srcRect:XRect
			):void {

			var __rect:XRect = m_XSubRectPoolManager.borrowObject () as XRect;
			__srcRect.copy2 (__rect); __rect.offsetPoint (__srcPoint);
			m_rects[__layer].set (__logicObject, __rect);
		}

		
//------------------------------------------------------------------------------------------
		public function getRects (__layer:int):XDict /* <XLogicObject, XRect> */ {
			return m_rects[__layer];
		}

//------------------------------------------------------------------------------------------
		public function getList (__layer:int):XDict /* <XLogicObject, XRect> */ {
			return m_rects[__layer];
		}
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}
