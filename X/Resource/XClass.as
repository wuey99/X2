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
package X.Resource {

//------------------------------------------------------------------------------------------	
	public class XClass extends Object {
		private var m_class:Class /* <Dynamic> */ = null;
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
		public function setClass (__class:Class /* <Dynamic> */):void {
			m_class = __class;
		}
		
//------------------------------------------------------------------------------------------	
		public function getClass ():Class /* <Dynamic> */ {
			return m_class;
		}

//------------------------------------------------------------------------------------------
		/* @:get, set count Float */
		
		public function get count ():Number {
			return m_count;
		}
		
		public function set count (__value:Number): /* @:set_type */ void {
			m_count = __value;
			
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------
}