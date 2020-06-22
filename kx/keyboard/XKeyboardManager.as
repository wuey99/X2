//------------------------------------------------------------------------------------------
// <$begin$/>
// The MIT License (MIT)
//
// The "X-Engine"
//
// Copyright (c) 2014 Jimmy Huey (wuey99@gmail.com)
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
package kx.keyboard {
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	
	import kx.collections.*;
	import kx.geom.*;
	import kx.signals.*;
	import kx.task.*;
	import kx.world.*;
	
//------------------------------------------------------------------------------------------	
	public class XKeyboardManager extends Object {
		private var xxx:XWorld;
		private var m_focus:XTask;
		private var m_text:TextField;
		private var m_keyCodes:XDict; // <Int, Int>
		private var m_parent:Sprite;
		private var m_mouseDownListenerID:int;
		private var m_keyDownSignal:XSignal;
		private var m_keyUpSignal:XSignal;
		
//------------------------------------------------------------------------------------------
		public function XKeyboardManager (__xxx:XWorld) {
			xxx = __xxx;
			
			m_parent = xxx.getParent () as Sprite;
			
			m_focus = null;
			m_keyCodes = new XDict (); // <Int, Int>
			
			createSprites ();
			
			m_keyDownSignal = new XSignal ();
			m_keyUpSignal = new XSignal ();
		}

		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public function createSprites ():void {
			m_text = new TextField ();
			
			m_text.x = 9999;
			m_text.y = 9999;
			
			xxx.addChild (m_text);
		}
		
		//------------------------------------------------------------------------------------------
		public function grabFocus ():void {
			if (m_focus == null) {
				m_parent.stage.addEventListener (KeyboardEvent.KEY_DOWN, onKeyboardDown);
				m_parent.stage.addEventListener (KeyboardEvent.KEY_UP, onKeyboardUp);
				m_mouseDownListenerID = xxx.addMouseDownListener (onMouseDown);
//				xxx.addPolledMouseMoveListener (onMouseMove);
				
				takeStageFocus ();
				
				m_focus = xxx.getXTaskManager ().addTask ([
					XTask.LABEL, "loop",
						XTask.WAIT, 0x0800,
						
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
		public function onMouseMove (__point:XPoint):void {
			takeStageFocus ();
		}
		
		//------------------------------------------------------------------------------------------
		public function releaseFocus ():void {
			if (m_focus != null) {
				xxx.getXTaskManager ().removeTask (m_focus);
				
				m_parent.stage.removeEventListener (KeyboardEvent.KEY_DOWN, onKeyboardDown);
				m_parent.stage.removeEventListener (KeyboardEvent.KEY_UP, onKeyboardUp);
				xxx.removeMouseDownListener (m_mouseDownListenerID);
//				xxx.removePolledMouseMoveListener (onMouseMove);
				
				m_focus = null;
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function onKeyboardDown (e:KeyboardEvent):void {
//			trace (": v:", e.keyCode);
			
			var __c:uint = e.keyCode;
			
			m_keyCodes.set (__c, 1);
		}
		
		//------------------------------------------------------------------------------------------
		public function onKeyboardUp (e:KeyboardEvent):void {
//			trace (": ^:", e.keyCode);
			
			var __c:uint = e.keyCode;
			
			if (m_keyCodes.exists (__c)) {
				m_keyCodes.set (__c, 0);
			}
		}

		//------------------------------------------------------------------------------------------
		public function addKeyDownListener (__listener:Function):int {
			return m_keyDownSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeKeyDownListener (__id:int):void {
			m_keyDownSignal.removeListener (__id);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeAllKeyDownListeners ():void {
			m_keyDownSignal.removeAllListeners ();
		}
		
		//------------------------------------------------------------------------------------------
		public function addKeyUpListener (__listener:Function):int {	
			return m_keyUpSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeKeyUpListener (__id:int):void {
			m_keyUpSignal.removeListener (__id);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeAllKeyUpnListeners ():void {
			m_keyUpSignal.removeAllListeners ();
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
