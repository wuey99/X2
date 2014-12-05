//------------------------------------------------------------------------------------------
// <$begin$/>
// The MIT License (MIT)
// 
// Copyright (c) 2014 Jimmy Huey
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

	import X.Resource.Manager.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.system.*;
	
//------------------------------------------------------------------------------------------	
	public class XResource extends Object {
		protected var m_resourcePath:String;
		protected var m_resourceXML:XML;
		protected var m_count:Number;

//------------------------------------------------------------------------------------------
		public function XResource () {
			m_count = 0;
		}
		
//------------------------------------------------------------------------------------------
		public function setup (
			__resourcePath:String, __resourceXML:XML,
			__parent:Sprite,
			__resourceManager:XSubResourceManager
			):void {
		}
			
//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}
		
//------------------------------------------------------------------------------------------		
		public function loadResource ():void {		
		}
		
//------------------------------------------------------------------------------------------
		public function kill ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function get count ():Number {
			return m_count;
		}
		
		public function set count (__value:Number):void {
			m_count = __value;
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
		public function getAllClassNames ():Array {
			var __xmlList:XMLList = m_resourceXML.child ("*");
			var i:Number;
			var __classNames:Array = new Array ();
						
			for (i=0; i<__xmlList.length (); i++) {
				__classNames.push (__xmlList[i].@name);	
			}
			
			return __classNames;
		}
		
//------------------------------------------------------------------------------------------
		public function getClassByName (__className:String):Class {
			return null;
		}
		
//------------------------------------------------------------------------------------------
		public function getAllClasses ():Array {
			return null;
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}