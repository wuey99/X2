//------------------------------------------------------------------------------------------
// Copyright (C) 2014 Jimmy Huey
//
// Some Rights Reserved.
//
// The "X-Engine" is licensed under a Creative Commons
// Attribution-Share Alike 3.0 United States License.
// (CC BY-SA 3.0)
//
// You are free to:
//
//      SHARE - to copy, distribute, display and perform the work.
//      ADAPT - remix, transform build upon this material, even for commercial works.
//
//      The licensor cannot revoke these freedoms as long as you follow the license terms.
//
// Under the following terms:
//
//      ATTRIBUTION — 
//      You must give appropriate credit, provide a link to the license, and
//      indicate if changes were made.  You may do so in any reasonable manner,
//      but not in any way that suggests the licensor endorses you or your use.
//
//      SHARE-ALIKE -
//      If you remix, transform, or build upon the material, you must
//      distribute your contributions under the same license as the original.
//
// No additional restrictions — You may not apply legal terms or technological measures
// that legally restrict others from doing anything the license permits. 
//
// The full summary can be located at:
// http://creativecommons.org/licenses/by-sa/3.0/us/ 
//
// The human-readable summary of the Legal Code can be located at:
// http://creativecommons.org/licenses/by-sa/3.0/us/legalcode
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
