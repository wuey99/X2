//------------------------------------------------------------------------------------------
package X.Signals {

	import flash.utils.*;
	
//------------------------------------------------------------------------------------------
	public class XSignal extends Object {
		private var m_listeners:Dictionary;
		private var m_parent:*;
		
//------------------------------------------------------------------------------------------
		public function XSignal () {
			super();
			
			m_listeners = new Dictionary ();
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
			m_listeners[__listener] = 0;
		}

//------------------------------------------------------------------------------------------
		public function fireSignal (...args):void {
			var __listener:*;
			
			switch (args.length) {
				case 0:
					for (__listener in m_listeners) {
						__listener ();
					}
					
					break;
					
				case 1:
					for (__listener in m_listeners) {
						__listener (args[0]);
					}
					
					break;
					
				default:
					for (__listener in m_listeners) {
						__listener.apply (null, args);
					}
					
					break;
			}
		}
		
//------------------------------------------------------------------------------------------
		public function removeListener (__listener:Function):void {
			if (__listener in m_listeners) {
				delete m_listeners[__listener];
			}
		}

//------------------------------------------------------------------------------------------
		public function removeAllListeners ():void {
			var __listener:*;
			
			for (__listener in m_listeners) {
				delete m_listeners[__listener];
			}
		}
				
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}