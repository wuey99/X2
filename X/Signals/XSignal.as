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
package X.Signals {

	import X.Collections.*;
	
//------------------------------------------------------------------------------------------
	public class XSignal extends Object {
		private var m_listeners:XDict;
		private var m_parent:*;
		
//------------------------------------------------------------------------------------------
		public function XSignal () {
			super();
			
			m_listeners = new XDict ();
		}

//------------------------------------------------------------------------------------------
		public function getParent ():* {
			return m_parent;
		}
		
//------------------------------------------------------------------------------------------
		public function setParent (__parent:*):void {
			m_parent = __parent;
		}
		
//------------------------------------------------------------------------------------------
		public function addListener (__listener:Function):void {
			m_listeners.put (__listener, 0);
		}

//------------------------------------------------------------------------------------------
		public function fireSignal (...args):void {	
			switch (args.length) {
				case 0:
					m_listeners.forEach (
						function (__listener:*):void {
							__listener ();
						}
					);
					
					break;
					
				case 1:
					m_listeners.forEach (
						function (__listener:*):void {
							__listener (args[0]);
						}
					);
					
					break;
					
				default:
					m_listeners.forEach (
						function (__listener:*):void {
							__listener.apply (null, args);
						}
					);
					
					break;
			}
		}
		
//------------------------------------------------------------------------------------------
		public function removeListener (__listener:Function):void {
			if (m_listeners.exists (__listener)) {
				m_listeners.remove (__listener);
			}
		}

//------------------------------------------------------------------------------------------
		public function removeAllListeners ():void {
			m_listeners.forEach (
				function (__listener:*):void {
					m_listeners.remove (__listener);
				}
			);
		}
				
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}