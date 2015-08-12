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
package x.resource {
	
	import x.type.*;
	import x.xml.*;
	
//------------------------------------------------------------------------------------------	
	public class XResourceName extends Object {
		private var m_className:String;
		private var m_resourceName:String;
		private var m_manifestName:String;
				
//------------------------------------------------------------------------------------------
// fullName examples:
//
// XLogicObject:XLogicObject  -  Resource Name, Class Name
// :XLogicObject:XLogicObject  -  Resource Name, Class Name
// Project:XLogicObject:XLogicObject  -   Manifest Name, Resource Name, Class Name
//------------------------------------------------------------------------------------------
		public function XResourceName (__fullName:String) {
			super ();
			
			var s:Array /* <String> */ = __fullName.split (":");
			
			if (s.length == 1) {
				m_manifestName = "";
				m_resourceName = s[0];
				m_className = "";
			
				if (m_resourceName.charAt (0) != "$") {
					throw (XType.createError ("className not valid: " + __fullName));					
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
				throw (XType.createError ("className not valid: " + __fullName));				
			}
		}
		
//------------------------------------------------------------------------------------------
		/* @:get, set manifestName String */
		
		public function get manifestName ():String {
			return m_manifestName;
		}
		
		public function set manifestName (__value:String): /* @:set_type */ void {
			/* @:set_return ""; */			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		/* @:get, set resourceName String */
		
		public function get resourceName ():String {
			return m_resourceName;
		}
		
		public function set resourceName (__value:String): /* @:set_type */ void {
			/* @:set_return ""; */			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		/* @:get, set className String */
		
		public function get className ():String {
			return m_className;
		}
		
		public function set className (__value:String): /* @:set_type */ void {
			/* @:set_return ""; */			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}