//------------------------------------------------------------------------------------------
// <$begin$/>
// The MIT License (MIT)
// 
// Copyright (c) 2014 Jimmy Huey
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
