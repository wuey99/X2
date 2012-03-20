//------------------------------------------------------------------------------------------
package X.Resource {

//------------------------------------------------------------------------------------------	
	public class XClass extends Object {
		private var m_class:Class = null;
		private var m_className:String;
		private var m_resourcePath:String;
		private var m_resourceXML:XML;

//------------------------------------------------------------------------------------------
		public function XClass (__className:String, __resourcePath:String, __resourceXML:XML) {
			m_className = __className;
			m_resourcePath = __resourcePath;
			m_resourceXML = __resourceXML;
		}

//------------------------------------------------------------------------------------------
		public function getClassName ():String {
			return m_className;
		}

//------------------------------------------------------------------------------------------
		public function getResourcePath ():String {
			return m_resourcePath;
		}

//------------------------------------------------------------------------------------------
		public function getResourceXML ():XML {
			return m_resourceXML;
		}
				
//------------------------------------------------------------------------------------------
		public function setClass (__class:Class):void {
			m_class = __class;
		}
		
//------------------------------------------------------------------------------------------	
		public function getClass ():Class {
			return m_class;
		}
		
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------
}