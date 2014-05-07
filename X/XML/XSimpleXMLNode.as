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
package X.XML {

//------------------------------------------------------------------------------------------
	public class XSimpleXMLNode extends Object {
		private var m_tag:String;
		private var m_attribs:Array;
		private var m_attribsMap:Object;
		private var m_text:String;
		private var m_children:Array;
		private var m_parent:XSimpleXMLNode;
		
//------------------------------------------------------------------------------------------
		public function XSimpleXMLNode () {
			super ();
			
			m_attribs = new Array ();
			m_attribsMap = new Object ();
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
			m_attribsMap = new Object ();
			
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