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
	// primarily used in TikiEdit
	//------------------------------------------------------------------------------------------
	public class XMapItemCachedView extends XMapItemView {
		
		//------------------------------------------------------------------------------------------
		public function XMapItemCachedView () {
		}
		
		//------------------------------------------------------------------------------------------
		// create sprite
		//------------------------------------------------------------------------------------------
		protected override function __createSprites (__spriteClassName:String):void {			
			m_sprite = new (xxx.getClass (__spriteClassName)) ();
			m_sprite.cacheAsBitmap = true;	
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
	}
	
//------------------------------------------------------------------------------------------	
}
