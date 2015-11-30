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
package kx.world.sprite {

// X classes
	import kx.world.*;
	
// flash classes
	include "..\\..\\flash.h";
	
//------------------------------------------------------------------------------------------
	public class XSprite0 extends Sprite {
		public var m_xxx:XWorld;
				
//------------------------------------------------------------------------------------------
		public function XSprite0 () {
			super ();
			
			if (CONFIG::starling) {
			}
			else
			{
				mouseEnabled = false;
			}
		}
		
//------------------------------------------------------------------------------------------
		/* @:get, set xxx XWorld */
		
		public function get xxx ():XWorld {
			return m_xxx;
		}
		
		public function set xxx (__XWorld:XWorld): /* @:set_type */ void {
			m_xxx = __XWorld;
			
			/* @:set_return m_xxx; */			
		}
		/* @:end */
		
//-----------------------------------------------------------------------------------------
		/* @:get, set childList Sprite */
	
		public function get childList ():Sprite {
			return this;
		}
		
		public function set childList (__val:Sprite): /* @:set_type */ void {
			
			/* @:set_return null; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
// <HAXE>
/* --
-- */
// </HAXE>
// <AS3>
		if (CONFIG::starling) {

			//------------------------------------------------------------------------------------------
			/* @:override get, set rotation Float */
			
			public override function get rotation ():Number {
				return super.rotation * 180/Math.PI;
			}
			
			public override function set rotation (__val:Number): /* @:set_type */ void {
				super.rotation = __val * Math.PI/180;
				
				/* @:set_return __val; */			
			}
			/* @:end */
			
			//------------------------------------------------------------------------------------------
			/* @:get, set mouseX Float */
			
			public function get mouseX ():Number {
				return 0;
			}
			
			public function set mouseX (__val:Number): /* @:set_type */ void {
				/* @:set_return 0; */			
			}
			/* @:end */
			
			//------------------------------------------------------------------------------------------
			/* @:get, set mouseY Float */
			
			public function get mouseY ():Number {
				return 0;
			}
			
			public function set mouseY (__val:Number): /* @:set_type */ void {
				/* @:set_return 0; */			
			}
			/* @:end */
			
			//------------------------------------------------------------------------------------------
			/* @:get, set mouseEnabled Bool */
			
			public function get mouseEnabled ():Boolean {
				return true;
			}
			
			public function set mouseEnabled (__val:Boolean): /* @:set_type */ void {
				/* @:set_return true; */			
			}
			/* @:end */
		
			//------------------------------------------------------------------------------------------
			/* @:get, set mouseChildren Bool */
			
			public function get mouseChildren ():Boolean {
				return true;
			}
			
			public function set mouseChildren (__val:Boolean): /* @:set_type */ void {
				/* @:set_return true; */			
			}
			/* @:end */
		}
// </AS3>
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}
