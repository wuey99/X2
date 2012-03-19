//------------------------------------------------------------------------------------------
package X.World.Sprite {
	
	import X.*;
	import X.Bitmap.*;
	import X.Geom.*;
	import X.World.*;
	
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.*;
	
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
		
		//------------------------------------------------------------------------------------------
		include "..\\Sprite\\XRegistration_impl.h";
		
		//------------------------------------------------------------------------------------------
		public function XBitmap () {
			super ();
			
			m_pos = new XPoint ();
			m_rect = new XRect ();
			
			setRegistration ();
			
			m_scale = 1.0;
			m_visible = true;
			
			m_bitmapNames = new Object ();
		}
		
		//------------------------------------------------------------------------------------------
		public function setup ():void {	
		}
		
		//------------------------------------------------------------------------------------------
		public function cleanup ():void {
			m_bitmapDataAnimManager.remove (m_className);
			
			var i:Number;
			
			var __name:String;
			
			for (__name in m_bitmapNames) {
				m_bitmapNames[__name].dispose ();
				
				delete m_bitmapNames[__name];
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function initWithClassName (__xxx:XWorld, __XApp:XApp, __className:String):void {
			m_bitmapDataAnimManager =
				__xxx != null ? __xxx.getBitmapDataAnimManager () : __XApp.getBitmapDataAnimManager ();
			
			m_className = __className;
			
			m_bitmapDataAnim = m_bitmapDataAnimManager.add (__className);
			
			goto (1);
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
			return m_bitmapDataAnim.getNumBitmaps ();
		}

		//------------------------------------------------------------------------------------------
		public function getBitmapDataAnim ():XBitmapDataAnim {
			return m_bitmapDataAnim;
		}
		
		//------------------------------------------------------------------------------------------
		public function getBitmap (__frame:Number):BitmapData {
			return m_bitmapDataAnim.getBitmap (__frame);
		}		
		
		//------------------------------------------------------------------------------------------
		public function getBitmapByName (__name:String):BitmapData {
			return m_bitmapNames[__name];
		}
		
		//------------------------------------------------------------------------------------------
		public function goto (__frame:Number):void {
			m_frame = __frame-1;
			
			bitmapData = m_bitmapDataAnim.getBitmap (m_frame);
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
			return m_bitmapDataAnim.dx;
		}
		
		//------------------------------------------------------------------------------------------
		public function get dy ():Number {
			return m_bitmapDataAnim.dy;
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
}
