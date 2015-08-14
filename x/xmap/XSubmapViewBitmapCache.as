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
package x.xmap {

	import x.*;
	import x.bitmap.XBitmapCacheManager;
	import x.collections.*;
	import x.geom.*;
	import x.world.*;
	import x.world.collision.*;
	import x.world.logic.*;
	import x.world.sprite.*;
	import x.xmap.*;
	
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------	
// instead of maintaining an XLogicObject for an XMapItemModel (for the view), maintain a 
// bitmap/view-cache for eash Submap.  On initialization, all XMapItemModel's that flagged
// for caching are drawing directly into the Submap's bitmap/view-cache.
//
// pros:
//
// 1) performance gains because all cached XMapItem's are now baked into a single bitmap.
//
// cons:
//
// 1) lack of fine-grained control of z-ordering
//
// 2) since the image is baked into the bitmap, there is no ability to animate (or change image's appearance)
//    without having to recache the image.
//
// 3) possibly large set-up times (each Submap is 512 x 512 pixels by default)
//------------------------------------------------------------------------------------------
	public class XSubmapViewBitmapCache extends XLogicObject {
		private var m_XMapView:XMapView;
		private var m_submapModel:XSubmapModel;
		
		private var m_bitmap:XBitmap;
		private var x_sprite:XDepthSprite;
	
		private var tempRect:XRect;
		private var tempPoint:XPoint;

		private var m_delay:int;
		
		private var m_bitmapCacheManager:XBitmapCacheManager;
		
//------------------------------------------------------------------------------------------	
		public function XSubmapViewBitmapCache () {
			super ();
			
			m_submapModel = null;
		}

//------------------------------------------------------------------------------------------			
		public override function setup (__xxx:XWorld, args:Array /* <Dynamic> */):void {
			super.setup (__xxx, args);
			
			m_XMapView = getArg (args, 0);
			
			createSprites ();
			
			tempRect = xxx.getXRectPoolManager ().borrowObject () as XRect;
			tempPoint = xxx.getXPointPoolManager ().borrowObject () as XPoint;
			
			m_bitmapCacheManager = xxx.getBitmapCacheManager ();
			
			m_delay = 4;
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			removeAll ();

			m_XMapView.getSubmapBitmapPoolManager ().returnObject (m_bitmap);
					
			xxx.getXRectPoolManager ().returnObject (tempRect);
			xxx.getXPointPoolManager ().returnObject (tempPoint);
			
			if (m_submapModel != null) {
				fireKillSignal (m_submapModel);
							
				m_submapModel.inuse--;
				
				m_submapModel = null;
			}
		}

//------------------------------------------------------------------------------------------
		public function setXMapView (__XMapView:XMapView):void {
			m_XMapView = __XMapView;
		}		
		
//------------------------------------------------------------------------------------------
		public function setModel (__model:XSubmapModel):void {
			m_submapModel = __model;
			
			m_boundingRect = m_submapModel.boundingRect.cloneX ();
			
			refresh ();
		}

//------------------------------------------------------------------------------------------
		public function refresh ():void {
			if (m_submapModel.useArrayItems) {
				arrayRefresh ();
			}
			else
			{
				dictRefresh ();
			}
		}
		
//------------------------------------------------------------------------------------------
		public function dictRefresh ():void {
			m_bitmap.bitmapData.lock ();
	
			tempRect.x = 0;
			tempRect.y = 0;
			tempRect.width = m_submapModel.width;
			tempRect.height = m_submapModel.height;

			m_bitmap.bitmapData.fillRect (
				tempRect, 0x00000000
			);
			
// used only for debugging.  commented out to improve performance
//			__vline (0);
//			__vline (m_submapModel.width-1);
//			__hline (0);
//			__hline (m_submapModel.height-1);
			
			var __items:XDict /* <XMapItemModel, Int> */ = m_submapModel.items ();
			var __item:XMapItemModel;
			var __bitmap:XBitmap;
//			var __p:XPoint = new XPoint ();
			
			tempRect.x = 0;
			tempRect.y = 0;
			
			var i:int;
			
			__items.forEach (
				function (x:*):void {
					__item = x as XMapItemModel;

					__bitmap = xxx.getBitmapCacheManager ().get (__item.imageClassName);

					trace (": imageClassName: ", __item.imageClassName, __bitmap, __bitmap.bitmapData, __item.frame, __item.boundingRect.width, __item.boundingRect.height);
					
					if (__bitmap != null) {
						if (__item.frame != 0) {
							__bitmap.gotoAndStop (__item.frame);
						}
						
						tempPoint.x = __item.x - m_submapModel.x;
						tempPoint.y = __item.y - m_submapModel.y;
						
						tempRect.width = __item.boundingRect.width;
						tempRect.height = __item.boundingRect.height;
						
						m_bitmap.bitmapData.copyPixels (
							__bitmap.bitmapData, tempRect, tempPoint, null, null, true
						);
					}
				}
			);
							
			m_bitmap.bitmapData.unlock ();
			
			function __vline (x:int):void {
				var y:int;
				
				for (y=0; y<m_submapModel.height; y++) {
					m_bitmap.bitmapData.setPixel32 (x, y, 0xffff00ff);
				}
			}
			
			function __hline (y:int):void {
				var x:int;
				
				for (x=0; x<m_submapModel.width; x++) {
					m_bitmap.bitmapData.setPixel32 (x, y, 0xffff00ff);
				}
			}
		}
		
//------------------------------------------------------------------------------------------
		public function arrayRefresh ():void {
			m_bitmap.bitmapData.lock ();
			
			tempRect.x = 0;
			tempRect.y = 0;
			tempRect.width = m_submapModel.width;
			tempRect.height = m_submapModel.height;

			m_bitmap.bitmapData.fillRect (
				tempRect, 0x00000000
			);
			
			var __items:Vector.<XMapItemModel> = m_submapModel.arrayItems ();
			var __item:XMapItemModel;
			var __srcBitmap:XBitmap;
			var __dstBitmapData:BitmapData;
			var __submapX:Number = m_submapModel.x;
			var __submapY:Number = m_submapModel.y;
			
//			tempRect.x = 0;
//			tempRect.y = 0;
			
			var i:int, __length:int = __items.length;
			
			__dstBitmapData = m_bitmap.bitmapData;
			
			for (i=0; i<__length; i++) {
				__item = __items[i];
					
				__srcBitmap = m_bitmapCacheManager.get (__item.imageClassName);
					
//				trace (": imageClassName: ", __item.imageClassName, __srcBitmap, __srcBitmap.bitmapData, __item.frame, __item.boundingRect.width, __item.boundingRect.height);
					
				if (__srcBitmap != null) {
					if (__item.frame != 0) {
						__srcBitmap.gotoAndStop (__item.frame);
					}
						
					tempPoint.x = __item.x - __submapX;
					tempPoint.y = __item.y - __submapY;

					__dstBitmapData.copyPixels (
						__srcBitmap.bitmapData, __item.boundingRect, tempPoint, null, null, true
					);
				}
			}
			
			m_bitmap.bitmapData.unlock ();
		}
		
//------------------------------------------------------------------------------------------
// cull this object if it strays outside the current viewPort
//------------------------------------------------------------------------------------------	
		public override function cullObject ():void {
			if (m_delay > 0) {
				m_delay--;
				
				return;
			}
			
// determine whether this object is outside the current viewPort
			var v:XRect = xxx.getViewRect ();
						
			xxx.getXWorldLayer (m_layer).viewPort (v.width, v.height).copy2 (m_viewPortRect);
			m_viewPortRect.inflate (256, 256);
			
			m_boundingRect.copy2 (m_selfRect);
			m_selfRect.offsetPoint (getPos ());
			
			if (m_viewPortRect.intersects (m_selfRect)) {
				return;
			}

// yep, kill it
//			trace (": ---------------------------------------: ");
//			trace (": cull: ", this);
			
			killLater ();
		}
		
//------------------------------------------------------------------------------------------
// create sprites
//------------------------------------------------------------------------------------------
		public override function createSprites ():void {
			if (CONFIG::flash) {
				m_bitmap = m_XMapView.getSubmapBitmapPoolManager ().borrowObject () as XSubmapBitmap;
				x_sprite = addSpriteAt (m_bitmap, 0, 0);
				x_sprite.setDepth (getDepth ());
			}
			
			show ();
		}

//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
