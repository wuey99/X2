//------------------------------------------------------------------------------------------
// <$begin$/>
// <$end$/>
//------------------------------------------------------------------------------------------
package X.Game {
	
	import X.Collections.*;
	import X.Geom.*;
	import X.Pool.*;
	import X.World.Logic.*;
	import X.World.XWorld;
	import X.XMap.*;
	
//------------------------------------------------------------------------------------------
	public class XBulletCollisionList extends Object {
		private var xxx:XWorld;
		private var m_rects:Array;
		private var m_XSubRectPoolManager:XSubObjectPoolManager;
		
//------------------------------------------------------------------------------------------
		public function XBulletCollisionList () {
			super ();
			
			xxx = null;
		}
		
//------------------------------------------------------------------------------------------
		public function setup (__xxx:XWorld):void {
			xxx = __xxx;		
			m_rects = new Array ();
			
			var i:Number;
			
			for (i=0; i < xxx.getMaxLayers (); i++) {
				m_rects[i] = new XDict ();
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

			for (i=0; i < xxx.getMaxLayers (); i++) {
				m_rects[i].removeAll ();
			}
			
			m_XSubRectPoolManager.returnAllObjects ();
		}
	
//------------------------------------------------------------------------------------------
		public function addCollision (
			__layer:Number,
			__logicObject:XLogicObject,
			__srcPoint:XPoint, __srcRect:XRect
			):void {

			var __rect:XRect = m_XSubRectPoolManager.borrowObject () as XRect;
			__srcRect.copy2 (__rect); __rect.offsetPoint (__srcPoint);
			m_rects[__layer].put (__logicObject, __rect);
		}

//------------------------------------------------------------------------------------------
		public function findCollision (
			__layer:Number,
			__srcPoint:XPoint,
			__srcRect:XRect
		):XLogicObject {
			
			var __logicObject:XLogicObject = null;
			
			var __rect:XRect = m_XSubRectPoolManager.borrowObject () as XRect;
			__srcRect.copy2 (__rect); __rect.offsetPoint (__srcPoint);
			
			m_rects[__layer].forEach (
				function (x:*):void {
					if (XRect (m_rects[__layer].get (x)).intersects (__rect)) {
						__logicObject = x as XLogicObject;
					}
				}
			);	
			
			m_XSubRectPoolManager.returnObject (__rect);
	
			return __logicObject;
		}
		
//------------------------------------------------------------------------------------------
		public function findCollisions (
			__layer:Number,
			__srcPoint:XPoint,
			__srcRect:XRect
			):Array {

			var __logicObjects:Array = new Array ();

			var __rect:XRect = m_XSubRectPoolManager.borrowObject () as XRect;
			__srcRect.copy2 (__rect); __rect.offsetPoint (__srcPoint);

			m_rects[__layer].forEach (
				function (x:*):void {
					if (XRect (m_rects[__layer].get (x)).intersects (__rect)) {
						__logicObjects.push (x);
					}
				}
			);	
			
			m_XSubRectPoolManager.returnObject (__rect);
			
			return __logicObjects;
		}
		
//------------------------------------------------------------------------------------------
		public function getRects (__layer:Number):XDict {
			return m_rects[__layer];
		}

//------------------------------------------------------------------------------------------
		public function getList (__layer:Number):XDict {
			return m_rects[__layer];
		}
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}
