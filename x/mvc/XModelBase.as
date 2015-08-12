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
package x.mvc {
	import x.signals.XSignal;
	import x.xml.*;
	
// flash classes
	import flash.events.*;

//------------------------------------------------------------------------------------------	
	public class XModelBase extends EventDispatcher {
		private var m_changedSignal:XSignal;
		
//------------------------------------------------------------------------------------------	
		public function XModelBase () {
			super ();
			
			m_changedSignal = new XSignal ();
		}

//------------------------------------------------------------------------------------------
		public function addChangedListener (__listener:Function):void {
			m_changedSignal.addListener (__listener);
		}
		
//------------------------------------------------------------------------------------------
		public function fireChangedSignal ():void {
			m_changedSignal.fireSignal ();
		}
		
//------------------------------------------------------------------------------------------
		public function serializeAll ():XSimpleXMLNode {
			return null;
		}
		
//------------------------------------------------------------------------------------------
		public function deserializeAll (__xml:XSimpleXMLNode):void {
		}
			
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}	