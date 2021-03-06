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
package kx.pool {
	
	import kx.pool.*;
	import kx.collections.*;
	import kx.type.*;
	import kx.world.*;
	
	// <HAXE>
	/* --
	@:coreType abstract ClassKey from Class<Dynamic> to {} {}
	-- */
	// </HAXE>
	// <AS3>
	import mx.utils.*;
	// </AS3>
	
//------------------------------------------------------------------------------------------	
	public class XClassPoolManager extends Object {
		private var m_pools:XDict; // <Class<Dynamic>, XObjectPoolManager>
		
//------------------------------------------------------------------------------------------
		public function XClassPoolManager () {
			m_pools = new XDict (); // <Class<Dynamic>, XObjectPoolManager>
		}

//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}

//------------------------------------------------------------------------------------------
		public function setupPool (
			__class:Class /* <Dynamic> */,
			__numObjects:int,
			__overflow:int
		):XObjectPoolManager {
			
			return new XObjectPoolManager (
				function ():* {
					return XType.createInstance (__class);
				},
				
				function (__src:*, __dst:*):* {
					return null;
				},
				
				__numObjects, __overflow,
				
				function (x:*):void {
				}
			);
		}

//------------------------------------------------------------------------------------------
		public function preAllocate (__class:Class /* <Dynamic> */, __numObjects:int):void {
			var __pool:XObjectPoolManager;
			
			if (!m_pools.exists (__class)) {
				__pool = setupPool (__class, 16, 16);
				
				m_pools.set (__class, __pool);
			}	
			
			__pool = m_pools.get (__class);
			
			var i:int;
			
			for (i=0; i<__numObjects; i++) {
				__pool.borrowObject ();
			}
			
			returnAllObjects (__class);
		}
		
//------------------------------------------------------------------------------------------
		public function returnAllObjects (__class:Class /* <Dynamic> */ = null):void {
			var __pool:XObjectPoolManager;
			
			if (__class != null) {
				if (m_pools.exists (__class)) {
					__pool = m_pools.get (__class);
					
					__pool.returnAllObjects ();
				}
			}
			else
			{
				m_pools.forEach (
					function (x:*):void {
						__pool = m_pools.get (__class);
						
						__pool.returnAllObjects ();
					}
				);
			}
		}		
		
//------------------------------------------------------------------------------------------
		public function returnObject (__class:Class /* <Dynamic> */, __object:Object):void {
			var __pool:XObjectPoolManager;
			
			if (m_pools.exists (__class)) {
				__pool = m_pools.get (__class);
				
				__pool.returnObject (__object);
			}
		}

//------------------------------------------------------------------------------------------
		public function borrowObject (__class:Class /* <Dynamic> */):Object {
			var __pool:XObjectPoolManager;
			
			if (!m_pools.exists (__class)) {
				__pool = setupPool (__class, 16, 16);
				
				m_pools.set (__class, __pool);
			}
			else
			{
				__pool = m_pools.get (__class);
			}
			
			return __pool.borrowObject ();
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
