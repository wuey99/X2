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
package kx.display {
	
	//------------------------------------------------------------------------------------------	
	public class DisplayObjectContainer5 {
		public var parent:DisplayObjectContainer5;
		
		public var m_children:Array; // <DisplayObjectContainer5>
		
		//------------------------------------------------------------------------------------------
		public function DisplayObjectContainer5 () {
			m_children = new Array (); // <DisplayObjectContainer5>
		}
	
		//------------------------------------------------------------------------------------------	
		public function setup ():void {
		}
		
		//------------------------------------------------------------------------------------------	
		public function cleanup ():void {
		}
		
		//------------------------------------------------------------------------------------------	
		public function addChild (__child:DisplayObjectContainer5):DisplayObjectContainer5 {
			if (__child.parent != null) {
				__child.parent.removeChild (__child);
			}
			
			__child.parent = this;
			
			m_children.push (__child);
			
			return __child;
		}
		
		//------------------------------------------------------------------------------------------		
		public function addChildAt (__child:DisplayObjectContainer5, __index:int):DisplayObjectContainer5 {
			if (__child.parent != null) {
				__child.parent.removeChild (__child);
			}
			
			__child.parent = this;
			
			m_children.splice (__index, 0, __child);
			
			return __child;
		}
		
		//------------------------------------------------------------------------------------------
		public function contains (__child:DisplayObjectContainer5):Boolean {
			return false;
		}
		
		//------------------------------------------------------------------------------------------	
		public function getChildAt (__index:int):DisplayObjectContainer5 {
			if (__index >= 0 && __index < m_children.length) {
				return m_children[__index];
			}
			else
			{
				return null;
			}
		}
		
		//------------------------------------------------------------------------------------------	
		public function getChildIndex (__child:DisplayObjectContainer5):int {
			return m_children.indexOf (__child);
		}
		
		//------------------------------------------------------------------------------------------	
		public function removeChild (__child:DisplayObjectContainer5):DisplayObjectContainer5 {
			return removeChildAt (m_children.indexOf (__child));
		}
		
		//------------------------------------------------------------------------------------------	
		public function removeChildAt (__index:int):DisplayObjectContainer5 {
			if (__index < 0 || __index >= m_children.length) {
				return null;
			}
			else
			{
				var __child:DisplayObjectContainer5 = m_children[__index];
				
				__child.cleanup ();
				
				__child.parent = null;
				
				m_children.splice (__index, 1);
			}
		}
		
		//------------------------------------------------------------------------------------------	
		public function setChildIndex (__child:DisplayObjectContainer5, __dstIndex:int):void {
			var __srcIndex:int = m_children.indexOf (__child);
			
			if (__srcIndex == -1) {
				return;
			}
			
			m_children.splice (__srcIndex, 1);
			
			if (__srcIndex < __dstIndex) {
				__dstIndex--;
			}
			
			m_children.splice (__dstIndex, 0, __child);
		}
		
		//------------------------------------------------------------------------------------------	
		/* @:get, set numChildren Int */
		
		public function get numChildren ():int {
			return m_children.length;
		}
		
		public function set numChildren (__val:int): /* @:set_type */ void {
			
			/* @:set_return 0; */			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------	
		/* @:get, set mouseChildren Bool */
		
		public function get mouseChildren ():Boolean {
			return false;
		}
		
		public function set mouseChildren (__val:Boolean): /* @:set_type */ void {
			
			/* @:set_return false; */			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		/* @:get, set mouseEnabled Bool */
		
		public function get mouseEnabled ():Boolean {
			return false;
		}
	
		public function set mouseEnabled (__val:Boolean): /* @:set_type */ void {
	
			/* @:set_return false; */			
		}
		/* @:end */
	
	//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------
}