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

