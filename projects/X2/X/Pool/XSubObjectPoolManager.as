//------------------------------------------------------------------------------------------
// <$license$/>
//------------------------------------------------------------------------------------------
package X.Pool {
	
	import X.Collections.*;
	
//------------------------------------------------------------------------------------------	
	public class XSubObjectPoolManager extends Object {
		private var m_manager:XObjectPoolManager;
		private var m_inuseObjects:XDict;
		
//------------------------------------------------------------------------------------------
		public function XSubObjectPoolManager (__manager:XObjectPoolManager) {
			m_manager = __manager;
			
			m_inuseObjects = new XDict ();
		}
		
//------------------------------------------------------------------------------------------
		public function isObject (__object:Object):Boolean {
			return m_manager.isObject (__object);
		}	

//------------------------------------------------------------------------------------------
		public function getObjects ():XDict {
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
				
			m_inuseObjects.put (__object, 0);
			
			return __object;
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
