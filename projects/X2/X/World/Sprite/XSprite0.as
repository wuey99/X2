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
package X.World.Sprite {

// X classes
	import X.World.*;
	
// flash classes
	include "..\\..\\flash.h";
	
//------------------------------------------------------------------------------------------
	public class XSprite0 extends Sprite {
		public var m_xxx:XWorld;
				
//------------------------------------------------------------------------------------------
		public function XSprite0 () {
			super ();
			
			if (CONFIG::starling) {
			}
			else
			{
				mouseEnabled = false;
			}
		}
		
//------------------------------------------------------------------------------------------
		public function get xxx ():XWorld {
			return m_xxx;
		}
		
		public function set xxx (__XWorld:XWorld):void {
			m_xxx = __XWorld;
		}
		
//------------------------------------------------------------------------------------------
		public function get childList ():Sprite {
			return this;
		}
		
//------------------------------------------------------------------------------------------
		if (CONFIG::starling) {

			//------------------------------------------------------------------------------------------
			public override function get rotation ():Number {
				return super.rotation * 180/Math.PI;
			}
			
			//------------------------------------------------------------------------------------------
			public override function set rotation (__value:Number):void {
				super.rotation = __value * Math.PI/180;
			}
			
			//------------------------------------------------------------------------------------------
			public function get mouseX ():Number {
				return 0;
			}
			
			//------------------------------------------------------------------------------------------
			public function get mouseY ():Number {
				return 0;
			}
			
			//------------------------------------------------------------------------------------------
			public function set mouseEnabled (__value:Boolean):void {
			}
			
			//------------------------------------------------------------------------------------------
			public function get mouseEnabled ():Boolean {
				return true;
			}
			
			//------------------------------------------------------------------------------------------
			public function set mouseChildren (__value:Boolean):void {
			}

			//------------------------------------------------------------------------------------------
			public function get mouseChildren ():Boolean {
				return true;
			}
		}
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}
