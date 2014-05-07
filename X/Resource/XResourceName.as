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
package X.Resource {
	
//------------------------------------------------------------------------------------------	
	public class XResourceName extends Object {
		private var m_className:String;
		private var m_resourceName:String;
		private var m_manifestName:String
				
//------------------------------------------------------------------------------------------
// fullName examples:
//
// XLogicObject:XLogicObject  -  Resource Name, Class Name
// :XLogicObject:XLogicObject  -  Resource Name, Class Name
// Project:XLogicObject:XLogicObject  -   Manifest Name, Resource Name, Class Name
//------------------------------------------------------------------------------------------
		public function XResourceName (__fullName:String) {
			super ();
			
			var s:Array = __fullName.split (":");
			
			if (s.length == 1) {
				m_manifestName = "";
				m_resourceName = s[0];
				m_className = ""
			
				if (m_resourceName.charAt (0) != "$") {
					throw (Error ("className not valid: " + __fullName));					
				}
			}
			else if (s.length == 2) {
				m_manifestName = "";
				m_resourceName = s[0];
				m_className = s[1];
			}
			else if (s.length == 3) {
				m_manifestName = s[0];
				m_resourceName = s[1];
				m_className = s[2];
			}
			else
			{
				throw (Error ("className not valid: " + __fullName));				
			}
		}
		
//------------------------------------------------------------------------------------------
		public function get manifestName ():String {
			return m_manifestName;
		}
		
//------------------------------------------------------------------------------------------
		public function get resourceName ():String {
			return m_resourceName;
		}
		
//------------------------------------------------------------------------------------------
		public function get className ():String {
			return m_className;
		}
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}