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
package x.pool {
	
	import x.collections.*;
	
//------------------------------------------------------------------------------------------	
	public class XSubObjectPoolManager extends Object {
		private var m_manager:XObjectPoolManager;
		private var m_inuseObjects:XDict;  // <Dynamic, Int>
		
//------------------------------------------------------------------------------------------
		public function XSubObjectPoolManager (__manager:XObjectPoolManager) {
			m_manager = __manager;
			
			m_inuseObjects = new XDict ();  // <Dynamic, Int>
		}
		
//------------------------------------------------------------------------------------------
		public function isObject (__object:Object):Boolean {
			return m_manager.isObject (__object);
		}	

//------------------------------------------------------------------------------------------
		public function getObjects ():XDict /* <Dynamic, Int> */ {
			return m_manager.getObjects ();
		}

//------------------------------------------------------------------------------------------
		public function returnAllObjects ():void {
			m_inuseObjects.forEach (
				function (__object:*):void {
					returnObject (__object as Object);
				}
			);
		}		
		
//------------------------------------------------------------------------------------------
		public function returnObject (__object:Object):void {
			if (m_inuseObjects.exists (__object)) {
				m_manager.returnObject (__object);
				
				m_inuseObjects.remove (__object);
			}
		}

//------------------------------------------------------------------------------------------
		public function borrowObject ():Object {
			var __object:Object = m_manager.borrowObject ();
				
			m_inuseObjects.set (__object, 0);
			
			return __object;
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
