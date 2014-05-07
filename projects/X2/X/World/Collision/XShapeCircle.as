//------------------------------------------------------------------------------------------
// Copyright (C) 2014 Jimmy Huey
//
// Some Rights Reserved.
//
// The "X-Engine" is licensed under a Creative Commons
// Attribution-Share Alike 3.0 United States License.
// (CC BY-SA 3.0)
//
// You are free to:
//
//      SHARE - to copy, distribute, display and perform the work.
//      ADAPT - remix, transform build upon this material, even for commercial works.
//
//      The licensor cannot revoke these freedoms as long as you follow the license terms.
//
// Under the following terms:
//
//      ATTRIBUTION — 
//      You must give appropriate credit, provide a link to the license, and
//      indicate if changes were made.  You may do so in any reasonable manner,
//      but not in any way that suggests the licensor endorses you or your use.
//
//      SHARE-ALIKE -
//      If you remix, transform, or build upon the material, you must
//      distribute your contributions under the same license as the original.
//
// No additional restrictions — You may not apply legal terms or technological measures
// that legally restrict others from doing anything the license permits. 
//
// The full summary can be located at:
// http://creativecommons.org/licenses/by-sa/3.0/us/ 
//
// The human-readable summary of the Legal Code can be located at:
// http://creativecommons.org/licenses/by-sa/3.0/us/legalcode
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