//------------------------------------------------------------------------------------------
// <$begin$/>
// <$end$/>
//------------------------------------------------------------------------------------------
package X.Signals {
	
	import X.Collections.*;
	import X.XApp;
	
//------------------------------------------------------------------------------------------	
	public class XSignalManager extends Object {
		private var m_XApp:XApp;
		
		private var m_XSignals:XDict;
		
//------------------------------------------------------------------------------------------
		public function XSignalManager (__XApp:XApp) {
			m_XApp = __XApp;
			
			m_XSignals = new XDict ();
		}

//------------------------------------------------------------------------------------------
		public function isXSignal (__signal:XSignal):Boolean {
			return m_XSignals.exists (__signal);
		}	

//------------------------------------------------------------------------------------------
		public function getXSignals ():XDict {
			return m_XSignals;
		}

//------------------------------------------------------------------------------------------
		public function removeAllXSignals ():void {
			m_XSignals.forEach (
				function (__signal:*):void {
					removeXSignal (__signal as XSignal);
				}
			);
		}		
		
//------------------------------------------------------------------------------------------
		public function removeXSignal (__signal:XSignal):void {
			if (m_XSignals.exists (__signal)) {
				__signal.removeAllListeners ();
				
				m_XSignals.remove (__signal);
			}
		}

//------------------------------------------------------------------------------------------
		public function createXSignal ():XSignal {
			var __signal:XSignal = new XSignal ();
			
			__signal.setParent (this);
			
			m_XSignals.put (__signal, 0);
			
			return __signal;	
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
