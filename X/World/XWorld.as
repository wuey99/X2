//------------------------------------------------------------------------------------------
package X.World {

// Box2D classes
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import X.*;
	import X.Bitmap.*;
	import X.Datasource.XDatasource;
	import X.Debug.*;
	import X.Document.*;
	import X.Game.*;
	import X.Geom.*;
	import X.Keyboard.*;
	import X.MVC.*;
	import X.Pool.XObjectPoolManager;
	import X.Pool.XSubObjectPoolManager;
	import X.Resource.*;
	import X.Resource.Manager.*;
	import X.Signals.*;
	import X.Sound.*;
	import X.Task.*;
	import X.Text.*;
	import X.Texture.*;
	import X.Utils.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	import X.World.Tiles.*;
	import X.World.UI.*;
	import X.XML.*;
	import X.XMap.*;
	
	include "..\\flash.h";
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.system.*;
	import flash.utils.Timer;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
//------------------------------------------------------------------------------------------
	public class XWorld extends XSprite {
		public var m_ticks:Number;
		public var m_world:b2World;
		public var m_iterations:int = 20;
		public var m_timeStep:Number = 1.0/30.0;
		public var m_parent:*;	
		public var m_XApp:XApp
		public var m_XLogicManager:XLogicManager;
		public var m_XTaskManager:XTaskManager;
		public var m_XTaskManagerCX:XTaskManager;
		public var m_renderManager:XTaskManager;
		public var m_XLogicObjectPoolManager:XLogicObjectPoolManager;
		public var m_XMapModel:XMapModel;
		public var m_XWorldLayers:Array;
		public var m_XHudLayer:XSpriteLayer;
		public var MAX_LAYERS:Number;
		public var m_inuse_ENTER_FRAME:Number;
		public var m_inuse_RENDER_FRAME:Number;
		public var m_XKeyboardManager:XKeyboardManager;
		protected var m_viewRect:XRect;
		private var m_XBulletCollisionManager:XBulletCollisionManager;
		public var m_mouseX:Number;
		public var m_mouseY:Number;
		public var m_timer:Timer;
		
//------------------------------------------------------------------------------------------
		public var m_XWorld:XWorld;
		public var m_XLogicObject:XLogicObject;
		public var m_XLogicObjectCX0:XLogicObjectCX0;
		public var m_XLogicObjectCX:XLogicObjectCX;
		public var m_XLogicObjectBox2D:XLogicObjectBox2D;
		public var m_XShape:XShape;
		public var m_XShapeRect:XShapeRect;
		public var m_XShapeCircle:XShapeCircle;
		public var m_XMapItemModel:XMapItemModel;
		public var m_XDocument:XDocument;
		public var m_XButton:XButton;
		public var m_XWorldButton:XWorldButton;
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
		public var m_XDebugConsole:XDebugConsole;
		public var m_xmlDoc:XSimpleXMLDocument;
		public var m_xmlNode:XSimpleXMLNode;
		public var m_XPoint:XPoint;
		public var m_XRect:XRect;
		public var m_XMatrix:XMatrix;
		public var m_g$:g$;
		public var m_XMapLayerView:XMapLayerView;
		public var m_XMapView:XMapView;
		public var m_XSubXRectPoolManager:XSubObjectPoolManager;
		public var m_XSubXPointPoolManager:XSubObjectPoolManager;
		public var m_XMapLayerCachedView:XMapLayerCachedView;
		public var m_XBitmapDataAnimManager:XBitmapDataAnimManager;
		public var m_XControllerBase:XControllerBase;
		public var m_XMapItemCachedView:XMapItemCachedView;
		public var m_XMapItemXBitmapView:XMapItemXBitmapView;
		public var m_XSound:XSound;
		public var m_XTextureManager:XTextureManager;
		public var m_XSubTextureManager:XSubTextureManager;
		public var m_XMovieClipCacheManager:XMovieClipCacheManager;
		public var m_XTextLogicObject:XTextLogicObject;
		public var m_GUID:GUID;
		
//------------------------------------------------------------------------------------------
		public function XWorld (__parent:*, __XApp:XApp, __layers:Number=8, __timerInterval:Number=32){
			super ();
			
			m_parent = __parent;
			m_XApp = __XApp;
			
			MAX_LAYERS = __layers;
			
			if (CONFIG::starling) {
			}
			else
			{
				mouseEnabled = true;
				mouseChildren = true;
			}
			
			// Add event for main loop
			m_timer = new Timer (__timerInterval, 0);
			m_timer.start ();
			m_timer.addEventListener (TimerEvent.TIMER, onEnterFrame);
			m_inuse_ENTER_FRAME = 0;

			if (CONFIG::flash) {
				addEventListener(Event.RENDER, onRenderFrame);
				m_inuse_RENDER_FRAME = 0;
			}
			
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
			m_XTaskManager = new XTaskManager (__XApp);
			m_XTaskManagerCX = new XTaskManager (__XApp);
			m_renderManager = new XTaskManager (__XApp);
			m_XSignalManager = new XSignalManager (__XApp);
			m_XBulletCollisionManager = new XBulletCollisionManager (this);
			m_XLogicObjectPoolManager = new XLogicObjectPoolManager (this);
				
			m_XMapModel = null;
						
			m_XWorldLayers = new Array ();
							
			for (var i:Number = MAX_LAYERS-1; i>=0; i--) {
//			for (var i:Number = 0; i<MAX_LAYERS; i++) {
				m_XWorldLayers[i] = new XSpriteLayer ();
				m_XWorldLayers[i].setup (this);
				addChild (m_XWorldLayers[i]);
				m_XWorldLayers[i].mouseEnabled = true;
				m_XWorldLayers[i].mouseChildren = true;
			}

			m_XHudLayer = new XSpriteLayer ();
			m_XHudLayer.setup (this);
			addChild (m_XHudLayer);

			if (CONFIG::flash) {
				m_XHudLayer.mouseEnabled = true;
				m_XHudLayer.mouseChildren = true;
			}
			
			m_XKeyboardManager = new XKeyboardManager (this);
					
			setupDebug ();
			
			m_mouseX = m_mouseY = 0;
			
			if (CONFIG::starling) {
				addEventListener (TouchEvent.TOUCH, onTouchEvent);
			}
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
			
			m_XTaskManager.removeAllTasks ();
			m_XTaskManagerCX.removeAllTasks ();
			m_renderManager.removeAllTasks ();
			m_XSignalManager.removeAllXSignals ();
			m_XBulletCollisionManager.cleanup ();
			
			if (CONFIG::starling) {
				removeEventListener (TouchEvent.TOUCH, onTouchEvent);
			}
			
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			if (CONFIG::flash) {
				removeEventListener(Event.RENDER, onRenderFrame);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function setupDebug ():void {
			// set debug draw
			
			if (CONFIG::flash) {	
//				var dbgDraw:b2DebugDraw = new b2DebugDraw();
				var dbgDraw:XDebugDraw = new XDebugDraw(this);
				var dbgSprite:Sprite = new Sprite ();
	
				getXWorldLayer (0).childList.addChild(dbgSprite);
	
				dbgDraw.m_sprite = dbgSprite;
				dbgDraw.m_drawScale = 30.0;
				dbgDraw.m_fillAlpha = 0.75;
				dbgDraw.m_lineThickness = 2.0;
				dbgDraw.m_drawFlags = b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit;
				m_world.SetDebugDraw(dbgDraw);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function onEnterFrame(e:Event):void {
			__onEnterFrame ();
		}

//------------------------------------------------------------------------------------------
		protected function __onEnterFrame ():void {
			if (m_inuse_ENTER_FRAME) {
				trace (": overflow: ENTER_FRAME: ");
				
				return;
			}
			
			m_inuse_ENTER_FRAME++;
			
			getXLogicManager ().emptyKillQueue ();
			
			getXLogicManager ().updateLogic ();
			getXTaskManager ().updateTasks ();
			getXTaskManagerCX ().updateTasks ();
//			getXLogicManager ().updatePhysics ();
			getXLogicManager ().cullObjects ();
			if (CONFIG::flash) {
				m_world.Step (m_timeStep, m_iterations);
			}
			getXLogicManager ().setValues ();
			
			getXLogicManager ().emptyKillQueue ();
			
			m_XBulletCollisionManager.clearCollisions ();
			
			getXLogicManager ().setCollisions ();
			
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
		if (CONFIG::starling) {
			private function onTouchEvent (e:TouchEvent):void {
				var __touches:Vector.<Touch> = e.getTouches(this);
				
				for each (var __touch:Touch in __touches)
				{
					if (__touch.phase == TouchPhase.HOVER )
					{
						var __location:Point = __touch.getLocation (this);
						
						m_mouseX = __location.x;
						m_mouseY = __location.y;
						
						trace (": mouseX, mouseY: ", m_mouseX, m_mouseY);
					}
				}
			}
		}
		
//------------------------------------------------------------------------------------------
// returns the flash stage
//------------------------------------------------------------------------------------------
		public function getFlashStage ():* {
			if (CONFIG::starling) {
				return getParent ().stage;
			}
			else
			{
				return stage;
			}
		}

//------------------------------------------------------------------------------------------
		public override function get mouseX ():Number {
			if (CONFIG::starling) {
				return m_mouseX;
			}
			else
			{
				return stage.mouseX;
			}
		}
		
		public override function get mouseY ():Number {
			if (CONFIG::starling) {
				return m_mouseY;
			}
			else
			{
				return stage.mouseY;
			}
		}

//------------------------------------------------------------------------------------------
		public function getParent ():* {
			return m_parent;
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
		public function getMaxLayers ():Number {
			return MAX_LAYERS;
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
		public function getXLogicObjectPoolManager ():XLogicObjectPoolManager {
			return m_XLogicObjectPoolManager;
		}
		
//------------------------------------------------------------------------------------------
		public function getXLogicManager ():XLogicManager {
			return m_XLogicManager;
		}

//------------------------------------------------------------------------------------------
		public function getXBulletCollisionManager ():XBulletCollisionManager {
			return  m_XBulletCollisionManager;
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
		public function getXTaskManagerCX ():XTaskManager {
			return m_XTaskManagerCX;
		}
		
//------------------------------------------------------------------------------------------
		public function getXRectPoolManager ():XObjectPoolManager {
			return m_XApp.getXRectPoolManager ();
		}
		
//------------------------------------------------------------------------------------------
		public function getXPointPoolManager ():XObjectPoolManager {
			return m_XApp.getXPointPoolManager ();
		}

//------------------------------------------------------------------------------------------
		public function getXDepthSpritePoolManager ():XObjectPoolManager {
			return m_XApp.getXDepthSpritePoolManager ();
		}

//------------------------------------------------------------------------------------------
		public function getMovieClipCacheManager ():XMovieClipCacheManager {
			return m_XApp.getMovieClipCacheManager ();
		}
		
//------------------------------------------------------------------------------------------
		public function getBitmapCacheManager ():XBitmapCacheManager {
			return m_XApp.getBitmapCacheManager ();
		}

//------------------------------------------------------------------------------------------
		public function getBitmapDataAnimManager ():XBitmapDataAnimManager {
			return m_XApp.getBitmapDataAnimManager ();
		}

//------------------------------------------------------------------------------------------
		public function getTextureManager ():XTextureManager {
			return m_XApp.getTextureManager ();
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
		public function unloadClass (__className:String):Boolean {
			return m_XApp.unloadClass (__className);
		}	
		
//------------------------------------------------------------------------------------------
		if (CONFIG::starling) {
			public function get MOUSE_DOWN ():String {
				return TouchPhase.BEGAN;	
			}
			
			public function get MOUSE_UP ():String {
				return TouchPhase.BEGAN;	
			}
			
			public function get MOUSE_MOVE ():String {
				return TouchPhase.ENDED;	
			}
	
			public function get MOUSE_OVER ():String {
				return TouchPhase.HOVER;	
			}
			
			public function get MOUSE_OUT ():String {
				return TouchPhase.ENDED;	
			}
		}
		else
		{
			public function get MOUSE_DOWN ():String {
				return MouseEvent.MOUSE_DOWN;	
			}
			
			public function get MOUSE_UP ():String {
				return MouseEvent.MOUSE_UP;	
			}
			
			public function get MOUSE_MOVE ():String {
				return MouseEvent.MOUSE_MOVE;	
			}
			
			public function get MOUSE_OVER ():String {
				return MouseEvent.MOUSE_OVER;	
			}
			
			public function get MOUSE_OUT ():String {
				return MouseEvent.MOUSE_OUT;	
			}	
		}
		
//------------------------------------------------------------------------------------------
		public function globalToWorld (__layer:Number, __p:XPoint):XPoint {
			var __x:Point;
			
			if (__layer < 0) {
				__x = getXHudLayer ().globalToLocal (__p);
			}
			else 
			{
				__x = getXWorldLayer (__layer).globalToLocal (__p);
			}
			
			return new XPoint (__x.x, __x.y);
		}

//------------------------------------------------------------------------------------------
		public function globalToWorld2 (__layer:Number, __src:XPoint, __dst:XPoint):XPoint {
			var __x:Point;
			
			if (__layer < 0) {
				__x = getXHudLayer ().globalToLocal (__src);
			}
			else 
			{
				__x = getXWorldLayer (__layer).globalToLocal (__src);
			}
			
			__dst.x = __x.x; __dst.y = __x.y;
			
			return __dst;
		}
							
//------------------------------------------------------------------------------------------
		public function setViewRect (
			__width:Number, __height:Number
			):void {
				
			m_viewRect = new XRect (0, 0, __width, __height);
		}

//------------------------------------------------------------------------------------------	
		public function getViewRect ():XRect {
			return m_viewRect
		}
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}
