//------------------------------------------------------------------------------------------
// <$begin$/>
// <$end$/>
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
						
			oX = oY = 8;
			
			xxx.addTimer1000Listener (
				function ():void {
					setupText (
						// width
						700,
						// height
						32,
						// text
						"FPS: " + xxx.getFPS (),
						// font name
						"Verdana",
						// font size
						16,
						// color
						0xe0e0e0,
						// bold
						true
					);					
				}
			);
		}

//------------------------------------------------------------------------------------------
		protected override function __removeSprite (__sprite:XDepthSprite):void {
			removeSpriteFromHud (__sprite);
		}
		
//------------------------------------------------------------------------------------------
		protected override function __addSpriteAt (__sprite:XTextSprite, __dx:Number=0, __dy:Number=0):XDepthSprite {
			return addSpriteToHudAt (__sprite, __dx, __dy);	
		}
		
//------------------------------------------------------------------------------------------
		public override function Idle_Script ():void {
			
			script.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():void {
					script.addTask ([
						XTask.LABEL, "loop",
							XTask.WAIT, 0x1000,
							
							function ():void {
							},
							
							XTask.GOTO, "loop",
						
						XTask.RETN,
					]);
					
				},
				
				//------------------------------------------------------------------------------------------
				// animation
				//------------------------------------------------------------------------------------------	
				XTask.LABEL, "loop",	
					XTask.WAIT, 0x0100,	
					
					XTask.GOTO, "loop",
				
				XTask.RETN,
				
				//------------------------------------------------------------------------------------------			
			]);
			
		//------------------------------------------------------------------------------------------
		}
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}
