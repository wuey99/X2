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
