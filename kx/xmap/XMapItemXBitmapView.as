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
package kx.xmap {
	
	// X classes
	import kx.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.xmap.*;
	
	// Flash classes
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------
	public class XMapItemXBitmapView extends XMapItemView {
		protected var m_bitmap:XMovieClip;
		
		//------------------------------------------------------------------------------------------
		public function XMapItemXBitmapView () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array /* <Dynamic> */):void {
			super.setup (__xxx, args);
		}

		//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
		}
		
		//------------------------------------------------------------------------------------------
		// create sprite
		//------------------------------------------------------------------------------------------
		protected override function __createSprites (__spriteClassName:String):void {		
			m_sprite = createXMovieClip (__spriteClassName);
			x_sprite = addSpriteAt (m_bitmap, m_bitmap.dx, m_bitmap.dy);
			
			if (m_frame != 0) {
				gotoAndStop (m_frame);
			}
			else
			{
				gotoAndStop (1);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function getTotalFrames ():int {
			return m_bitmap.getTotalFrames ();	
		}	
		
		//------------------------------------------------------------------------------------------
		public override function gotoAndStop (__frame:int):void {
			m_bitmap.gotoAndStop (__frame);
		}
		
	//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
