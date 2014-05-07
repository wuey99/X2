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
package X.World.Sprite {

// X classes
	import X.Geom.*;
	
// flash classes
	import flash.geom.*;
		
//------------------------------------------------------------------------------------------	
	public interface XRegistration {
		
//------------------------------------------------------------------------------------------
		function globalToParent():Point;

//------------------------------------------------------------------------------------------
		function setRegistration(x:Number=0, y:Number=0):void;

//------------------------------------------------------------------------------------------
		function getRegistration():XPoint;
				
//------------------------------------------------------------------------------------------		
		function get x2():Number;

//------------------------------------------------------------------------------------------
		function set x2(value:Number):void;

//------------------------------------------------------------------------------------------
		function get y2():Number;

//------------------------------------------------------------------------------------------
		function set y2(value:Number):void;

//------------------------------------------------------------------------------------------
		function get scaleX2():Number;

//------------------------------------------------------------------------------------------
		function set scaleX2(value:Number):void;

//------------------------------------------------------------------------------------------
		function get scaleY2():Number;

//------------------------------------------------------------------------------------------
		function set scaleY2(value:Number):void;

//------------------------------------------------------------------------------------------
		function get rotation2():Number;

//------------------------------------------------------------------------------------------
		function set rotation2(value:Number):void;

//------------------------------------------------------------------------------------------
		function get mouseX2():Number;

//------------------------------------------------------------------------------------------
		function get mouseY2():Number;

//------------------------------------------------------------------------------------------
		function setProperty2(prop:String, n:Number):void;	
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
