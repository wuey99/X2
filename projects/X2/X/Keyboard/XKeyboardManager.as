//------------------------------------------------------------------------------------------
// <$license$/>
//------------------------------------------------------------------------------------------
package X.Keyboard {
	
	import X.World.*;
	import X.Task.*;
	import X.Collections.*;
	
	import flash.display.*;
	import flash.text.*;
	import flash.utils.*;
	import flash.events.*;
	
//------------------------------------------------------------------------------------------	
	public class XKeyboardManager extends Object {
		private var xxx:XWorld;
		private var m_focus:XTask;
		private var m_text:TextField;
		private var m_keyCodes:XDict;
		private var m_parent:Sprite;
		
//------------------------------------------------------------------------------------------
		public function XKeyboardManager (__xxx:XWorld) {
			xxx = __xxx;
			
			m_parent = xxx.getParent () as Sprite;
			
			m_focus = null;
			m_keyCodes = new XDict ();
			
			createSprites ();
		}

		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public function createSprites ():void {
			m_text = new TextField ();
			
			m_text.x = 9999;
			m_text.y = 9999;
			
			if (CONFIG::starling) {
				m_parent.addChild (m_text);
			}
			else
			{
				xxx.addChild (m_text);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function grabFocus ():void {
			if (m_focus == null) {
				m_parent.stage.addEventListener (KeyboardEvent.KEY_DOWN, onKeyboardDown);
				m_parent.stage.addEventListener (KeyboardEvent.KEY_UP, onKeyboardUp);
				m_parent.stage.addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown);
				m_parent.stage.addEventListener (MouseEvent.MOUSE_MOVE, onMouseMove);
				
				takeStageFocus ();
				
				m_focus = xxx.getXTaskManager ().addTask ([
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
			if (m_parent.stage.focus != m_text) {
				m_parent.stage.focus = m_text;
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
				xxx.getXTaskManager ().removeTask (m_focus);
				
				m_parent.stage.removeEventListener (KeyboardEvent.KEY_DOWN, onKeyboardDown);
				m_parent.stage.removeEventListener (KeyboardEvent.KEY_UP, onKeyboardUp);
				
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
