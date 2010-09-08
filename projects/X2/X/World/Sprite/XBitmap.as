//------------------------------------------------------------------------------------------
package X.World.Sprite {

	import X.World.*;
	
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------	
	public class XBitmap extends Bitmap implements XRegistration {
		public var m_scale:Number;
		public var m_visible:Boolean;
		public var m_bitmaps:Array;
		public var m_bitmapsX:Object;
		public var m_dx:Number;
		public var m_dy:Number;
		public var m_frame:Number;

//------------------------------------------------------------------------------------------
		include "..\\Sprite\\XRegistration_impl.as";
				
//------------------------------------------------------------------------------------------
		public function XBitmap () {
			super ();
			
			setRegistration ();
			
			m_scale = 1.0;
			m_visible = true;
			
			m_bitmaps = new Array ();
			m_bitmapsX = new Object ();
		}

//------------------------------------------------------------------------------------------
		public function initWithScaling (__movieClip:MovieClip, __scale:Number):void {
			initWithScalingXY (__movieClip, __scale, __scale);
		}
		
//------------------------------------------------------------------------------------------
		public function initWithScalingXY (__movieClip:MovieClip, __scaleX:Number, __scaleY:Number):void {
			var i:Number;
			var __width:Number, __height:Number;
			var __bounds:Rectangle;
			
			__width = 0;
			__height = 0;
		
			for (i=0; i < __movieClip.totalFrames; i++) {
				__movieClip.gotoAndStop (i+1);
				__bounds = __movieClip.getBounds (__movieClip);
				__width = Math.max (__width, __bounds.width);
				__height = Math.max (__height, __bounds.height);
			}
	
			__movieClip.gotoAndStop (1);
			__movieClip.gotoAndStop (1);
			__movieClip.gotoAndStop (1);
									
			for (i=0; i < __movieClip.totalFrames; i++) {
				__movieClip.gotoAndStop (i+1);
				__bounds = __movieClip.getBounds (__movieClip);
				var __bitmap:BitmapData = new BitmapData (__width*__scaleX, __height*__scaleY, true, 0xffffff);
				var __matrix:Matrix = new Matrix ();
				__matrix.scale (__scaleX, __scaleY);
				__matrix.translate (__bounds.x*__scaleX, __bounds.y*__scaleY)
				__bitmap.draw (__movieClip, __matrix);
				m_bitmaps.push (__bitmap);
				m_dx = -__bounds.x*__scaleX;
				m_dy = -__bounds.y*__scaleY;
			}
			
			m_frame = 1;
			
			goto (m_frame);
		}
		
//------------------------------------------------------------------------------------------
		public function goto (__frame:Number):void {
			m_frame = __frame-1;
			
			bitmapData = m_bitmaps[m_frame];
		}

//------------------------------------------------------------------------------------------
		public function createBitmap (__name:String, __width:Number, __height:Number):void {
			var __bitmap:BitmapData = new BitmapData (__width, __height);
			
			m_bitmapsX[__name] = __bitmap;
			
			gotoX (__name);
		}

//------------------------------------------------------------------------------------------
		public function gotoX (__name:String):void {
			bitmapData = m_bitmapsX[__name];
		}
				
//------------------------------------------------------------------------------------------
		public function get dx ():Number {
			return m_dx;
		}
		
//------------------------------------------------------------------------------------------
		public function get dy ():Number {
			return  m_dy;
		}
		
//------------------------------------------------------------------------------------------
		public function viewPort (__canvasWidth:Number, __canvasHeight:Number):Rectangle {
			return new Rectangle (-x/m_scale, -y/m_scale, __canvasWidth/m_scale, __canvasHeight/m_scale);
		}
		
//------------------------------------------------------------------------------------------
		public function getPos ():Point {
			return new Point (x2, y2);
		}

//------------------------------------------------------------------------------------------		
		public function setPos (__p:Point):void {
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
