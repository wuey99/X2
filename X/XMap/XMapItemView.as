//------------------------------------------------------------------------------------------
// <$license$/>
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
