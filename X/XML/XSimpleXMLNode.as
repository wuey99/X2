//------------------------------------------------------------------------------------------
package X.XML {

//------------------------------------------------------------------------------------------
	public class XSimpleXMLNode extends Object {
		private var m_tag:String;
		private var m_attribs:Object;
		private var m_text:String;
		private var m_children:Array;
		private var m_parent:XSimpleXMLNode;
		
//------------------------------------------------------------------------------------------
		public function XSimpleXMLNode () {
			super ();
			
			m_children = new Array ();
			m_parent = null;
		}

//------------------------------------------------------------------------------------------
		public function setupWithParams (__tag:String, __text:String, __attribs:Object):void {
			m_tag = __tag;
			m_text = __text;
			m_attribs = __attribs;
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
				__xmlNode.setupWithXML (__xmlList[i]);
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
			
			__xmlNode.setParent (this);
			
			m_children.push (__xmlNode);
			
			return __xmlNode;
		}

//------------------------------------------------------------------------------------------
		public function addChildWithXMLString (__xmlString:String):XSimpleXMLNode {
			var __xmlNode:XSimpleXMLNode = new XSimpleXMLNode ();
			__xmlNode.setupWithXMLString (__xmlString);
		
			__xmlNode.setParent (this);
			
			m_children.push (__xmlNode);
			
			return __xmlNode;
		}

//------------------------------------------------------------------------------------------
		public function addChildWithXMLNode (__xmlNode:XSimpleXMLNode):XSimpleXMLNode {
			__xmlNode.setParent (this);
			
			m_children.push (__xmlNode);
			
			return __xmlNode;
		}

//------------------------------------------------------------------------------------------
		public function removeChild (__xmlNode:XSimpleXMLNode):void {
		}
		
//------------------------------------------------------------------------------------------
		public function getChildren ():Array {
			return m_children;
		}
		
//------------------------------------------------------------------------------------------
		public function get tag ():String {
			return m_tag;
		}
		
//------------------------------------------------------------------------------------------
		public function addAttribute (__name:String, __value:*):void {
			m_attribs[__name] = __value;
		}	
		
//------------------------------------------------------------------------------------------
		public function getAttributes ():Object {
			return m_attribs;
		}

//-----------------------------------------------------------------------------------------
		public function getAttribute (__name:String):* {
			return m_attribs[__name];
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
			
			if (m_text != "" || m_children.length) {
				__string += ">\n";
				
				if (m_text != "") {
					__string += __tab (__indent) + m_text + "\n";
				}
				
				if (m_children.length != 0) {
					var i:Number;
					
					for (i=0; i<m_children.length; i++) {
						__string += m_children[i].toXMLString (__indent+1);
					}
				}
				
				__string += __tab (__indent) + "</" + m_tag + ">\n";
			}
			else
			{
				__string += "/>\n";
			}
			
			return __string;
		}

//------------------------------------------------------------------------------------------
		public function parent ():XSimpleXMLNode {
			return m_parent;
		}

//------------------------------------------------------------------------------------------
		public function setParent (__parent:XSimpleXMLNode):void {
			m_parent = __parent;
		}

//------------------------------------------------------------------------------------------
		public function localName ():String {
			return m_tag;
		}

//------------------------------------------------------------------------------------------
		public function insertChildAfter (__dst:XSimpleXMLNode, __src:XSimpleXMLNode):void {
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
	}
	
//------------------------------------------------------------------------------------------
}