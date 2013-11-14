//------------------------------------------------------------------------------------------
package X.Debug  {
	
	import X.*;
	import X.Task.*;
	import X.Text.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	
//------------------------------------------------------------------------------------------
	public class XFPSCounter extends XTextLogicObject {

//------------------------------------------------------------------------------------------
		public function XFPSCounter () {
			super ();
		}
		
//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
		}
		
//------------------------------------------------------------------------------------------
		public override function setupX ():void {
			super.setupX ();
			
			setupText (
				// width
				700,
				// height
				32,
				// text
				"FPS",
				// font name
				"Verdana",
				// font size
				16,
				// color
				0xe0e0e0,
				// bold
				true
			);
			
			oX = oY = 8;
		}

//------------------------------------------------------------------------------------------
		protected override function __addSpriteAt (__sprite:XTextSprite, __dx:Number=0, __dy:Number=0):XDepthSprite {
			return addSpriteToHudAt (__sprite, __dx, __dy);	
		}
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}
