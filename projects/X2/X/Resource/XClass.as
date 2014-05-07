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
package X.Resource {

//------------------------------------------------------------------------------------------	
	public class XClass extends Object {
		private var m_class:Class = null;
		private var m_className:String;
		private var m_resourcePath:String;
		private var m_resourceXML:XML;
		private var m_count:Number;

//------------------------------------------------------------------------------------------
		public function XClass (__className:String, __resourcePath:String, __resourceXML:XML) {
			m_className = __className;
			m_resourcePath = __resourcePath;
			m_resourceXML = __resourceXML;
			m_count = 0;
		}

//------------------------------------------------------------------------------------------
		public function getClassName ():String {
			return m_className;
		}

//------------------------------------------------------------------------------------------
		public function getResourcePath ():String {
			return m_resourcePath;
		}

//------------------------------------------------------------------------------------------
		public function getResourceXML ():XML {
			return m_resourceXML;
		}
				
//------------------------------------------------------------------------------------------
		public function setClass (__class:Class):void {
			m_class = __class;
		}
		
//------------------------------------------------------------------------------------------	
		public function getClass ():Class {
			return m_class;
		}

//------------------------------------------------------------------------------------------
		public function get count ():Number {
			return m_count;
		}
		
		public function set count (__value:Number):void {
			m_count = __value;
		}
		
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------
}