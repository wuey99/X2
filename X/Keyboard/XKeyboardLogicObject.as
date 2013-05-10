//------------------------------------------------------------------------------------------
package X.Keyboard {
	
	import X.*;
	import X.Collections.*;
	import X.Task.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	
	import flash.display.*;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------
	public class XKeyboardLogicObject extends XLogicObject {
		private var m_focus:XTask;
		private var m_text:XTextSprite;
		private var m_keyCodes:XDict;
		
//------------------------------------------------------------------------------------------
		public function XKeyboardLogicObject () {
			m_focus = null;
			
			m_keyCodes = new XDict ();
		}

//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			createSprites ();
		}

//------------------------------------------------------------------------------------------
		public override function setupX ():void {
		}

//------------------------------------------------------------------------------------------	
		public override function cleanup ():void {	
			super.cleanup ();
		}
		
//------------------------------------------------------------------------------------------
// create sprites
//------------------------------------------------------------------------------------------
		public override function createSprites ():void {
			m_text = new XTextSprite ();
			
			addSpriteAt (m_text, 9999, 9999);
		}

//------------------------------------------------------------------------------------------
		public function grabFocus ():void {
			if (m_focus == null) {
				stage.addEventListener (KeyboardEvent.KEY_DOWN, onKeyboardDown);
				stage.addEventListener (KeyboardEvent.KEY_UP, onKeyboardUp);
				stage.addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown);
				stage.addEventListener (MouseEvent.MOUSE_MOVE, onMouseMove);
								
				takeStageFocus ();
						
				m_focus = addTask ([
					XTask.LABEL, "loop",
						XTask.WAIT, 0x0100,
					
						function ():void {
							takeStageFocus ();
						},
					
						XTask.GOTO, "loop",
					
						XTask.RETN,
				]);
			}
		}

//------------------------------------------------------------------------------------------
		public function takeStageFocus ():void {
// !STARLING!
			if (CONFIG::flash) {
				if (stage.focus != m_text.v) {
					stage.focus = m_text.v;
				}
			}
		}
		
//------------------------------------------------------------------------------------------
		public function onMouseDown (e:MouseEvent):void {
			takeStageFocus ();
		}

//------------------------------------------------------------------------------------------
		public function onMouseMove (e:MouseEvent):void {
			takeStageFocus ();
		}
		
//------------------------------------------------------------------------------------------
		public function releaseFocus ():void {
			if (m_focus != null) {
				removeTask (m_focus);
				
				stage.removeEventListener (KeyboardEvent.KEY_DOWN, onKeyboardDown);
				stage.removeEventListener (KeyboardEvent.KEY_UP, onKeyboardUp);
								
				m_focus = null;
			}
		}
		
//------------------------------------------------------------------------------------------
		public function onKeyboardDown (e:KeyboardEvent):void {
//			trace (": v:", e.keyCode);
			
			var __c:uint = e.keyCode;
			
			m_keyCodes.put (__c, 1);
		}
		
//------------------------------------------------------------------------------------------
		public function onKeyboardUp (e:KeyboardEvent):void {
//			trace (": ^:", e.keyCode);
			
			var __c:uint = e.keyCode;
			
			if (m_keyCodes.exists (__c)) {
				m_keyCodes.put (__c, 0);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function getKeyCode (__c:uint):Boolean {
			if (m_keyCodes.exists (__c)) {
				return m_keyCodes.get (__c) == 1;
			}
			else
			{
				return false;
			}
		}
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}
