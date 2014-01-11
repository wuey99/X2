//------------------------------------------------------------------------------------------	
package X.World.Sprite {
	
	import X.*;
	import X.Bitmap.*;
	import X.Geom.*;
	import X.Task.*;
	import X.World.*;
	import X.World.Logic.XLogicObject;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.utils.*;
	
		//------------------------------------------------------------------------------------------
		CONFIG::flash
			//------------------------------------------------------------------------------------------	
			public class XBitmap extends Bitmap implements XRegistration {
				public var m_bitmapDataAnimManager:XBitmapDataAnimManager;
				public var m_bitmapDataAnim:XBitmapDataAnim;
				public var m_className:String;
				public var m_bitmapNames:Object;
				public var m_frame:Number;
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
					
					m_bitmapNames = new Object ();
					
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
					
					var i:Number;
					
					var __name:String;
					
					for (__name in m_bitmapNames) {
						m_bitmapNames[__name].dispose ();
						
						delete m_bitmapNames[__name];
					}
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
					
					if (m_bitmapDataAnim) {
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
					if (__name in m_bitmapNames) {
						m_bitmapNames[__name].dispose ();
						
						delete m_bitmapNames[__name];
					}
				}
				
				//------------------------------------------------------------------------------------------
				public function nameInBitmapNames (__name:String):Boolean {
					return __name in m_bitmapNames;
				}		
				
				//------------------------------------------------------------------------------------------
				public function getNumBitmaps ():Number {
					if (m_bitmapDataAnim) {
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
				public function getBitmap (__frame:Number):BitmapData {
					if (m_bitmapDataAnim) {
						return m_bitmapDataAnim.getBitmap (__frame);
					}
					else
					{
						return null;
					}	
				}		
				
				//------------------------------------------------------------------------------------------
				public function getBitmapByName (__name:String):BitmapData {
					return m_bitmapNames[__name];
				}
				
				//------------------------------------------------------------------------------------------
				public function gotoAndStop (__frame:Number):void {
					goto (__frame);
				}
				
				//------------------------------------------------------------------------------------------
				public function goto (__frame:Number):void {
					m_frame = __frame-1;
					
					if (m_bitmapDataAnim) {
						bitmapData = m_bitmapDataAnim.getBitmap (m_frame);
					}
				}
				
				//------------------------------------------------------------------------------------------
				public function createBitmap (__name:String, __width:Number, __height:Number):void {
					var __bitmap:BitmapData = new BitmapData (__width, __height);
					
					m_bitmapNames[__name] = __bitmap;
					
					gotoX (__name);
				}
				
				//------------------------------------------------------------------------------------------
				public function gotoX (__name:String):void {
					bitmapData = m_bitmapNames[__name];
				}
				
				//------------------------------------------------------------------------------------------
				public function get dx ():Number {
					if (m_bitmapDataAnim) {
						return m_bitmapDataAnim.dx;
					}
					else
					{
						return 0;
					}
				}
				
				//------------------------------------------------------------------------------------------
				public function get dy ():Number {
					if (m_bitmapDataAnim) {
						return m_bitmapDataAnim.dy;
					}
					else
					{
						return 0;
					}
				}
				
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
				public function set visible2 (__visible:Boolean):void {
					m_visible = __visible;
				}
				
				//------------------------------------------------------------------------------------------			
				public function get visible2 ():Boolean {
					return m_visible;
				}
				
				//------------------------------------------------------------------------------------------	
			}
		
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
				public function getNumBitmaps ():Number {
					return 0;
				}
				
				//------------------------------------------------------------------------------------------
				public function getBitmapDataAnim ():XBitmapDataAnim {
					return null;
				}
				
				//------------------------------------------------------------------------------------------
				public function getBitmap (__frame:Number):* {
					return null;
				}		
				
				//------------------------------------------------------------------------------------------
				public function getBitmapByName (__name:String):* {
					return null;
				}

				//------------------------------------------------------------------------------------------
				public function get bitmapData ():BitmapData {
					return null;
				}
				
				//------------------------------------------------------------------------------------------
				public function goto (__frame:Number):void {
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
			
//------------------------------------------------------------------------------------------
}