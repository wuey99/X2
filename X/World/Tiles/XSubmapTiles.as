//------------------------------------------------------------------------------------------
package X.World.Tiles {

	import X.*;
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
		private var m_sprite:Sprite;
		private var x_sprite:XDepthSprite;
		private var m_XSubmapModel:XSubmapModel;

//------------------------------------------------------------------------------------------	
		public function XSubmapTiles () {
		}

//------------------------------------------------------------------------------------------			
		public override function init (__xxx:XWorld, args:Array):void {
			super.init (__xxx, args);
			
			createSprites ();
		}

//------------------------------------------------------------------------------------------
		public function setModel (__model:XSubmapModel):void {
			m_XSubmapModel = __model;
			
			m_boundingRect = m_XSubmapModel.boundingRect.clone ();
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
			m_sprite = new Sprite ();
			
			addSpriteAt (m_sprite, 0, 0);
			
			m_sprite.graphics.clear ();
			m_sprite.graphics.beginFill (0x303030);
			m_sprite.graphics.drawRect (0, 0, 128, 128)
				
			show ();
		}

//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
