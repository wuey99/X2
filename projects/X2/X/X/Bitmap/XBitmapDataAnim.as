//------------------------------------------------------------------------------------------
package X.Bitmap {
	
	import X.Geom.*;
	import X.World.*;
	
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------	
	public class XBitmapDataAnim extends Object {
		public var m_bitmaps:Array;
		public var m_dx:Number;
		public var m_dy:Number;
		
		//------------------------------------------------------------------------------------------
		public function XBitmapDataAnim () {
			super ();

			m_bitmaps = new Array ();
		}
		
		//------------------------------------------------------------------------------------------
		public function setup ():void {	
		}
		
		//------------------------------------------------------------------------------------------
		public function cleanup ():void {	
			var i:Number;
			
			for (i=0; i<m_bitmaps.length; i++) {
				m_bitmaps[i].dispose ();
				m_bitmaps[i] = null;
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function initWithScaling (__movieClip:MovieClip, __scale:Number):void {
			initWithScalingXY (__movieClip, __scale, __scale);
		}
		
		//------------------------------------------------------------------------------------------
		public function initWithScalingXY (__movieClip:MovieClip, __scaleX:Number, __scaleY:Number):void {
			var i:Number;
			var __width:Number, __height:Number;
			var __rect:Rectangle;
			
			__width = 0;
			__height = 0;
			
			for (i=0; i < __movieClip.totalFrames; i++) {
				__movieClip.gotoAndStop (i+1);
				__rect = __movieClip.getBounds (__movieClip);
				__width = Math.max (__width, __rect.width);
				__height = Math.max (__height, __rect.height);
			}
			
			for (i=0; i < __movieClip.totalFrames; i++) {
				__movieClip.gotoAndStop (i+1);
				__rect = __movieClip.getBounds (__movieClip);
				var __bitmap:BitmapData = new BitmapData (__width*__scaleX, __height*__scaleY, true, 0xffffff);
				var __matrix:Matrix = new Matrix ();
				__matrix.scale (__scaleX, __scaleY);
				__matrix.translate (-__rect.x*__scaleX, -__rect.y*__scaleY)
				__bitmap.draw (__movieClip, __matrix);
				m_bitmaps.push (__bitmap);
				m_dx = -__rect.x*__scaleX;
				m_dy = -__rect.y*__scaleY;
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function getNumBitmaps ():Number {
			return m_bitmaps.length;
		}
		
		//------------------------------------------------------------------------------------------
		public function getBitmap (__frame:Number):BitmapData {
			return m_bitmaps[__frame];
		}		

		//------------------------------------------------------------------------------------------
		public function get dx ():Number {
			return m_dx;
		}
		
		//------------------------------------------------------------------------------------------
		public function get dy ():Number {
			return m_dy;
		}

		//------------------------------------------------------------------------------------------
	}
	
	//------------------------------------------------------------------------------------------
}
