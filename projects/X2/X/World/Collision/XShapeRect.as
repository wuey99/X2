//------------------------------------------------------------------------------------------
// <$license$/>
//------------------------------------------------------------------------------------------
package X.World.Collision {

// Box2D classes
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import X.World.*;
	
	import flash.utils.*;

//------------------------------------------------------------------------------------------
	public class XShapeRect extends XShape {
		public var m_width:Number;
		public var m_height:Number;
		
//------------------------------------------------------------------------------------------
		public function XShapeRect () {
		}

//------------------------------------------------------------------------------------------
		public function setup (
			__x:Number, __y:Number,
			__width:Number, __height:Number,
			__rotation:Number):void {
				
				x = __x;
				y = __y;
				setSize (__width, __height);
				rotation = __rotation;
		}
		
//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function setSize (__width:Number, __height:Number):void {
			m_width = __width;
			m_height = __height;
		}
		
//------------------------------------------------------------------------------------------
		public function getWidth ():Number {			
			return m_width / 30;
		}
		
//------------------------------------------------------------------------------------------
		public function getHeight ():Number {		
			return m_height / 30;
		}
		
//------------------------------------------------------------------------------------------			
	}
	
//------------------------------------------------------------------------------------------	
}