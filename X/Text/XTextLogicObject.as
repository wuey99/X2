//------------------------------------------------------------------------------------------
// <$begin$/>
// <$end$/>
//------------------------------------------------------------------------------------------
package X.Text {

	import X.*;
	import X.Geom.*;
	import X.Task.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------
	public class XTextLogicObject extends XLogicObject {
		public var m_text:XTextSprite;
		public var x_text:XDepthSprite;
		
		public var script:XTask;
		public var gravity:XTask;
		
		//------------------------------------------------------------------------------------------
		public function XTextLogicObject () {
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupX ():void {
			super.setupX ();
			
			gravity = addEmptyTask ();
			script = addEmptyTask ();
			
			gravity.gotoTask (getPhysicsTask$ (0.25));
			
			initScript ();
			
			addTask ([
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
				
					function ():void {
					}, 
				
				XTask.GOTO, "loop",
				
				XTask.RETN,
			]);
		}

		//------------------------------------------------------------------------------------------
		public function initScript ():void {
			Idle_Script ();
		}
		
		//------------------------------------------------------------------------------------------
		public function setupText (
			__width:Number=32,
			__height:Number=32,
			__text:String="",
			__fontName:String="Verdana",
			__fontSize:Number=12,
			__color:int=0x000000,
			__bold:Boolean=false
		):void {
			
			if (x_text) {
				removeXTextSprite (m_text);
				
				__removeSprite (x_text);
			}
			
			m_text = createXTextSprite (
				// width
				__width,
				// height
				__height,
				// text
				__text,
				// font name
				__fontName,
				// font size
				__fontSize,
				// color
				__color,
				// bold
				__bold
			);
			
			x_text = __addSpriteAt (m_text, 0, 0);
			
			show ();			
		}

		//------------------------------------------------------------------------------------------
		protected function __removeSprite (__sprite:XDepthSprite):void {
			removeSprite (__sprite);
			
			removeSpriteFromHud (__sprite);
		}
		
		//------------------------------------------------------------------------------------------
		protected function __addSpriteAt (__sprite:XTextSprite, __dx:Number=0, __dy:Number=0):XDepthSprite {
			return addSpriteAt (__sprite, __dx, __dy);	
		}
		
		//------------------------------------------------------------------------------------------
		public function get text ():XTextSprite {
			return m_text;
		}
		
		//------------------------------------------------------------------------------------------
		public function autoCalcSize ():void {
			m_text.autoCalcSize ();
		}

		//------------------------------------------------------------------------------------------
		public function autoCalcWidth ():void {
			m_text.autoCalcWidth ();
		}
		
		//------------------------------------------------------------------------------------------
		public function autoCalcHeight ():void {
			m_text.autoCalcHeight ();
		}
		
		//------------------------------------------------------------------------------------------
		public function centerOnX (__x:Number, __width:Number):void {	
			oX = __x + (__width - m_text.width)/2;
		}
		
		//------------------------------------------------------------------------------------------
		public function centerOnY (__y:Number, __height:Number):void {
			oY = __y + (__height - m_text.height)/2;
		}
		
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():void {
		}
		
		//------------------------------------------------------------------------------------------
		public function getPhysicsTask$ (DECCEL:Number):Array {
			return [
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					updatePhysics,	
					XTask.GOTO, "loop",
				
				XTask.RETN,
			];
		}
		
		//------------------------------------------------------------------------------------------
		public function Idle_Script ():void {
			
			script.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():void {
					script.addTask ([
						XTask.LABEL, "loop",
							XTask.WAIT, 0x0100,
						
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