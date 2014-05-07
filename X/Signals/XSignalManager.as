//------------------------------------------------------------------------------------------
// Copyright (C) 2014 Jimmy Huey
//
// Some Rights Reserved.
//
// The "X-Engine" is licensed under a Creative Commons
// Attribution-Share Alike 3.0 United States License.
// (CC BY-SA 3.0)
//
// You are free to:
//
//      SHARE - to copy, distribute, display and perform the work.
//      ADAPT - remix, transform build upon this material, even for commercial works.
//
//      The licensor cannot revoke these freedoms as long as you follow the license terms.
//
// Under the following terms:
//
//      ATTRIBUTION — 
//      You must give appropriate credit, provide a link to the license, and
//      indicate if changes were made.  You may do so in any reasonable manner,
//      but not in any way that suggests the licensor endorses you or your use.
//
//      SHARE-ALIKE -
//      If you remix, transform, or build upon the material, you must
//      distribute your contributions under the same license as the original.
//
// No additional restrictions — You may not apply legal terms or technological measures
// that legally restrict others from doing anything the license permits. 
//
// The full summary can be located at:
// http://creativecommons.org/licenses/by-sa/3.0/us/ 
//
// The human-readable summary of the Legal Code can be located at:
// http://creativecommons.org/licenses/by-sa/3.0/us/legalcode
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
