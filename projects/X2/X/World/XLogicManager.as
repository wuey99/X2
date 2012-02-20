﻿//------------------------------------------------------------------------------------------
package X.World {

// X classes
	import X.*;
	import X.Collections.*;
	import X.Geom.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	import X.XMap.*;
	
	import flash.geom.*;
	
//------------------------------------------------------------------------------------------	
	public class XLogicManager extends Object {
		private var xxx:XWorld;
		private var m_XLogicObjects:XDict;
		private var m_XLogicObjectsTopLevel:XDict;
		private var m_killQueue:Array;
		
//------------------------------------------------------------------------------------------
		public function XLogicManager (__xxx:XWorld) {
			xxx = __xxx;
			
			m_XLogicObjects = new XDict ();
			m_XLogicObjectsTopLevel = new XDict ();
			
			m_killQueue = new Array ();
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
									
//			trace (": XLogicManager:init: ", __logicObject, args.length, args);
							
			__logicObject.setup (xxx, args);

			__logicObject.setItem (__item);
//			__logicObject.setPos (new XPoint (__x, __y));
			__logicObject.oX = __x;
			__logicObject.oY = __y;
//			__logicObject.setLayer (__layer);
//			__logicObject.setDepth (__depth);
			__logicObject.setScale (__scale);
			__logicObject.setRotation (__rotation);
			__logicObject.setParent (__parent);
			
			__logicObject.setupX ();
						
//			xxx.addChild (__logicObject);
			
			m_XLogicObjects.put (__logicObject, 0);
			
			if (__parent == null) {
				m_XLogicObjectsTopLevel.put (__logicObject, 0);
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
			args:Array
			):XLogicObject {

			xxx.addChild (__logicObject);
			
			__logicObject.setDepth (__depth);
			__logicObject.setRelativeDepthFlag (__relative);
			__logicObject.setLayer (__layer);

//			trace (": XLogicManager:init: ", __logicObject, args.length, args);
							
			__logicObject.setup (xxx, args);

			__logicObject.setItem (__item);
//			__logicObject.setPos (new XPoint (__x, __y));
			__logicObject.oX = __x;
			__logicObject.oY = __y;
//			__logicObject.setLayer (__layer);
//			__logicObject.setDepth (__depth);
			__logicObject.setScale (__scale);
			__logicObject.setRotation (__rotation);
			__logicObject.setParent (__parent);
			
			__logicObject.setupX ();
						
//			xxx.addChild (__logicObject);
			
			m_XLogicObjects.put (__logicObject, 0);
			
			if (__parent == null) {
				m_XLogicObjectsTopLevel.put (__logicObject, 0);
			}
			
			return __logicObject;
		}

//------------------------------------------------------------------------------------------
		public function killLater (__object:XLogicObject):void {
//			trace (": kill? ", __object);
			
			if (m_killQueue.indexOf (__object) == -1) {
				m_killQueue.push (__object);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function emptyKillQueue ():void {
			var i:Number;
					
			for (i=0; i<m_killQueue.length; i++) {
				var x:XLogicObject = m_killQueue[i] as XLogicObject;
				
				x.cleanup ();
				
				removeXLogicObject (x);
			}
			
			m_killQueue = new Array ();
		}

//------------------------------------------------------------------------------------------
		public function removeXLogicObject (x:XLogicObject):void {
			if (m_XLogicObjects.exists (x)) {
				m_XLogicObjects.remove (x);
			}
						
			if (m_XLogicObjectsTopLevel.exists (x)) {
				m_XLogicObjectsTopLevel.remove (x);
			}
				
//			trace (": kill: ", x, x.m_GUID, x.xxx, xxx);
				
			if (xxx.contains (x)) {
				xxx.removeChild (x);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function getXLogicObjects ():XDict {
			return m_XLogicObjects;
		}
		
//------------------------------------------------------------------------------------------
		public function updateLogic ():void {
			m_XLogicObjects.forEach (
				function (x:*):void {
					x.updateLogic ();
				}
			);		
		}

//------------------------------------------------------------------------------------------
		public function updatePhysics ():void {
			m_XLogicObjects.forEach (
				function (x:*):void {
					x.updatePhysics ();
				}
			);
		}
		
//------------------------------------------------------------------------------------------
		public function cullObjects ():void {
			m_XLogicObjectsTopLevel.forEach (
				function (x:*):void {
					x.cullObject ();
				}
			);
		}

//------------------------------------------------------------------------------------------
		public function setValues ():void {
			m_XLogicObjects.forEach (
				function (x:*):void {
					x.setValues ();
				}
			);
		}
		
//------------------------------------------------------------------------------------------
		public function updateDisplay ():void {					
			m_XLogicObjectsTopLevel.forEach (
				function (x:*):void {
					var logicObject:XLogicObject = x as XLogicObject;
					
					logicObject.x2 = logicObject.y2 = 0;
					logicObject.setMasterAlpha (logicObject.getAlpha ());
					logicObject.setMasterDepth (logicObject.getDepth ());
					logicObject.setMasterVisible (logicObject.getVisible ());
					logicObject.setMasterScaleX (logicObject.getScaleX ());
					logicObject.setMasterScaleY (logicObject.getScaleY ());
					logicObject.setMasterRotation (logicObject.getRotation ());
							
					logicObject.updateDisplay ();
				}
			);
		}

//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
