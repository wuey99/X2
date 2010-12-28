//------------------------------------------------------------------------------------------
package X.XML {

//------------------------------------------------------------------------------------------
	public class XXMLNode extends Object {
		private var m_xml:XML;
		
//------------------------------------------------------------------------------------------
		public function XXMLNode () {
			super ();
		}

//------------------------------------------------------------------------------------------
		public function setupWithParams (__tag:String, __text:String, __attribs:Object):void {
			m_xml = new XML (__paramsToXMLString (__tag, __text, __attribs));
		}

//------------------------------------------------------------------------------------------
		public function setupWithXMLString (__xmlString:String):void {
			m_xml = new XML (__xmlString);
		}
		
//------------------------------------------------------------------------------------------
		public function setupWithXXMLNode (__xxmlNode:XXMLNode):void {
			m_xml = new XML (__xxmlNode.getXML ());
		}

//------------------------------------------------------------------------------------------
		public function setupWithXML (__xml:XML):void {
			m_xml = __xml;
		}
		
//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}

//------------------------------------------------------------------------------------------
		public function addChildWithParams (__tag:String, __text:String, __attribs:Object):XXMLNode {
			var __xxmlNode:XXMLNode = new XXMLNode ();
			__xxmlNode.setupWithParams (__tag, __text, __attribs);
			
			m_xml.appendChild (__xxmlNode.getXML ());
			
			return __xxmlNode;
		}

//------------------------------------------------------------------------------------------
		public function addChildWithXMLString (__xmlString:String):XXMLNode {
			var __xxmlNode:XXMLNode = new XXMLNode ();
			__xxmlNode.setupWithXMLString (__xmlString);
			
			m_xml.appendChild (__xxmlNode.getXML ());
			
			return __xxmlNode;
		}

//------------------------------------------------------------------------------------------
		public function addChildWithXXMLNode (__xxmlNode:XXMLNode):XXMLNode {
			m_xml.appendChild (__xxmlNode.getXML ());
			
			return __xxmlNode;
		}
		
//------------------------------------------------------------------------------------------
		public function getChildren ():XXMLList {
			var __xxmlList:XXMLList = new XXMLList ();
			
			__xxmlList.setupWithXMLList (m_xml.children ());
			
			return __xxmlList;
		}
		
//------------------------------------------------------------------------------------------
		public function addAttribute (__name:String, __value:String):void {
			m_xml.@[__name] = __value;
		}
		
//------------------------------------------------------------------------------------------
		public function getAttributes ():Object {
			var i:Number;
			var __xmlList:XMLList = m_xml.attributes ();
			var __attribs:Object = new Object ();
			
			for (i = 0; i<__xmlList.length (); i++) {
				var __key:String = __xmlList[i].name ();
				__attribs[__key] = m_xml.@[__key];
			}
			
			return __attribs;
		}

//------------------------------------------------------------------------------------------
		public function getText ():String {
			return m_xml.text ();
		}
			
//------------------------------------------------------------------------------------------
		public function toXMLString ():String {
			return m_xml.toXMLString ();
		}

//------------------------------------------------------------------------------------------
		public function getXML ():XML {
			return m_xml;
		}

//------------------------------------------------------------------------------------------
		private function __paramsToXMLString (__tag:String, __text:String, __attribs:Object):String {
			var __xmlString:String = "";
			
			__xmlString += "<" + __tag;
		
			for (var __prop:* in __attribs) {
				__xmlString += " " + __prop + "=\"" + __attribs[__prop] + "\"";
			}
			
			__xmlString += ">";
			
			__xmlString += __text;
			
			__xmlString += "</" + __tag + ">"
			
			return __xmlString;
		}
				
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}