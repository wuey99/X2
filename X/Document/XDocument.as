//------------------------------------------------------------------------------------------
// <$begin$/>
// The MIT License (MIT)
//
// The "X-Engine"
//
// Copyright (c) 2014 Jimmy Huey (wuey99@gmail.com)
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
		/* @:get, set model XModelBase */
		
		public function get model ():XModelBase {
			return m_model;
		}
		
		public function set model (__model:XModelBase): /* @:set_type */ void {
			m_model = __model;
			
			/* @:set_return null; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set xml XSimpleXMLNode */
		
		public function get xml ():XSimpleXMLNode {
			return m_xml;
		}
		
		public function set xml (__xml:XSimpleXMLNode): /* @:set_type */ void {
			m_xml = __xml;
			
			/* @:set_return null; */			
		}
		/* @:end */
				
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