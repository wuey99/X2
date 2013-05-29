//------------------------------------------------------------------------------------------
package X.XMap {

// X classes
	import X.Collections.*;
	import X.Geom.*;
	import X.Pool.XObjectPoolManager;
	import X.Task.*;
	import X.Texture.XSubTextureManager;
	import X.Utils.*;
	import X.World.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	import X.XML.XSimpleXMLNode;
	
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	import starling.textures.*;
		
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
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			m_imageNamesCached = false;
			
			if (CONFIG::starling) {
				m_textureManagerName = GUID.create ();
				
				m_subTextureManager = xxx.getTextureManager ().createSubManager (m_textureManagerName);
			}
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
			
			uncacheImageClassNames ();
			
			if (m_subTextureManager) {
				xxx.getTextureManager ().removeSubManager (m_textureManagerName);
			}
			
			if (m_submapBitmapPoolManager) {
				m_submapBitmapPoolManager.cleanup ();
			}
			
			if (m_submapImagePoolManager) {
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
			var i:Number;
			
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
							if (xxx.getMovieClipCacheManager ().isQueued (__name as String)) {
								trace (": not cached: ", __name);
								
								__flags = false;
							}							
						}
						else
						{
							if (xxx.getBitmapCacheManager ().isQueued (__name as String)) {
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
		if (CONFIG::starling) {
			public function cacheImageClassNames ():void {
				var __layer:XMapLayerModel;
				
				var i:Number;
				
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
				
				for (i=0; i<m_XMapModel.getLayers ().length; i++) {
					__layer = m_XMapModel.getLayers ()[i] as XMapLayerModel;
					
					__layer.getImageClassNames ().forEach (
						function (__name:*):void {
							trace (": cacheImageClassName: (movieClips): ", __name);
							
							if (__name == "ErrorImages:undefinedClass") {
								return;
							}
							
							xxx.getMovieClipCacheManager ().add (__name as String);
						}
					);
				}	
			}
		}
		else
		{
			public function cacheImageClassNames ():void {
				var i:Number;
				
				for (i=0; i<m_XMapModel.getLayers ().length; i++) {
					var __layer:XMapLayerModel = m_XMapModel.getLayers ()[i] as XMapLayerModel;
					
					__layer.getImageClassNames ().forEach (
						function (__name:*):void {
							trace (": cacheImageClassName: ", __name);
							
							xxx.getBitmapCacheManager ().add (__name as String);
						}
					);
				}			
			}		
		}
		
//------------------------------------------------------------------------------------------
		public function uncacheImageClassNames ():void {
			var i:Number;
			
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
			if (CONFIG::starling) {
				initSubmapImagePoolManager (512, 512);
			}
			else
			{
				initSubmapBitmapPoolManager (512, 512);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function initSubmapBitmapPoolManager (
			__width:Number=512, __height:Number=512,
			__alloc:Number=64, __spill:Number=16
			):void {
				
			m_submapBitmapPoolManager = new XObjectPoolManager (
				function ():* {
					var __bitmap:XSubmapBitmap = new XSubmapBitmap ();
					
					__bitmap.createBitmap ("tiles", __width, __height);
				
					return __bitmap;
				},
				
				function (__src:*, __dst:*):* {
					return null;
				},
				
				__alloc, __spill,
				
				function (x:*):void {
					XBitmap (x).cleanup ();
				}
			);
		}
		
//------------------------------------------------------------------------------------------
		public function getSubmapBitmapPoolManager ():XObjectPoolManager {
			return m_submapBitmapPoolManager;
		}
			
//------------------------------------------------------------------------------------------
		public function initSubmapImagePoolManager (
			__width:Number=512, __height:Number=512,
			__alloc:Number=8, __spill:Number=1
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
		public function createModelFromXML (__xml:XSimpleXMLNode):void {
			var __model:XMapModel = new XMapModel ();
			
			__model.deserializeAll (__xml);	
			
			setModel (__model);		
		}

//------------------------------------------------------------------------------------------
		public function createModelFromXMLReadOnly (__xml:XSimpleXMLNode):void {
			var __model:XMapModel = new XMapModel ();
			
			__model.deserializeAllReadOnly (__xml);	
			
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
		public function updateFromXMapModel ():void {
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
