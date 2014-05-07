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
	
	import flash.geom.*;
	
//------------------------------------------------------------------------------------------
	public class XPoint extends Point {
		
//------------------------------------------------------------------------------------------
		public function XPoint (__x:Number = 0, __y:Number = 0) {
			super (__x, __y);
		}

//------------------------------------------------------------------------------------------
		public function setPoint (__x:Number, __y:Number):void {
			x = __x;
			y = __y;
		}
		
//------------------------------------------------------------------------------------------
		public function cloneX ():XPoint {
			var __point:Point = clone ();
			
			return new XPoint (__point.x, __point.y);
		}
	
//------------------------------------------------------------------------------------------
		public function copy2 (__point:XPoint):void {
			__point.x = x;
			__point.y = y;
		}
			
//------------------------------------------------------------------------------------------
		public function getPoint ():Point {
			return this as Point;
		}
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}
