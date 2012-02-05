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

