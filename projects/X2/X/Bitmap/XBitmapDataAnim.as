//------------------------------------------------------------------------------------------
// <$begin$/>
// <$end$/>
//------------------------------------------------------------------------------------------
package X.Bitmap {
	
	import X.*;
	import X.Geom.*;
	import X.Task.*;
	import X.World.*;
	
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------	
	public class XBitmapDataAnim extends Object {
		public var m_bitmaps:Array;
		public var m_dx:Number;
		public var m_dy:Number;
		public var m_ready:Boolean;
		
		//------------------------------------------------------------------------------------------
		public function XBitmapDataAnim () {
			super ();

			m_bitmaps = new Array ();
			
			m_ready = false;
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
			
			m_bitmaps = null;
		}
		
		//------------------------------------------------------------------------------------------
		public function initWithScaling (__XApp:XApp, __movieClip:MovieClip, __scale:Number):void {
			initWithScalingXY (__XApp, __movieClip, __scale, __scale);
		}
		
		//------------------------------------------------------------------------------------------
		public function initWithScalingXY (__XApp:XApp, __movieClip:MovieClip, __scaleX:Number, __scaleY:Number):void {
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
				var __bitmap:BitmapData = new BitmapData (__width*__scaleX, __height*__scaleY, true, 0xffffff);
				m_bitmaps.push (__bitmap);
			}
		
			m_dx = -__rect.x*__scaleX;
			m_dy = -__rect.y*__scaleY;
			
			var __index:Number;

			__XApp.getXTaskManager ().addTask ([		
				function ():void {
					__index = 0;
				},
				
				XTask.LABEL, "loop",
					function ():void {
						__movieClip.gotoAndStop (__index + 1);
					}, 

					function ():void {
						if (m_bitmaps && m_bitmaps[__index]) {
							__rect = __movieClip.getBounds (__movieClip);
							var __matrix:Matrix = new Matrix ();
							__matrix.scale (__scaleX, __scaleY);
							__matrix.translate (-__rect.x*__scaleX, -__rect.y*__scaleY)
							m_bitmaps[__index].draw (__movieClip, __matrix);
						}
						__index += 1;
					},
					
					XTask.FLAGS, function (__task:XTask):void {
						__task.ifTrue (__index == __movieClip.totalFrames);
					},
					
					XTask.BNE, "loop",
					
					function ():void {
						m_ready = true;
					},
					
				XTask.RETN,
			]);
		}

		//------------------------------------------------------------------------------------------
		public function isReady ():Boolean {
			return m_ready;
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
