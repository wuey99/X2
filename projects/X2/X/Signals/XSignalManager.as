//------------------------------------------------------------------------------------------
package X.Signals {
	
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------	
	public class XSignalManager extends Object {
		private var m_XSignals:Dictionary;
		
//------------------------------------------------------------------------------------------
		public function XSignalManager () {
			m_XSignals = new Dictionary ();
		}

//------------------------------------------------------------------------------------------
		public function isXSignal (__signal:XSignal):Boolean {
			return __signal in m_XSignals;
		}	

//------------------------------------------------------------------------------------------
		public function getXSignals ():Dictionary {
			return m_XSignals;
		}

//------------------------------------------------------------------------------------------
		public function removeAllXSignals ():void {
			var __signal:*;
			
			for (__signal in m_XSignals) {
				removeXSignal (__signal as XSignal);
			}
		}		
		
//------------------------------------------------------------------------------------------
		public function removeXSignal (__signal:XSignal):void {
			if (__signal in m_XSignals) {
				__signal.removeAllListeners ();
				
				delete m_XSignals[__signal];
			}
		}

//------------------------------------------------------------------------------------------
		public function createXSignal ():XSignal {
			var __signal:XSignal = new XSignal ();
			
			__signal.setParent (this);
			
			m_XSignals[__signal] = 0;
			
			return __signal;	
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
