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
package x.signals {

	import x.collections.*;

//------------------------------------------------------------------------------------------
	public class XSignal extends Object {
		private var m_listeners:XDict; // <Dynamic, Int>
		private var m_parent:*;
// <HAXE>
/* --
		public var fireSignal:Function;
-- */
// </HAXE>
// <AS3>
// </AS3>
		
//------------------------------------------------------------------------------------------
		public function XSignal () {
			m_listeners = new XDict (); // <Dynamic, Int>
			
// <HAXE>
/* --
			fireSignal = Reflect.makeVarArgs (__fireSignal);
-- */
// </HAXE>
// <AS3>
// </AS3>
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
			m_listeners.set (__listener, 0);
		}

//------------------------------------------------------------------------------------------
// <HAXE>
/* --
		public function __fireSignal (args:Array<Dynamic>):Void {
			switch (args.length) {
				case 0:
					for (__listener in m_listeners.keys ()) {
						__listener ();
					}
		
				case 1:
					for (__listener in m_listeners.keys ()) {
						__listener (args[0]);
					}
		
				case 2:
					for (__listener in m_listeners.keys ()) {
						__listener (args[0], args[1]);
					}
		
				case 3:
					for (__listener in m_listeners.keys ()) {
						__listener (args[0], args[1], args[2]);
					}
		
				case 4:
					for (__listener in m_listeners.keys ()) {
						__listener (args[0], args[1], args[2], args[3]);
					}
			}
		}
-- */	
// <AS3>
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
// </AS3>
		
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