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
package X.XML {

//------------------------------------------------------------------------------------------
	public class XSimpleXMLNode extends Object {
		private var m_tag:String;
		private var m_attribs:Array;
		private var m_attribsMap:Array;
		private var m_text:String;
		private var m_children:Array;
		private var m_parent:XSimpleXMLNode;
		
//------------------------------------------------------------------------------------------
		public function XSimpleXMLNode () {
			super ();
			
			m_attribs = new Array ();
			m_attribsMap = new Array ();
			m_children = new Array ();
			m_parent = null;
		}

//------------------------------------------------------------------------------------------
		public function setupWithParams (__tag:String, __text:String, __attribs:Array):void {
			m_tag = __tag;
			m_text = __text;
			var i:Number;
			
			for (i=0; i<__attribs.length; i+=2) {
				m_attribs.push (__attribs[i+0]);
				m_attribsMap[__attribs[i+0]] = __attribs[i+1];
			}
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
			m_attribs = new Array ();
			m_attribsMap = new Array ();
			
			__xmlList = __xml.attributes ();
			
			for (i = 0; i<__xmlList.length (); i++) {
				var __key:String = __xmlList[i].name ();
				m_attribs.push (__key);
				m_attribsMap[__key] = __xml.@[__key];
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
		public function addChildWithParams (__tag:String, __text:String, __attribs:Array):XSimpleXMLNode {
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
			m_attribs.push (__name);
			m_attribsMap[__name] = __value;
		}	
		
//------------------------------------------------------------------------------------------
//		public function getAttributes ():Object {
//			return m_attribs;
//		}

//-----------------------------------------------------------------------------------------
		public function hasAttribute (__name:String):Boolean {
			return m_attribsMap[__name] == undefined ? false : true;
		}
		
//-----------------------------------------------------------------------------------------
		public function getAttribute (__name:String):* {
			return m_attribsMap[__name];
		}
		
//------------------------------------------------------------------------------------------
		public function getText ():String {
			return m_text;
		}
			
//------------------------------------------------------------------------------------------
		protected function __tab (__indent:Number):String {
			var i:Number;
			var tabs:String = "";
			
			for (i=0; i<__indent; i++) {
				tabs += "\t";
			}
			
			return tabs;
		}
		
//------------------------------------------------------------------------------------------
		public function toXMLString (__indent:Number = 0):String {
			var i:Number;
			
			var __string:String = "";
			
			__string += __tab (__indent) + "<" + m_tag;
					
			for (i = 0; i<m_attribs.length; i++) {
				var __key:String = m_attribs[i];	
				__string += " " + __key + "=" + "\"" + m_attribsMap[__key] + "\"";	
			}
			
			if (m_text != "" || m_children.length) {
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