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
	
	import kx.*;
	import kx.collections.*;
	import kx.bitmap.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.logic.XLogicObject;
	
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------	
	public class XBitmap extends XSplat {
		public static var g_XApp:XApp;
		
		public var m_bitmapDataAnimManager:XBitmapDataAnimManager;
		public var m_bitmapDataAnim:XBitmapDataAnim;
		public var m_bitmapNames:XDict; // <String, BitmapData>
		public var bitmap:Bitmap;
		
		//------------------------------------------------------------------------------------------
		public function XBitmap () {
			super ();
			
			bitmap = new Bitmap ();
			addChild (bitmap);
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup ():void {
			super.setup ();
			
			m_bitmapNames = new XDict (); // <String, BitmapData>
			
			m_bitmapDataAnimManager = null;
		}
		
		//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
				
			alpha = 1.0;
			visible = true;
			visible2 = true;
			scaleX = scaleY = 1.0;
		
			if (m_bitmapDataAnimManager != null) {
				m_bitmapDataAnimManager.remove (m_className);
			}
			
			m_bitmapNames.forEach (
				function (x:*):void {
					var __name:String = x as String;
					
					var __bitmapData:BitmapData = m_bitmapNames.get (__name);
					__bitmapData.dispose ();
					
					m_bitmapNames.remove (__name);
				}
			);
		}
		
		//------------------------------------------------------------------------------------------
		public static function setXApp (__XApp:XApp):void {
			g_XApp = __XApp;
		}
		
		//------------------------------------------------------------------------------------------
		public override function initWithClassName (__xxx:XWorld, __XApp:XApp, __className:String):void {
			m_bitmapDataAnimManager =
				__xxx != null ? __xxx.getBitmapDataAnimManager () : __XApp.getBitmapDataAnimManager ();
			
			m_className = __className;
			
			m_bitmapDataAnim = m_bitmapDataAnimManager.add (__className);
			
			if (m_bitmapDataAnim != null) {
				goto (1);
			}
			else
			{
				m_bitmapDataAnimManager.getXTaskManager ().addTask ([
					XTask.LABEL, "loop",
						XTask.WAIT, 0x0100,
						
						XTask.FLAGS, function (__task:XTask):void {
							__task.ifTrue (m_bitmapDataAnimManager.isQueued (__className));
						}, XTask.BEQ, "loop",
						
						function ():void {
							m_bitmapDataAnim = m_bitmapDataAnimManager.get (__className);
						},
					
					XTask.RETN,
				]);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function disposeBitmapByName (__name:String):void {
			if (m_bitmapNames.exists (__name)) {
				var __bitmapData:BitmapData = m_bitmapNames.get (__name);
				__bitmapData.dispose ();
				
				m_bitmapNames.remove (__name);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function nameInBitmapNames (__name:String):Boolean {
			return m_bitmapNames.exists (__name);
		}		
		
		//------------------------------------------------------------------------------------------
		public function getNumBitmaps ():int {
			if (m_bitmapDataAnim != null) {
				return m_bitmapDataAnim.getNumBitmaps ();
			}
			else
			{
				return 0;
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function getTotalFrames ():int {
			return getNumBitmaps ();
		}
		
		//------------------------------------------------------------------------------------------
		public function getBitmapDataAnim ():XBitmapDataAnim {
			return m_bitmapDataAnim;
		}
		
		//------------------------------------------------------------------------------------------
		public function getBitmap (__frame:int):BitmapData {
			if (m_bitmapDataAnim != null) {
				return m_bitmapDataAnim.getBitmap (__frame);
			}
			else
			{
				return null;
			}	
		}		
		
		//------------------------------------------------------------------------------------------
		public function getBitmapByName (__name:String):BitmapData {
			return m_bitmapNames.get (__name);
		}
		
		//------------------------------------------------------------------------------------------
		public function createBitmap (__name:String, __width:int, __height:int):void {
			var __bitmap:BitmapData = new BitmapData (__width, __height);
			
			m_bitmapNames.set (__name, __bitmap);
			
			gotoX (__name);
		}
		
		//------------------------------------------------------------------------------------------
		public override function gotoAndStop (__frame:int):void {
			goto (__frame);
		}
		
		//------------------------------------------------------------------------------------------
		public override function goto (__frame:int):void {
			m_frame = __frame-1;
			
			if (m_bitmapDataAnim != null) {
				bitmap.bitmapData = m_bitmapDataAnim.getBitmap (m_frame);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function gotoX (__name:String):void {
			bitmap.bitmapData = m_bitmapNames.get (__name);
		}
		
		//------------------------------------------------------------------------------------------
		/* @:override get, set dx Float */
		
		public override function get dx ():Number {
			if (m_bitmapDataAnim != null) {
				return m_bitmapDataAnim.dx;
			}
			else
			{
				return 0;
			}
		}
		
		public override function set dx (__val:Number): /* @:set_type */ void {
			/* @:set_return 0; */			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		/* @:override get, set dy Float */
		
		public override function get dy ():Number {
			if (m_bitmapDataAnim != null) {
				return m_bitmapDataAnim.dy;
			}
			else
			{
				return 0;
			}
		}
		
		public override function set dy (__val:Number): /* @:set_type */ void {
			/* @:set_return 0; */			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------	
	}
					
//------------------------------------------------------------------------------------------
}