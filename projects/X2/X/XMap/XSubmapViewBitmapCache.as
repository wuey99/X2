//------------------------------------------------------------------------------------------
// <$begin$/>
// Copyright (C) 2014 Jimmy Huey
//
// Some Rights Reserved.
//
// The "X-Engine" is licensed under a Creative Commons
// Attribution-NonCommerical-ShareAlike 3.0 Unported License.
// (CC BY-NC-SA 3.0)
//
// You are free to:
//
//      SHARE - to copy, distribute, display and perform the work.
//      ADAPT - remix, transform build upon this material.
//
//      The licensor cannot revoke these freedoms as long as you follow the license terms.
//
// Under the following terms:
//
//      ATTRIBUTION -
//          You must give appropriate credit, provide a link to the license, and
//          indicate if changes were made.  You may do so in any reasonable manner,
//          but not in any way that suggests the licensor endorses you or your use.
//
//      SHAREALIKE -
//          If you remix, transform, or build upon the material, you must
//          distribute your contributions under the same license as the original.
//
//      NONCOMMERICIAL -
//          You may not use the material for commercial purposes.
//
// No additional restrictions - You may not apply legal terms or technological measures
// that legally restrict others from doing anything the license permits.
//
// The full summary can be located at:
// http://creativecommons.org/licenses/by-nc-sa/3.0/
//
// The human-readable summary of the Legal Code can be located at:
// http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode
//
// The "X-Engine" is free for non-commerical use.
// For commercial use, you will need to provide additional credits.
// Please contact me @ wuey99[dot]gmail[dot]com for more details.
// <$end$/>
//------------------------------------------------------------------------------------------
package X.XMap {

	import X.*;
	import X.Collections.*;
	import X.Geom.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	
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
					
//------------------------------------------------------------------------------------------	
		public function XSubmapViewBitmapCache () {
			m_submapModel = null;
		}

//------------------------------------------------------------------------------------------			
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			m_XMapView = getArg (args, 0);
			
			createSprites ();
			
			tempRect = xxx.getXRectPoolManager ().borrowObject () as XRect;
			tempPoint = xxx.getXPointPoolManager ().borrowObject () as XPoint;
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
			
			var __items:XDict = m_submapModel.items ();
			var __item:XMapItemModel;
			var __bitmap:XBitmap;
//			var __p:XPoint = new XPoint ();
			
			tempRect.x = 0;
			tempRect.y = 0;
			
			var i:Number;
			
			__items.forEach (
				function (x:*):void {
					__item = x as XMapItemModel;

					__bitmap = xxx.getBitmapCacheManager ().get (__item.imageClassName);

					trace (": imageClassName: ", __item.imageClassName, __bitmap, __bitmap.bitmapData, __item.frame, __item.boundingRect.width, __item.boundingRect.height);
					
					if (__bitmap != null) {
						if (__item.frame != 0) {
							__bitmap.goto (__item.frame);
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
			
			function __vline (x:Number):void {
				var y:Number;
				
				for (y=0; y<m_submapModel.height; y++) {
					m_bitmap.bitmapData.setPixel32 (x, y, 0xffff00ff);
				}
			}
			
			function __hline (y:Number):void {
				var x:Number;
				
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
			var __bitmap:XBitmap;
			
			tempRect.x = 0;
			tempRect.y = 0;
			
			var i:int, __length:int = __items.length;
			
			for (i=0; i<__length; i++) {
				__item = __items[i];
					
				__bitmap = xxx.getBitmapCacheManager ().get (__item.imageClassName);
					
				trace (": imageClassName: ", __item.imageClassName, __bitmap, __bitmap.bitmapData, __item.frame, __item.boundingRect.width, __item.boundingRect.height);
					
				if (__bitmap != null) {
					if (__item.frame != 0) {
						__bitmap.goto (__item.frame);
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
			
			m_bitmap.bitmapData.unlock ();
		}
		
//------------------------------------------------------------------------------------------
// cull this object if it strays outside the current viewPort
//------------------------------------------------------------------------------------------	
		public override function cullObject ():void {

// determine whether this object is outside the current viewPort
			var v:XRect = xxx.getViewRect ();

			var r:XRect = xxx.getXRectPoolManager ().borrowObject () as XRect;	
			var i:XRect = xxx.getXRectPoolManager ().borrowObject () as XRect;
										
			xxx.getXWorldLayer (m_layer).viewPort (v.width, v.height).copy2 (r);
			r.inflate (256, 256);
			
			m_boundingRect.copy2 (i);
			i.offsetPoint (getPos ());
			
			if (r.intersects (i)) {
				xxx.getXRectPoolManager ().returnObject (r);
				xxx.getXRectPoolManager ().returnObject (i);
				
				return;
			}
			
			xxx.getXRectPoolManager ().returnObject (r);
			xxx.getXRectPoolManager ().returnObject (i);
					
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
