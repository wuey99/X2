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
package kx.xml {

	import kx.collections.*;
	import kx.type.*;
	
//------------------------------------------------------------------------------------------
// http://try.haxe.org/#37419
//------------------------------------------------------------------------------------------
	public class XSimpleXMLNode extends Object {
		private var m_tag:String;
		private var m_attribsMap:XDict; // <String, Dynamic>
		private var m_text:String;
		private var m_children:Array; // <XSimpleXMLNode>
		private var m_parent:XSimpleXMLNode;
		
//------------------------------------------------------------------------------------------
		public function XSimpleXMLNode (__xmlString:String = null) {
			super ();
			
			m_attribsMap = new XDict (); // <String, Dynamic>
			m_children = new Array (); // <XSimpleXMLNode>
			m_parent = null;
			
			if (__xmlString != null) {
				setupWithXMLString (__xmlString);
			}
		}

//------------------------------------------------------------------------------------------
		public function setupWithParams (__tag:String, __text:String, __attribs:Array /* <Dynamic> */):void {
			m_tag = __tag;
			m_text = __text;
			
			var i:int = 0;
//			for (i=0; i<__attribs.length; i+=2) {
			while (i<__attribs.length) {
				m_attribsMap.set (__attribs[i+0], __attribs[i+1]);
				
				i += 2;
			}
		}
		
// <HAXE>
/* --
//------------------------------------------------------------------------------------------	
		public function setupWithXMLString (__xmlString:String):void {
			var __xml:Xml = Xml.parse (__xmlString);
		
			setupWithXML (__xml.firstElement ());													
		}
		
//------------------------------------------------------------------------------------------
		public function setupWithXML (__xml:Xml):void {
			m_tag = __xml.nodeName;
			m_text = "";
		
			if (__xml.firstChild () != null) {
				var __type:Xml.XmlType = __xml.firstChild ().nodeType;
			
				if (__type == Xml.Element || __type == Xml.Document) {
					m_text = "";
				}
				else
				{
					m_text = __xml.firstChild ().nodeValue;
				}
			}
		
//------------------------------------------------------------------------------------------
			m_attribsMap = new Map<String, Dynamic> ();

			for (__key in __xml.attributes ()) {	
				m_attribsMap.set (__key, __xml.get (__key));
			}
		
//------------------------------------------------------------------------------------------	
			m_children = __getXMLChildren (__xml);
		}
		
//------------------------------------------------------------------------------------------
		private function __getXMLChildren (__xml:Xml):Array<XSimpleXMLNode> {
			var __children:Array<XSimpleXMLNode> = new Array<XSimpleXMLNode> ();
			
			//------------------------------------------------------------------------------------------	
			for (__element in __xml.elements ()) {
				var __xmlNode:XSimpleXMLNode = new XSimpleXMLNode ();
				__xmlNode.setupWithXML (__element);
				__children.push (__xmlNode);	
			}
			
			//------------------------------------------------------------------------------------------
			return __children;
		}
-- */
// </HAXE>		
// <AS3>		
//------------------------------------------------------------------------------------------
		public function setupWithXMLString (__xmlString:String):void {
			var __xml:XML = new XML (__xmlString);
			
			setupWithXML (__xml);													
		}

//------------------------------------------------------------------------------------------
		public function setupWithXML (__xml:XML):void {
			var i:int;
			var __xmlList:XMLList;
			
//------------------------------------------------------------------------------------------
			m_tag = __xml.name ();
			m_text = __xml.text ();
	
//------------------------------------------------------------------------------------------
			m_attribsMap = new XDict (); // <String, Dynamic>
			
			__xmlList = __xml.attributes ();
			
			for (i = 0; i<__xmlList.length (); i++) {
				var __key:String = __xmlList[i].name ();
				
				m_attribsMap.set (__key, __xml.@[__key]);
			}
		
//------------------------------------------------------------------------------------------	
			m_children = __getXMLChildren (__xml);
		}

//------------------------------------------------------------------------------------------
		private function __getXMLChildren (__xml:XML):Array /* <XSimpleXMLNode> */ {
			var i:int;
			var __xmlList:XMLList;
			var __children:Array /* <XSimpleXMLNode> */ = new Array (); // <XSimpleXMLNode>
				
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
// </AS3>
	
//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function addChildWithParams (__tag:String, __text:String, __attribs:Array /* <Dynamic> */):XSimpleXMLNode {
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
		public function getChildren ():Array /* <XSimpleXMLNode> */ {
			return m_children;
		}
		
//------------------------------------------------------------------------------------------
		/* @:get, set tag String */
		
		public function get tag ():String {
			return m_tag;
		}
		
		public function set tag (__val:String): /* @:set_type */ void {
			m_tag = __val;
			
			/* @:set_return __val; */			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		public function addAttribute (__name:String, __val:*):void {
			m_attribsMap.set (__name, __val);
		}	
		
//------------------------------------------------------------------------------------------
//		public function getAttributes ():Object {
//			return m_attribs;
//		}

//-----------------------------------------------------------------------------------------
		public function hasAttribute (__name:String):Boolean {
			return m_attribsMap.exists (__name);
		}

//-----------------------------------------------------------------------------------------
		public function attribute (__name:String):* {
			return m_attribsMap.get (__name);
		}
		
//-----------------------------------------------------------------------------------------
		public function getAttribute (__name:String):* {
			return m_attribsMap.get (__name);
		}
		
//-----------------------------------------------------------------------------------------
		public function getAttributeFloat (__name:String):Number {
			return /* @:cast */ XType.parseFloat_ (m_attribsMap.get (__name));
		}

//-----------------------------------------------------------------------------------------
		public function getAttributeInt (__name:String):int {
			return /* @:cast */ XType.parseInt (m_attribsMap.get (__name));
		}
		
//-----------------------------------------------------------------------------------------
		public function getAttributeString (__name:String):String {
			return /* @:cast */ m_attribsMap.get (__name);
		}
		
//-----------------------------------------------------------------------------------------
		public function getAttributeBoolean (__name:String):Boolean {
			var __boolean:String = getAttributeString (__name);
			
			if (__boolean == "true" || __boolean == "1") {
				return true;
			}
			else
			{
				return false;
			}
		}		
		
//------------------------------------------------------------------------------------------
		public function getText ():String {
			return m_text;
		}
			
//------------------------------------------------------------------------------------------
		public function getTextTrim ():String {
			return XType.trim (m_text);
		}
		
//------------------------------------------------------------------------------------------
		protected function __tab (__indent:int):String {
			var i:int;
			var tabs:String = "";
			
			for (i=0; i<__indent; i++) {
				tabs += "\t";
			}
			
			return tabs;
		}
		
//------------------------------------------------------------------------------------------
		public function toXMLString (__indent:int = 0):String {
			var i:int;
			
			var __string:String = "";
			
			__string += __tab (__indent) + "<" + m_tag;
					
			m_attribsMap.forEach (
				function (x:*):void {
					var __key:String = x as String;
					__string += " " + __key + "=" + "\"" + m_attribsMap.get (__key) + "\"";	
				}
			);
			
			if (m_text != "" || m_children.length != 0) {
				__string += ">\n";
				
				if (m_text != "") {
					__string += __tab (__indent+1) + m_text + "\n";
				}
				
				if (m_children.length != 0) {	
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
		public function toXMLStringEscaped (__indent:int = 0):String {
			var i:int;
			
			var __string:String = "";
			
			__string += __tab (__indent) + "\"<" + m_tag;
			
			m_attribsMap.forEach (
				function (x:*):void {
					var __key:String = x as String;
					__string += " " + __key + "=" + "\\\"" + m_attribsMap.get (__key) + "\\\"";	
				}
			);
			
			if (m_text != "" || m_children.length != 0) {
				__string += ">\" +\n";
				
				if (m_text != "") {
					__string += __tab (__indent+1) + m_text + "\n";
				}
				
				if (m_children.length != 0) {	
					for (i=0; i<m_children.length; i++) {
						__string += m_children[i].toXMLStringEscaped (__indent+1);
					}
				}
				
				__string += __tab (__indent) + "\"</" + m_tag + ">\" +\n";
			}
			else
			{
				__string += "/>\" +\n";
			}
			
			return __string ;
		}
		
		//------------------------------------------------------------------------------------------
		public function toXMLStringBlob (__indent:int = 0):String {
			var i:int;
			
			var __string:String = "";
			
			__string += "<" + m_tag;
			
			m_attribsMap.forEach (
				function (x:*):void {
					var __key:String = x as String;
					__string += " " + __key + "=" + "\\\"" + m_attribsMap.get (__key) + "\\\"";	
				}
			);
			
			if (m_text != "" || m_children.length != 0) {
				__string += ">";
				
				if (m_text != "") {
					__string + m_text;
				}
				
				if (m_children.length != 0) {	
					for (i=0; i<m_children.length; i++) {
						__string += m_children[i].toXMLStringBlob(__indent+1);
					}
				}
				
				__string += "</" + m_tag + ">";
			}
			else
			{
				__string += "/>";
			}
			
			return __string ;
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
		public function appendChild (__src:XSimpleXMLNode):void {
		}
		
//------------------------------------------------------------------------------------------
		public function child (__tag:String):Array /* <XSimpleXMLNode> */ {
			if (__tag == "*") {
				return m_children;
			}
			
			var __list:Array /* <XSimpleXMLNode> */ = new Array (); // <XSimpleXMLNode>
			
			var i:int;
			
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