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
package kx.display {
	import kx.collections.*;
	import kx.geom.*;
	
	//------------------------------------------------------------------------------------------	
	public class Sprite5 extends DisplayObjectContainer5 {
		public var alpha:Number;
		public var rotation:Number;
		public var scaleX:Number;
		public var scaleY:Number;
		public var visible:Boolean;
		public var width:int;
		public var height:int;
		public var m_mouseX:Number;
		public var m_mouseY:Number;
		public var m_stageX:Number;
		public var m_stageY:Number;
		public var stage:*;
		public var x:Number;
		public var y:Number;
		public var regX:Number;
		public var regY:Number;
		public var mouseEnabled:Boolean;
		public var m_isOver:Boolean;
		public var m_numChildEvents:int;

		public var m_CLICKS:XDict;	// <Dynamic, Int>
		public var m_DOUBLE_CLICKS:XDict; // <Dynamic, Int>
		public var m_MOUSE_DOWNS:XDict; // <Dynamic, Int>
		public var m_MOUSE_MOVES:XDict; // <Dynamic, Int>
		public var m_MOUSE_OUTS:XDict; // <Dynamic, Int>
		public var m_MOUSE_OVERS:XDict; // <Dynamic, Int>
		public var m_MOUSE_UPS:XDict; // <Dynamic, Int>

		//------------------------------------------------------------------------------------------
		public function Sprite5 () {
			alpha = 1.0;
			rotation = 0.0;
			scaleX = 1.0;
			scaleY = 1.0;
			visible = false;
			width = 0;
			height = 0;
			m_mouseX = 0;
			m_mouseY = 0;
			m_stageX = 0;
			m_stageY = 0;
			x = 0;
			y = 0;
			regX = 0;
			regY = 0;
			mouseEnabled = false;
			m_isOver = false;
			m_numChildEvents = 0;
			
			m_CLICKS = XDict (); // <Dynamic, Int>
			m_DOUBLE_CLICKS = new XDict (); // <Dynamic, Int>
			m_MOUSE_DOWNS = new XDict (); // <Dynamic, Int>
			m_MOUSE_MOVES = new XDict (); // <Dynamic, Int>
			m_MOUSE_OUTS = new XDict (); // <Dynamic, Int>
			m_MOUSE_OVERS = new XDict (); // <Dynamic, Int>
			m_MOUSE_UPS = new XDict (); // <Dynamic, Int>
		}

		//------------------------------------------------------------------------------------------	
		public function globalToLocal (__point:XPoint):XPoint {	
			var __m:XMatrix = getConcatenatedMatrix ();
			__m.invert ();
			__m.append (new XMatrix (1, 0, 0, 1, __point.x, __point.y));
			
			return new XPoint (__m.tx, __m.ty);
		}
		
		//------------------------------------------------------------------------------------------	
		public function localToGlobal (__point:XPoint):XPoint {
			var __m:XMatrix  = getConcatenatedMatrix ();
			__m.append (new XMatrix (1, 0, 0, 1, __point.x, __point.y));
			
			return new XPoint (__m.tx, __m.ty);
		}

		//------------------------------------------------------------------------------------------	
		public function getConcatenatedMatrix ():XMatrix {
			var __m:XMatrix = new XMatrix ();
			
			var __sprite:Sprite5 = this;
			
			do {
				var __r:Number = __sprite.rotation * Math.PI/180;
				var __cos:Number = Math.cos (__r);
				var __sin:Number = Math.sin (__r);
				
				__m.concat (XMatrix.createTranslation (-__sprite.regX, -__sprite.regY));
				
				__m.concat (
					new XMatrix (
						__cos * __sprite.scaleX,
						__sin * __sprite.scaleX,
						-__sin * __sprite.scaleY,
						__cos * __sprite.scaleY,
						__sprite.x,
						__sprite.y
					)
				);
				
				__sprite = __sprite.parent;
			} while (__sprite != null);
			
			return __m;
		}
		
		//------------------------------------------------------------------------------------------
		/* @:get, set mouseX Float */
		
		public function get mouseX ():Number {
			return m_mouseX;
		}
		
		public function set mouseX (__val:Number): /* @:set_type */ void {
			m_mouseX = __val;
			
			/* @:set_return 0; */			
		}
		/* @:end */

		//------------------------------------------------------------------------------------------
		/* @:get, set mouseY Float */
		
		public function get mouseY ():Number {
			return m_mouseY;
		}
		
		public function set mouseY (__val:Number): /* @:set_type */ void {
			m_mouseY = __val;
			
			/* @:set_return 0; */			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		/* @:get, set stageX Float */
		
		public function get stageX ():Number {
			return m_stageX;
		}
		
		public function set stageX (__val:Number): /* @:set_type */ void {
			m_mouseX = __val;
			
			/* @:set_return 0; */			
		}
		/* @:end */

		//------------------------------------------------------------------------------------------
		/* @:get, set stageY Float*/
		
		public function get stageY ():Number {
			return m_stageY;
		}
		
		public function set stageY (__val:Number): /* @:set_type */ void {
			m_mouseY = __val;
			
			/* @:set_return 0; */			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		/* @:get, set numChildEvents Int */
		
		public function get numChildEvents ():int {
			return m_numChildEvents;
		}
		
		public function set numChildEvents (__val:int): /* @:set_type */ void {
			m_numChildEvents = __val;
			
			/* @:set_return 0; */			
		}
		/* @:end */
		
	//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------
}