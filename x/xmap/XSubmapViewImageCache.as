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
	import x.collections.*;
	import x.geom.*;
	import x.world.*;
	import x.world.collision.*;
	import x.world.logic.*;
	import x.world.sprite.*;
	import x.xmap.*;
	
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	// <HAXE>
	/* --
	import x.texture.starling.*;
	-- */
	// </HAXE>
	// <AS3>
	import starling.textures.*;
	// </AS3>

//------------------------------------------------------------------------------------------	
// instead of maintaining an XLogicObject for an XMapItemModel (for the view), maintain a 
// texture/view-cache for eash Submap.  On initialization, all XMapItemModel's that flagged
// for caching are drawing directly into the Submap's texture/view-cache.
//
// pros:
//
// 1) performance gains because all cached XMapItem's are now baked into a single texture.
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
	public class XSubmapViewImageCache extends XLogicObject {
		private var m_XMapView:XMapView;
		private var m_submapModel:XSubmapModel;
		
		private var m_image:XImage;
		private var x_sprite:XDepthSprite;
	
		private var tempRect:XRect;
		private var tempPoint:XPoint;
		
		private var m_delay:int;
		
		private var m_text:XTextSprite;
		
//------------------------------------------------------------------------------------------	
		public function XSubmapViewImageCache () {
			m_submapModel = null;
		}

//------------------------------------------------------------------------------------------			
		public override function setup (__xxx:XWorld, args:Array /* <Dynamic> */):void {
			super.setup (__xxx, args);
			
			m_XMapView = getArg (args, 0);
			
			createSprites ();
			
			tempRect = xxx.getXRectPoolManager ().borrowObject () as XRect;
			tempPoint = xxx.getXPointPoolManager ().borrowObject () as XPoint;
			
			m_delay = 4;
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
// TODO figure out coercion issue
//			x_sprite.removeChild (m_image);
			
			if (CONFIG::starling) {
				dispose ();
			}
			
			removeAll ();

			m_XMapView.getSubmapImagePoolManager ().returnObject (m_image);
			
//			m_text.cleanup ();
			
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
			var __renderTexture:RenderTexture = m_image.getTexture ();
			
			__renderTexture.drawBundled (
				function ():void {
					tempRect.x = 0;
					tempRect.y = 0;
					tempRect.width = m_submapModel.width;
					tempRect.height = m_submapModel.height;
									
					__vline (0);
					__vline (m_submapModel.width-1);
					__hline (0);
					__hline (m_submapModel.height-1);
					
					var __items:XDict /* <XMapItemModel, Float> */ = m_submapModel.items ();
					var __item:XMapItemModel;
					var __movieClip:XMovieClip;
					
					tempRect.x = 0;
					tempRect.y = 0;
					
					var i:int;
					
					__items.forEach (
						function (x:*):void {
							__item = x as XMapItemModel;
		
							__movieClip = xxx.getMovieClipCacheManager ().get (__item.imageClassName);
		
							trace (": imageClassName: ", __item.imageClassName, __movieClip, xxx.getMovieClipCacheManager ().isQueued (__item.imageClassName), __movieClip.getMovieClip (), __item.frame, __item.boundingRect.width, __item.boundingRect.height);
							
							trace (": movieClip: numFrames: ", __movieClip.getMovieClip ().numFrames);
							
							if (CONFIG::starling) {
								if (__movieClip != null) {
									if (__item.frame != 0) {
										__movieClip.gotoAndStop (__item.frame);
									}
									
									tempPoint.x = __item.x - m_submapModel.x;
									tempPoint.y = __item.y - m_submapModel.y;
									
									tempRect.width = __item.boundingRect.width;
									tempRect.height = __item.boundingRect.height;
									
									__movieClip.x = tempPoint.x;
									__movieClip.y = tempPoint.y;

									__renderTexture.draw (__movieClip);
								}
							}
						}
					);
				}
			);

			function __vline (x:int):void {
				var y:int;
			}
			
			function __hline (y:int):void {
				var x:int;
			}
		}
		
//------------------------------------------------------------------------------------------
		public function arrayRefresh ():void {
			var __renderTexture:RenderTexture = m_image.getTexture ();
			
			__renderTexture.drawBundled (
				function ():void {
					tempRect.x = 0;
					tempRect.y = 0;
					tempRect.width = m_submapModel.width;
					tempRect.height = m_submapModel.height;
					
					__vline (0);
					__vline (m_submapModel.width-1);
					__hline (0);
					__hline (m_submapModel.height-1);
					
					var __items:Vector.<XMapItemModel> = m_submapModel.arrayItems ();
					var __item:XMapItemModel;
					var __movieClip:XMovieClip;
					
					tempRect.x = 0;
					tempRect.y = 0;
					
					var i:int, __length:int = __items.length;
					
					for (i=0; i<__length; i++) {
							__item = __items[i];
							
							__movieClip = xxx.getMovieClipCacheManager ().get (__item.imageClassName);
							
							trace (": imageClassName: ", __item.imageClassName, __movieClip, xxx.getMovieClipCacheManager ().isQueued (__item.imageClassName), __movieClip.getMovieClip (), __item.frame, __item.boundingRect.width, __item.boundingRect.height);
							
							trace (": movieClip: numFrames: ", __movieClip.getMovieClip ().numFrames);
							
							if (CONFIG::starling) {
								if (__movieClip != null) {
									if (__item.frame != 0) {
										__movieClip.gotoAndStop (__item.frame);
									}
									
									tempPoint.x = __item.x - m_submapModel.x;
									tempPoint.y = __item.y - m_submapModel.y;
									
									tempRect.width = __item.boundingRect.width;
									tempRect.height = __item.boundingRect.height;
									
									__movieClip.x = tempPoint.x;
									__movieClip.y = tempPoint.y;
									
									__renderTexture.draw (__movieClip);
								}
							}
					}
				}
			);
			
			function __vline (x:Number):void {
				var y:Number;
			}
			
			function __hline (y:Number):void {
				var x:Number;
			}
		}
		
//------------------------------------------------------------------------------------------
// cull this object if it strays outside the current viewPort
//------------------------------------------------------------------------------------------	
		public override function cullObject ():void {
			if (m_delay) {
				m_delay--;
				
				return;
			}
			
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
//			trace (": XSubmapViewImage: cull: ", this, m_image.id);
			
			killLater ();
		}
		
//------------------------------------------------------------------------------------------
// create sprites
//------------------------------------------------------------------------------------------
		public override function createSprites ():void {
			if (CONFIG::starling) {
				m_image = m_XMapView.getSubmapImagePoolManager ().borrowObject () as XSubmapImage;				
				x_sprite = addSpriteAt (m_image, 0, 0);
				x_sprite.setDepth (getDepth ());

				/*
				m_text = createXTextSprite (96, 32, ": " + m_image.id, "Aller", 24, 0xffffff, true);
				var __depthSprite:XDepthSprite = addSpriteAt (m_text, 0, 0);
				__depthSprite.setDepth (getDepth () + 1001);
	
				trace (": XSubmapViewImage: id: ", m_image.id, m_image.visible);
				*/
				
//				trace (": numberOfBorrowedObjects: ", m_XMapView.getSubmapImagePoolManager ().numberOfBorrowedObjects (),  m_XMapView.getSubmapImagePoolManager ().totalNumberOfObjects ());
			}
			
			show ();
		}

//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
