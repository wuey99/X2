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
package x.world.sprite {

	import x.world.*;

	include "..\\..\\flash.h";
	import flash.geom.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------	
	public class XDepthSprite extends XSprite {
		public var m_depth:Number;
		public var m_depth2:Number;
		public var m_relativeDepthFlag:Boolean;
		public var m_sprite:DisplayObject;
		public var x_layer:XSpriteLayer;
		
//------------------------------------------------------------------------------------------
		public function XDepthSprite () {
			super ();
			
			clear ();
		}

//------------------------------------------------------------------------------------------
		public function clear ():void {
			while (numChildren) {
				if (CONFIG::starling) {
					removeChildAt (0, true);
				}
				else
				{
					removeChildAt (0);
				}
			}
		}
			
//------------------------------------------------------------------------------------------
		public function addSprite (
			__sprite:DisplayObject,
			__depth:Number,
			__layer:XSpriteLayer,
			__relative:Boolean = false
			):void {
				
			m_sprite = __sprite;
			x_layer = __layer;
			setDepth (__depth);
// !!!
			childList.addChild (__sprite);
			visible = false;
			relativeDepthFlag = __relative;
		}

//------------------------------------------------------------------------------------------
		public function replaceSprite (__sprite:DisplayObject):void {
			clear ();
			
			m_sprite = __sprite;
			
			childList.addChild (__sprite);
			
			visible = true;
		}
		
//------------------------------------------------------------------------------------------
		/* @:override get, set visible Bool */
		
		public override function get visible ():Boolean {
			return super.visible;
		}
		
		public override function set visible (__visible:Boolean): /* @:set_type */ void {
			super.visible = __visible;
			
			m_sprite.visible = __visible;
			
			/* @:set_return null; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------	
		public function setDepth (__depth:Number):void {
			m_depth = __depth;
			depth2 = __depth;
		}		
		
//------------------------------------------------------------------------------------------	
		public function getDepth ():Number {
			return m_depth;
		}
		
//------------------------------------------------------------------------------------------
		/* @:get, set depth Float */
		
		public function get depth ():Number {
			return m_depth;
		}
	
		public function set depth (__depth:Number): /* @:set_type */ void {
			m_depth = __depth;
			depth2 = __depth;
			
			/* @:set_return 0; */			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		public function getRelativeDepthFlag ():Boolean {
			return m_relativeDepthFlag;
		}
		
//------------------------------------------------------------------------------------------
		public function setRelativeDepthFlag (__relative:Boolean):void {
			m_relativeDepthFlag = __relative;
		}

//------------------------------------------------------------------------------------------
		/* @:get, set relativeDepthFlag Bool */
		
		public function get relativeDepthFlag ():Boolean {
			return m_relativeDepthFlag;
		}
		
		public function set relativeDepthFlag (__relative:Boolean): /* @:set_type */ void {
			m_relativeDepthFlag = __relative;
			
			/* @:set_return true; */			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		/* @:get, set depth2 Float */
		
		public function get depth2 ():Number {
			return m_depth2;
		}
		
		public function set depth2 (__depth:Number): /* @:set_type */ void {
			if (__depth != m_depth2) {
				m_depth2 = __depth;
				x_layer.forceSort = true;
			}
			
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
