//------------------------------------------------------------------------------------------
package X.World.Tiles {

	import X.*;
	import X.Geom.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	import X.XMap.XSubmapModel;
	
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------	
// primarily used in TikiEdit
//
// this class handles the view and caching of CX (collision tiles) and represents a Submap's
// collision data.
//------------------------------------------------------------------------------------------
	public class XSubmapTiles extends XLogicObject {
		private var m_submapModel:XSubmapModel;
		
		private var m_bitmap:XBitmap;
		private var x_sprite:XDepthSprite;
		
		private var cx_sprite:MovieClip;
		private var cx_bitmap:XBitmap;
		
		private var tempRect:XRect;
		private var tempPoint:XPoint;

		private var m_XMapView:*;

//------------------------------------------------------------------------------------------	
		public function XSubmapTiles () {
			m_submapModel = null;
		}

//------------------------------------------------------------------------------------------			
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			m_XMapView = getArg (args, 0);
			
			createSprites ();
			
			tempRect = xxx.getXRectPoolManager ().borrowObject () as XRect;
			tempPoint = xxx.getXPointPoolManager ().borrowObject () as XPoint;
			
			cx_bitmap = xxx.getBitmapCacheManager ().get ("CX:CXClass");
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
//			m_bitmap.cleanup ();
			
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
		public function setModel (__model:XSubmapModel):void {
			m_submapModel = __model;
			
			m_boundingRect = m_submapModel.boundingRect.cloneX ();
						
			refresh ();
		}
				
//------------------------------------------------------------------------------------------
		public function refresh ():void {
			m_bitmap.bitmapData.lock ();

			var __width:Number = m_submapModel.width;
			var __height:Number = m_submapModel.height;
						
			tempRect.x = 0;
			tempRect.y = 0;
			tempRect.width = m_submapModel.width;
			tempRect.height = m_submapModel.height;
			
			m_bitmap.bitmapData.fillRect (
//				new XRect (0, 0, m_submapModel.width, m_submapModel.height), 0x00000000
				tempRect, 0x00000000
			);
		
			__vline (0);
			__vline (__width-1);
			__hline (0);
			__hline (__height-1);
		
			__tiles ();
		
			m_bitmap.bitmapData.unlock ();
				
			function __tiles ():void {
				var __col:Number;
				var __row:Number;
				var __rect:XRect;
//				var __p:XPoint = new XPoint ();
		
//				__rect = new XRect (0, 0, XSubmapModel.CX_TILE_WIDTH, XSubmapModel.CX_TILE_HEIGHT);
	
				tempRect.x = 0;
				tempRect.y = 0;
				tempRect.width = XSubmapModel.CX_TILE_WIDTH;
				tempRect.height = XSubmapModel.CX_TILE_HEIGHT;
							
				for (__row=0; __row < m_submapModel.rows; __row++) {
					for (__col=0; __col < m_submapModel.cols; __col++) {
						cx_bitmap.goto (m_submapModel.getCXTile (__col, __row)+1);
																					
						tempPoint.x = __col << 4;
						tempPoint.y = __row << 4;
						
						m_bitmap.bitmapData.copyPixels (
							cx_bitmap.bitmapData, tempRect, tempPoint, null, null, true
						);
					}
				}
			}
			
			function __vline (x:Number):void {
				var y:Number;
				
				for (y=0; y<__height; y++) {
					m_bitmap.bitmapData.setPixel32 (x, y, 0xffff00ff);
				}
			}
			
			function __hline (y:Number):void {
				var x:Number;
				
				for (x=0; x<__width; x++) {
					m_bitmap.bitmapData.setPixel32 (x, y, 0xffff00ff);
				}
			}
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
			m_bitmap = m_XMapView.getSubmapBitmapPoolManager ().borrowObject () as XBitmap;
// !STARLING!
			if (CONFIG::flash) {
				x_sprite = addSpriteAt (m_bitmap, 0, 0);
				x_sprite.setDepth (getDepth ());
			}
			
			show ();
		}

//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
