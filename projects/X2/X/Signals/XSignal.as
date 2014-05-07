//------------------------------------------------------------------------------------------
// <$begin$/>
// <$end$/>
//------------------------------------------------------------------------------------------
package X.Signals {

	import X.Collections.*;
	
//------------------------------------------------------------------------------------------
	public class XSignal extends Object {
		private var m_listeners:XDict;
		private var m_parent:*;
		
//------------------------------------------------------------------------------------------
		public function XSignal () {
			super();
			
			m_listeners = new XDict ();
		}

//------------------------------------------------------------------------------------------
		public function getParent ():* {
			return m_parent;
		}
		
//------------------------------------------------------------------------------------------
		public function setParent (__parent:*):void {
			m_parent = __parent;
		}
		
//------------------------------------------------------------------------------------------
		public function addListener (__listener:Function):void {
			m_listeners.put (__listener, 0);
		}

//------------------------------------------------------------------------------------------
		public function fireSignal (...args):void {	
			switch (args.length) {
				case 0:
					m_listeners.forEach (
						function (__listener:*):void {
							__listener ();
						}
					);
					
					break;
					
				case 1:
					m_listeners.forEach (
						function (__listener:*):void {
							__listener (args[0]);
						}
					);
					
					break;
					
				default:
					m_listeners.forEach (
						function (__listener:*):void {
							__listener.apply (null, args);
						}
					);
					
					break;
			}
		}
		
//------------------------------------------------------------------------------------------
		public function removeListener (__listener:Function):void {
			if (m_listeners.exists (__listener)) {
				m_listeners.remove (__listener);
			}
		}

//------------------------------------------------------------------------------------------
		public function removeAllListeners ():void {
			m_listeners.forEach (
				function (__listener:*):void {
					m_listeners.remove (__listener);
				}
			);
		}
				
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}