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
	
	import x.*;
	import x.collections.*;
	import x.bitmap.*;
	import x.geom.*;
	import x.task.*;
	import x.world.*;
	import x.world.logic.XLogicObject;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------
// <HAXE>
/* --
-- */
// </HAXE>
// <AS3>
		CONFIG::flash
// </AS3>
			//------------------------------------------------------------------------------------------	
			public class XBitmap extends Bitmap implements XRegistration {
				public var m_bitmapDataAnimManager:XBitmapDataAnimManager;
				public var m_bitmapDataAnim:XBitmapDataAnim;
				public var m_className:String;
				public var m_bitmapNames:XDict; // <String, BitmapData>
				public var m_frame:int;
				public var m_scale:Number;
				public var m_visible:Boolean;
				public var m_pos:XPoint;
				public var m_rect:XRect;
				public var theParent:*;
				public var rp:XPoint;
				public static var g_XApp:XApp;
				
				//------------------------------------------------------------------------------------------
				include "..\\Sprite\\XRegistration_impl.h";
				
				//------------------------------------------------------------------------------------------
				public function XBitmap () {
					super ();
				}
				
				//------------------------------------------------------------------------------------------
				public function setup ():void {
					m_pos = g_XApp.getXPointPoolManager ().borrowObject () as XPoint;
					m_rect = g_XApp.getXRectPoolManager ().borrowObject () as XRect;
					rp = g_XApp.getXPointPoolManager ().borrowObject () as XPoint;
					
					setRegistration ();
					
					m_scale = 1.0;
					m_visible = true;
					
					m_bitmapNames = new XDict (); // <String, BitmapData>
					
					m_bitmapDataAnimManager = null;
				}
				
				//------------------------------------------------------------------------------------------
				public function cleanup ():void {
					g_XApp.getXPointPoolManager ().returnObject (m_pos);
					g_XApp.getXPointPoolManager ().returnObject (m_rect);
					g_XApp.getXPointPoolManager ().returnObject (rp);	
					
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
				public function initWithClassName (__xxx:XWorld, __XApp:XApp, __className:String):void {
					m_bitmapDataAnimManager =
						__xxx != null ? __xxx.getBitmapDataAnimManager () : __XApp.getBitmapDataAnimManager ();
					
					m_className = __className;
					
					m_bitmapDataAnim = m_bitmapDataAnimManager.add (__className);
					
					if (m_bitmapDataAnim != null) {
						__goto (1);
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
					/*
					if (__name in m_bitmapNames) {
						m_bitmapNames[__name].dispose ();
						
						delete m_bitmapNames[__name];
					}
					*/
					
					if (m_bitmapNames.exists (__name)) {
						var __bitmapData:BitmapData = m_bitmapNames.get (__name);
						__bitmapData.dispose ();
						
						m_bitmapNames.remove (__name);
					}
				}
				
				//------------------------------------------------------------------------------------------
				public function nameInBitmapNames (__name:String):Boolean {
//					return __name in m_bitmapNames;
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
//					return m_bitmapNames[__name];
					return m_bitmapNames.get (__name);
				}
				
				//------------------------------------------------------------------------------------------
				public function gotoAndStop (__frame:int):void {
					__goto (__frame);
				}
				
				//------------------------------------------------------------------------------------------
				private function __goto (__frame:int):void {
					m_frame = __frame-1;
					
					if (m_bitmapDataAnim != null) {
						bitmapData = m_bitmapDataAnim.getBitmap (m_frame);
					}
				}
				
				//------------------------------------------------------------------------------------------
				public function createBitmap (__name:String, __width:int, __height:int):void {
					var __bitmap:BitmapData = new BitmapData (__width, __height);
					
//					m_bitmapNames[__name] = __bitmap;
					m_bitmapNames.set (__name, __bitmap);
					
					gotoX (__name);
				}
				
				//------------------------------------------------------------------------------------------
				public function gotoX (__name:String):void {
//					bitmapData = m_bitmapNames[__name];
					bitmapData = m_bitmapNames.get (__name);
				}
				
				//------------------------------------------------------------------------------------------
				/* @:get, set dx Float */
				
				public function get dx ():Number {
					if (m_bitmapDataAnim != null) {
						return m_bitmapDataAnim.dx;
					}
					else
					{
						return 0;
					}
				}
				
				public function set dx (__val:Number): /* @:set_type */ void {
					/* @:set_return 0; */			
				}
				/* @:end */
				
				//------------------------------------------------------------------------------------------
				/* @:get, set dy Float */
				
				public function get dy ():Number {
					if (m_bitmapDataAnim != null) {
						return m_bitmapDataAnim.dy;
					}
					else
					{
						return 0;
					}
				}
				
				public function set dy (__val:Number): /* @:set_type */ void {
					/* @:set_return 0; */			
				}
				/* @:end */
				
				//------------------------------------------------------------------------------------------
				public function viewPort (__canvasWidth:Number, __canvasHeight:Number):XRect {
					m_rect.x = -x/m_scale;
					m_rect.y = -y/m_scale;
					m_rect.width = __canvasWidth/m_scale;
					m_rect.height = __canvasHeight/m_scale;
					
					return m_rect;
				}
				
				//------------------------------------------------------------------------------------------
				public function getPos ():XPoint {
					m_pos.x = x2;
					m_pos.y = y2;
					
					return m_pos;
				}
				
				//------------------------------------------------------------------------------------------		
				public function setPos (__p:XPoint):void {
					x2 = __p.x;
					y2 = __p.y;
				}
				
				//------------------------------------------------------------------------------------------
				public function setScale (__scale:Number):void {
					m_scale = __scale;
					
					scaleX2 = __scale;
					scaleY2 = __scale;
				}
				
				//------------------------------------------------------------------------------------------
				public function getScale ():Number {
					return m_scale;
				}
				
				//------------------------------------------------------------------------------------------
				/* @:get, set visible2 Bool */
				
				public function get visible2 ():Boolean {
					return m_visible;
				}
				
				public function set visible2 (__visible:Boolean): /* @:set_type */ void {
					m_visible = __visible;
					
					/* @:set_return true; */	
				}
				
				//------------------------------------------------------------------------------------------	
			}
		
		//------------------------------------------------------------------------------------------			
// <HAXE>
/* --
-- */
// </HAXE>
			
// <AS3>
			//------------------------------------------------------------------------------------------	
			CONFIG::starling
				
			//------------------------------------------------------------------------------------------	
			public class XBitmap extends XMovieClip {
				
				//------------------------------------------------------------------------------------------
				public function XBitmap () {
					super ();
				}
				
				//------------------------------------------------------------------------------------------
				public override function setup ():void {
					super.setup ();
				}
				
				//------------------------------------------------------------------------------------------
				public override function cleanup ():void {
					super.cleanup ();
				}
				
				//------------------------------------------------------------------------------------------
				public static function setXApp (__XApp:XApp):void {
				}
				
				//------------------------------------------------------------------------------------------
				public function disposeBitmapByName (__name:String):void {
				}
				
				//------------------------------------------------------------------------------------------
				public function nameInBitmapNames (__name:String):Boolean {
					return false;
				}		
				
				//------------------------------------------------------------------------------------------
				public function getNumBitmaps ():int {
					return 0;
				}
				
				//------------------------------------------------------------------------------------------
				public function getBitmapDataAnim ():XBitmapDataAnim {
					return null;
				}
				
				//------------------------------------------------------------------------------------------
				public function getBitmap (__frame:int):* {
					return null;
				}		
				
				//------------------------------------------------------------------------------------------
				public function getBitmapByName (__name:String):* {
					return null;
				}

				//------------------------------------------------------------------------------------------
				/* @:get, set bitmapData BitmapData */
				
				public function get bitmapData ():BitmapData {
					return null;
				}
				
				public function set bitmapData (__val:BitmapData): /* @:set_type */ void {
				}
				
				//------------------------------------------------------------------------------------------
				private function __goto (__frame:int):void {
					gotoAndStop (__frame);
				}
				
				//------------------------------------------------------------------------------------------
				public function createBitmap (__name:String, __width:Number, __height:Number):void {
				}
				
				//------------------------------------------------------------------------------------------
				public function gotoX (__name:String):void {
				}
				
			//------------------------------------------------------------------------------------------	
			}	
// </AS3>
			
//------------------------------------------------------------------------------------------
}