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
		private var m_submapModel:XSubmapModel;

//------------------------------------------------------------------------------------------	
		public function XSubmapTiles () {
			m_submapModel = null;
		}

//------------------------------------------------------------------------------------------			
		public override function init (__xxx:XWorld, args:Array):void {
			super.init (__xxx, args);
			
			createSprites ();
		}

//------------------------------------------------------------------------------------------
		public function setModel (__model:XSubmapModel):void {
			m_submapModel = __model;
			
			m_boundingRect = m_submapModel.boundingRect.clone ();
	
			m_sprite.graphics.lineStyle (2, 0xff00ff);		
			m_sprite.graphics.moveTo (0, 0);
			m_sprite.graphics.lineTo (0, m_submapModel.height-1);
			m_sprite.graphics.lineTo (m_submapModel.width-1, m_submapModel.height-1);
			m_sprite.graphics.lineTo (m_submapModel.width-1, 0);
			m_sprite.graphics.lineTo (0, 0);
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
			m_sprite = new Sprite ();
			
			addSpriteAt (m_sprite, 0, 0);
			
			m_sprite.graphics.clear ();
				
			show ();
		}

//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
