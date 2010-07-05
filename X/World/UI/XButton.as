//------------------------------------------------------------------------------------------
package X.World.UI {

// X classes
	import X.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.XDepthSprite;
	import X.Task.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;

//------------------------------------------------------------------------------------------
	public class XButton extends XLogicObject {
		private var m_sprite:MovieClip;
		private var x_sprite:XDepthSprite;
		private var m_buttonClassName:String;
		
		public var NORMAL_STATE:Number = 1;
		public var OVER_STATE:Number = 2;
		public var DOWN_STATE:Number = 3;
		public var SELECTED_STATE:Number = 4;
		
		public var m_currState:Number;
		
//------------------------------------------------------------------------------------------
		public function XButton () {
		}

//------------------------------------------------------------------------------------------
		public override function init (__xxx:XWorld, ...args):void {
			super.init (__xxx);
			
			m_buttonClassName = args[0];
	
			createSprite ();
			
//			mouseEnabled = true;
			
			m_sprite.mouseEnabled = true;
			
			xxx.getXTaskManager ().addTask ([
				function ():void {
					m_sprite.addEventListener (MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
					m_sprite.addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
					m_sprite.addEventListener (MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
					m_sprite.addEventListener (MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
					m_sprite.addEventListener (MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
				},
				
				XTask.RETN,
			]);
			
			m_currState = NORMAL_STATE;
		}

//------------------------------------------------------------------------------------------
		public function addMouseUpEventListener (func:Function):void {
			m_sprite.addEventListener (MouseEvent.MOUSE_UP, func, false, 0, true);
		}
		
//------------------------------------------------------------------------------------------		
		public function onMouseOver (e:MouseEvent):void {
//			if (m_currState == OVER_STATE) {
//				return;
//			}
			
			xxx.getXTaskManager ().addTask ([			
				function  ():void {	
					m_sprite.gotoAndStop (OVER_STATE);
				},
				
				XTask.RETN,
			]);
			
			m_currState = OVER_STATE;
		}	

//------------------------------------------------------------------------------------------		
		public function onMouseDown (e:MouseEvent):void {				
			xxx.getXTaskManager ().addTask ([
				function ():void {
					m_sprite.gotoAndStop (DOWN_STATE);	
				},
				
				XTask.RETN,				
			]);

			m_currState = DOWN_STATE;
		}	

//------------------------------------------------------------------------------------------		
		public function onMouseUp (e:MouseEvent):void {				
			xxx.getXTaskManager ().addTask ([
				function ():void {
					m_sprite.gotoAndStop (NORMAL_STATE);
				},
				
				XTask.RETN,
			]);
			
			m_currState = NORMAL_STATE;
		}

//------------------------------------------------------------------------------------------		
		public function onMouseMove (e:MouseEvent):void {	
		}
									
//------------------------------------------------------------------------------------------		
		public function onMouseOut (e:MouseEvent):void {	
			xxx.getXTaskManager ().addTask ([
				function ():void {
					m_sprite.gotoAndStop (NORMAL_STATE);
				},
				
				XTask.RETN,
			]);
			
			m_currState = NORMAL_STATE;
		}

//------------------------------------------------------------------------------------------
		public override function setValues ():void {
			setRegistration (-getPos ().x, -getPos ().y);
		}
		
//------------------------------------------------------------------------------------------
// create sprite
//------------------------------------------------------------------------------------------
		public function createSprite ():void {			
			m_sprite = new (xxx.getClass (m_buttonClassName)) ();
					
			x_sprite = addSpriteToHud (m_sprite);
			
			m_sprite.gotoAndStop (NORMAL_STATE);
		}
		
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
