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
// For commercial use, you will need to provide proper credits.
// Please contact me @ wuey99[dot]gmail[dot]com for more details.
// <$end$/>
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