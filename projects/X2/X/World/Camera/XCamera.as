//------------------------------------------------------------------------------------------
package World.Camera {
	
	import X.*;
	import X.Task.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	import X.Signals.XSignal;
	
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------
	public class XCamera extends XLogicObject {
		
//------------------------------------------------------------------------------------------
		public function XCamera () {
		}

//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, ...args):void {
			super.setup (__xxx);
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
		}
		
//------------------------------------------------------------------------------------------
		public override function setupX ():void {
			super.initX ();
		}

//------------------------------------------------------------------------------------------
// create sprites
//------------------------------------------------------------------------------------------
		public override function createSprites ():void {
		}
			
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}
