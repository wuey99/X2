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
// For commercial use, you will need to provide additional credits.
// Please contact me @ wuey99[dot]gmail[dot]com for more details.
// <$end$/>
//------------------------------------------------------------------------------------------
package X.Utils {
			
	import X.XML.*;
	
//------------------------------------------------------------------------------------------
// this class maps a list of classNames to unique indexes
//------------------------------------------------------------------------------------------
	public class XClassNameToIndex  {
		private var m_classNamesStrings:Array;
		private var m_classNamesCounts:Array;
		private var m_freeClassNameIndexes:Array;
		
//------------------------------------------------------------------------------------------	
		public function XClassNameToIndex () {
			m_classNamesStrings = new Array ();
			m_classNamesCounts = new Array ();
			m_freeClassNameIndexes = new Array ();
		}	

//------------------------------------------------------------------------------------------
		public function setup ():void {
		}
	
//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}
		
//------------------------------------------------------------------------------------------
// given an index, find its className.
//------------------------------------------------------------------------------------------
		public function getClassNameFromIndex (__index:int):String {
			return m_classNamesStrings[__index];
		}

//------------------------------------------------------------------------------------------
// given a className assign a unique index to it.
//------------------------------------------------------------------------------------------
		public function getIndexFromClassName (__className:String):int {
			var index:int;
			
// look up the index associated with the className
			index = m_classNamesStrings.indexOf (__className);
			
// if no index can be found, create a new index
			if (index == -1) {
				
				// create a new className if there are no previously deleted ones
				if (m_freeClassNameIndexes.length == 0) {		
					m_classNamesStrings.push (__className);
					m_classNamesCounts.push (1);
					index = m_classNamesStrings.indexOf (__className);
				}
				// reclaim a previously deleted className's index
				else
				{	
					index = m_freeClassNameIndexes.pop ();
					m_classNamesStrings[index] = __className;	
					m_classNamesCounts[index]++;	
				}		
			}
			// increment the className's ref count
			else
			{		
				m_classNamesCounts[index]++;
			}
			
			return index;
		}

//------------------------------------------------------------------------------------------
// remove a className from the list
//
// classNames aren't physically removed from the list: the entry is cleared out and the index
// in the Array is made available for reuse.
//------------------------------------------------------------------------------------------
		public function removeIndexFromClassNames (__index:int):void {
			m_classNamesCounts[__index]--;
			
			if (m_classNamesCounts[__index] == 0) {
				m_classNamesStrings[__index] = "";
				
				m_freeClassNameIndexes.push (__index);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function getAllClassNames ():Array {
			var __classNames:Array = new Array ();
			var i:Number;
			
			for (i=0; i<m_classNamesStrings.length; i++) {
				if (m_classNamesStrings[i] != "") {
					__classNames.push (m_classNamesStrings[i]);
				}
			}
			
			return __classNames;
		}

//------------------------------------------------------------------------------------------
		public function getClassNameCount (__index:Number):Number {
			return m_classNamesCounts[__index];
		}
		
//------------------------------------------------------------------------------------------
		public function serialize ():XSimpleXMLNode {
			var __xml:XSimpleXMLNode = new XSimpleXMLNode ();
			
			__xml.setupWithParams ("classNames", "", []);
			
			var i:Number;
			
			for (i=0; i<m_classNamesStrings.length; i++) {
				var __attribs:Array = [
					"index",		i,
					"name",			m_classNamesStrings[i],
					"count",		m_classNamesCounts[i]					
				];
				
				var __className:XSimpleXMLNode = new XSimpleXMLNode ();
				
				__className.setupWithParams ("className", "", __attribs);
				
				__xml.addChildWithXMLNode (__className);
			}
			
			return __xml;
		}

//------------------------------------------------------------------------------------------
		public function deserialize (__xml:XSimpleXMLNode):void {
			m_classNamesStrings = new Array ();
			m_classNamesCounts = new Array ();
			m_freeClassNameIndexes = new Array ();
			
			trace (": XClassNameToIndex: deserialize: ");
			
			var __xmlList:Array = __xml.child ("classNames")[0].child ("className");
			
			var i:Number;
			var __name:String;
			var __count:Number;
			
			for (i=0; i<__xmlList.length; i++) {
				__name = __xmlList[i].getAttribute ("name");
				__count = __xmlList[i].getAttribute ("count");
				
				trace (": XClassNameToIndex: deserialize: ", __name, __count);
				
				m_classNamesStrings.push (__name);
				
// don't use the count because the rest of the deserialization code is going to add
// the items back to the XMap.
//				m_classNamesCounts.push (__count);
				m_classNamesCounts.push (0);
			}
			
			for (i=0; i<m_classNamesStrings.length; i++) {
				if (m_classNamesStrings[i] == "") {
					m_freeClassNameIndexes.push (i);
				}
			}
		}
		
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
