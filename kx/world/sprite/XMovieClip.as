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
	
	import flash.display.Graphics;
	import flash.geom.*;
	import flash.utils.*;
	
	import kx.*;
	import kx.bitmap.*;
	import kx.pool.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.texture.*;
	import kx.type.*;
	import kx.world.*;
	import kx.world.sprite.*;
	
	//------------------------------------------------------------------------------------------	
	public class XMovieClip extends XSprite {
		public var m_bitmap:XBitmap;
		public var m_XApp:XApp;
		
		//------------------------------------------------------------------------------------------
		public function XMovieClip () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup ():void {
			super.setup ();
			
			m_bitmap = new XBitmap ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
			
			m_bitmap.cleanup ();		
		}

		//------------------------------------------------------------------------------------------
		public function initWithClassName (__xxx:XWorld, __XApp:XApp, __className:String):void {
			xxx = __xxx;
			m_XApp = __XApp;
		
			m_bitmap.setup ();
			m_bitmap.initWithClassName (__xxx, null, __className);
			m_bitmap.alpha = 1.0;
			m_bitmap.scaleX = m_bitmap.scaleY = 1.0;
			m_bitmap.x = -m_bitmap.dx;
			m_bitmap.y = -m_bitmap.dy;

			addChild (m_bitmap);
		}

		//------------------------------------------------------------------------------------------
		public function getXBitmapPoolManager ():XObjectPoolManager {
			return xxx != null ? xxx.getXBitmapPoolManager () : m_XApp.getXBitmapPoolManager ();			
		}
		
		//------------------------------------------------------------------------------------------
		public function getXTaskManager ():XTaskManager {
			return xxx != null ? xxx.getXTaskManager () : m_XApp.getXTaskManager ();			
		}
		
		//------------------------------------------------------------------------------------------
		public function getMovieClip ():XBitmap {
			return m_bitmap;
		}
			
		/* @:get, set movieclip XBitmap */
		
		public function get movieclip ():XBitmap {
			return m_bitmap;
		}
		
		public function set movieclip (__val:XBitmap): /* @:set_type */ void {
			m_bitmap = __val;
			
			/* @:set_return __val; */			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		public function gotoAndPlay (__frame:int):void {
			m_bitmap.gotoAndStop (__frame);
		}
		
		//------------------------------------------------------------------------------------------
		public function gotoAndStopAtLabel (__label:String):void {
			m_bitmap.gotoX (__label);
		}
		
		//------------------------------------------------------------------------------------------
		public function gotoAndStop (__frame:int):void {
			m_bitmap.gotoAndStop (__frame);
		}

		//------------------------------------------------------------------------------------------
		public function play ():void {
		}
		
		//------------------------------------------------------------------------------------------
		public function stop ():void {
		}
			
		//------------------------------------------------------------------------------------------
		/* @:get, set dx Float */
		
		public function get dx ():Number {
			return m_bitmap.dx;
		}
		
		public function set dx (__val:Number): /* @:set_type */ void {
			m_bitmap.dx = __val;
			
			/* @:set_return __val; */			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		/* @:get, set dy Float */
		
		public function get dy ():Number {
			return m_bitmap.dy;
		}
		
		public function set dy (__val:Number): /* @:set_type */ void {
			m_bitmap.dy = __val;
			
			/* @:set_return __val; */			
		}
		/* @:end */
				
		//------------------------------------------------------------------------------------------
	}
	
	//------------------------------------------------------------------------------------------
}
