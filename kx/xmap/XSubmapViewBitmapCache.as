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
package kx.xmap {

	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	import kx.*;
	import kx.bitmap.XBitmapCacheManager;
	import kx.collections.*;
	import kx.geom.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.xmap.*;
	
//------------------------------------------------------------------------------------------
	public class XSubmapViewBitmapCache extends XSubmapViewCache {
		private var m_bitmap:XBitmap;
		private var m_bitmapCacheManager:XBitmapCacheManager;
		
//------------------------------------------------------------------------------------------	
		public function XSubmapViewBitmapCache () {
			super ();
		}

//------------------------------------------------------------------------------------------			
		public override function setup (__xxx:XWorld, args:Array /* <Dynamic> */):void {
			super.setup (__xxx, args);
	
			m_bitmapCacheManager = xxx.getBitmapCacheManager ();
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup();
			
			m_XMapView.getSubmapBitmapPoolManager ().returnObject (m_bitmap);
		}

//------------------------------------------------------------------------------------------
		public override function dictRefresh ():void {
			m_bitmap.bitmap.bitmapData.lock ();
	
			tempRect.x = 0;
			tempRect.y = 0;
			tempRect.width = m_submapModel.width;
			tempRect.height = m_submapModel.height;

			m_bitmap.bitmap.bitmapData.fillRect (
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

					trace (": imageClassName: ", __item.imageClassName, __bitmap, __bitmap.bitmap.bitmapData, __item.frame, __item.boundingRect.width, __item.boundingRect.height);
					
					if (__bitmap != null) {
						if (__item.frame != 0) {
							__bitmap.gotoAndStop (__item.frame);
						}
						
						tempPoint.x = __item.x - m_submapModel.x;
						tempPoint.y = __item.y - m_submapModel.y;
						
						tempRect.width = __item.boundingRect.width;
						tempRect.height = __item.boundingRect.height;
						
						m_bitmap.bitmap.bitmapData.copyPixels (
							__bitmap.bitmap.bitmapData, tempRect, tempPoint, null, null, true
						);
					}
				}
			);
							
			m_bitmap.bitmap.bitmapData.unlock ();
			
			function __vline (x:int):void {
				var y:int;
				
				for (y=0; y<m_submapModel.height; y++) {
					m_bitmap.bitmap.bitmapData.setPixel32 (x, y, 0xffff00ff);
				}
			}
			
			function __hline (y:int):void {
				var x:int;
				
				for (x=0; x<m_submapModel.width; x++) {
					m_bitmap.bitmap.bitmapData.setPixel32 (x, y, 0xffff00ff);
				}
			}
		}
		
//------------------------------------------------------------------------------------------
		public override function arrayRefresh ():void {
			m_bitmap.bitmap.bitmapData.lock ();
			
			tempRect.x = 0;
			tempRect.y = 0;
			tempRect.width = m_submapModel.width;
			tempRect.height = m_submapModel.height;

			m_bitmap.bitmap.bitmapData.fillRect (
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
			
			__dstBitmapData = m_bitmap.bitmap.bitmapData;
			
			for (i=0; i<__length; i++) {
				__item = __items[i];
					
				__srcBitmap = m_bitmapCacheManager.get (__item.imageClassName);
					
//				trace (": imageClassName: ", __item.imageClassName, __srcBitmap, __srcBitmap.bitmap.bitmapData, __item.frame, __item.boundingRect.width, __item.boundingRect.height);
					
				if (__srcBitmap != null) {
					if (__item.frame != 0) {
						__srcBitmap.gotoAndStop (__item.frame);
					}
						
					tempPoint.x = __item.x - __submapX;
					tempPoint.y = __item.y - __submapY;

					__dstBitmapData.copyPixels (
						__srcBitmap.bitmap.bitmapData, __item.boundingRect, tempPoint, null, null, true
					);
				}
			}
			
			m_bitmap.bitmap.bitmapData.unlock ();
		}

//------------------------------------------------------------------------------------------
		public override function tileRefresh ():void {
			m_bitmap.bitmap.bitmapData.lock ();
			
			tempRect.x = 0;
			tempRect.y = 0;
			tempRect.width = m_submapModel.width;
			tempRect.height = m_submapModel.height;
			
			m_bitmap.bitmap.bitmapData.fillRect (
				tempRect, 0x00000000
			);
			
			var __srcBitmap:XBitmap;
			var __dstBitmapData:BitmapData;
			var __submapX:Number = m_submapModel.x;
			var __submapY:Number = m_submapModel.y;
			var __tmap:Vector.<Array> = m_submapModel.tmap;
			var __tileCols:int = m_submapModel.tileCols;
			var __tileRows:int = m_submapModel.tileRows;
			
			var __boundingRect:XRect =  m_XMapView.getSubmapBitmapPoolManager ().borrowObject () as XRect;
			
			__boundingRect.x = 0;
			__boundingRect.y = 0;
			__boundingRect.width = XSubmapModel.TX_TILE_WIDTH;
			__boundingRect.height = XSubmapModel.TX_TILE_HEIGHT;
			
			__dstBitmapData = m_bitmap.bitmap.bitmapData;
			
			for (var __row:int = 0; __row < __tileRows; __row++) {
				for (var __col:int = 0; __col < __tileRows; __col++) {
					var __tile:Array /* <Dynamic> */  = __tmap[__row * __tileCols + __col];
					
					__srcBitmap = m_bitmapCacheManager.get (__tile[0]);
					
					if (__srcBitmap != null) {
						if (__tile[1] != 0) {
							__srcBitmap.gotoAndStop (__tile[1]);
						}
						
						tempPoint.x = __col * XSubmapModel.TX_TILE_WIDTH;
						tempPoint.y = __row * XSubmapModel.TX_TILE_HEIGHT;
						
						__dstBitmapData.copyPixels (
							__srcBitmap.bitmap.bitmapData, __boundingRect, tempPoint, null, null, true
						);
					}
				}
			}
			
			m_XMapView.getSubmapBitmapPoolManager ().returnObject (__boundingRect);
			
			m_bitmap.bitmap.bitmapData.unlock ();
		}
		
//------------------------------------------------------------------------------------------
// create sprites
//------------------------------------------------------------------------------------------
		public override function createSprites ():void {
			m_bitmap = m_XMapView.getSubmapBitmapPoolManager ().borrowObject () as XSubmapBitmap;
			x_sprite = addSpriteAt (m_bitmap, 0, 0);
			x_sprite.setDepth (getDepth ());
			
			show ();
		}

//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
