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
package X.XMap {

// X classes
	import X.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.XDepthSprite;
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;

//------------------------------------------------------------------------------------------
	public class XMapItemView extends XLogicObject {
		protected var m_sprite:MovieClip;
		protected var x_sprite:XDepthSprite;
		protected var m_frame:Number;
		
//------------------------------------------------------------------------------------------
		public function XMapItemView () {
		}

//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			m_frame = args[1];
			
			__createSprites (args[0]);
		}

//------------------------------------------------------------------------------------------
// create sprite
//------------------------------------------------------------------------------------------
		protected function __createSprites (__spriteClassName:String):void {			
			m_sprite = new (xxx.getClass (__spriteClassName)) ();
// !STARLING!
			if (CONFIG::flash) {
				x_sprite = addSprite (m_sprite);
			}
			
			if (m_frame) {
				gotoAndStop (m_frame);
			}
			else
			{
				gotoAndStop (1);
			}
		}

//------------------------------------------------------------------------------------------
		public function getTotalFrames ():Number {
			return m_sprite.totalFrames;	
		}	
		
//------------------------------------------------------------------------------------------
		public override function gotoAndPlay (__frame:Number):void {
			m_sprite.gotoAndPlay (__frame);
		}
		
//------------------------------------------------------------------------------------------
		public override function gotoAndStop (__frame:Number):void {
			m_sprite.gotoAndStop (__frame);
		}
		
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
