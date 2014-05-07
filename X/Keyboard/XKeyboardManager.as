//------------------------------------------------------------------------------------------
// <$begin$/>
// Copyright (C) 2014 Jimmy Huey
//
// Some Rights Reserved.
//
// The "X-Engine" is licensed under a Creative Commons
// Attribution-NonCommerical-ShareAlike 3.0 Unported License.
// (CC BY-NC-SA 3.0)
//
// You are free to:
//
//      SHARE - to copy, distribute, display and perform the work.
//      ADAPT - remix, transform build upon this material.
//
//      The licensor cannot revoke these freedoms as long as you follow the license terms.
//
// Under the following terms:
//
//      ATTRIBUTION -
//          You must give appropriate credit, provide a link to the license, and
//          indicate if changes were made.  You may do so in any reasonable manner,
//          but not in any way that suggests the licensor endorses you or your use.
//
//      SHAREALIKE -
//          If you remix, transform, or build upon the material, you must
//          distribute your contributions under the same license as the original.
//
//      NONCOMMERICIAL -
//          You may not use the material for commercial purposes.
//
// No additional restrictions - You may not apply legal terms or technological measures
// that legally restrict others from doing anything the license permits.
//
// The full summary can be located at:
// http://creativecommons.org/licenses/by-nc-sa/3.0/
//
// The human-readable summary of the Legal Code can be located at:
// http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode
//
// The "X-Engine" is free for non-commerical use.
// For commercial use, you will need to provide additional credits.
// Please contact me @ wuey99[dot]gmail[dot]com for more details.
// <$end$/>
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
