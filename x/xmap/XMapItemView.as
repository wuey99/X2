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
package x.xmap {

// X classes
	import x.*;
	import x.type.*;
	import x.world.*;
	import x.world.collision.*;
	import x.world.logic.*;
	import x.world.sprite.XDepthSprite;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;

//------------------------------------------------------------------------------------------
	public class XMapItemView extends XLogicObject {
		protected var m_sprite:MovieClip;
		protected var x_sprite:XDepthSprite;
		protected var m_frame:Number;
		
//------------------------------------------------------------------------------------------
		public function XMapItemView () {
		}

//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array /* <Dynamic> */):void {
			super.setup (__xxx, args);
			
			m_frame = args[1];
			
			__createSprites (args[0]);
		}

//------------------------------------------------------------------------------------------
// create sprite
//------------------------------------------------------------------------------------------
		protected function __createSprites (__spriteClassName:String):void {			
			m_sprite = XType.createInstance (xxx.getClass (__spriteClassName));
// !STARLING!
			if (CONFIG::flash) {
				x_sprite = addSprite (m_sprite);
			}
			
			if (m_frame) {
				gotoAndStop (m_frame);
			}
			else
			{
				gotoAndStop (1);
			}
		}

//------------------------------------------------------------------------------------------
		public function getTotalFrames ():int {
			return m_sprite.totalFrames;	
		}	
		
//------------------------------------------------------------------------------------------
		public override function gotoAndPlay (__frame:int):void {
			m_sprite.gotoAndPlay (__frame);
		}
		
//------------------------------------------------------------------------------------------
		public override function gotoAndStop (__frame:int):void {
			m_sprite.gotoAndStop (__frame);
		}
		
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
