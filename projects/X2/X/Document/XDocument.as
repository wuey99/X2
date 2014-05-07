//------------------------------------------------------------------------------------------
// <$begin$/>
// Copyright (C) 2014 Jimmy Huey
//
// Some Rights Reserved.
//
// The "X-Engine" is licensed under a Creative Commons
// Attribution-NonCommerical-ShareAlike 3.0 Unported License.
// (CC BY-NC-SA 3.0)
//
// You are free to:
//
//      SHARE - to copy, distribute, display and perform the work.
//      ADAPT - remix, transform build upon this material.
//
//      The licensor cannot revoke these freedoms as long as you follow the license terms.
//
// Under the following terms:
//
//      ATTRIBUTION -
//          You must give appropriate credit, provide a link to the license, and
//          indicate if changes were made.  You may do so in any reasonable manner,
//          but not in any way that suggests the licensor endorses you or your use.
//
//      SHAREALIKE -
//          If you remix, transform, or build upon the material, you must
//          distribute your contributions under the same license as the original.
//
//      NONCOMMERICIAL -
//          You may not use the material for commercial purposes.
//
// No additional restrictions - You may not apply legal terms or technological measures
// that legally restrict others from doing anything the license permits.
//
// The full summary can be located at:
// http://creativecommons.org/licenses/by-nc-sa/3.0/
//
// The human-readable summary of the Legal Code can be located at:
// http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode
//
// The "X-Engine" is free for non-commerical use.
// For commercial use, you will need to provide proper credits.
// Please contact me @ wuey99[dot]gmail[dot]com for more details.
// <$end$/>
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