//------------------------------------------------------------------------------------------
package X.Game {
	
	import X.Collections.*;
	import X.Geom.*;
	import X.Pool.*;
	import X.World.XWorld;
	import X.XMap.*;
	
//------------------------------------------------------------------------------------------
	public class XBulletCollisionList extends Object {
		private var xxx:XWorld;
		private var m_XMapModel:XMapModel;
		private var m_rects:Array;
		private var m_XSubRectPoolManager:XSubObjectPoolManager;
		
//------------------------------------------------------------------------------------------
		public function XBulletCollisionList () {
			super ();
			
			xxx = null;
			m_XMapModel = null;
		}
		
//------------------------------------------------------------------------------------------
		public function setup (__xxx:XWorld, __XMapModel:XMapModel):void {
			xxx = __xxx;
			
			m_XMapModel = __XMapModel;
			
			m_rects = new Array ();
			
			var i:Number;
			
			for (i=0; i<m_XMapModel.getNumLayers (); i++) {
				m_rects[i] = new Array ();
			}
			
			m_XSubRectPoolManager = new XSubObjectPoolManager (xxx.getXRectPoolManager ());
			
			clear ();
		}
		
//------------------------------------------------------------------------------------------
		public function cleanup ():void {
			clear ();
		}

//------------------------------------------------------------------------------------------		
		public function clear ():void {
			var i:Number;
			
			for (i=0; i<m_XMapModel.getNumLayers (); i++) {
				m_rects[i].slice (0);
			}
			
			m_XSubRectPoolManager.returnAllObjects ();
		}
	
//------------------------------------------------------------------------------------------
		public function setCollision (__layer:Number, __x:Number, __y:Number, __width:Number, __height:Number):void {
			var __rect:XRect = m_XSubRectPoolManager.borrowObject () as XRect;
			
			__rect.setRect (__x, __y, __width, __height);
			
			m_rects[__layer].push (__rect);
		}

//------------------------------------------------------------------------------------------
		public function getRects (__layer:Number):Array {
			return m_rects[__layer];
		}
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}
