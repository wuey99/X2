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
		private var m_movieClip:MovieClip;
		private var x_sprite:XDepthSprite;
		private var m_frame:Number;
		
//------------------------------------------------------------------------------------------
		public function XMapItemView () {
		}

//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			createSprite (args[0]);
			
			m_frame = args[1];
		}

//------------------------------------------------------------------------------------------
// create sprite
//------------------------------------------------------------------------------------------
		public function createSprite (__spriteClassName:String):void {			
			m_movieClip = new (xxx.getClass (__spriteClassName)) ();

			x_sprite = addSprite (m_movieClip);
				
			if (m_frame) {
				gotoAndStop (m_frame);
			}
		}
	
//------------------------------------------------------------------------------------------
		public override function gotoAndPlay (__frame:Number):void {
			m_movieClip.gotoAndPlay (__frame);
		}
		
//------------------------------------------------------------------------------------------
		public override function gotoAndStop (__frame:Number):void {
			m_movieClip.gotoAndStop (__frame);
		}
		
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
