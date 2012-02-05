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
// this class probably more appropriately belongs in TikiEdit
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
		
//------------------------------------------------------------------------------------------	
		public function XSubmapTiles () {
			m_submapModel = null;
		}

//------------------------------------------------------------------------------------------			
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			createSprites ();
			
			tempRect = xxx.getXRectPoolManager ().borrowObject () as XRect;
			
			cx_bitmap = xxx.getBitmapCacheManager ().get ("CX:CXClass");
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			m_bitmap.cleanup ();
			
			removeAll ();
					
			xxx.getXRectPoolManager ().returnObject (tempRect);
			
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
			
			var __width:Number = m_submapModel.width;
			var __height:Number = m_submapModel.height;
	
			if (!m_bitmap.nameInBitmapNames ("tiles")) {
				m_bitmap.createBitmap ("tiles", __width, __height);
			}
						
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
				var __p:XPoint = new XPoint ();
		
//				__rect = new XRect (0, 0, XSubmapModel.CX_TILE_WIDTH, XSubmapModel.CX_TILE_HEIGHT);
	
				tempRect.x = 0;
				tempRect.y = 0;
				tempRect.width = XSubmapModel.CX_TILE_WIDTH;
				tempRect.height = XSubmapModel.CX_TILE_HEIGHT;
							
				for (__row=0; __row < m_submapModel.rows; __row++) {
					for (__col=0; __col < m_submapModel.cols; __col++) {
						cx_bitmap.goto (m_submapModel.getCXTile (__col, __row)+1);
																					
						__p.x = __col << 4;
						__p.y = __row << 4;
						
						m_bitmap.bitmapData.copyPixels (
							cx_bitmap.bitmapData, tempRect, __p, null, null, true
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
			trace (": ---------------------------------------: ");
			trace (": cull: ", this);
			
			killLater ();
		}
		
//------------------------------------------------------------------------------------------
// create sprites
//------------------------------------------------------------------------------------------
		public override function createSprites ():void {
			m_bitmap = new XBitmap ();
			x_sprite = addSpriteAt (m_bitmap, 0, 0);
			x_sprite.setDepth (getDepth ());
			
//			cx_sprite = new (xxx.getClass ("CX:CXClass")) ();
//			cx_bitmap = new XBitmap ();
//			cx_bitmap.initWithScaling (cx_sprite, 1.0);
			
			show ();
		}

//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
