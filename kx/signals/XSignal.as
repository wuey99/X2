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
package kx.signals {

	import kx.collections.*;
	import kx.type.*;

	// <HAXE>
	/* --
	import haxe.ds.ObjectMap;
	-- */
	// </HAXE>
	// <AS3>
	// </AS3>
	
//------------------------------------------------------------------------------------------
	public class XSignal extends Object {
		private var m_listeners:XDict; // <Int, Dynamic>
		private var m_parent:*;
		private var m_id:int;
// <HAXE>
/* --
		public var fireSignal:Function;
-- */
// </HAXE>
// <AS3>
// </AS3>
		
//------------------------------------------------------------------------------------------
		public function XSignal () {
			m_listeners = new XDict (); // <Int, Dynamic>
			m_id = 0;
			
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
		public function addListener (__listener:Function):int {
			m_listeners.set (++m_id, __listener);
			
			return m_id;
		}

//------------------------------------------------------------------------------------------
// <HAXE>
/* --
		public function __fireSignal (args:Array<Dynamic>):Void {
			var __listener:Function;
			var __id:Int;
		
			switch (args.length) {
				case 0:
					for (__id in m_listeners.keys ()) {
						__listener = m_listeners.get (__id);
		
						__listener ();
					}
		
				case 1:
					for (__id in m_listeners.keys ()) {
						__listener = m_listeners.get (__id);
		
						__listener (args[0]);
					}
		
				case 2:
					for (__id in m_listeners.keys ()) {
						__listener = m_listeners.get (__id);
		
						__listener (args[0], args[1]);
					}
		
				case 3:
					for (__id in m_listeners.keys ()) {
						__listener = m_listeners.get (__id);
		
						__listener (args[0], args[1], args[2]);
					}
		
				case 4:
					for (__id in m_listeners.keys ()) {
						__listener = m_listeners.get (__id);
		
						__listener (args[0], args[1], args[2], args[3]);
					}
		
				case 5:
					for (__id in m_listeners.keys ()) {
						__listener = m_listeners.get (__id);
						
						__listener (args[0], args[1], args[2], args[3], args[4]);
					}
			
				case 6:
					for (__id in m_listeners.keys ()) {
						__listener = m_listeners.get (__id);
						
						__listener (args[0], args[1], args[2], args[3], args[4], args[5]);
					}
	
				case 7:
					for (__id in m_listeners.keys ()) {
						__listener = m_listeners.get (__id);
						
						__listener (args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
					}
		
				case 8:
					for (__id in m_listeners.keys ()) {
						__listener = m_listeners.get (__id);
						
						__listener (args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
					}
			}
		}
-- */	
// <AS3>
//------------------------------------------------------------------------------------------
		public function fireSignal (...args):void {	
			var __listener:Function;
			
			switch (args.length) {
				case 0:
					m_listeners.forEach (
						function (__id:int):void {
							__listener = m_listeners.get (__id);
							
							__listener ();
						}
					);
					
					break;
					
				case 1:
					m_listeners.forEach (
						function (__id:int):void {
							__listener = m_listeners.get (__id);
							
							__listener (args[0]);
						}
					);
					
					break;
					
				default:
					m_listeners.forEach (
						function (__id:int):void {
							__listener = m_listeners.get (__id);
							
							__listener.apply (null, args);
						}
					);
					
					break;
			}
		}
// </AS3>
		
//------------------------------------------------------------------------------------------
		public function removeListener (__id:int):void {
			if (m_listeners.exists (__id)) {
				m_listeners.remove (__id);
			}
		}

//------------------------------------------------------------------------------------------
		public function removeAllListeners ():void {
			m_listeners.forEach (
				function (__id:int):void {
					m_listeners.remove (__id);
				}
			);
		}
				
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}