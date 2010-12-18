//------------------------------------------------------------------------------------------
package X.World {

// Box2D classes
//	import Box2D.Collision.*;
//	import Box2D.Collision.Shapes.*;
//	import Box2D.Common.Math.*;
//	import Box2D.Dynamics.*;
	
// X classes
	import X.*;
	import X.Geom.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	import X.XMap.*;
	
	import flash.geom.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------	
	public class XLogicManager extends Object {
		private var xxx:XWorld;
		private var m_XLogicObjects:Dictionary;
		private var m_XLogicObjectsTopLevel:Dictionary;
		private var m_killList:Array;
		
//------------------------------------------------------------------------------------------
		public function XLogicManager (__xxx:XWorld) {
			xxx = __xxx;
			
			m_XLogicObjects = new Dictionary ();
			m_XLogicObjectsTopLevel = new Dictionary ();
			
			m_killList = new Array ();
		}

//------------------------------------------------------------------------------------------
		public function createXLogicObjectFromClassName (
			__parent:XLogicObject,
			__className:String,
			__item:XMapItemModel, __layer:Number, __depth:Number,
			__x:Number, __y:Number, __z:Number, 
			__scale:Number, __rotation:Number,
			...args
			):XLogicObject {
				
			var __class:Class = xxx.getClass (__className);
			
			var __logicObject:XLogicObject = new (__class) () as XLogicObject;
				
			return __initXLogicObject (
				__parent,
				__logicObject,
				__item, __layer, __depth,
				__x, __y, __z,
				__scale, __rotation,
				args);
		}
		
//------------------------------------------------------------------------------------------
		public function initXLogicObjectFromXML (
			__parent:XLogicObject,
			__logicObject:XLogicObject,
			...args
			):XLogicObject {
				
			if (__logicObject.iClassName != "") {
				return __initXLogicObject (
						__parent,
						__logicObject,
						__logicObject.iItem, __logicObject.iLayer, __logicObject.iDepth,
						__logicObject.iX, __logicObject.iY, 0,
						__logicObject.iScale, __logicObject.iRotation,
						[__logicObject.iClassName]);				
			}
			else
			{
				return __initXLogicObject (
						__parent,
						__logicObject,
						__logicObject.iItem, __logicObject.iLayer, __logicObject.iDepth,
						__logicObject.iX, __logicObject.iY, 0,
						__logicObject.iScale, __logicObject.iRotation,
						args);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function initXLogicObject (
			__parent:XLogicObject,
			__logicObject:XLogicObject,
			__item:XMapItemModel, __layer:Number, __depth:Number,
			__x:Number, __y:Number, __z:Number, 
			__scale:Number, __rotation:Number,
			...args
			):XLogicObject {

			return __initXLogicObject (
					__parent,
					__logicObject,
					__item, __layer, __depth,
					__x, __y, __z,
					__scale, __rotation,
					args
				);
		}

//------------------------------------------------------------------------------------------
		public function initXLogicObjectRel (
			__parent:XLogicObject,
			__logicObject:XLogicObject,
			__item:XMapItemModel, __layer:Number, __depth:Number, __relative:Boolean,
			__x:Number, __y:Number, __z:Number, 
			__scale:Number, __rotation:Number,
			...args
			):XLogicObject {
				
			return __initXLogicObjectRel (
					__parent,
					__logicObject,
					__item, __layer, __depth, __relative,
					__x, __y, __z,
					__scale, __rotation,
					args
				);
		}
					
//------------------------------------------------------------------------------------------
		public function __initXLogicObject (
			__parent:XLogicObject,
			__logicObject:XLogicObject,
			__item:XMapItemModel, __layer:Number, __depth:Number,
			__x:Number, __y:Number, __z:Number, 
			__scale:Number, __rotation:Number,
			args:Array
			):XLogicObject {

			xxx.addChild (__logicObject);
			
			__logicObject.setDepth (__depth);
			__logicObject.setRelativeDepthFlag (false);
			__logicObject.setLayer (__layer);
									
			trace (": XLogicManager:init: ", __logicObject, args.length, args);
							
			__logicObject.setup (xxx, args);

			__logicObject.setItem (__item);
			__logicObject.setPos (new XPoint (__x, __y));			
//			__logicObject.setLayer (__layer);
//			__logicObject.setDepth (__depth);
			__logicObject.setScale (__scale);
			__logicObject.setRotation (__rotation);
			__logicObject.setParent (__parent);
			
			__logicObject.setupX ();
						
//			xxx.addChild (__logicObject);
			
			m_XLogicObjects[__logicObject] = 0;
			
			if (__parent == null) {
				m_XLogicObjectsTopLevel[__logicObject] = 0;
			}
			
			return __logicObject;
		}
		
//------------------------------------------------------------------------------------------
		public function __initXLogicObjectRel (
			__parent:XLogicObject,
			__logicObject:XLogicObject,
			__item:XMapItemModel, __layer:Number, __depth:Number, __relative:Boolean,
			__x:Number, __y:Number, __z:Number, 
			__scale:Number, __rotation:Number,
			...args
			):XLogicObject {

			xxx.addChild (__logicObject);
			
			__logicObject.setDepth (__depth);
			__logicObject.setRelativeDepthFlag (__relative);
			__logicObject.setLayer (__layer);
									
			trace (": XLogicManager:init: ", __logicObject, args.length, args);
							
			__logicObject.setup (xxx, args);

			__logicObject.setItem (__item);
			__logicObject.setPos (new XPoint (__x, __y));			
//			__logicObject.setLayer (__layer);
//			__logicObject.setDepth (__depth);
			__logicObject.setScale (__scale);
			__logicObject.setRotation (__rotation);
			__logicObject.setParent (__parent);
			
			__logicObject.setupX ();
						
//			xxx.addChild (__logicObject);
			
			m_XLogicObjects[__logicObject] = 0;
			
			if (__parent == null) {
				m_XLogicObjectsTopLevel[__logicObject] = 0;
			}
			
			return __logicObject;
		}

//------------------------------------------------------------------------------------------
		public function kill (__object:XLogicObject):void {
			trace (": kill? ", __object);
			
			if (m_killList.indexOf (__object) == -1) {
				m_killList.push (__object);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function cleanupKills ():void {
			var i:Number;
					
			for (i=0; i<m_killList.length; i++) {
				var x:XLogicObject = m_killList[i] as XLogicObject;
				
				x.quit ();
				
				delete m_XLogicObjects[x];
				
				if (x in m_XLogicObjectsTopLevel) {
					delete m_XLogicObjectsTopLevel[x];
				}
				
				trace (": kill: ", x, x.m_GUID, x.xxx, xxx);
				
				xxx.removeChild (x);
				
				if (x.getParent () != null) {
					x.getParent ().removeXLogicObject0 (x);
				}
			}
			
			m_killList = new Array ();
		}

//------------------------------------------------------------------------------------------
		public function getXLogicObjects ():Dictionary {
			return m_XLogicObjects;
		}
		
//------------------------------------------------------------------------------------------
		public function updateLogic ():void {
			var x:*;
			
			for (x in m_XLogicObjects) {
				x.updateLogic ();
			}
		}

//------------------------------------------------------------------------------------------
		public function updatePhysics ():void {
			var x:*;
			
			for (x in m_XLogicObjects) {
				x.updatePhysics ();
			}
		}
		
//------------------------------------------------------------------------------------------
		public function cullObjects ():void {
			var x:*;
			
			for (x in m_XLogicObjects) {
				x.cullObject ();
			}
		}

//------------------------------------------------------------------------------------------
		public function setValues ():void {
			var x:*;
			
			for (x in m_XLogicObjects) {
				x.setValues ();
			}
		}
		
//------------------------------------------------------------------------------------------
		public function updateDisplay ():void {			
			var x:*;
					
			for (x in m_XLogicObjectsTopLevel) {
				x.x2 = x.y2 = 0;
				x.setMasterAlpha (x.getAlpha ());
				x.setMasterDepth (x.getDepth ());
				x.setMasterVisible (x.getVisible ());
				x.setMasterScaleX (x.getScaleX ());
				x.setMasterScaleY (x.getScaleY ());
				x.setMasterRotation (x.getRotation ());
						
				x.updateDisplay ();
			}
		}

//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
