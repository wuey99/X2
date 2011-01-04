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
// given as className assign a unique index to it.
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
			return m_classNamesStrings;
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
				
				trace (": ", __name);
				
				m_classNamesStrings.push (__name);
				m_classNamesCounts.push (__count);
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
