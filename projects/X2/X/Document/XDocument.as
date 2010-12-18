//------------------------------------------------------------------------------------------
package X.Document {
	
	import X.MVC.XModelBase;
	import X.XApp;

//------------------------------------------------------------------------------------------
	public class XDocument extends Object {
		protected var m_model:XModelBase;
		protected var m_XApp:XApp;
		protected var m_name:String;
		protected var m_xml:XML;
						
//------------------------------------------------------------------------------------------
		public function XDocument () {	
			super ();
		}

//------------------------------------------------------------------------------------------
		public function setup (__XApp:XApp, __model:XModelBase, __xml:XML):void {
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
		public function get model ():XModelBase {
			return m_model;
		}
		
		public function set model (__model:XModelBase):void {
			m_model = __model;
		}

//------------------------------------------------------------------------------------------
		public function get xml ():XML {
			return m_xml;
		}
		
		public function set xml (__xml:XML):void {
			m_xml = __xml;
		}
				
//------------------------------------------------------------------------------------------
		public function serializeAll ():XML {
			return m_model.serializeAll ();
		}
		
//------------------------------------------------------------------------------------------
		public function deserializeAll (__xml:XML):void {
			m_model.deserializeAll (__xml);
		}
		
//------------------------------------------------------------------------------------------		
	}
	
//------------------------------------------------------------------------------------------
}