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
package X.XMap {
	
	// X classes
	import X.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	import X.XMap.*;
	
	// Flash classes
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------
	public class XMapItemXBitmapView extends XMapItemView {
		protected var m_bitmap:XBitmap;
		
		//------------------------------------------------------------------------------------------
		public function XMapItemXBitmapView () {
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
		}

		//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
			
			m_bitmap.cleanup ();
		}
		
		//------------------------------------------------------------------------------------------
		// create sprite
		//------------------------------------------------------------------------------------------
		protected override function __createSprites (__spriteClassName:String):void {			
			m_bitmap = new XBitmap ();
			m_bitmap.setup ();
			m_bitmap.initWithClassName (xxx, null, __spriteClassName);
// !STARLING!
			if (CONFIG::flash) {
				x_sprite = addSpriteAt (m_bitmap, m_bitmap.dx, m_bitmap.dy);
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
		public override function getTotalFrames ():Number {
			return m_bitmap.getNumBitmaps ();	
		}	
		
		//------------------------------------------------------------------------------------------
		public override function gotoAndStop (__frame:Number):void {
			m_bitmap.gotoAndStop (__frame);
		}
		
	//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
