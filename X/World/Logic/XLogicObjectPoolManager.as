//------------------------------------------------------------------------------------------
// <$begin$/>
// <$end$/>
//------------------------------------------------------------------------------------------
package X.World.Logic {
	
	import X.Pool.*;
	import X.Collections.*;
	import X.World.*;
	
//------------------------------------------------------------------------------------------	
	public class XLogicObjectPoolManager extends Object {
		private var xxx:XWorld;
		
		private var m_pools:XDict;
		
//------------------------------------------------------------------------------------------
		public function XLogicObjectPoolManager (__xxx:XWorld) {
			xxx = __xxx;
			
			m_pools = new XDict ();
		}

//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}

//------------------------------------------------------------------------------------------
		public function returnAllObjects (__class:Class = null):void {
			var __pool:XObjectPoolManager;
			
			if (__class) {
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
		public function returnObject (__class:Class, __object:Object):void {
			var __pool:XObjectPoolManager;
			
			if (m_pools.exists (__class)) {
				__pool = m_pools.get (__class);
				
				__pool.returnObject (__object);
			}
		}

//------------------------------------------------------------------------------------------
		public function borrowObject (__class:Class):Object {
			var __pool:XObjectPoolManager;
			
			if (!m_pools.exists (__class)) {
				__pool = new XObjectPoolManager (
					function ():* {
						return new __class ();
					},
					
					function (__src:*, __dst:*):* {
						return null;
					},
					
					16, 16,
					
					function (x:*):void {
					}
				);
				
				m_pools.put (__class, __pool);
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
