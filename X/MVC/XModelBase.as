//------------------------------------------------------------------------------------------
// <$begin$/>
// <$end$/>
//------------------------------------------------------------------------------------------
package X.MVC {
	import X.Signals.XSignal;
	import X.XML.*;
	
// flash classes
	import flash.events.*;

//------------------------------------------------------------------------------------------	
	public class XModelBase extends EventDispatcher {
		private var m_changedSignal:XSignal;
		
//------------------------------------------------------------------------------------------	
		public function XModelBase () {
			m_changedSignal = new XSignal ();
		}

//------------------------------------------------------------------------------------------
		public function addChangedListener (__listener:Function):void {
			m_changedSignal.addListener (__listener);
		}
		
//------------------------------------------------------------------------------------------
		public function fireChangedSignal ():void {
			m_changedSignal.fireSignal ();
		}
		
//------------------------------------------------------------------------------------------
		public function serializeAll ():XSimpleXMLNode {
			return null;
		}
		
//------------------------------------------------------------------------------------------
		public function deserializeAll (__xml:XSimpleXMLNode):void {
		}
			
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}	