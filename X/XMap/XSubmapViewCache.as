//------------------------------------------------------------------------------------------
package X.World.XMap {

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
// instead of maintaining an XLogicObject for an XMapItemModel (for the view), maintain a 
// view-cache/bitmap for eash Submap.  On initialization, all XMapItemModel's that flagged
// for caching are drawing directly into the Submap's view-cache/bitmap.
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
	public class XSubmapViewCache extends XLogicObject {
		private var m_submapModel:XSubmapModel;
		
		private var m_bitmap:XBitmap;
		private var x_sprite:XDepthSprite;
		
//------------------------------------------------------------------------------------------	
		public function XSubmapViewCache () {
			m_submapModel = null;
		}

//------------------------------------------------------------------------------------------			
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			createSprites ();
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			removeAll ();
			
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
	
			m_bitmap.createBitmap ("tiles", __width, __height);
		}

//------------------------------------------------------------------------------------------
// cull this object if it strays outside the current viewPort
//------------------------------------------------------------------------------------------	
		public override function cullObject ():void {

// determine whether this object is outside the current viewPort
			var v:XRect = xxx.getViewRect();
			
			var r:XRect = xxx.getXRectPoolManager ().borrowObject () as XRect;	
			var i:XRect = xxx.getXRectPoolManager ().borrowObject () as XRect;
			
			xxx.getXWorldLayer (m_layer).viewPort (v.width, v.height).copy2 (r);
			r.inflate (256, 256);
						
			m_item.boundingRect.copy2 (i);
			i.offsetPoint (getPos ());
			
			if (r.intersects (i)) {
				xxx.getXRectPoolManager ().returnObject (r);
				xxx.getXRectPoolManager ().returnObject (i);
				
				return;
			}
			
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
			
			show ();
		}

//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
