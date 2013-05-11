//------------------------------------------------------------------------------------------
package X {

// Box2D classes
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import X.Bitmap.*;
	import X.Debug.XDebug;
	import X.Geom.*;
	import X.MVC.*;
	import X.Pool.XObjectPoolManager;
	import X.Resource.Manager.*;
	import X.Signals.*;
	import X.Sound.*;
	import X.Task.*;
	import X.Texture.*;
	import X.World.*;
	import X.World.Sprite.XDepthSprite;
	import X.XMap.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.system.*;
	import flash.utils.Timer;
	
//------------------------------------------------------------------------------------------
	public class XApp extends Object {
		private var m_parent:Sprite;
		private var m_XTaskManager:XTaskManager;
		private var m_timer:Timer;
		private var m_inuse_TIMER_FRAME:Number;
		private var m_XDebug:XDebug;
		private var m_projectManager:XProjectManager;
		private var m_XSignalManager:XSignalManager;
		private var m_XSoundManager:XSoundManager;
		private var m_XBitmapCacheManager:XBitmapCacheManager;
		private var m_XBitmapDataAnimManager:XBitmapDataAnimManager;
		private var m_XSignalPoolManager:XObjectPoolManager;
		private var m_XRectPoolManager:XObjectPoolManager;
		private var m_XPointPoolManager:XObjectPoolManager;
		private var m_XDepthSpritePoolManager:XObjectPoolManager;
		private var m_XMovieClipCacheManager:XMovieClipCacheManager;
		
//------------------------------------------------------------------------------------------
		public function XApp () {
		}

//------------------------------------------------------------------------------------------
		public function setup (__poolSettings:Object):void {
			m_XTaskManager = new XTaskManager (this);
			m_XSignalManager = new XSignalManager (this);
			m_XSoundManager = new XSoundManager (this);
			m_XBitmapCacheManager = new XBitmapCacheManager (this);
			m_XBitmapDataAnimManager = new XBitmapDataAnimManager (this);
			m_XMovieClipCacheManager = new XMovieClipCacheManager (this);
			
			__initPoolManagers (__poolSettings);
			
			m_XDebug = new XDebug ();
			m_XDebug.setup (this);
			
			m_timer = new Timer (16, 0);
			m_timer.start ();
			m_timer.addEventListener (TimerEvent.TIMER, updateTimer);
			m_inuse_TIMER_FRAME = 0;
		}

//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}

//------------------------------------------------------------------------------------------
		public function getMaximalPoolSettings ():Object {
			return {
				XSignal: {init: 10000, overflow: 1000},
				XRect: {init: 25000, overflow: 1000},				
				XPoint: {init: 25000, overflow: 1000},
				XDepthSprite: {init: 4000, overflow: 1000}
			};
		}
		
//------------------------------------------------------------------------------------------
		public function getDefaultPoolSettings ():Object {
			return {
				XSignal: {init: 2000, overflow: 1000},
				XRect: {init: 2500, overflow: 1000},				
				XPoint: {init: 2500, overflow: 1000},
				XDepthSprite: {init: 2000, overflow: 1000}
			};
		}
		
//------------------------------------------------------------------------------------------
		private function __initPoolManagers (__poolSettings:Object):void {

//------------------------------------------------------------------------------------------
// XSignals
//------------------------------------------------------------------------------------------
			m_XSignalPoolManager = new XObjectPoolManager (
				function ():* {
					return new XSignal ();
				},
				
				function (__src:*, __dst:*):* {
					return null;
				},
				
				__poolSettings.XSignal.init, __poolSettings.XSignal.overflow
			);
				
//------------------------------------------------------------------------------------------
// XRect
//------------------------------------------------------------------------------------------
			m_XRectPoolManager = new XObjectPoolManager (
				function ():* {
					return new XRect ();
				},
				
				function (__src:*, __dst:*):* {
					var __rect1:XRect = __src as XRect;
					var __rect2:XRect = __dst as XRect;
					
					__rect2.x = __rect1.x;
					__rect2.y = __rect1.y;
					__rect2.width = __rect1.width;
					__rect2.height = __rect1.height;
					
					return __rect2;
				},
				
				__poolSettings.XRect.init, __poolSettings.XRect.overflow
			);
		
//------------------------------------------------------------------------------------------
// XPoint
//------------------------------------------------------------------------------------------
			m_XPointPoolManager = new XObjectPoolManager (
				function ():* {
					return new XPoint ();
				},
				
				function (__src:*, __dst:*):* {
					var __point1:XPoint = __src as XPoint;
					var __point2:XPoint = __dst as XPoint;
					
					__point2.x = __point1.x;
					__point2.y = __point1.y;

					return __point2;
				},
				
				__poolSettings.XPoint.init, __poolSettings.XPoint.overflow
			);

//------------------------------------------------------------------------------------------
// XDepthSprite
//------------------------------------------------------------------------------------------
			m_XDepthSpritePoolManager = new XObjectPoolManager (
				function ():* {
					var __sprite:XDepthSprite = new XDepthSprite ();
					__sprite.clear ();
					return __sprite;
				},
				
				function (__src:*, __dst:*):* {
					return null;
				},
				
				__poolSettings.XDepthSprite.init, __poolSettings.XDepthSprite.overflow
			);
		}
			
//------------------------------------------------------------------------------------------
		public function updateTimer (e:Event):void {
			if (m_inuse_TIMER_FRAME) {
				trace (": overflow: TIMER_FRAME: ");
				
				return;
			}

			m_inuse_TIMER_FRAME++;
			
			getXTaskManager ().updateTasks ();
			
			m_inuse_TIMER_FRAME--;
		}
		
//------------------------------------------------------------------------------------------
		public function getTime ():Number {
			var __date:Date = new Date ();
			
			return __date.time;
		}
		
//------------------------------------------------------------------------------------------
		public function getXTaskManager ():XTaskManager {
			return m_XTaskManager;
		}

//------------------------------------------------------------------------------------------
		public function getXSignalPoolManager ():XObjectPoolManager {
			return m_XSignalPoolManager;
		}

//------------------------------------------------------------------------------------------
		public function getXRectPoolManager ():XObjectPoolManager {
			return m_XRectPoolManager;
		}
		
//------------------------------------------------------------------------------------------
		public function getXPointPoolManager ():XObjectPoolManager {
			return m_XPointPoolManager;
		}

//------------------------------------------------------------------------------------------
		public function getXDepthSpritePoolManager ():XObjectPoolManager {
			return m_XDepthSpritePoolManager;
		}
						
//------------------------------------------------------------------------------------------
		public function createXSignal ():XSignal {
			return m_XSignalManager.createXSignal ();
		}
		
//------------------------------------------------------------------------------------------
		public function getXSignalManager ():XSignalManager {
			return m_XSignalManager;
		}

//------------------------------------------------------------------------------------------
		public function getXSoundManager ():XSoundManager {
			return m_XSoundManager;
		}
				
//------------------------------------------------------------------------------------------
		public function setProjectManager (__projectManager:XProjectManager):void {
			m_projectManager = __projectManager;
		}

//------------------------------------------------------------------------------------------
		public function getProjectManager ():XProjectManager {
			return m_projectManager;
		}

//------------------------------------------------------------------------------------------
		public function getBitmapCacheManager ():XBitmapCacheManager {
			return m_XBitmapCacheManager;
		}

//------------------------------------------------------------------------------------------
		public function getBitmapDataAnimManager ():XBitmapDataAnimManager {
			return m_XBitmapDataAnimManager;
		}

//------------------------------------------------------------------------------------------
		public function getXMovieClipCacheManager ():XMovieClipCacheManager {
			return m_XMovieClipCacheManager;
		}
		
//------------------------------------------------------------------------------------------
		public function getResourceManagerByName (__name:String):XSubResourceManager {
			return getProjectManager ().getResourceManagerByName (__name);
		}

//------------------------------------------------------------------------------------------
		public function getClass (__className:String):Class {
			return getProjectManager ().getClassByName (__className);
		}
		
//------------------------------------------------------------------------------------------
		public function getClassByName (__className:String):Class {
			return getProjectManager ().getClassByName (__className);
		}

//------------------------------------------------------------------------------------------
		public function disableDebug ():void {
			m_XDebug.disable (true);
		}
		
//------------------------------------------------------------------------------------------
		public function print (...args):void {
		 trace (args);
		}
	
//------------------------------------------------------------------------------------------
		public function getCommonClasses ():Boolean {
			trace (": -------------------------: ");
			trace (": getting common classes: ");
			
			getClass ("XLogicObjectXMap:XLogicObjectXMap");
			getClass ("ErrorImages:undefinedClass");
				
			return (
				getClass ("XLogicObjectXMap:XLogicObjectXMap") == null ||
				getClass ("ErrorImages:undefinedClass") == null
				)
		}

//------------------------------------------------------------------------------------------
// report memory leaks
//------------------------------------------------------------------------------------------
		public function reportMemoryLeaks (m_XApp:XApp, xxx:XWorld):void {
			var i:Number;
			var x:*;

			m_XApp.print ("------------------------------");
			m_XApp.print ("active XSignals xxx");
			
			i = 0;
			
			getXSignalManager ().getXSignals ().forEach (
				function (x:*):void {
					m_XApp.print (": signal: " + i + ": " + x + ", parent: " + x.getParent ());
				}
			);
			
			m_XApp.print ("------------------------------");
			m_XApp.print ("active XSignals XApp");
			
			i = 0;
			
			m_XApp.getXSignalManager ().getXSignals ().forEach (
				function (x:*):void {
					m_XApp.print (": signal: " + i + ": " + x + ", parent: " + x.getParent ());
				}
			);
									
			m_XApp.print ("------------------------------");
			m_XApp.print ("active XLogicObjects");

			i = 0;
				
			xxx.getXLogicManager ().getXLogicObjects ().forEach (
				function (x:*):void {
					m_XApp.print (": XLogicObject: " + i + ": " + x);
						
					i++;
				}
			);
							
			m_XApp.print ("------------------------------");
			m_XApp.print ("active tasks xxx: ");
				
			i = 0;
				
			xxx.getXTaskManager ().getTasks ().forEach (
				function (x:*):void {
					m_XApp.print (": task: " + i + ": " + x + ", parent: " + x.getParent ());
					
					i++;
				}	
			);

			m_XApp.print ("------------------------------");
			m_XApp.print ("active tasks XApp: ");
												
			m_XApp.getXTaskManager ().getTasks ().forEach (
				function (x:*):void {
					m_XApp.print (": task: " + i + ": " + x + ", parent: " + x.getParent ());
				}
			);
			
			m_XApp.print ("------------------------------");
			m_XApp.print ("XSignalPoolManager XApp: ");
			
			m_XApp.print (": XSignalPoolManager: " + m_XSignalPoolManager.numberOfBorrowedObjects ());
			
			m_XApp.print ("------------------------------");
			m_XApp.print ("XRectPoolManager XApp: ");
			
			m_XApp.print (": XRectPoolManager: " + m_XRectPoolManager.numberOfBorrowedObjects ());

			m_XApp.print ("------------------------------");
			m_XApp.print ("XPointPoolManager XApp: ");
			
			m_XApp.print (": XPointPoolManager: " + m_XPointPoolManager.numberOfBorrowedObjects ());		

			m_XApp.print ("------------------------------");
			m_XApp.print ("XDepthSpritePoolManager XApp: ");
			
			m_XApp.print (": XDepthSpritePoolManager: " + m_XDepthSpritePoolManager.numberOfBorrowedObjects ());
		}
			
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}	