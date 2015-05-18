//------------------------------------------------------------------------------------------
// <$begin$/>
// The MIT License (MIT)
//
// The "X-Engine"
//
// Copyright (c) 2014 Jimmy Huey (wuey99@gmail.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
		private var m_XTaskManager0:XTaskManager;
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
			m_XTaskManager0 = new XTaskManager (__XApp);
			m_XTaskManager = new XTaskManager (__XApp);
			m_XTaskManagerCX = new XTaskManager (__XApp);
			
			m_killQueue = new XDict ();
		}

//------------------------------------------------------------------------------------------
		public function cleanup ():void {
			m_XTaskManager0.removeAllTasks ();
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
			m_XTaskManager0.updateTasks ();
			m_XTaskManager.updateTasks ();
			m_XTaskManagerCX.updateTasks ();
		}

//------------------------------------------------------------------------------------------
		public function getXTaskManager0 ():XTaskManager {
			return m_XTaskManager0;
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
