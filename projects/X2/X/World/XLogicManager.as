﻿//------------------------------------------------------------------------------------------
// <$begin$/>
// Copyright (C) 2014 Jimmy Huey
//
// Some Rights Reserved.
//
// The "X-Engine" is licensed under a Creative Commons
// Attribution-NonCommerical-ShareAlike 3.0 Unported License.
// (CC BY-NC-SA 3.0)
//
// You are free to:
//
//      SHARE - to copy, distribute, display and perform the work.
//      ADAPT - remix, transform build upon this material.
//
//      The licensor cannot revoke these freedoms as long as you follow the license terms.
//
// Under the following terms:
//
//      ATTRIBUTION -
//          You must give appropriate credit, provide a link to the license, and
//          indicate if changes were made.  You may do so in any reasonable manner,
//          but not in any way that suggests the licensor endorses you or your use.
//
//      SHAREALIKE -
//          If you remix, transform, or build upon the material, you must
//          distribute your contributions under the same license as the original.
//
//      NONCOMMERICIAL -
//          You may not use the material for commercial purposes.
//
// No additional restrictions - You may not apply legal terms or technological measures
// that legally restrict others from doing anything the license permits.
//
// The full summary can be located at:
// http://creativecommons.org/licenses/by-nc-sa/3.0/
//
// The human-readable summary of the Legal Code can be located at:
// http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode
//
// The "X-Engine" is free for non-commerical use.
// For commercial use, you will need to provide additional credits.
// Please contact me @ wuey99[dot]gmail[dot]com for more details.
// <$end$/>
//------------------------------------------------------------------------------------------
package X.World {

// X classes
	import X.*;
	import X.Collections.*;
	import X.Geom.*;
	import X.Task.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	import X.XMap.*;
	
	import flash.geom.*;
	
//------------------------------------------------------------------------------------------	
	public class XLogicManager extends Object {
		private var xxx:XWorld;
		private var m_XTaskManager:XTaskManager;
		private var m_XTaskManagerCX:XTaskManager;
		private var m_XLogicObjects:XDict;
		private var m_XLogicObjectsTopLevel:XDict;
		private var m_killQueue:XDict;
		private var m_paused:Boolean;
		
//------------------------------------------------------------------------------------------
		public function XLogicManager (__XApp:XApp, __xxx:XWorld) {
			xxx = __xxx;
			
			m_XLogicObjects = new XDict ();
			m_XLogicObjectsTopLevel = new XDict ();
			m_XTaskManager = new XTaskManager (__XApp);
			m_XTaskManagerCX = new XTaskManager (__XApp);
			
			m_killQueue = new XDict ();
		}

//------------------------------------------------------------------------------------------
		public function cleanup ():void {
			m_XTaskManager.removeAllTasks ();
			m_XTaskManagerCX.removeAllTasks ();
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
				null,
				__item, __layer, __depth,
				__x, __y, __z,
				__scale, __rotation,
				args);
		}
		
//------------------------------------------------------------------------------------------
		public function initXLogicObjectFromPool (
			__parent:XLogicObject,
			__class:Class,
			__item:XMapItemModel, __layer:Number, __depth:Number,
			__x:Number, __y:Number, __z:Number, 
			__scale:Number, __rotation:Number,
			...args
		):XLogicObject {
			
			var __logicObject:XLogicObject = xxx.getXLogicObjectPoolManager ().borrowObject (__class) as XLogicObject;
			
			return __initXLogicObject (
				__parent,
				__logicObject,
				__class,
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
						null,
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
						null,
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
					null,
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
					null,
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
			__class:Class,
			__item:XMapItemModel, __layer:Number, __depth:Number,
			__x:Number, __y:Number, __z:Number, 
			__scale:Number, __rotation:Number,
			args:Array
			):XLogicObject {

			xxx.addChild (__logicObject);
			
			__logicObject.XLogicManager = this;
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
			__logicObject.oAlpha = 1.0;
			
			if (__class) {
				__logicObject.setPoolClass (__class);
			}
			
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
			__class:Class,
			__item:XMapItemModel, __layer:Number, __depth:Number, __relative:Boolean,
			__x:Number, __y:Number, __z:Number, 
			__scale:Number, __rotation:Number,
			args:Array
			):XLogicObject {

			xxx.addChild (__logicObject);
			
			__logicObject.XLogicManager = this;
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
			__logicObject.oAlpha = 1.0;
			
			if (__class) {
				__logicObject.setPoolClass (__class);
			}
			
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
			
			if (!m_killQueue.exists (__object)) {
				m_killQueue.put (__object, 0);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function emptyKillQueue ():void {	
			m_killQueue.forEach (
				function (x:*):void {
					var __logicObject:XLogicObject = x as XLogicObject;
					
					__logicObject.cleanup ();
					
					removeXLogicObject (__logicObject);
					
					m_killQueue.remove (__logicObject);
				}
			);
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
				if (CONFIG::starling) {
					xxx.removeChild (x, true);
				}
				else
				{
					xxx.removeChild (x);
				}
			}
		}
		
//------------------------------------------------------------------------------------------
		public function getXLogicObjects ():XDict {
			return m_XLogicObjects;
		}

//------------------------------------------------------------------------------------------
		public function updateTasks ():void {
			m_XTaskManager.updateTasks ();
			m_XTaskManagerCX.updateTasks ();
		}
		
//------------------------------------------------------------------------------------------
		public function getXTaskManager ():XTaskManager {
			return m_XTaskManager;
		}

//------------------------------------------------------------------------------------------
		public function getXTaskManagerCX ():XTaskManager {
			return m_XTaskManagerCX;
		}
		
//------------------------------------------------------------------------------------------
		public function setCollisions ():void {
			m_XLogicObjects.forEach (
				function (x:*):void {
					var __logicObject:XLogicObject = x as XLogicObject;
					
					if (!__logicObject.isDead) {
						__logicObject.setCollisions ();
					}
				}
			);		
		}
		
//------------------------------------------------------------------------------------------
		public function updateLogic ():void {
			m_XLogicObjects.forEach (
				function (x:*):void {
					var __logicObject:XLogicObject = x as XLogicObject;
					
					if (!__logicObject.isDead) {
						__logicObject.updateLogic ();
					}
				}
			);		
		}

//------------------------------------------------------------------------------------------
		public function updatePhysics ():void {
			m_XLogicObjects.forEach (
				function (x:*):void {
					var __logicObject:XLogicObject = x as XLogicObject;
					
					if (!__logicObject.isDead) {
						__logicObject.updatePhysics ();
					}
				}
			);
		}
		
//------------------------------------------------------------------------------------------
		public function cullObjects ():void {
			m_XLogicObjectsTopLevel.forEach (
				function (x:*):void {
					var __logicObject:XLogicObject = x as XLogicObject;
					
					if (!__logicObject.isDead) {
						__logicObject.cullObject ();
					}
				}
			);
		}

//------------------------------------------------------------------------------------------
		public function setValues ():void {
			m_XLogicObjects.forEach (
				function (x:*):void {
					var __logicObject:XLogicObject = x as XLogicObject;
					
					if (!__logicObject.isDead) {
						__logicObject.setValues ();
					}
				}
			);
		}
		
//------------------------------------------------------------------------------------------
		public function updateDisplay ():void {					
			m_XLogicObjectsTopLevel.forEach (
				function (x:*):void {
					var __logicObject:XLogicObject = x as XLogicObject;
				
					if (!__logicObject.isDead) {
						__logicObject.x2 = __logicObject.y2 = 0;
						__logicObject.setMasterAlpha (__logicObject.getAlpha ());
						__logicObject.setMasterDepth (__logicObject.getDepth ());
						__logicObject.setMasterVisible (__logicObject.getVisible ());
						__logicObject.setMasterScaleX (__logicObject.getScaleX ());
						__logicObject.setMasterScaleY (__logicObject.getScaleY ());
						__logicObject.setMasterRotation (__logicObject.getRotation ());
								
						__logicObject.updateDisplay ();
					}
				}
			);
		}

//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
