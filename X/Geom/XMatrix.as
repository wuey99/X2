//------------------------------------------------------------------------------------------
// <$begin$/>
// Copyright (C) 2014 Jimmy Huey
//
// Some Rights Reserved.
//
// The "X-Engine" is licensed under a Creative Commons
// Attribution-NonCommerical-ShareAlike 3.0 Unported License.
// (CC BY-NC-SA 3.0)
//
// You are free to:
//
//      SHARE - to copy, distribute, display and perform the work.
//      ADAPT - remix, transform build upon this material.
//
//      The licensor cannot revoke these freedoms as long as you follow the license terms.
//
// Under the following terms:
//
//      ATTRIBUTION -
//          You must give appropriate credit, provide a link to the license, and
//          indicate if changes were made.  You may do so in any reasonable manner,
//          but not in any way that suggests the licensor endorses you or your use.
//
//      SHAREALIKE -
//          If you remix, transform, or build upon the material, you must
//          distribute your contributions under the same license as the original.
//
//      NONCOMMERICIAL -
//          You may not use the material for commercial purposes.
//
// No additional restrictions - You may not apply legal terms or technological measures
// that legally restrict others from doing anything the license permits.
//
// The full summary can be located at:
// http://creativecommons.org/licenses/by-nc-sa/3.0/
//
// The human-readable summary of the Legal Code can be located at:
// http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode
//
// The "X-Engine" is free for non-commerical use.
// For commercial use, you will need to provide additional credits.
// Please contact me @ wuey99[dot]gmail[dot]com for more details.
// <$end$/>
//------------------------------------------------------------------------------------------
package X.Geom {
	
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
		public function get determinant ():Number {
			return m_a * m_d - m_b * m_c;
		}

//------------------------------------------------------------------------------------------
		public function get a ():Number {
			return m_a;
		}

//------------------------------------------------------------------------------------------
		public function get b ():Number {
			return m_b;
		}
		
//------------------------------------------------------------------------------------------
		public function get c ():Number {
			return m_c;
		}
						
//------------------------------------------------------------------------------------------
		public function get d ():Number {
			return m_d;
		}
		
//------------------------------------------------------------------------------------------
		public function get tx ():Number {
			return m_tx;
		}

//------------------------------------------------------------------------------------------
		public function get ty ():Number {
			return m_ty;
		}
				
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
		public function invert ():void {
			var __a:Number = m_a;
			var __b:Number = m_b;
			var __c:Number = m_c;
			var __d:Number = m_d;
			var __tx:Number = m_tx;
			var __ty:Number = m_ty
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
