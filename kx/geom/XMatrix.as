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
package kx.geom {
	
//------------------------------------------------------------------------------------------
	public class XMatrix extends Object {
		private var m_a:Number;
		private var m_b:Number;
		private var m_c:Number;
		private var m_d:Number;
		private var m_tx:Number;
		private var m_ty:Number;
		
//------------------------------------------------------------------------------------------
		public function XMatrix (
			__a:Number = 1,
			__b:Number = 0,
			__c:Number = 0,
			__d:Number = 1,
			__tx:Number = 0,
			__ty:Number = 0
			) {
				
			super ();
			
			m_a = __a;
			m_b = __b;
			m_c = __c;
			m_d = __d;
			m_tx = __tx;
			m_ty = __ty;
		}

//------------------------------------------------------------------------------------------
		public function clone ():XMatrix {
			return new XMatrix (m_a, m_b, m_c, m_d, m_tx, m_ty);
		}

//------------------------------------------------------------------------------------------
		/* @:get, set determinant Float */
		
		public function get determinant ():Number {
			return m_a * m_d - m_b * m_c;
		}

		public function set determinant (__val:Number): /* @:set_type */ void {
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set a Float */
		
		public function get a ():Number {
			return m_a;
		}

		public function set a (__val:Number): /* @:set_type */ void {
			m_a = __val;
			
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set b Float */
		
		public function get b ():Number {
			return m_b;
		}
		
		public function set b (__val:Number): /* @:set_type */ void {
			m_b = __val;
			
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set c Float */
		
		public function get c ():Number {
			return m_c;
		}
						
		public function set c (__val:Number): /* @:set_type */ void {
			m_c = __val;
			
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set d Float */
		
		public function get d ():Number {
			return m_d;
		}
		
		public function set d (__val:Number): /* @:set_type */ void {
			m_d = __val;
			
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set tx Float */
		
		public function get tx ():Number {
			return m_tx;
		}

		public function set tx (__val:Number): /* @:set_type */ void {
			m_tx = __val;
			
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set ty Float */
		
		public function get ty ():Number {
			return m_ty;
		}
				
		public function set ty (__val:Number): /* @:set_type */ void {
			m_ty = __val;
			
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public static function createScaling (__sx:Number, __sy:Number):XMatrix {
			return new XMatrix (__sx, 0, 0, __sy, 0, 0);
		}
		
//------------------------------------------------------------------------------------------
		public static function createTranslation (__tx:Number, __ty:Number):XMatrix {
			return new XMatrix (1, 0, 0, 1, __tx, __ty);
		}
		
//------------------------------------------------------------------------------------------
		public static function createRotatation (__angle:Number):XMatrix {
			var __radians:Number = __angle*Math.PI/180;
			
			var __sin:Number = Math.sin (__radians);
			var __cos:Number = Math.cos (__radians);
			
			return new XMatrix (__cos, __sin, -__sin, __cos, 0, 0);
		}
		
//------------------------------------------------------------------------------------------
		public function identity ():void {
			m_a = 1;
			m_b = 0;
			m_c = 0;
			m_d = 1;
			m_tx = 0;
			m_ty = 0;
		}
		
//------------------------------------------------------------------------------------------
		public function concat (__m:XMatrix):XMatrix {
			var __a:Number = m_a;
			var __b:Number = m_b;
			var __c:Number = m_c;
			var __d:Number = m_d;
			var __tx:Number = m_tx;
			var __ty:Number = m_ty;
			
 			m_a = __m.a * __a + __m.c * __b;
			m_b = __m.b * __a + __m.d * __b;
			m_c = __m.a * __c + __m.c * __d;
			m_d = __m.b * __c + __m.d * __d;
                        
			m_tx = __m.a * __tx + __m.c * __ty + __m.tx;
			m_ty = __m.b * __tx + __m.d * __ty + __m.ty;
                        
			return this;
		}

//------------------------------------------------------------------------------------------
		public function append (__m:XMatrix):XMatrix {
			var __a:Number = m_a;
			var __b:Number = m_b;
			var __c:Number = m_c;
			var __d:Number = m_d;
			var __tx:Number = m_tx;
			var __ty:Number = m_ty;
			
			m_a = __m.a * __a + __m.b * __c;
			m_b = __m.a * __b + __m.b * __d;
			m_c = __m.c * __a + __m.d * __c;
			m_d = __m.c * __b + __m.d * __d;
			
			m_tx = __m.tx * __a + __m.ty * __c + m_tx;
			m_ty = __m.tx * __b + __m.ty * __d + m_ty;
			
			return this;			
		}
		
//------------------------------------------------------------------------------------------
		public function invert ():void {
			var __a:Number = m_a;
			var __b:Number = m_b;
			var __c:Number = m_c;
			var __d:Number = m_d;
			var __tx:Number = m_tx;
			var __ty:Number = m_ty;
			var __det:Number = 1/determinant;
			
			m_a = __d * __det;
			m_b = -__b * __det;
			m_c = __c * __det;
			m_d = __a * __det;

			m_tx = (__c * __ty - __tx * __d ) * __det;
			m_ty = (__tx * __b - __a * __ty ) * __det;
		}
		
//------------------------------------------------------------------------------------------
		public function rotate (__angle:Number):XMatrix {
			return concat (createRotatation (__angle));
		}
		
//------------------------------------------------------------------------------------------
		public function scale (__sx:Number, __sy:Number):XMatrix {
			return concat (createScaling (__sx, __sy));
		}
		
//------------------------------------------------------------------------------------------
		public function translate (__dx:Number, __dy:Number):XMatrix {
			return concat (createTranslation (__dx, __dy));
		}

//------------------------------------------------------------------------------------------
		public function toString ():String {
			return "(a=" + m_a + ", b=" + m_b + ", c=" + m_c + ", d=" + m_d + ", tx=" + m_tx + ", ty=" + m_ty + ")";
		}

//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}
