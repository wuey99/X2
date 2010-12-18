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
	public class XSubmapTiles extends XLogicObject {
		private var m_submapModel:XSubmapModel;
		
		private var m_bitmap:XBitmap;
		private var x_sprite:XDepthSprite;
		
		private var cx_sprite:MovieClip;
		private var cx_bitmap:XBitmap;
		
//------------------------------------------------------------------------------------------	
		public function XSubmapTiles () {
			m_submapModel = null;
		}

//------------------------------------------------------------------------------------------			
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			createSprites ();
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function setModel (__model:XSubmapModel):void {
			m_submapModel = __model;
			
			__generateTiledDisplay ();
		}
				
//------------------------------------------------------------------------------------------
		public function __generateTiledDisplay ():void {
			m_boundingRect = m_submapModel.boundingRect.clone ();
			
			var __width:Number = m_submapModel.width;
			var __height:Number = m_submapModel.height;
	
			m_bitmap.createBitmap ("tiles", __width, __height);
				
			m_bitmap.bitmapData.fillRect (
				new Rectangle (0, 0, m_submapModel.width, m_submapModel.height),
				0x00000000
			);
		
			__vline (0);
			__vline (__width-1);
			__hline (0);
			__hline (__height-1);
		
			__tiles ();
			
			function __tiles ():void {
				var __col:Number;
				var __row:Number;
				var __rect:Rectangle;
				var __p:XPoint = new XPoint ();
		
				__rect = new Rectangle (0, 0, XSubmapModel.CX_TILE_WIDTH, XSubmapModel.CX_TILE_HEIGHT);
				
				trace (": submapModel: ", m_submapModel);
		
				for (__row=0; __row < m_submapModel.rows; __row++) {
					for (__col=0; __col < m_submapModel.cols; __col++) {
						cx_bitmap.goto (m_submapModel.getCXTile (__col, __row)+1);
//						cx_bitmap.goto (XSubmapModel.CX_SOLID + 1);
																
						__p.x = __col << 4;
						__p.y = __row << 4;
						
						m_bitmap.bitmapData.copyPixels (
							cx_bitmap.bitmapData, __rect, __p, null, null, true
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
// kill this object and remove it from the World
//------------------------------------------------------------------------------------------
		public override function kill ():void {
			
// let the Object Manager handle the kill
			xxx.getXLogicManager ().kill (this);

			if (m_submapModel != null) {
				fireKillSignal (m_submapModel);
							
				m_submapModel.inuse--;
				
				m_submapModel = null;
			}
		}
		
//------------------------------------------------------------------------------------------
// cull this object if it strays outside the current viewPort
//------------------------------------------------------------------------------------------	
		public override function cullObject ():void {

// determine whether this object is outside the current viewPort
			var v:Rectangle = xxx.getXMapModel ().getViewRect ();
				
			var r:Rectangle = xxx.getXWorldLayer (m_layer).viewPort (v.width, v.height);
			r.inflate (256, 256);

			var i:Rectangle;

			i = m_boundingRect.clone ();
			i.offsetPoint (getPos ());
			
			if (r.intersects (i)) {
				return;
			}
			
// yep, kill it
			trace (": ---------------------------------------: ");
			trace (": cull: ", this);
			
			kill ();
		}
		
//------------------------------------------------------------------------------------------
// create sprites
//------------------------------------------------------------------------------------------
		public override function createSprites ():void {
			m_bitmap = new XBitmap ();
			x_sprite = addSpriteAt (m_bitmap, 0, 0);
			x_sprite.setDepth (getDepth ());
			
			cx_sprite = new (xxx.getClass ("CX:CXClass")) ();
			cx_bitmap = new XBitmap ();
			cx_bitmap.initWithScaling (cx_sprite, 1.0);
			
			show ();
		}

//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
