//------------------------------------------------------------------------------------------
package X.XMap {

// X classes
	import X.Collections.*;
	import X.Geom.*;
	import X.Pool.XObjectPoolManager;
	import X.Task.*;
	import X.World.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	import X.XML.XSimpleXMLNode;
	
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
		
//------------------------------------------------------------------------------------------
	public class XMapView extends XLogicObject {
		protected var m_XMapModel:XMapModel;
		protected var m_submapBitmapPoolManager:XObjectPoolManager;
				
//------------------------------------------------------------------------------------------
		public function XMapView () {
			super ();
		}
		
//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
			
			uncacheImageClassNames ();
		}
		
//--------------------------------------------f----------------------------------------------
		public override function setupX ():void {
		}

//------------------------------------------------------------------------------------------
		public function areImageClassNamesCached ():Boolean {
			var __flags:Boolean;
			var i:Number;
			
			__flags = true;
			
			for (i=0; i<m_XMapModel.getLayers ().length; i++) {
				var __layer:XMapLayerModel = m_XMapModel.getLayers ()[i] as XMapLayerModel;
	
				__layer.getImageClassNames ().forEach (
					function (__name:*):void {
//						if (xxx.getBitmapCacheManager ().get (__name as String) == null) {
//							__flags = false;
//						}
						
//						trace (": isCached: ", __name, xxx.getBitmapCacheManager ().isQueued (__name));
						
						if (xxx.getBitmapCacheManager ().isQueued (__name as String)) {
							__flags = false;
						}
					}
				);
				
				if (!__flags) {
					return false;
				}
			}
			
			return true;	
		}
		
//------------------------------------------------------------------------------------------
		public function cacheImageClassNames ():void {
			var i:Number;
			
			for (i=0; i<m_XMapModel.getLayers ().length; i++) {
				var __layer:XMapLayerModel = m_XMapModel.getLayers ()[i] as XMapLayerModel;
	
				__layer.getImageClassNames ().forEach (
					function (__name:*):void {
						xxx.getBitmapCacheManager ().add (__name as String);
					}
				);
			}			
		}
		
//------------------------------------------------------------------------------------------
		public function uncacheImageClassNames ():void {
			var i:Number;
			
			for (i=0; i<m_XMapModel.getLayers ().length; i++) {
				var __layer:XMapLayerModel = m_XMapModel.getLayers ()[i] as XMapLayerModel;
	
				__layer.getImageClassNames ().forEach (
					function (__name:*):void {
						xxx.getBitmapCacheManager ().remove (__name as String);
					}
				);
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
				
				__alloc, __spill
			);
		}
		
//------------------------------------------------------------------------------------------
		public function getSubmapBitmapPoolManager ():XObjectPoolManager {
			return m_submapBitmapPoolManager;
		}
			
//------------------------------------------------------------------------------------------
		public function createModelFromXML (__xml:XSimpleXMLNode):void {
			var __model:XMapModel = new XMapModel ();
			
			__model.deserializeAll (__xml);	
			
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
