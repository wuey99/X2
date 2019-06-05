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
	
	import kx.collections.*;
	
	// <HAXE>
	/* --
	import haxe.ds.ObjectMap;
	-- */
	// </HAXE>
	// <AS3>
	// </AS3>
	
//------------------------------------------------------------------------------------------	
	public class XObjectPoolManager extends Object {
		// <HAXE>
		/* --
		public var m_freeObjects:Array<Array<Dynamic>>;
		-- */
		// </HAXE>
		// <AS3>
		public var m_freeObjects:Array; // <Dynamic>
		// </AS3>
		public var m_numFreeObjects:int;
		private var m_inuseObjects:XDict; // <Dynamic, Int>
		private var m_newObject:Function;
		private var m_cloneObject:Function;
		private var m_overflow:int;
		private var m_cleanup:Function;
		private var m_numberOfBorrowedObjects:int;
		private var m_sectionSize:int;
		private var m_otherSize:int;
		private var m_section:int;
		private var m_otherSection:int;
		private var m_sectionIndex:int;
		
//------------------------------------------------------------------------------------------
		public function XObjectPoolManager (
			__newObject:Function,
			__cloneObject:Function,
			__numObjects:int,
			__overflow:int,
			__cleanup:Function = null
		) {
				
			// <HAXE>
			/* --
			m_freeObjects = new Array<Array<Dynamic>> ();
			-- */
			// </HAXE>
			// <AS3>
			m_freeObjects = new Array ();
			// </AS3>
			m_inuseObjects = new XDict (); // <Dynamic, Int>
			m_newObject = __newObject;
			m_cloneObject = __cloneObject;
			m_overflow = __overflow;
			m_cleanup = __cleanup;
			
			m_freeObjects.push (new Array () /* <Dynamic> */);
			m_freeObjects.push (new Array () /* <Dynamic> */);
			
			m_sectionSize = 0;
			m_otherSize = 0;
			
			m_section = 0;
			m_otherSection = 1;
			
			m_sectionIndex = 0;
			
			m_numFreeObjects = 0;
			m_numberOfBorrowedObjects = 0;
			
			addMoreObjects (__numObjects);
		}

//------------------------------------------------------------------------------------------
		public function cleanup ():void {
			returnAllObjects ();
			
			if (m_cleanup == null) {
				return;
			}
			
			var i:int;
			
			for (i=0; i<m_sectionSize; i++) {
				m_cleanup (m_freeObjects[m_section][i]);
			}
			
			for (i=0; i<m_otherSize; i++) {
				m_cleanup (m_freeObjects[m_otherSection][i]);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function addMoreObjects (__numObjects:int):void {
			var i:int;
			
			for (i=0; i<__numObjects; i++) {
				m_freeObjects[0].push (null);
				m_freeObjects[1].push (null);
			}
			
			for (i=0; i<__numObjects; i++) {
				m_freeObjects[m_section][m_sectionSize + i] = m_newObject ();
			}
			
			m_sectionSize += __numObjects;
			
			m_numFreeObjects += __numObjects;
		}

//------------------------------------------------------------------------------------------
		/* @:get, set freeObjects Array<Dynamic> */
		
		public function get freeObjects ():Array /* <Dynamic> */ {
			return m_freeObjects[m_section];
		}

		public function set freeObjects (__val:*): /* @:set_type */ void {
			/* @:set_return null; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function totalNumberOfObjects ():int {
			return m_sectionSize + m_otherSize + m_numberOfBorrowedObjects;	
		}
		
//------------------------------------------------------------------------------------------
		public function numberOfBorrowedObjects ():int {
			return m_numberOfBorrowedObjects;
		}	
		
//------------------------------------------------------------------------------------------
		public function isObject (__object:Object):Boolean {
			return m_inuseObjects.exists (__object);
		}	

//------------------------------------------------------------------------------------------
		public function getObjects ():XDict /* <Dynamic, Int> */ {
			return m_inuseObjects;
		}

//------------------------------------------------------------------------------------------
		public function cloneObject (__src:Object):* {
			var __dst:Object = borrowObject ();
			
			return m_cloneObject (__src, __dst);
		}
		
//------------------------------------------------------------------------------------------
		public function returnAllObjects ():void {
			m_inuseObjects.forEach (
				function (__object:*):void {
					returnObject (/* @:cast */ __object as Object);
				}
			);
		}		
		
//------------------------------------------------------------------------------------------
		public function returnObject (__object:Object):void {
			if (m_inuseObjects.exists (__object)) {
				m_freeObjects[m_otherSection][m_otherSize++] = __object;
				m_numFreeObjects++;
				
				m_inuseObjects.remove (__object);
				
				m_numberOfBorrowedObjects--;
			}
		}

//------------------------------------------------------------------------------------------
		public function returnObjectTo (__pool:XObjectPoolManager, __object:Object):void {
			if (m_inuseObjects.exists (__object)) {
				__pool.m_freeObjects[m_otherSection][m_otherSize++] = __object;
				__pool.m_numFreeObjects++;
				
				m_inuseObjects.remove (__object);
				
				m_numberOfBorrowedObjects--;
			}
		}
		
//------------------------------------------------------------------------------------------
		public function borrowObject ():Object {
			if (m_numFreeObjects == 0) {
				addMoreObjects (m_overflow);
			}
			
			if (m_sectionIndex == m_sectionSize) {
				m_sectionSize = m_otherSize;
				m_otherSection = m_section;
				m_section = (m_section + 1) & 1;
				m_sectionIndex = 0;
				m_otherSize = 0;
			}
			
			var __object:Object = m_freeObjects[m_section][m_sectionIndex++];
			m_numFreeObjects--;
				
			m_inuseObjects.set (__object, 0);
			
			m_numberOfBorrowedObjects++;
			
			return __object;
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
