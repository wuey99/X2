//------------------------------------------------------------------------------------------
package X.XML {

//------------------------------------------------------------------------------------------
	public class XSimpleXMLNode extends Object {
		private var m_tag:String;
		private var m_attribs:Object;
		private var m_text:String;
		private var m_children:Array;
		
//------------------------------------------------------------------------------------------
		public function XSimpleXMLNode () {
			super ();
		}

//------------------------------------------------------------------------------------------
		public function setupWithParams (__tag:String, __text:String, __attribs:Object):void {
			m_tag = __tag;
			m_text = __text;
			m_attribs = __attribs;
			m_children = new Array ();
		}

//------------------------------------------------------------------------------------------
		public function setupWithXMLString (__xmlString:String):void {
			var __xml:XML = new XML (__xmlString);
			
			setupWithXML (__xml);													
		}

//------------------------------------------------------------------------------------------
		public function setupWithXML (__xml:XML):void {
			var i:Number;
			var __xmlList:XMLList;
			
//------------------------------------------------------------------------------------------
			m_tag = __xml.name ();
			m_text = __xml.text ();
	
//------------------------------------------------------------------------------------------
			m_attribs = new Object ();
			
			__xmlList = __xml.attributes ();
			for (i = 0; i<__xmlList.length (); i++) {
				var __key:String = __xmlList[i].name ();
				m_attribs[__key] = __xml.@[__key];
			}
		
//------------------------------------------------------------------------------------------	
			m_children = __getXMLChildren (__xml);
		}

//------------------------------------------------------------------------------------------
		private function __getXMLChildren (__xml:XML):Array {
			var i:Number;
			var __xmlList:XMLList;
			var __children:Array = new Array ();
				
//------------------------------------------------------------------------------------------
			__xmlList = __xml.children ();
			for (i=0; i<__xmlList.length (); i++) {
				var __xmlNode:XSimpleXMLNode = new XSimpleXMLNode ();
				__xmlNode.setupWithXML (__xml);
				__children.push (__xmlNode);	
			}

//------------------------------------------------------------------------------------------
			return __children;
		}
				
//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function addChildWithParams (__tag:String, __text:String, __attribs:Object):XSimpleXMLNode {
			var __xmlNode:XSimpleXMLNode = new XSimpleXMLNode ();
			__xmlNode.setupWithParams (__tag, __text, __attribs);
			
			m_children.push (__xmlNode);
			
			return __xmlNode;
		}

//------------------------------------------------------------------------------------------
		public function addChildWithXMLString (__xmlString:String):XSimpleXMLNode {
			var __xmlNode:XSimpleXMLNode = new XSimpleXMLNode ();
			__xmlNode.setupWithXMLString (__xmlString);
			
			m_children.push (__xmlNode);
			
			return __xmlNode;
		}

//------------------------------------------------------------------------------------------
		public function addChildWithXXMLNode (__xmlNode:XSimpleXMLNode):XSimpleXMLNode {
			m_children.push (__xmlNode);
			
			return __xmlNode;
		}
		
//------------------------------------------------------------------------------------------
		public function getChildren ():Array {
			return m_children;
		}

//------------------------------------------------------------------------------------------
		public function child (__tag:String):Array {
			if (__tag == "*") {
				return m_children;
			}
			
			var __list:Array = new Array ();
			
			var i:Number;
			
			for (i=0; i<m_children.length; i++) {
				if (m_children[i].tag == __tag) {
					__list.push (m_children[i]);
				}
			}
			
			return __list;
		}
		
//------------------------------------------------------------------------------------------
		public function get tag ():String {
			return m_tag;
		}
		
//------------------------------------------------------------------------------------------
		public function addAttribute (__name:String, __value:String):void {
			m_attribs[__name] = __value;
		}
		
//------------------------------------------------------------------------------------------
		public function getAttributes ():Object {
			return m_attribs;
		}

//------------------------------------------------------------------------------------------
		public function getText ():String {
			return m_text;
		}
			
//------------------------------------------------------------------------------------------
		private function __tab (__indent:Number):String {
			var i:Number;
			var tabs:String = "";
			
			for (i=0; i<__indent; i++) {
				tabs += "\t";
			}
			
			return tabs;
		}
		
//------------------------------------------------------------------------------------------
		public function toXMLString (__indent:Number = 0):String {
			var __string:String = "";
			
			__string += __tab (__indent) + "<" + m_tag;
			
			var __props:*;
			
			for (__props in m_attribs) {
				__string += " " + __props + "=" + "\"" + m_attribs[__props] + "\"";	
			}
			
			__string += ">\n";
			
			if (m_text != "") {
				__string += __tab (__indent) + m_text + "\n";
			}
			
			if (m_children.length != 0) {
				var i:Number;
				
				for (i=0; i<m_children.length; i++) {
					__string += __tab (__indent) + m_children[i].toXMLString (__indent+1);
				}
			}
			
			__string += __tab (__indent) + "</" + m_tag + ">\n"
			
			return __string;
		}

//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}