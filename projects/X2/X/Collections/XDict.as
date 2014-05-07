//------------------------------------------------------------------------------------------
// Copyright (C) 2014 Jimmy Huey
//
// Some Rights Reserved.
//
// The "X-Engine" is licensed under a Creative Commons
// Attribution-Share Alike 3.0 United States License.
// (CC BY-SA 3.0)
//
// You are free to:
//
//      SHARE - to copy, distribute, display and perform the work.
//      ADAPT - remix, transform build upon this material, even for commercial works.
//
//      The licensor cannot revoke these freedoms as long as you follow the license terms.
//
// Under the following terms:
//
//      ATTRIBUTION — 
//      You must give appropriate credit, provide a link to the license, and
//      indicate if changes were made.  You may do so in any reasonable manner,
//      but not in any way that suggests the licensor endorses you or your use.
//
//      SHARE-ALIKE -
//      If you remix, transform, or build upon the material, you must
//      distribute your contributions under the same license as the original.
//
// No additional restrictions — You may not apply legal terms or technological measures
// that legally restrict others from doing anything the license permits. 
//
// The full summary can be located at:
// http://creativecommons.org/licenses/by-sa/3.0/us/ 
//
// The human-readable summary of the Legal Code can be located at:
// http://creativecommons.org/licenses/by-sa/3.0/us/legalcode
//------------------------------------------------------------------------------------------
package X.Collections {
	
	import flash.utils.Dictionary;
	
//------------------------------------------------------------------------------------------
	public class XDict extends Object {
		private var m_dict:Dictionary;
		
//------------------------------------------------------------------------------------------
		public function XDict () {
			super ();
			
			m_dict = new Dictionary ();
		}

//------------------------------------------------------------------------------------------
		public function setup ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}

//------------------------------------------------------------------------------------------
		[Inline]
		public function exists (__key:*):Boolean {
			return __key in m_dict;
		}

//------------------------------------------------------------------------------------------
		[Inline]
		public function get (__key:*):* {
			return m_dict[__key];
		}
	
//------------------------------------------------------------------------------------------
		[Inline]
		public function put (__key:*, __value:*):void {
			m_dict[__key] = __value;
		}	
		
//------------------------------------------------------------------------------------------
		[Inline]
		public function remove (__key:*):void {
			delete m_dict[__key];
		}

//------------------------------------------------------------------------------------------
		public function removeAll ():void {
			var __key:*;
			
			for (__key in m_dict) {
				remove (__key);
			}
		}

//------------------------------------------------------------------------------------------
		public function dict ():Dictionary {
			return m_dict;
		}
		
//------------------------------------------------------------------------------------------
		public function length ():Number {
			return m_dict.length;
		}

//------------------------------------------------------------------------------------------
		public function forEach (__callback:Function):void {
			var __key:*;
			
			for (__key in m_dict) {
				__callback (__key);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function __hash (__key:Object):String {
			return "";
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}