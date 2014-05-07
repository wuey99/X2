//------------------------------------------------------------------------------------------
// <$license$/>
//------------------------------------------------------------------------------------------
package X.World.Collision {

// flash classes
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.*;
	
// Box2D classes
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;

// X classes
	import X.World.*;
	import X.World.Collision.*;
	
//------------------------------------------------------------------------------------------	
	public class XShapeCircle extends XShape {
		public var m_width:Number;
		public var m_height:Number;
		
//------------------------------------------------------------------------------------------
		public function XShapeCircle () {
		}

//------------------------------------------------------------------------------------------
		public function setup (
			__x:Number, __y:Number,
			__width:Number
			):void {
			
				x = __x;
				y = __y;
				
				m_width = __width;	
			}
			
//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function setWidth (__width:Number):void {
			m_width = __width;
		}
		
//------------------------------------------------------------------------------------------
		public function getRadius ():Number {
			return m_width / 30 / 2;
		}

//------------------------------------------------------------------------------------------			
	}
		
//------------------------------------------------------------------------------------------	
}