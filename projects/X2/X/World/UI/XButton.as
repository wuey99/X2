//------------------------------------------------------------------------------------------
package X.World.UI {

// X classes
	import X.*;
	import X.Signals.*;
	import X.Task.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	
	include "..\\..\\events.h";
	import flash.text.*;
	import flash.utils.*;

//------------------------------------------------------------------------------------------
	public class XButton extends XLogicObject {
		protected var m_sprite:XMovieClip;
		protected var x_sprite:XDepthSprite;
		protected var m_buttonClassName:String;
		protected var m_mouseDownSignal:XSignal;
		protected var m_mouseUpSignal:XSignal;
		protected var m_mouseOutSignal:XSignal;

		public var NORMAL_STATE:Number = 1;
		public var OVER_STATE:Number = 2;
		public var DOWN_STATE:Number = 3;
		public var SELECTED_STATE:Number = 4;
		public var DISABLED_STATE:Number = 5;
				
		public var m_label:Number;
		public var m_currState:Number;
		protected var m_disabledFlag:Boolean;
				
//------------------------------------------------------------------------------------------
		public function XButton () {
		}

//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			m_buttonClassName = args[0];

			m_mouseDownSignal = createXSignal ();	
			m_mouseOutSignal = createXSignal ();
			m_mouseUpSignal = createXSignal ();
			
			createSprites ();
			
			if (CONFIG::flash) {
				m_sprite.mouseEnabled = true;
			}
			
			m_disabledFlag = false;
			
			xxx.getXTaskManager ().addTask ([
				function ():void {
					m_sprite.addEventListener (xxx.MOUSE_OVER, onMouseOver);
					m_sprite.addEventListener (xxx.MOUSE_DOWN, onMouseDown);
					m_sprite.addEventListener (xxx.MOUSE_MOVE, onMouseMove);
					m_sprite.addEventListener (xxx.MOUSE_UP, onMouseUp);
					m_sprite.addEventListener (xxx.MOUSE_OUT, onMouseOut);
				},
				
				XTask.RETN,
			]);
			
			__gotoState (getNormalState ());
			
			m_currState = getNormalState ()
		
			createHighlightTask ();	
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
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
			m_sprite.addEventListener (xxx.MOUSE_UP, func);
		}
		
//------------------------------------------------------------------------------------------
		if (CONFIG::starling) {
			public function onMouseOver (e:TouchEvent):void {
				trace (": XButton: onMouseOver: ", e);
				
				if (m_disabledFlag) {
					return;
				}
				
				__gotoState (OVER_STATE);
				
				m_currState = OVER_STATE;
			}
		}
		else
		{
			public function onMouseOver (e:MouseEvent):void {
				if (m_disabledFlag) {
					return;
				}
				
				__gotoState (OVER_STATE);
				
				m_currState = OVER_STATE;
			}			
		}

//------------------------------------------------------------------------------------------
		if (CONFIG::starling) {
			public function onMouseDown (e:TouchEvent):void {
				if (m_disabledFlag) {
					return;
				}
				
				__gotoState (DOWN_STATE);	
	
				m_currState = DOWN_STATE;
				
				fireMouseDownSignal ();
			}
		}
		else
		{
			public function onMouseDown (e:MouseEvent):void {
				if (m_disabledFlag) {
					return;
				}
				
				__gotoState (DOWN_STATE);	
				
				m_currState = DOWN_STATE;
				
				fireMouseDownSignal ();
			}			
		}

//------------------------------------------------------------------------------------------
		if (CONFIG::starling) {
			public function onMouseUp (e:TouchEvent):void {
				if (m_disabledFlag) {
					return;
				}
							
				__gotoState (getNormalState ());
				
				m_currState = getNormalState ();
				
				fireMouseUpSignal ();
			}
		}
		else
		{
			public function onMouseUp (e:MouseEvent):void {
				if (m_disabledFlag) {
					return;
				}
				
				__gotoState (getNormalState ());
				
				m_currState = getNormalState ();
				
				fireMouseUpSignal ();
			}			
		}

//------------------------------------------------------------------------------------------
		if (CONFIG::starling) {
			public function onMouseMove (e:TouchEvent):void {	
			}
		}
		else
		{
			public function onMouseMove (e:MouseEvent):void {	
			}			
		}
		
//------------------------------------------------------------------------------------------	
		if (CONFIG::starling) {
			public function onMouseOut (e:TouchEvent):void {
				if (m_disabledFlag) {
					return;
				}
				
				__gotoState (getNormalState ());
				
				m_currState = getNormalState ();
				
				fireMouseOutSignal ();
			}
		}
		else
		{
			public function onMouseOut (e:MouseEvent):void {
				if (m_disabledFlag) {
					return;
				}
				
				__gotoState (getNormalState ());
				
				m_currState = getNormalState ();
				
				fireMouseOutSignal ();
			}			
		}

//------------------------------------------------------------------------------------------
		public function setNormalState ():void {
			__gotoState (getNormalState ());
			
			m_currState = getNormalState ();		
		}

//------------------------------------------------------------------------------------------
		protected function getNormalState ():Number {
			return NORMAL_STATE;
		}
		
//------------------------------------------------------------------------------------------
		public function isDisabled ():Boolean {
			return m_disabledFlag;
		}
			
//------------------------------------------------------------------------------------------
		public function setDisabled (__disabled:Boolean):void {
			if (__disabled) {
				__gotoState (DISABLED_STATE);
							
				m_disabledFlag = true;
			}
			else
			{
				setNormalState ();
				
				m_disabledFlag = false;
			}
		}
		
//------------------------------------------------------------------------------------------
		public override function setValues ():void {
			setRegistration (-getPos ().x, -getPos ().y);
		}
		
//------------------------------------------------------------------------------------------
// create sprites
//------------------------------------------------------------------------------------------
		public override function createSprites ():void {			
			m_sprite = createXMovieClip (m_buttonClassName);
			x_sprite = addSpriteToHud (m_sprite);
			
			__gotoState (NORMAL_STATE);
			
			m_currState = getNormalState ();
			
			show ();
		}

//------------------------------------------------------------------------------------------
		public function gotoState (__label:Number):void {
			m_label = __label;
		}
		
//------------------------------------------------------------------------------------------
		private function __gotoState (__label:Number):void {
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
		public function addMouseOutListener (__listener:Function):void {
			m_mouseOutSignal.addListener (__listener);
		}

//------------------------------------------------------------------------------------------
		public function fireMouseOutSignal ():void {
			m_mouseOutSignal.fireSignal ();
		}
			
//------------------------------------------------------------------------------------------
		public function removeAllListeners ():void {
			m_mouseDownSignal.removeAllListeners ();
			m_mouseUpSignal.removeAllListeners ();
			m_mouseOutSignal.removeAllListeners ();
		}
			
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
