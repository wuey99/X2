//------------------------------------------------------------------------------------------
// <$begin$/>
// The MIT License (MIT)
// 
// Copyright (c) 2014 Jimmy Huey
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// <$end$/>
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
	
	import flash.events.*;
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
			
			setupListeners ();
			
			__gotoState (getNormalState ());
			
			m_currState = getNormalState ()
		
			createHighlightTask ();	
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
			
			cleanupListeners ();
		}

//------------------------------------------------------------------------------------------
		public function setupListeners ():void {		
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
		}
		
//------------------------------------------------------------------------------------------
		public function cleanupListeners ():void {
			m_sprite.removeEventListener (xxx.MOUSE_OVER, onMouseOver);
			m_sprite.removeEventListener (xxx.MOUSE_DOWN, onMouseDown);
			m_sprite.removeEventListener (xxx.MOUSE_MOVE, onMouseMove);
			m_sprite.removeEventListener (xxx.MOUSE_UP, onMouseUp);
			m_sprite.removeEventListener (xxx.MOUSE_OUT, onMouseOut);			
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
		public function __onMouseOver ():void {	
			if (m_disabledFlag) {
				return;
			}
			
			__gotoState (OVER_STATE);
			
			m_currState = OVER_STATE;
		}
		
//------------------------------------------------------------------------------------------
		public function __onMouseDown ():void {	
			if (m_disabledFlag) {
				return;
			}
			
			__gotoState (DOWN_STATE);	
			
			m_currState = DOWN_STATE;
			
			fireMouseDownSignal ();
		}

//------------------------------------------------------------------------------------------
		public function __onMouseUp ():void {
			if (m_disabledFlag) {
				return;
			}
			
			__gotoState (getNormalState ());
			
			m_currState = getNormalState ();
			
			fireMouseUpSignal ();			
		}
		
//------------------------------------------------------------------------------------------
		public function __onMouseMove ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function __onMouseOut ():void {
			if (m_disabledFlag) {
				return;
			}
			
			__gotoState (getNormalState ());
			
			m_currState = getNormalState ();
			
			fireMouseOutSignal ();
		}
		
//------------------------------------------------------------------------------------------
			public function onMouseOver (e:MouseEvent):void {
				__onMouseOver ();
			}			

//------------------------------------------------------------------------------------------
			public function onMouseDown (e:MouseEvent):void {
				__onMouseDown ();
			}			

//------------------------------------------------------------------------------------------
			public function onMouseUp (e:MouseEvent):void {
				__onMouseUp ();
			}			

//------------------------------------------------------------------------------------------
			public function onMouseMove (e:MouseEvent):void {	
				__onMouseMove ();
			}			
		
//------------------------------------------------------------------------------------------	
			public function onMouseOut (e:MouseEvent):void {
				__onMouseOut ();
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
			x_sprite = addSpriteAt (m_sprite, 0, 0);
			
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
