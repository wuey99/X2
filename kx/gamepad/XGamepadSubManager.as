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
package kx.gamepad {
	
	import kx.*;
	import kx.collections.*;
	import kx.gamepad.*;
	
	//------------------------------------------------------------------------------------------	
	public class XGamepadSubManager extends Object {
		public var m_manager:XGamepadManager;
		
		private var m_analogChangedSignalIDs:XDict;  // <Int, String>
		private var m_buttonUpSignalIDs:XDict; // <Int, String>
		private var m_buttonDownSignalIDs:XDict; // <Int, String>
		
		//------------------------------------------------------------------------------------------
		public function XGamepadSubManager (__manager:XGamepadManager) {
			super ();
			
			m_manager = __manager;
			
			m_analogChangedSignalIDs = new XDict ();  // <Int, String>
			m_buttonUpSignalIDs = new XDict ();  // <Int, String>
			m_buttonDownSignalIDs = new XDict ();  // <Int, String>
		}
		
		//------------------------------------------------------------------------------------------
		public function setup ():void {
		}	
		
		//------------------------------------------------------------------------------------------
		public function cleanup ():void {
			removeAllListeners ();
		}
		
		//------------------------------------------------------------------------------------------
		public function addAnalogChangedListener (__axis:String, __listener:Function):int {
			var __id:int;
			
			__id = m_manager.addAnalogChangedListener (__axis, __listener);
			
			m_analogChangedSignalIDs.set (__id, __axis);
			
			return __id;
		}
		
		//------------------------------------------------------------------------------------------
		public function addButtonUpListener (__button:String, __listener:Function):int {
			var __id:int;
			
			__id = m_manager.addButtonUpListener (__button, __listener);
		
			m_buttonUpSignalIDs.set (__id, __button);
			
			return __id;
		}
		
		//------------------------------------------------------------------------------------------
		public function addButtonDownListener (__button:String, __listener:Function):int {
			var __id:int;
			
			__id = m_manager.addButtonDownListener (__button, __listener);
			
			m_buttonDownSignalIDs.set (__id, __button);
			
			return __id;
		}
		
		//------------------------------------------------------------------------------------------
		public function removeAllListeners ():void {	
			m_analogChangedSignalIDs.forEach (
				function (__id:int):void {
					m_manager.removeAnalogChangedListener (m_analogChangedSignalIDs.get (__id), __id);	
				}
			);
			
			m_buttonUpSignalIDs.forEach (
				function (__id:int):void {
					m_manager.removeButtonUpListener (m_buttonUpSignalIDs.get (__id), __id);	
				}
			);
			
			m_buttonDownSignalIDs.forEach (
				function (__id:int):void {
					m_manager.removeButtonDownListener (m_buttonDownSignalIDs.get (__id), __id);	
				}
			);
		}
		
		//------------------------------------------------------------------------------------------
	}
	
	//------------------------------------------------------------------------------------------
}
