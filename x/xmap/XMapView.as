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

// X classes
	import x.collections.*;
	import x.geom.*;
	import x.pool.XObjectPoolManager;
	import x.task.*;
	import x.texture.XSubTextureManager;
	import x.utils.*;
	import x.world.*;
	import x.world.logic.*;
	import x.world.sprite.*;
	import x.xml.*;
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
	public class XMapView extends XLogicObject {
		protected var m_XMapModel:XMapModel;
		protected var m_submapBitmapPoolManager:XObjectPoolManager;
		protected var m_submapImagePoolManager:XObjectPoolManager;
		protected var m_subTextureManager:XSubTextureManager;
		protected var m_textureManagerName:String;
		protected var m_imageNamesCached:Boolean;
				
//------------------------------------------------------------------------------------------
		public function XMapView () {
			super ();
		}
		
//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array /* <Dynamic> */):void {
			super.setup (__xxx, args);
			
			m_imageNamesCached = false;
			
			if (CONFIG::starling) {
				m_textureManagerName = GUID.create ();
				
//				m_subTextureManager = xxx.getTextureManager ().createSubManager (m_textureManagerName);
			}
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
			
			uncacheImageClassNames ();
			
			if (m_subTextureManager != null) {
				xxx.getTextureManager ().removeSubManager (m_textureManagerName);
			}
			
			if (m_submapBitmapPoolManager != null) {
				m_submapBitmapPoolManager.cleanup ();
			}
			
			if (m_submapImagePoolManager != null) {
				m_submapImagePoolManager.cleanup ();
			}
		}
		
//--------------------------------------------f----------------------------------------------
		public override function setupX ():void {
		}

//------------------------------------------------------------------------------------------
		public override function cullObject ():void {
			getXLogicObjects ().forEach (
				function (x:*):void {
					var __logicObject:XLogicObject = x as XLogicObject;
					
					__logicObject.cullObject ();
				}
			);
			
			super.cullObject ();
		}
		
//------------------------------------------------------------------------------------------
// all levels/XMaps contain a list of images used in the level.  We cache them all as
// bitmap's (in flash) and textures/movieclips (in starling).		
//------------------------------------------------------------------------------------------
		
//------------------------------------------------------------------------------------------
		public function areImageClassNamesCached ():Boolean {
			var __flags:Boolean;
			var i:int;
			
			if (m_imageNamesCached) {
				return true;
			}
			
			__flags = true;
			
			for (i=0; i<m_XMapModel.getLayers ().length; i++) {
				var __layer:XMapLayerModel = m_XMapModel.getLayers ()[i] as XMapLayerModel;
	
				__layer.getImageClassNames ().forEach (
					function (__name:*):void {
						if (__name == "ErrorImages:undefinedClass") {
							return;
						}

						if (CONFIG::starling) {
							if (xxx.getMovieClipCacheManager ().isQueued (/* @:cast */ __name as String)) {
								trace (": not cached: ", __name);
								
								__flags = false;
							}							
						}
						else
						{
							if (xxx.getBitmapCacheManager ().isQueued (/* @:cast */ __name as String)) {
								trace (": not cached: ", __name);
								
								__flags = false;
							}
						}
					}
				);
				
				if (!__flags) {
					return false;
				}
			}
			
			m_imageNamesCached = true;
			
			return true;	
		}

//------------------------------------------------------------------------------------------
// <HAXE>
/* --
-- */
// </HAXE>
// <AS3>
		if (CONFIG::starling) {
			public function cacheImageClassNames ():void {
				var __layer:XMapLayerModel;
				
				var i:int;
				
				/*
				m_subTextureManager.start ();
				
				for (i=0; i<m_XMapModel.getLayers ().length; i++) {
					__layer = m_XMapModel.getLayers ()[i] as XMapLayerModel;
		
					__layer.getImageClassNames ().forEach (
						function (__name:*):void {
							trace (": cacheImageClassName: (textures): ", __name);
							
							if (__name == "ErrorImages:undefinedClass") {
								return;
							}
							
							m_subTextureManager.add (__name as String);
						}
					);
				}
				
				m_subTextureManager.finish ();
				*/
				
				for (i=0; i<m_XMapModel.getLayers ().length; i++) {
					__layer = m_XMapModel.getLayers ()[i] as XMapLayerModel;
					
					__layer.getImageClassNames ().forEach (
						function (__name:*):void {
							trace (": cacheImageClassName: (movieClips): ", __name);
							
							if (__name == "ErrorImages:undefinedClass") {
								return;
							}
							
							xxx.getMovieClipCacheManager ().add (/* @:cast */__name as String);
						}
					);
				}	
			}
		}
		else
		{
// </AS3>
			public function cacheImageClassNames ():void {
				var i:int;
				
				for (i=0; i<m_XMapModel.getLayers ().length; i++) {
					var __layer:XMapLayerModel = m_XMapModel.getLayers ()[i] as XMapLayerModel;
					
					__layer.getImageClassNames ().forEach (
						function (__name:*):void {
							trace (": cacheImageClassName: ", __name);
							
							xxx.getBitmapCacheManager ().add (/* @:cast */ __name as String);
						}
					);
				}			
			}	
// <HAXE>
/* --
-- */
// </HAXE>
// <AS3>
		}
// </AS3>
		
//------------------------------------------------------------------------------------------
		public function uncacheImageClassNames ():void {
			var i:int;
			
			if (CONFIG::starling) {
				for (i=0; i<m_XMapModel.getLayers ().length; i++) {
					var __layer:XMapLayerModel = m_XMapModel.getLayers ()[i] as XMapLayerModel;
					
					__layer.getImageClassNames ().forEach (
						function (__name:*):void {
							xxx.getMovieClipCacheManager ().remove (__name as String);
						}
					);
				}
			}
			else
			{
				for (i=0; i<m_XMapModel.getLayers ().length; i++) {
					var __layer:XMapLayerModel = m_XMapModel.getLayers ()[i] as XMapLayerModel;
		
					__layer.getImageClassNames ().forEach (
						function (__name:*):void {
							xxx.getBitmapCacheManager ().remove (__name as String);
						}
					);
				}
			}
		}

//------------------------------------------------------------------------------------------
		public function getSubTextureManager ():XSubTextureManager {
			return m_subTextureManager;
		}
		
//------------------------------------------------------------------------------------------
		public function initSubmapPoolManager ():void {
// <HAXE>
/* --
			initSubmapBitmapPoolManager (512, 512);
-- */
// </HAXE>
// <AS3>
			if (CONFIG::starling) {
				initSubmapImagePoolManager (512, 512);
			}
			else
			{
				initSubmapBitmapPoolManager (512, 512);
			}
// </AS3>
		}
		
//------------------------------------------------------------------------------------------
		public function initSubmapBitmapPoolManager (
			__width:int=512, __height:int=512,
			__alloc:int=64, __spill:int=16
			):void {
				
			m_submapBitmapPoolManager = new XObjectPoolManager (
				function ():* {
					var __bitmap:XSubmapBitmap = new XSubmapBitmap ();
					__bitmap.setup ();					
					__bitmap.createBitmap ("tiles", __width, __height);
				
					return __bitmap;
				},
				
				function (__src:*, __dst:*):* {
					return null;
				},
				
				__alloc, __spill,
				
				function (x:*):void {
					var __bitmap:XBitmap = x as XBitmap;
					
					__bitmap.cleanup ();
				}
			);
		}
		
//------------------------------------------------------------------------------------------
		public function getSubmapBitmapPoolManager ():XObjectPoolManager {
			return m_submapBitmapPoolManager;
		}
	
//------------------------------------------------------------------------------------------		
// <HAXE>
/* --
-- */
// </HAXE>
// <AS3>
//------------------------------------------------------------------------------------------
		public function initSubmapImagePoolManager (
			__width:int=512, __height:int=512,
			__alloc:int=8, __spill:int=1
			):void {
			
			m_submapImagePoolManager = new XObjectPoolManager (
				function ():* {
					var __texture:RenderTexture = new RenderTexture (__width, __height, false);
					
					var __image:XSubmapImage = new XSubmapImage (__texture);
					
					return __image;
				},
				
				function (__src:*, __dst:*):* {
					return null;
				},
				
				__alloc, __spill,
				
				function (x:*):void {
					XImage (x).cleanup ();
				}
			);
		}
		
//------------------------------------------------------------------------------------------
		public function getSubmapImagePoolManager ():XObjectPoolManager {
			return m_submapImagePoolManager;
		}
		
//------------------------------------------------------------------------------------------		
// </AS3>
		
//------------------------------------------------------------------------------------------
		public function createModelFromXML (__xml:XSimpleXMLNode, __useArrayItems:Boolean=false):void {
			var __model:XMapModel = new XMapModel ();
			
			__model.deserializeAllNormal (__xml, __useArrayItems);	
			
			setModel (__model);		
		}

//------------------------------------------------------------------------------------------
		public function createModelFromXMLReadOnly (__xml:XSimpleXMLNode, __useArrayItems:Boolean=false):void {
			var __model:XMapModel = new XMapModel ();
			
			__model.deserializeAllReadOnly (__xml, __useArrayItems);	
			
			setModel (__model);		
		}
		
//------------------------------------------------------------------------------------------
		public function getModel ():XMapModel {
			return m_XMapModel;
		}
		
//------------------------------------------------------------------------------------------
		public function setModel (__model:XMapModel):void {
			m_XMapModel = __model;
			
			cacheImageClassNames ();
		}
		
//------------------------------------------------------------------------------------------
		public function scrollTo (__layer:int, __x:Number, __y:Number):void {
		}

//------------------------------------------------------------------------------------------
		public function updateScroll ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function updateFromXMapModel ():void {
		}

//------------------------------------------------------------------------------------------
		public function prepareUpdateScroll ():void {	
		}

//------------------------------------------------------------------------------------------
		public function finishUpdateScroll ():void {	
		}
						
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
