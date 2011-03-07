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
		}

//------------------------------------------------------------------------------------------
		public function clone ():XMatrix {
			return new XMatrix (m_a, m_b, m_c, m_d, m_tx, m_ty);
		}

//------------------------------------------------------------------------------------------
		public static function createScale (__sx:Number, __sy:Number):XMatrix {
			return new XMatrix (__sx, 0, 0, __sy, 0, 0);
		}
		
//------------------------------------------------------------------------------------------
		public static function createTranslate (__tx:Number, __ty:Number):XMatrix {
			return new XMatrix (1, 0, 0, 1, __tx, __ty);
		}
		
//------------------------------------------------------------------------------------------
		public static function createRotate (__angle:Number):XMatrix {
			var sin = Math.sin (__angle);
			var cos = Math.cos (__angle);
			
			return new XMatrix (cos, sin, -sin, cos, 0, 0);
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
                        
			tx = __m.a * __tx + __m.c * __ty + __m.tx;
			ty = __m.b * __tx + __m.d * __ty + __m.ty;
                        
			return this;
		}

//------------------------------------------------------------------------------------------
		public function get determinant ():Number {
			return m_a * m_d - m_b * m_c;
		}

//------------------------------------------------------------------------------------------
		public invert ():void {
			var __a = m_a;
			var __b = m_b;
			var __c = m_c;
			var __d = m_d;
			var __tx = m_tx;
			var __ty = m_ty
			var __det = 1/determinant;
			
			m_a = __d * __det;
			m_b = -__b * __det;
			m_c = __c * __det;
			m_d = __a * __det;

			m_tx = (__c * __ty - __tx * __d ) * __det;
			m_ty = (__tx * __b - __a * __ty ) * __det;
		}
		
//------------------------------------------------------------------------------------------
		public rotate (__angle:Number):XMatrix {
			return concat (createRotate (__angle));
		}
		
//------------------------------------------------------------------------------------------
		public scale (__sx:Number, __sy:Number):XMatrix {
			return concat (createScale (__sx, __sy));
		}
		
//------------------------------------------------------------------------------------------
		public translate (__dx:Number, __dy:Number):XMatrix {
			return concat (createTranslate (__dx, __dy));
		}

//------------------------------------------------------------------------------------------
		public function toString ():String {
			return "(a=" + m_a + ", b=" + m_b + ", c=" + m_c + ", d=" + m_d + ", tx=" + m_tx + ", ty=" + m_ty + ")";
		}

//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}
