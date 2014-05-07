//------------------------------------------------------------------------------------------
// <$license$/>
//------------------------------------------------------------------------------------------
package X.Document {
	
	import X.MVC.XModelBase;
	import X.XApp;
	import X.XML.*;

//------------------------------------------------------------------------------------------
	public class XDocument extends Object {
		protected var m_model:XModelBase;
		protected var m_XApp:XApp;
		protected var m_name:String;
		protected var m_xml:XSimpleXMLNode;
		protected var m_documentName:String;
				
//------------------------------------------------------------------------------------------
		public function XDocument () {	
			super ();
		}

//------------------------------------------------------------------------------------------
		public function setup (__XApp:XApp, __model:XModelBase, __xml:XSimpleXMLNode):void {
			m_XApp = __XApp;
			model = __model;
			xml = __xml;
			
			if (xml != null) {
				model.deserializeAll (xml);
			}
		}

//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}

//------------------------------------------------------------------------------------------
		public function setDocumentName (__name:String):void {
			m_documentName = __name;
		}
		
//------------------------------------------------------------------------------------------
		public function getDocumentName ():String {
			return m_documentName;
		}
				
//------------------------------------------------------------------------------------------
		public function get model ():XModelBase {
			return m_model;
		}
		
		public function set model (__model:XModelBase):void {
			m_model = __model;
		}

//------------------------------------------------------------------------------------------
		public function get xml ():XSimpleXMLNode {
			return m_xml;
		}
		
		public function set xml (__xml:XSimpleXMLNode):void {
			m_xml = __xml;
		}
				
//------------------------------------------------------------------------------------------
		public function serializeAll ():XSimpleXMLNode {
			return m_model.serializeAll ();
		}
		
//------------------------------------------------------------------------------------------
		public function deserializeAll (__xml:XSimpleXMLNode):void {
			m_model.deserializeAll (__xml);
		}
		
//------------------------------------------------------------------------------------------		
	}
	
//------------------------------------------------------------------------------------------
}