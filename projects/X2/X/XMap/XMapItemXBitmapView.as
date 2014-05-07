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
	
	// Box2D classes
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	// X classes
	import X.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	import X.XMap.*;
	
	// Flash classes
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------
	public class XMapItemXBitmapView extends XMapItemView {
		protected var m_bitmap:XBitmap;
		
		//------------------------------------------------------------------------------------------
		public function XMapItemXBitmapView () {
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
		}

		//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
			
			m_bitmap.cleanup ();
		}
		
		//------------------------------------------------------------------------------------------
		// create sprite
		//------------------------------------------------------------------------------------------
		protected override function __createSprites (__spriteClassName:String):void {			
			m_bitmap = new XBitmap ();
			m_bitmap.setup ();
			m_bitmap.initWithClassName (xxx, null, __spriteClassName);
// !STARLING!
			if (CONFIG::flash) {
				x_sprite = addSpriteAt (m_bitmap, m_bitmap.dx, m_bitmap.dy);
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
		public override function getTotalFrames ():Number {
			return m_bitmap.getNumBitmaps ();	
		}	
		
		//------------------------------------------------------------------------------------------
		public override function gotoAndStop (__frame:Number):void {
			m_bitmap.gotoAndStop (__frame);
		}
		
	//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
