//------------------------------------------------------------------------------------------
package X.Pool {
	
	import X.Collections.*;
	
//------------------------------------------------------------------------------------------	
	public class XObjectPoolManager extends Object {
		public var m_freeObjects:Array;
		public var m_numFreeObjects:int;
		private var m_inuseObjects:XDict;
		private var m_newObject:Function;
		private var m_cloneObject:Function;
		private var m_overflow:Number;
		private var m_cleanup:Function;
		private var m_numberOfBorrowedObjects:Number;
		
//------------------------------------------------------------------------------------------
		public function XObjectPoolManager (
			__newObject:Function,
			__cloneObject:Function,
			__numObjects:Number,
			__overflow:Number,
			__cleanup:Function = null
		) {
				
			m_freeObjects = new Array ();
			m_inuseObjects = new XDict ();
			m_newObject = __newObject;
			m_cloneObject = __cloneObject;
			m_overflow = __overflow;
			m_cleanup = __cleanup;
			
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
			
			var i:Number;
			
			for (i=0; i<m_freeObjects.length; i++) {
				m_cleanup (m_freeObjects[i]);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function addMoreObjects (__numObjects:Number):void {
			var i:Number;
			
			for (i=0; i<__numObjects; i++) {
				m_freeObjects[m_numFreeObjects++] = (m_newObject ());
			}
		}

//------------------------------------------------------------------------------------------
		public function get freeObjects ():Array {
			return m_freeObjects;
		}

//------------------------------------------------------------------------------------------
		public function totalNumberOfObjects ():Number {
			return m_freeObjects.length + m_numberOfBorrowedObjects;	
		}
		
//------------------------------------------------------------------------------------------
		public function numberOfBorrowedObjects ():Number {
			return m_numberOfBorrowedObjects;
		}	
		
//------------------------------------------------------------------------------------------
		public function isObject (__object:Object):Boolean {
			return m_inuseObjects.exists (__object);
		}	

//------------------------------------------------------------------------------------------
		public function getObjects ():XDict {
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
					returnObject (__object as Object);
				}
			);
		}		
		
//------------------------------------------------------------------------------------------
		public function returnObject (__object:Object):void {
			if (m_inuseObjects.exists (__object)) {
				m_freeObjects[m_numFreeObjects++] = (__object);
				
				m_inuseObjects.remove (__object);
				
				m_numberOfBorrowedObjects--;
			}
		}

//------------------------------------------------------------------------------------------
		public function returnObjectTo (__pool:XObjectPoolManager, __object:Object):void {
			if (m_inuseObjects.exists (__object)) {
				__pool.m_freeObjects[__pool.m_numFreeObjects++] = (__object);
				
				m_inuseObjects.remove (__object);
				
				m_numberOfBorrowedObjects--;
			}
		}
		
//------------------------------------------------------------------------------------------
		public function borrowObject ():Object {
			if (m_numFreeObjects == 0) {
				addMoreObjects (m_overflow);
			}
			
			var __object:Object = m_freeObjects.pop ();
				
			m_inuseObjects.put (__object, 0);
			
			m_numFreeObjects--;
			m_numberOfBorrowedObjects++;
			
			return __object;
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
