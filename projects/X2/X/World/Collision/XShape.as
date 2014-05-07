//------------------------------------------------------------------------------------------
// <$license$/>
//------------------------------------------------------------------------------------------
package X.World.Collision {

// Box2D classes
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
// flash classes
	import flash.display.MovieClip;
	import flash.utils.*;

// X classes
	import X.World.*;
	import X.World.Collision.*;
	
//------------------------------------------------------------------------------------------	
	public class XShape extends MovieClip {
		
//------------------------------------------------------------------------------------------
		public function XShape () {
		}
		
//------------------------------------------------------------------------------------------
		public function getPos ():b2Vec2 {
			return new b2Vec2 (x / 30, y / 30);
		}

//------------------------------------------------------------------------------------------
		public function getAngle ():Number {
			return rotation * Math.PI/180;
		}
		
//------------------------------------------------------------------------------------------			
	}
	
//------------------------------------------------------------------------------------------	
}