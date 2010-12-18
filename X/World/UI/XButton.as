//------------------------------------------------------------------------------------------
package X.World.UI {

// X classes
	import X.*;
	import X.Task.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.Signals.*;
	import X.World.Sprite.XDepthSprite;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;

//------------------------------------------------------------------------------------------
	public class XButton extends XLogicObject {
		protected var m_sprite:MovieClip;
		protected var x_sprite:XDepthSprite;
		protected var m_buttonClassName:String;
		protected var m_mouseDownSignal:XSignal;
		protected var m_mouseUpSignal:XSignal;
		
		public var NORMAL_STATE:Number = 1;
		public var OVER_STATE:Number = 2;
		public var DOWN_STATE:Number = 3;
		public var SELECTED_STATE:Number = 4;
		
		public var m_label:Number;
		public var m_currState:Number;
		
//------------------------------------------------------------------------------------------
		public function XButton () {
		}

//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			m_buttonClassName = args[0];

			m_mouseDownSignal = createXSignal ();	
			m_mouseUpSignal = createXSignal ();
			
			createSprites ();
			
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
			
			goto (NORMAL_STATE);
			
			m_currState = NORMAL_STATE;
		
			createHighlightTask ();	
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function createHighlightTask ():void {
			addTask ([
				XTask.LABEL, "__loop",
					XTask.WAIT, 0x0100,
					
					function ():void {
						m_sprite.gotoAndStop (m_label);
					},
									
					XTask.GOTO, "__loop",
			]);
		}
		
//------------------------------------------------------------------------------------------
		public function addMouseUpEventListener (func:Function):void {
			m_sprite.addEventListener (MouseEvent.MOUSE_UP, func, false, 0, true);
		}
		
//------------------------------------------------------------------------------------------		
		public function onMouseOver (e:MouseEvent):void {
			goto (OVER_STATE);
			
			m_currState = OVER_STATE;
		}	

//------------------------------------------------------------------------------------------		
		public function onMouseDown (e:MouseEvent):void {
			goto (DOWN_STATE);	

			m_currState = DOWN_STATE;
		}	

//------------------------------------------------------------------------------------------		
		public function onMouseUp (e:MouseEvent):void {				
			goto (NORMAL_STATE);
			
			m_currState = NORMAL_STATE;
			
			fireMouseUpSignal ();
		}

//------------------------------------------------------------------------------------------		
		public function onMouseMove (e:MouseEvent):void {	
		}
									
//------------------------------------------------------------------------------------------		
		public function onMouseOut (e:MouseEvent):void {	
			goto (NORMAL_STATE);
			
			m_currState = NORMAL_STATE;
		}

//------------------------------------------------------------------------------------------
		public override function setValues ():void {
			setRegistration (-getPos ().x, -getPos ().y);
		}
		
//------------------------------------------------------------------------------------------
// create sprites
//------------------------------------------------------------------------------------------
		public override function createSprites ():void {			
			m_sprite = new (xxx.getClass (m_buttonClassName)) ();
					
			x_sprite = addSpriteToHud (m_sprite);
			
			goto (NORMAL_STATE);
			
			show ();
		}

//------------------------------------------------------------------------------------------
		protected function goto (__label:Number):void {
			m_label = __label;
		}

//------------------------------------------------------------------------------------------
		public function addMouseDownListener (__listener:Function):void {
			m_mouseDownSignal.addListener (__listener);
		}

//------------------------------------------------------------------------------------------
		public function fireMouseDownSignal ():void {
			m_mouseDownSignal.fireSignal ();
		}
						
//------------------------------------------------------------------------------------------
		public function addMouseUpListener (__listener:Function):void {
			m_mouseUpSignal.addListener (__listener);
		}

//------------------------------------------------------------------------------------------
		public function fireMouseUpSignal ():void {
			m_mouseUpSignal.fireSignal ();
		}
	
//------------------------------------------------------------------------------------------
		public function removeAllListeners ():void {
			m_mouseUpSignal.removeAllListeners ();
		}
			
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
