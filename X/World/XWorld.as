//------------------------------------------------------------------------------------------
package X.World {

// Box2D classes
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import X.*;
	import X.Datasource.XDatasource;
	import X.Document.*;
	import X.Keyboard.*;
	import X.MVC.*;
	import X.Resource.*;
	import X.Signals.*;
	import X.Sound.*;
	import X.Task.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	import X.World.Tiles.*;
	import X.World.UI.XButton;
	import X.XMap.*;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.system.*;
	
//------------------------------------------------------------------------------------------
	public class XWorld extends XSprite {
		public var m_ticks:Number;
		public var m_world:b2World;
		public var m_iterations:int = 20;
		public var m_timeStep:Number = 1.0/30.0;
		public var m_parent:Sprite;	
		public var m_XApp:XApp
		public var m_XLogicManager:XLogicManager;
		public var m_XTaskManager:XTaskManager;
		public var m_renderManager:XTaskManager;
		public var m_XMapModel:XMapModel;
		public var m_XWorldLayers:Array;
		public var m_XHudLayer:XSpriteLayer;
		public static var MAX_LAYERS:Number = 4;
		public var m_inuse_ENTER_FRAME:Number;
		public var m_inuse_RENDER_FRAME:Number;
		public var m_XKeyboardManager:XKeyboardManager;
				
//------------------------------------------------------------------------------------------
		public var m_XWorld:XWorld;
		public var m_XLogicObject:XLogicObject;
		public var m_XLogicObjectCX:XLogicObjectCX;
		public var m_XLogicObjectBox2D:XLogicObjectBox2D;
		public var m_XShape:XShape;
		public var m_XShapeRect:XShapeRect;
		public var m_XShapeCircle:XShapeCircle;
		public var m_XMapItemModel:XMapItemModel;
		public var m_XDocument:XDocument;
		public var m_XButton:XButton;
		public var m_XSprite:XSprite;
		public var m_XTask:XTask;
		public var m_XDatasource:XDatasource;
		public var m_XTextSprite:XTextSprite;
		public var m_XProjectManager:XProjectManager;
		public var m_XSignals:XSignal;
		public var m_XBitmap:XBitmap;
		public var m_XSignalManager:XSignalManager;
		public var m_XSubmapTiles:XSubmapTiles;
		public var m_XSoundManager:XSoundManager;
		public var m_XSoundTaskManager:XSoundTaskManager;
		public var m_XSoundTask:XSoundTask;

//------------------------------------------------------------------------------------------
		public function XWorld (__parent:Sprite, __XApp:XApp){
			m_parent = __parent;
			m_XApp = __XApp;
			
			// Add event for main loop
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			m_inuse_ENTER_FRAME = 0;
			
			addEventListener(Event.RENDER, onRenderFrame, false, 0, true);
			m_inuse_RENDER_FRAME = 0;
			
			// Create world AABB
			var worldAABB:b2AABB = new b2AABB ();
			worldAABB.lowerBound.Set (-100.0, -100.0);
			worldAABB.upperBound.Set (100.0, 100.0);
			
			// Define the gravity vector
			var gravity:b2Vec2 = new b2Vec2 (0.0, 30.0);
			
			// Allow bodies to sleep
			var doSleep:Boolean = true;
			
			// Construct a world object
			m_world = new b2World (worldAABB, gravity, doSleep);
			
			m_ticks = 0;
			
			m_XLogicManager = new XLogicManager (this);
			m_XTaskManager = new XTaskManager ();
			m_renderManager = new XTaskManager ();
			m_XSignalManager = new XSignalManager ();
									
			m_XMapModel = null;
						
			m_XWorldLayers = new Array ();
						
//			for (var i:Number = MAX_LAYERS-1; i>=0; i--) {
			for (var i:Number = 0; i<MAX_LAYERS; i++) {
				m_XWorldLayers[i] = new XSpriteLayer ();
				m_XWorldLayers[i].init (this);
				addChild (m_XWorldLayers[i]);
			}

			m_XHudLayer = new XSpriteLayer ();
			m_XHudLayer.init (this);
			addChild (m_XHudLayer);

			m_XKeyboardManager = new XKeyboardManager (this);
					
			setupDebug ()
		}

//------------------------------------------------------------------------------------------
		public function setupDebug ():void {
			// set debug draw
			
//			var dbgDraw:b2DebugDraw = new b2DebugDraw();
			var dbgDraw:XDebugDraw = new XDebugDraw(this);
			var dbgSprite:Sprite = new Sprite();
// !!!
			getXWorldLayer (0).childList.addChild(dbgSprite);
			dbgDraw.m_sprite = dbgSprite;
			dbgDraw.m_drawScale = 30.0;
			dbgDraw.m_fillAlpha = 0.75;
			dbgDraw.m_lineThickness = 2.0;
			dbgDraw.m_drawFlags = b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit;
			m_world.SetDebugDraw(dbgDraw);
		}
		
//------------------------------------------------------------------------------------------
		public function onEnterFrame(e:Event):void {
			if (m_inuse_ENTER_FRAME) {
				trace (": overflow: ENTER_FRAME: ");
				
				return;
			}
			
			m_inuse_ENTER_FRAME++;
			
			getXLogicManager ().cleanupKills ();
			
				getXLogicManager ().updateLogic ();
				getXTaskManager ().updateTasks ();
//				getXLogicManager ().updatePhysics ();
				getXLogicManager ().cullObjects ();
				m_world.Step (m_timeStep, m_iterations);
				getXLogicManager ().setValues ();
				
			getXLogicManager ().cleanupKills ();

			getXLogicManager ().updateDisplay ();
 
			for (var i:Number=0; i<MAX_LAYERS; i++) {
				if (getXWorldLayer (i).forceSort) {
					getXWorldLayer (i).depthSort ();
					getXWorldLayer (i).forceSort = false;
				}
			}
			
			getXHudLayer ().depthSort ();
			
			m_inuse_ENTER_FRAME--;
		}

//------------------------------------------------------------------------------------------
		public function onRenderFrame(e:Event):void {
			if (m_inuse_RENDER_FRAME) {
				trace (": overflow: RENDER_FRAME: ");
				
				return;
			}
			
			m_inuse_RENDER_FRAME++;
			
			getRenderManager ().updateTasks ();
			
			m_inuse_RENDER_FRAME--;		
		}	

//------------------------------------------------------------------------------------------
		public function getXApp ():XApp {
			return m_XApp;
		}
		
//------------------------------------------------------------------------------------------
		public function show ():void {
			visible = true;
		}	

//------------------------------------------------------------------------------------------
		public function hide ():void {
			visible = false;
		}
		
//------------------------------------------------------------------------------------------
		public function getWorld ():b2World {
			return m_world;
		}

//------------------------------------------------------------------------------------------
		public function setXMapModel (__XMapModel:XMapModel):void {
			m_XMapModel = __XMapModel;
		}
		
//------------------------------------------------------------------------------------------
		public function getXMapModel ():XMapModel {
			return m_XMapModel;
		}
		
//------------------------------------------------------------------------------------------
		public function getXLogicManager ():XLogicManager {
			return m_XLogicManager;
		}

//------------------------------------------------------------------------------------------
		public function createXSignal ():XSignal {
			return  m_XSignalManager.createXSignal ();
		}
		
//------------------------------------------------------------------------------------------
		public function getXSignalManager ():XSignalManager {
			return m_XSignalManager;
		}
		
//------------------------------------------------------------------------------------------
		public function getXTaskManager ():XTaskManager {
			return m_XTaskManager;
		}

//------------------------------------------------------------------------------------------
		public function grabFocus ():void {
			m_XKeyboardManager.grabFocus ();
		}
		
//------------------------------------------------------------------------------------------
		public function releaseFocus():void {
			m_XKeyboardManager.releaseFocus ();
		}
		
//------------------------------------------------------------------------------------------
		public function getKeyCode (__c:uint):Boolean {
			return m_XKeyboardManager.getKeyCode (__c);
		}

//------------------------------------------------------------------------------------------
		public function getRenderManager ():XTaskManager {
			return m_renderManager;
		}
				
//------------------------------------------------------------------------------------------
		public function getXWorldLayer (__layer:Number):XSpriteLayer {
			return m_XWorldLayers[__layer];
		}

//------------------------------------------------------------------------------------------
		public function getXHudLayer ():XSpriteLayer {
			return m_XHudLayer;
		}
		
//------------------------------------------------------------------------------------------
		public function getClass (__className:String):Class {
			return m_XApp.getClass (__className);
		}					
		
//------------------------------------------------------------------------------------------
		public function globalToWorld (__layer:Number, __p:Point):Point {
			if (__layer < 0) {
				__p = getXHudLayer ().globalToLocal (__p);
			}
			else 
			{
				__p = getXWorldLayer (__layer).globalToLocal (__p);
			}
			
			return __p;
		}
				
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}
