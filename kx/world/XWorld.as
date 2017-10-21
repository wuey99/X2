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
package kx.world {

// Box2D classes
	/*
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	*/
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.system.*;
	import flash.utils.Timer;
	import flash.display.Stage;
	
	import kx.*;
	import kx.bitmap.*;
	import kx.datasource.XDatasource;
	import kx.debug.*;
	import kx.document.*;
	import kx.game.*;
	import kx.gamepad.XGamepad;
	import kx.gamepad.XGamepadSubManager;
	import kx.geom.*;
	import kx.keyboard.*;
	import kx.gamepad.*;
	import kx.mvc.*;
	import kx.pool.*;
	import kx.resource.*;
	import kx.resource.manager.*;
	import kx.signals.*;
	import kx.sound.*;
	import kx.task.*;
	import kx.text.*;
	import kx.texture.*;
	import kx.utils.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.world.tiles.*;
	import kx.world.ui.*;
	import kx.xmap.*;
	import kx.xml.*;
	
	// <HAXE>
	/* --
	-- */
	// </HAXE>
	// <AS3>
	import starling.events.EnterFrameEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	// </AS3>
	
//------------------------------------------------------------------------------------------
	public class XWorld extends XSprite {
		public var m_ticks:int;
//		public var m_world:b2World;
		public var m_iterations:int = 20;
		public var m_timeStep:Number = 1.0/30.0;
		public var self:*;
		public var m_parent:*;	
		public var m_XApp:XApp;
		public var m_XLogicManager:XLogicManager;
		public var m_XLogicManager2:XLogicManager;
		public var m_XTaskManager:XTaskManager;
		public var m_XTaskManagerCX:XTaskManager;
		public var m_renderManager:XTaskManager;
		public var m_XMapModel:XMapModel;
		public var m_XWorldLayers:Array; // <XSpriteLayer>
		public var m_XHudLayer:XSpriteLayer;
		public var MAX_LAYERS:int;
		public var m_inuse_ENTER_FRAME:int;
		public var m_inuse_RENDER_FRAME:int;
		public var m_XKeyboardManager:XKeyboardManager;
		protected var m_viewRect:XRect;
		private var m_XBulletCollisionManager:XBulletCollisionManager;
		private var m_XObjectCollisionManager:XObjectCollisionManager;
		private var m_objectCollisionList:XObjectCollisionList;
		public var m_mouseX:Number;
		public var m_mouseY:Number;
		public var m_timer:Timer;
		public var m_timer1000:Timer;
		public var m_timer1000Signal:XSignal;
		public var m_frameCount:Number;
		public var m_FPS:Number;
		public var m_minimumFPS:Number;
		public var m_idealFPS:Number;
		public var m_FPSCounterObject:XFPSCounter;
		public var m_paused:Boolean;
		public var m_soundManager:XSoundManager;
		public var m_XLogicObjectPoolManager:XClassPoolManager;
		public var m_beforeFrameSignal:XSignal;
		public var m_afterFrameSignal:XSignal;
		
		public var m_mouseOverSignal:XSignal;
		public var m_mouseDownSignal:XSignal;
		public var m_mouseMoveSignal:XSignal;
		public var m_polledMouseMoveSignal:XSignal;
		public var m_mouseUpSignal:XSignal;
		public var m_mouseOutSignal:XSignal;
		public var m_keyboardDownSignal:XSignal;
		public var m_keyboardUpSignal:XSignal;
		public var m_focusInSignal:XSignal;
		public var m_focusOutSignal:XSignal;
		
//------------------------------------------------------------------------------------------
		public var m_XWorld:XWorld;
		public var m_XLogicObject:XLogicObject;
		public var m_XMapItemModel:XMapItemModel;
		public var m_XDocument:XDocument;
		public var m_XButton:XButton;
		public var m_XWorldButton:XWorldButton;
		public var m_XWorldButton4:XWorldButton4;
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
		public var m_XSoundSubManager:XSoundSubManager;
		public var m_XDebugConsole:XDebugConsole;
		public var m_xmlDoc:XSimpleXMLDocument;
		public var m_xmlNode:XSimpleXMLNode;
		public var m_XPoint:XPoint;
		public var m_XRect:XRect;
		public var m_XMatrix:XMatrix;
		public var m_XMapLayerView:XMapLayerView;
		public var m_XMapView:XMapView;
		public var m_XSubXRectPoolManager:XSubObjectPoolManager;
		public var m_XSubXPointPoolManager:XSubObjectPoolManager;
		public var m_XMapLayerCachedView:XMapLayerCachedView;
		public var m_XBitmapDataAnimManager:XBitmapDataAnimManager;
		public var m_XControllerBase:XControllerBase;
		public var m_XMapItemCachedView:XMapItemCachedView;
		public var m_XMapItemXBitmapView:XMapItemXBitmapView;
		public var m_XTextureManager:XTextureManager;
		public var m_XSubTextureManager:XSubTextureManager;
		public var m_XMovieClipCacheManager:XMovieClipCacheManager;
		public var m_XTextLogicObject:XTextLogicObject;
		public var m_GUID:GUID;
		public var m_Domain:Domain;
		public var m_timely:Timely;
		public var m_gamepad:XGamepad;
		public var m_gamepadSubManager:XGamepadSubManager;
		
//------------------------------------------------------------------------------------------
		public function XWorld (__parent:*, __XApp:XApp, __layers:int=8, __timerInterval:Number=32){
			super ();
			
			setup ();
			
			m_parent = __parent;
			m_XApp = __XApp;
			self = this;
			
			MAX_LAYERS = __layers;
			
			{
				mouseEnabled = true;
				mouseChildren = true;
			}
						
			m_inuse_ENTER_FRAME = 0;
			m_frameCount = 0;
			m_FPS = 0;
			m_minimumFPS = 20;
			m_idealFPS = 30;
			m_paused = false;
		
			if (CONFIG::flash) {
				addEventListener(Event.RENDER, onRenderFrame);
				m_inuse_RENDER_FRAME = 0;
			}
	
			/*
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
			*/
			
			m_ticks = 0;
			
			m_XLogicManager = new XLogicManager (__XApp, this);
			m_XLogicManager2 = new XLogicManager (__XApp, this);

// deprecate this?
			m_XTaskManager = new XTaskManager (__XApp);
			m_XTaskManagerCX = new XTaskManager (__XApp);
			
			m_renderManager = new XTaskManager (__XApp);
			m_XSignalManager = new XSignalManager (__XApp);
			m_XBulletCollisionManager = new XBulletCollisionManager (this);
			m_XObjectCollisionManager = new XObjectCollisionManager (this);
			m_objectCollisionList = m_XObjectCollisionManager.addCollisionList ();
			
			m_XLogicObjectPoolManager = new XClassPoolManager ();
			
			m_timer1000 = new Timer (1000, 0);
			m_timer1000.start ();
			m_timer1000.addEventListener (TimerEvent.TIMER, onUpdateTimer1000);
			m_timer1000Signal = getXSignalManager ().createXSignal ();
			
			m_beforeFrameSignal = getXSignalManager ().createXSignal ();
			m_afterFrameSignal = getXSignalManager ().createXSignal ();
			
			initMouseScript ();
			
			m_XMapModel = null;
						
			m_XWorldLayers = new Array (); // <XSpriteLayer>
		
			for (var i:int = 0; i<MAX_LAYERS; i++) {
				m_XWorldLayers.push (null);
			}
			
			function __createLayer (i:int):void {
				m_XWorldLayers[i] = new XSpriteLayer ();
				m_XWorldLayers[i].setup ();
				m_XWorldLayers[i].xxx = self;
				addChild (m_XWorldLayers[i]);
				m_XWorldLayers[i].mouseEnabled = true;
				m_XWorldLayers[i].mouseChildren = true;
			}
			
			var i:int = MAX_LAYERS-1;
//			for (var i:Number = MAX_LAYERS-1; i>=0; i--) {
			while (i >= 0) {
				__createLayer (i);
				
				i--;
			}
		
			m_XHudLayer = new XSpriteLayer ();
			m_XHudLayer.setup ();
			m_XHudLayer.xxx = this;
			addChild (m_XHudLayer);

			if (CONFIG::flash) {
				m_XHudLayer.mouseEnabled = true;
				m_XHudLayer.mouseChildren = true;
			}
			
			m_XKeyboardManager = new XKeyboardManager (this);
					
			m_mouseX = m_mouseY = 0;
			
//			setupDebug ();
			
			addEventListener (Event.ENTER_FRAME, onFPSCounter);
			
			if (__timerInterval > 0) {
				// Add event for main loop
				m_timer = new Timer (__timerInterval, 0);
				m_timer.start ();
				m_timer.addEventListener (TimerEvent.TIMER, onEnterFrame);
			}
			else
			{
	
				addEventListener (Event.ENTER_FRAME, onEnterFrame);		
			}
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
			
			quitMouseScript ();
			
			m_XLogicManager.cleanup ();
			m_XLogicManager2.cleanup ();
			
// deprecate this?
			m_XTaskManager.removeAllTasks ();
			m_XTaskManagerCX.removeAllTasks ();
			
			m_renderManager.removeAllTasks ();
			m_XSignalManager.removeAllXSignals ();
			m_XBulletCollisionManager.cleanup ();
				
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);	
			removeEventListener(Event.RENDER, onRenderFrame);
		}
		
//------------------------------------------------------------------------------------------
		public function setupDebug ():void {
			// set debug draw
			
// <HAXE>
/* --
-- */
// </HAXE>
// <AS3>
			/*
			if (CONFIG::flash) {	
				import flash.display.Sprite;
				
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
			*/
// </AS3>
			
			m_FPSCounterObject = /* @:cast */ getXLogicManager2 ().initXLogicObject (
				// parent
				null,
				// logicObject
				/* @:cast */ new XFPSCounter () as XLogicObject,
				// item, layer, depth
				null, -1, 1000000,
				// x, y, z
				0, 0, 0,
				// scale, rotation
				1.0, 0
			) as XFPSCounter;
		}

//------------------------------------------------------------------------------------------
		public function onFPSCounter (e:Event):void {
			m_frameCount++;
		}

//------------------------------------------------------------------------------------------
// <HAXE>
/* --
-- */
// </HAXE>
// <AS3>
		public function onFPSCounterStarling (e:EnterFrameEvent):void {
			m_frameCount++;
		}
// </AS3>
	
//------------------------------------------------------------------------------------------
		public function onEnterFrame (e:Event):void {
			__onEnterFrame ();
		}

//------------------------------------------------------------------------------------------
		public function onUpdateTimer1000 (e:Event):void {	
			m_FPS = m_frameCount;
			
			m_frameCount = 0;
			
			m_timer1000Signal.fireSignal ();
		}
		
//------------------------------------------------------------------------------------------
		public function setFPS (__val:Number):void {
			m_FPS = __val;
			
			m_frameCount = 0;
		}

//------------------------------------------------------------------------------------------
		public function getFPS ():Number {
			return m_FPS;
		}

//------------------------------------------------------------------------------------------
		public function setMinimumFPS (__val:Number):void {
			m_minimumFPS = __val;	
		}
		
//------------------------------------------------------------------------------------------
		public function getMinimumFPS ():Number {
			return m_minimumFPS;
		}
		
//------------------------------------------------------------------------------------------
		public function setIdealFPS (__val:Number):void {
			m_idealFPS = __val;	
		}
		
//------------------------------------------------------------------------------------------
		public function getIdealFPS ():Number {
			return m_idealFPS;
		}
		
//------------------------------------------------------------------------------------------
		public function addTimer1000Listener (__listener:Function):int {
			return m_timer1000Signal.addListener (__listener);
		}

//------------------------------------------------------------------------------------------
		public function removeTimer1000Listener (__id:int):void {
			m_timer1000Signal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------
		protected function __onEnterFrame ():void {
			if (m_inuse_ENTER_FRAME > 0) {
				trace (": overflow: ENTER_FRAME: ");
				
				return;
			}
			
			m_inuse_ENTER_FRAME++;
			
			m_beforeFrameSignal.fireSignal ();
			
			getXLogicManager ().emptyKillQueue ();
			getXLogicManager2 ().emptyKillQueue ();
			
			getXLogicManager ().updateLogic ();
			getXLogicManager2 ().updateLogic ();
			
// will soon be deprecated?
			getXTaskManager ().updateTasks ();
			getXTaskManagerCX ().updateTasks ();
			
			if (!m_paused) {
				getXLogicManager ().updateTasks ();
			}
			getXLogicManager2 ().updateTasks ();
			
//			getXLogicManager ().updatePhysics ();
			
			getXLogicManager ().cullObjects ();
			getXLogicManager2 ().cullObjects ();
			
			if (CONFIG::flash) {
//				m_world.Step (m_timeStep, m_iterations);
			}
			
			getXLogicManager ().setValues ();
			getXLogicManager2 ().setValues ();
			
			getXLogicManager ().emptyKillQueue ();
			getXLogicManager2 ().emptyKillQueue ();
			
			m_XBulletCollisionManager.clearCollisions ();
			m_XObjectCollisionManager.clearCollisions ();
			
			getXLogicManager ().setCollisions ();
			getXLogicManager2 ().setCollisions ();
			
			getXLogicManager ().updateDisplay ();
			getXLogicManager2 ().updateDisplay ();
			
			m_afterFrameSignal.fireSignal ();
			
			for (var i:int=0; i<MAX_LAYERS; i++) {
//				if (getXWorldLayer (i).forceSort) {
				if (true) {
					getXWorldLayer (i).depthSort ();
					getXWorldLayer (i).forceSort = false;
				}
			}
			
			getXHudLayer ().depthSort ();
			
			m_inuse_ENTER_FRAME--;			
		}

//------------------------------------------------------------------------------------------
		public function pause ():void {
			m_paused = true;
			
			getSoundManager ().pause ();
		}
		
//------------------------------------------------------------------------------------------
		public function unpause ():void {
			m_paused = false;
			
			getSoundManager ().resume ();
		}

//------------------------------------------------------------------------------------------
		public function isPaused ():Boolean {
			return m_paused;
		}
		
//------------------------------------------------------------------------------------------
		public function addBeforeFrameListener (__listener:Function):int {
			return m_beforeFrameSignal.addListener (__listener);
		}
		
//------------------------------------------------------------------------------------------
		public function removeBeforeFrameListener (__id:int):void {
			m_beforeFrameSignal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------
		public function addAfterFrameListener (__listener:Function):int {
			return m_afterFrameSignal.addListener (__listener);
		}
		
//------------------------------------------------------------------------------------------
		public function removeAfterFrameListener (__id:int):void {
			m_afterFrameSignal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------
		public function onRenderFrame(e:Event):void {
			if (m_inuse_RENDER_FRAME > 0) {
				trace (": overflow: RENDER_FRAME: ");
				
				return;
			}
			
			m_inuse_RENDER_FRAME++;
			
			getRenderManager ().updateTasks ();
			
			m_inuse_RENDER_FRAME--;		
		}	
		
//------------------------------------------------------------------------------------------
// returns the flash stage
//------------------------------------------------------------------------------------------
		public function getFlashStage ():Stage {
			return stage;
		}

//------------------------------------------------------------------------------------------
		public function initMouseScript ():void {
			m_mouseOverSignal = new XSignal ();
			m_mouseDownSignal = new XSignal ();
			m_mouseMoveSignal = new XSignal ();
			m_polledMouseMoveSignal = new XSignal ();
			m_mouseUpSignal = new XSignal ();
			m_mouseOutSignal = new XSignal ();
			m_keyboardDownSignal = new XSignal ();
			m_keyboardUpSignal = new XSignal ();
			m_focusInSignal = new XSignal ();
			m_focusOutSignal = new XSignal ();
				
			/*
			getFlashStage ().addEventListener (KeyboardEvent.KEY_DOWN, onKeyboardDown);
			getFlashStage ().addEventListener (KeyboardEvent.KEY_UP, onKeyboardUp);
			getFlashStage ().addEventListener (Event.ACTIVATE, onFocusInEvent);
			getFlashStage ().addEventListener (Event.DEACTIVATE, onFocusOutEvent);
			*/
			
			var __point:XPoint = new XPoint ();
			
			var __oldX:Number;
			var __oldY:Number;
			
			getXTaskManager ().addTask ([
				XTask.WAIT, 0x0100,
				
				XTask.LABEL, "wait",
					XTask.WAIT, 0x0100,
	
					XTask.FLAGS, function (__task:XTask):void {
						__task.ifTrue (getFlashStage () != null);			
					}, XTask.BNE, "wait",
	
				function ():void {
					getFlashStage ().addEventListener (KeyboardEvent.KEY_DOWN, onKeyboardDown);
					getFlashStage ().addEventListener (KeyboardEvent.KEY_UP, onKeyboardUp);
					getFlashStage ().addEventListener (Event.ACTIVATE, onFocusInEvent);
					getFlashStage ().addEventListener (Event.DEACTIVATE, onFocusOutEvent);
				},
					
				function ():void {
					// xxx.getParent ().stage.addEventListener (xxx.MOUSE_OVER, onMouseOver);
					getFlashStage ().addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown);
					getFlashStage ().addEventListener (MouseEvent.MOUSE_MOVE, onMouseMove);
					getFlashStage ().addEventListener (MouseEvent.MOUSE_UP, onMouseUp);
					getFlashStage ().addEventListener (MouseEvent.MOUSE_OUT, onMouseOut);
					
					__oldX = mouseX; __oldY = mouseY;
				},
				
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
						function ():void {
							if (getFlashStage () != null && (__oldX != mouseX || __oldY != mouseY)) {
								__point.x = mouseX;
								__point.y = mouseY;
								
								m_polledMouseMoveSignal.fireSignal (__point);
								
								__oldX = mouseX; __oldY = mouseY;
							}
						},
						
					XTask.GOTO, "loop",
					
					XTask.RETN,
				]);
		}

//------------------------------------------------------------------------------------------
		public function quitMouseScript ():void {
			m_mouseOverSignal.removeAllListeners ();
			m_mouseMoveSignal.removeAllListeners ();
			m_polledMouseMoveSignal.removeAllListeners ();
			m_mouseUpSignal.removeAllListeners ();
			m_mouseOutSignal.removeAllListeners ();
			m_keyboardDownSignal.removeAllListeners ();
			m_keyboardUpSignal.removeAllListeners ();
			m_focusInSignal.removeAllListeners ();
			m_focusOutSignal.removeAllListeners ();
			
			getFlashStage ().removeEventListener (KeyboardEvent.KEY_DOWN, onKeyboardDown);
			getFlashStage ().removeEventListener (KeyboardEvent.KEY_UP, onKeyboardUp);
			getFlashStage ().removeEventListener (Event.ACTIVATE, onFocusInEvent);
			getFlashStage ().removeEventListener (Event.DEACTIVATE, onFocusOutEvent);
		}
		
//------------------------------------------------------------------------------------------
		public function onKeyboardDown (e:KeyboardEvent):void {	
			m_keyboardDownSignal.fireSignal (e);
		}
		
//------------------------------------------------------------------------------------------
		public function onKeyboardUp (e:KeyboardEvent):void {
			m_keyboardUpSignal.fireSignal (e);
		}
		
//------------------------------------------------------------------------------------------		
		public function addKeyboardDownListener (__listener:Function):int {
			return m_keyboardDownSignal.addListener (__listener);
		}
		
		public function removeKeyboardDownListener (__id:int):void {
			m_keyboardDownSignal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------		
		public function addKeyboardUpListener (__listener:Function):int {
			return m_keyboardUpSignal.addListener (__listener);
		}
		
		public function removeKeyboardUpListener (__id:int):void {
			m_keyboardUpSignal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------
		public function onMouseOver (e:MouseEvent):void {
			m_mouseOverSignal.fireSignal (e);
		}
		
		public function addMouseOverListener (__listener:Function):int {
			return m_mouseOverSignal.addListener (__listener);
		}

		public function removeMouseOverListener (__id:int):void {
			m_mouseOverSignal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------
		public function onMouseDown (e:MouseEvent):void {	
			m_mouseDownSignal.fireSignal (e);
		}
		
		public function addMouseDownListener (__listener:Function):int {
			return m_mouseDownSignal.addListener (__listener);
		}

		public function removeMouseDownListener (__id:int):void {
			m_mouseDownSignal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------
		public function onMouseMove (e:MouseEvent):void {	
			m_mouseMoveSignal.fireSignal (e);
		}
		
		public function addMouseMoveListener (__listener:Function):int {
			return m_mouseMoveSignal.addListener (__listener);
		}

		public function removeMouseMoveListener (__id:int):void {
			m_mouseMoveSignal.removeListener (__id);
		}

//------------------------------------------------------------------------------------------		
		public function addPolledMouseMoveListener (__listener:Function):int {
			return m_polledMouseMoveSignal.addListener (__listener);
		}
		
		public function removePolledMouseMoveListener (__id:int):void {
			m_polledMouseMoveSignal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------
		public function onMouseUp (e:MouseEvent):void {	
			m_mouseUpSignal.fireSignal (e);
		}
		
		public function addMouseUpListener (__listener:Function):int {
			return m_mouseUpSignal.addListener (__listener);
		}

		public function removeMouseUpListener (__id:int):void {
			m_mouseUpSignal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------
		public function onMouseOut (e:MouseEvent):void {	
			m_mouseOutSignal.fireSignal (e);
		}
		
		public function addMouseOutListener (__listener:Function):int {
			return m_mouseOutSignal.addListener (__listener);
		}

		public function removeMouseOutListener (__id:int):void {
			m_mouseOutSignal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------
		/* @:override get, set mouseX Float */
		
		public override function get mouseX ():Number {
			return getFlashStage ().mouseX;
		}
		
		public  function set mouseX (__val:Number): /* @:set_type */ void {
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:override get, set mouseY Float */
		
		public override function get mouseY ():Number {
			return getFlashStage ().mouseY;
		}
		
		public function set mouseY (__val:Number): /* @:set_type */ void {
			/* @:set_return 0; */			
		}
		/* @:end */

//------------------------------------------------------------------------------------------	
		public function onFocusInEvent (e:Event):void {
		}
		
//------------------------------------------------------------------------------------------	
		public function onFocusOutEvent (e:Event):void {
			fireFocusOutSignal ();	
		}
	
//------------------------------------------------------------------------------------------		
		public function addFocusInListener (__listener:Function):int {
			return m_focusInSignal.addListener (__listener);
		}
		
//------------------------------------------------------------------------------------------
		public function removeFocusInListener (__id:int):void {
			m_focusInSignal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------
		public function fireFocusInSignal ():void {
			m_focusInSignal.fireSignal ();
		}
		
//------------------------------------------------------------------------------------------		
		public function addFocusOutListener (__listener:Function):int {
			return m_focusOutSignal.addListener (__listener);
		}
		
//------------------------------------------------------------------------------------------
		public function removeFocusOutListener (__id:int):void {
			m_focusOutSignal.removeListener (__id);
		}
		
//------------------------------------------------------------------------------------------
		public function fireFocusOutSignal ():void {
			m_focusOutSignal.fireSignal ();
		}
		
//------------------------------------------------------------------------------------------
		public function getXGamepadManager ():XGamepadManager {
			return m_XApp.getXGamepadManager ();
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
		/*
		public function getWorld ():b2World {
			return m_world;
		}
		*/
		
//------------------------------------------------------------------------------------------
		public function getMaxLayers ():int {
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
		public function getXLogicObjectPoolManager ():XClassPoolManager {
			return m_XLogicObjectPoolManager;
		}

//------------------------------------------------------------------------------------------		
		public function getSoundManager ():XSoundManager {
			return m_XApp.getSoundManager ();
		}
		
//------------------------------------------------------------------------------------------
		public function getXLogicManager ():XLogicManager {
			return m_XLogicManager;
		}

//------------------------------------------------------------------------------------------
		public function getXLogicManager2 ():XLogicManager {
			return m_XLogicManager2;
		}
		
//------------------------------------------------------------------------------------------
		public function getXBulletCollisionManager ():XBulletCollisionManager {
			return  m_XBulletCollisionManager;
		}

//------------------------------------------------------------------------------------------
		public function getXObjectCollisionManager ():XObjectCollisionManager {
			return  m_XObjectCollisionManager;
		}

//------------------------------------------------------------------------------------------
		public function getObjectCollisionList ():XObjectCollisionList {
			return  m_objectCollisionList;
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
// deprecate and instead return XTaskManager from m_XLogicManager?
//------------------------------------------------------------------------------------------		
		public function getXTaskManager ():XTaskManager {
			return m_XTaskManager;
		}

//------------------------------------------------------------------------------------------
// deprecate and instead return XTaskManager from m_XLogicManager?
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
		public function getXBitmapPoolManager ():XObjectPoolManager {
			return m_XApp.getXBitmapPoolManager ();
		}

//------------------------------------------------------------------------------------------
		public function getXMovieClipPoolManager ():XObjectPoolManager {
			return m_XApp.getXMovieClipPoolManager ();
		}
	
//------------------------------------------------------------------------------------------
		public function getXTilemapPoolManager ():XObjectPoolManager {
			return m_XApp.getXTilemapPoolManager ();
		}
		
//------------------------------------------------------------------------------------------
		public function getXMapItemModelPoolManager ():XObjectPoolManager {
			return m_XApp.getXMapItemModelPoolManager ();
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
		public function getXWorldLayer (__layer:int):XSpriteLayer {
			return m_XWorldLayers[__layer];
		}

//------------------------------------------------------------------------------------------
		public function getXHudLayer ():XSpriteLayer {
			return m_XHudLayer;
		}
		
//------------------------------------------------------------------------------------------
		public function getClass (__className:String):Class /* <Dynamic> */ {
			return m_XApp.getClass (__className);
		}					

//------------------------------------------------------------------------------------------
		public function unloadClass (__className:String):Boolean {
			return m_XApp.unloadClass (__className);
		}	
		
//------------------------------------------------------------------------------------------
			/* @:get, set MOUSE_DOWN String */	
			public function get MOUSE_DOWN ():String {
				return MouseEvent.MOUSE_DOWN;	
			}
			
			public function set MOUSE_DOWN (__val:String): /* @:set_type */ void {
				/* @:set_return ""; */			
			}
			/* @:end */
			
			/* @:get, set MOUSE_UP String */	
			public function get MOUSE_UP ():String {
				return MouseEvent.MOUSE_UP;	
			}
			
			public function set MOUSE_UP (__val:String): /* @:set_type */ void {
				/* @:set_return ""; */			
			}
			/* @:end */
			
			/* @:get, set MOUSE_MOVE String */	
			public function get MOUSE_MOVE ():String {
				return MouseEvent.MOUSE_MOVE;	
			}
			
			public function set MOUSE_MOVE (__val:String): /* @:set_type */ void {
				/* @:set_return ""; */			
			}
			/* @:end */
			
			/* @:get, set MOUSE_OVER String */	
			public function get MOUSE_OVER ():String {
				return MouseEvent.MOUSE_OVER;	
			}
			
			public function set MOUSE_OVER (__val:String): /* @:set_type */ void {
				/* @:set_return ""; */			
			}
			/* @:end */
			
			/* @:get, set MOUSE_OUT String */	
			public function get MOUSE_OUT ():String {
				return MouseEvent.MOUSE_OUT;	
			}
			
			public function set MOUSE_OUT (__val:String): /* @:set_type */ void {
				/* @:set_return ""; */			
			}
			/* @:end */

//------------------------------------------------------------------------------------------
// http://www.flipcode.com/archives/Fast_Approximate_Distance_Functions.shtml
//------------------------------------------------------------------------------------------
		public function approxDistance (dx:Number, dy:Number):Number {
			var min:Number, max:Number, approx:Number;
			
			if ( dx < 0 ) dx = -dx;
			if ( dy < 0 ) dy = -dy;
			
			if ( dx < dy ) {
				min = dx;
				max = dy;
			}
			else
			{
				min = dy;
				max = dx;
			}
			
			approx = ( max * 1007 ) + ( min * 441 );
//			if ( max < ( min << 4 ))
			if ( max < ( min * 16 ))
				approx -= ( max * 40 );
			
			// add 512 for proper rounding
//			return (( approx + 512 ) >> 10 );
			return (( approx + 512 ) / 1024 );	
		}

//------------------------------------------------------------------------------------------
		public function realDistance (dx:Number, dy:Number):Number {
			return Math.sqrt (dx*dx + dy*dy);		
		}
		
//------------------------------------------------------------------------------------------
		public function globalToWorld (__layer:int, __p:XPoint):XPoint {
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
		public function globalToWorld2 (__layer:int, __src:XPoint, __dst:XPoint):XPoint {
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
			return m_viewRect;
		}
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}
