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
package kx.world.logic {

	import kx.collections.*;
	import kx.geom.*;
	import kx.mvc.*;
	import kx.signals.XSignal;
	import kx.task.*;
	import kx.world.*;
	import kx.world.sprite.*;
	import kx.xml.*;
	import kx.xmap.*;
	
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;

	include "..\\..\\flash.h";
	
//------------------------------------------------------------------------------------------
// XLogicObject: Game object's that live in a "World".  These are essentially containers
// that wrap up neat-and-tidy, game logic, sprites, etc.
//
// XLogicObjects can either be instantiated dynamically from code or from an externally
// created level via a Level Manager.
//
// XLogicObjects that are created from a Level Manager are responsible for handling their
// own birth/death: XLogicObjects that stray outside the current viewport are automatically
// culled and returned back to the level.  Alternatively they can be "nuked": permanently
// removed from Level, never to return.  This system is based on Mario-like level management:
// when XLogicObjects in the Level enters the current viewPort, they are automatically spawned.
// When they leave the current viewPort (and +/- a certain threshold) they're culled. 
// They automatically get respawned when the object in the level reenters the current viewPort.
//
// When spawned, XLogicObject's can either live in the World (which is a scrollable area that
// can potentially be much larger than the current viewPort or in the HUD, which is an area
// that never scrolls.
//
// XLogicObjects can hold either XSprites or child XLogicObjects.
//------------------------------------------------------------------------------------------
	public class XLogicObject extends XSprite0 implements XRegistration {
//		public var xxx:XWorld;
		public var m_XLogicManager:XLogicManager;
		public var m_parent:XLogicObject;
		public var m_item:XMapItemModel;
		public var m_xml:XSimpleXMLNode;
		public var m_layer:int;
		public var m_depth:Number;
		public var m_boundingRect:XRect;
		public var m_pos:XPoint;
		public var m_visible:Boolean;
		public var m_masterVisible:Boolean;
		public var m_relativeDepthFlag:Boolean;
		public var m_masterDepth:Number;
		public var m_scaleX:Number;
		public var m_scaleY:Number;
		public var m_masterScaleX:Number;
		public var m_masterScaleY:Number;
		public var m_rotation:Number;
		public var m_masterRotation:Number;
		public var m_delayed:int;
		public var m_XLogicObjects:XDict; // <XLogicObject, Int>
		public var m_worldSprites:XDict; // <XDepthSprite, Int>
		public var m_hudSprites:XDict; // <XDepthSprite, Int>
		public var m_childSprites:XDict; // <Sprite, Sprite>
		public var m_detachedSprites:XDict;  // <Sprite, Sprite>
		public var m_bitmaps:XDict; // <String, XBitmap>
		public var m_movieClips:XDict; // <String, XMovieClip>
		public var m_textSprites:XDict; // <XTextSprite, Int>
		public var m_GUID:int;
		public var m_alpha:Number;
		public var m_masterAlpha:Number;
		public var m_XSignals:XDict; // <XSignal, Int>
		public var self:XLogicObject;
		public var m_killSignal:XSignal;
		public var m_killSignalWithLogic:XSignal;
		public var m_XTaskSubManager0:XTaskSubManager;
		public var m_XTaskSubManager:XTaskSubManager;
		public var m_XTaskSubManagerCX:XTaskSubManager;
		public var m_isDead:Boolean;
		public var m_autoCulling:Boolean;
		public var m_poolClass:Class; // <Dynamic>
		public var __XTask:XTask_CONSTANTS;
		public var m_viewPortRect:XRect;
		public var m_selfRect:XRect;
		public var m_itemRect:XRect;
		public var m_itemPos:XPoint;
		
		public var m_iX:Number;
		public var m_iY:Number;
		public var m_iScale:Number;
		public var m_iRotation:Number;
		public var m_iItem:XMapItemModel;
		public var m_iLayer:int;
		public var m_iDepth:Number;
		public var m_iRelativeDepth:Boolean;
		public var m_iClassName:String;
		
		private static var g_GUID:int = 0;
		
		public var rp:XPoint;
		
//------------------------------------------------------------------------------------------
		include "..\\Sprite\\XRegistration_impl.h";
						
//------------------------------------------------------------------------------------------
		public function XLogicObject (__xxx:XWorld = null) {
			super ();
			
			self = this;
			m_item = null;
			m_parent = null;
			m_boundingRect = null;
			m_delayed = 1;
			m_layer = -1;
			m_isDead = false;
			m_autoCulling = false;
		
			m_GUID = g_GUID++;
					
			iX = 0;
			iY = 0;
			iScale = 1.0;
			iRotation = 0.0;
			iItem = null;
			iDepth = 0;
			iRelativeDepth = false;
			iLayer = 0;
			iClassName = "";
		
			__XTask = new XTask_CONSTANTS ();
			
			if (__xxx != null) {
				xxx = __xxx;
				
				m_XLogicObjects = new XDict (); // <XLogicObject, Int>
				m_worldSprites = new XDict ();  // <XDepthSprite, Int>
				m_hudSprites = new XDict (); // <XDepthSprite, Int>
				m_childSprites = new XDict (); // <Sprite, Sprite>
				m_detachedSprites = new XDict (); // <Sprite, Sprite>
				m_bitmaps = new XDict (); // <String, XBitmap> 
				m_movieClips = new XDict (); // <String, XMovieClip>
				m_textSprites = new XDict (); // <XTextSprite, Int>
				m_XSignals = new XDict (); // <XSignal, Int>
				m_XTaskSubManager0 = new XTaskSubManager (getXLogicManager ().getXTaskManager0 ());
				m_XTaskSubManager = new XTaskSubManager (getXLogicManager ().getXTaskManager ());
				m_XTaskSubManagerCX = new XTaskSubManager (getXLogicManager ().getXTaskManagerCX ());	
			}
		}
		
//------------------------------------------------------------------------------------------
		public function setup (__xxx:XWorld, args:Array /* <Dynamic> */):void {	
			m_masterScaleX = m_masterScaleY = 1.0;
			m_masterRotation = 0;
			m_masterVisible = true;
			m_masterDepth = 0;
			m_masterAlpha = 1.0;
		
			m_isDead = false;
			
			m_poolClass = null;
			
			if (xxx == null) {
				xxx = __xxx;
		
				m_XLogicObjects = new XDict (); // <XLogicObject, Int>
				m_worldSprites = new XDict ();  // <XDepthSprite, Int>
				m_hudSprites = new XDict (); // <XDepthSprite, Int>
				m_childSprites = new XDict (); // <Sprite, Sprite>
				m_detachedSprites = new XDict (); // <Sprite, Sprite>
				m_bitmaps = new XDict (); // <String, XBitmap> 
				m_movieClips = new XDict (); // <String, XMovieClip>
				m_textSprites = new XDict (); // <XTextSprite, Int>
				m_XSignals = new XDict (); // <XSignal, Int>
				m_XTaskSubManager0 = new XTaskSubManager (getXLogicManager ().getXTaskManager0 ());
				m_XTaskSubManager = new XTaskSubManager (getXLogicManager ().getXTaskManager ());
				m_XTaskSubManagerCX = new XTaskSubManager (getXLogicManager ().getXTaskManagerCX ());	
			}
			
			m_killSignal = createXSignal ();
			m_killSignalWithLogic = createXSignal ();
			
			m_pos = xxx.getXPointPoolManager ().borrowObject () as XPoint;
			rp = xxx.getXPointPoolManager ().borrowObject () as XPoint;
			
			setRegistration ();
			
			m_viewPortRect = xxx.getXRectPoolManager ().borrowObject () as XRect;	
			m_selfRect = xxx.getXRectPoolManager ().borrowObject () as XRect;
			m_itemRect = xxx.getXRectPoolManager ().borrowObject () as XRect;
			m_itemPos = xxx.getXPointPoolManager ().borrowObject () as XPoint;
			
			setVisible (false);			
			visible = false;
			
			setAlpha (1.0);
			alpha = 1.0;
		}

//------------------------------------------------------------------------------------------
		public function setupX ():void {
		}

//------------------------------------------------------------------------------------------
		public function addKillListener (__listener:Function):void {
			m_killSignal.addListener (__listener);
		}
		
//------------------------------------------------------------------------------------------
		public function fireKillSignal (__model:XModelBase):void {
			m_killSignal.fireSignal (__model);
		}
	
//------------------------------------------------------------------------------------------
		public function addKillListenerWithLogic (__listener:Function):void {
			m_killSignalWithLogic.addListener (__listener);
		}
		
//------------------------------------------------------------------------------------------
		public function fireKillSignalWithLogic (__logicObject:XLogicObject):void {
			m_killSignalWithLogic.fireSignal (__logicObject);
		}
		
//------------------------------------------------------------------------------------------
		public function cleanup ():void {
			// <HAXE>
			/* --
			-- */
			// </HAXE>
			// <AS3>
			if (CONFIG::starling) {
				dispose ();
			}
			// </AS3>
				
			xxx.getXPointPoolManager ().returnObject (m_pos);
			xxx.getXPointPoolManager ().returnObject (rp);
			
			xxx.getXRectPoolManager ().returnObject (m_viewPortRect);
			xxx.getXRectPoolManager ().returnObject (m_selfRect);
			xxx.getXRectPoolManager ().returnObject (m_itemRect);
			xxx.getXPointPoolManager ().returnObject (m_itemPos);
			
// if this item was spawned from a Level, decrement the item count and
// broadcast a "kill" signal.  it's possible for outsiders to subscribe
// to a the "kill" event.
			
			fireKillSignal (m_item);
			fireKillSignalWithLogic (this);
			
			if (m_item != null) {
//				fireKillSignal (m_item);
							
				m_item.inuse--;
				
				m_item = null;
			}
			
			removeAll ();

			if (m_poolClass != null) {
				xxx.getXLogicObjectPoolManager ().returnObject (m_poolClass, this);
			}
			
			isDead = true;
		}

//------------------------------------------------------------------------------------------
		public function nukeLater ():void {
			if (m_item != null) {
				m_item.inuse++;
			}
			
			killLater ();
		}
		
//------------------------------------------------------------------------------------------
// kill this object and remove it from the World (delayed)
//------------------------------------------------------------------------------------------
		public function killLater ():void {
			isDead = true;
			
			getXLogicManager ().killLater (this);
		}

//------------------------------------------------------------------------------------------
// kill this object and remove it from the World (now)
//------------------------------------------------------------------------------------------
		public function kill ():void {
			isDead = true;
			
			getXLogicManager ().killLater (this);
		}

//------------------------------------------------------------------------------------------
		public function nuke ():void {
			if (m_item != null) {
				m_item.inuse++;
			}
			
			kill ();
		}
		
//------------------------------------------------------------------------------------------
		public function removeAll ():void {
			removeAllTasks ();
			removeAllXLogicObjects ();
			removeAllWorldSprites ();
			removeAllHudSprites ();
			removeAllXBitmaps ();
			removeAllMovieClips ();
			removeAllXTextSprites ();
			removeAllXSignals ();
			removeAllTasksCX ();
			
			if (getParent () != null) {
				getParent ().removeXLogicObject0 (this);
			}
		}
		
//------------------------------------------------------------------------------------------
// cull this object if it strays outside the current viewPort
//------------------------------------------------------------------------------------------	
		public function cullObject ():void {
			if (autoCulling) {
				autoCullObject ();
				
				return;
			}
// if this object wasn't ever spawned from a level, don't perform any culling
			if (m_item == null) {
				return;
			}
			
// determine whether this object is outside the current viewPort
			var v:XRect = xxx.getViewRect();
			
			xxx.getXWorldLayer (m_layer).viewPort (v.width, v.height).copy2 (m_viewPortRect);
			m_viewPortRect.inflate (cullWidth (), cullHeight ());
			
			if (m_viewPortRect.intersects (m_itemRect)) {
				return;
			}
			
			m_boundingRect.copy2 (m_selfRect);
			m_selfRect.offsetPoint (getPos ());
			
			if (m_viewPortRect.intersects (m_selfRect)) {
				return;
			}
				
// yep, kill it
			trace (": ---------------------------------------: ");
			trace (": cull: ", this);
			
			killLater ();
		}

		//------------------------------------------------------------------------------------------
		// auto-cull this object if it strays outside the current viewPort
		//
		// auto-culled objects aren't spawned from a level so there's no
		// item object to retrieve a boundingRect from.  we're going to have
		// to provide a reasonable default for the boundingRect
		//------------------------------------------------------------------------------------------	
		public function autoCullObject ():void {
			// determine whether this object is outside the current viewPort
			var v:XRect = xxx.getViewRect();
			
			var r:XRect = xxx.getXRectPoolManager ().borrowObject () as XRect;	
			var i:XRect = xxx.getXRectPoolManager ().borrowObject () as XRect;

			xxx.getXWorldLayer (m_layer).viewPort (v.width, v.height).copy2 (r);
			r.inflate (autoCullWidth (), autoCullHeight ());
			
			m_boundingRect.copy2 (i);
			i.offsetPoint (getPos ());
			
			function __dealloc ():void {
				xxx.getXRectPoolManager ().returnObject (r);
				xxx.getXRectPoolManager ().returnObject (i);
			}
			
			if (r.intersects (i)) {
				__dealloc ();
				
				return;
			}
			
			__dealloc ();
			
			// yep, kill it
			trace (": ---------------------------------------: ");
			trace (": cull: ", this);
			
			killLater ();
		}

//------------------------------------------------------------------------------------------
		public function cullWidth ():Number {
			return 256;
		}
		
//------------------------------------------------------------------------------------------
		public function cullHeight ():Number {
			return 256;
		}
		
//------------------------------------------------------------------------------------------
		public function autoCullWidth ():Number {
			return 512;
		}
		
//------------------------------------------------------------------------------------------
		public function autoCullHeight ():Number {
			return 512;
		}
		
//------------------------------------------------------------------------------------------
		public function setParent (__parent:XLogicObject):void {
			m_parent = __parent;
		}
		
//------------------------------------------------------------------------------------------
		public function getParent ():XLogicObject {
			return m_parent;
		}

//------------------------------------------------------------------------------------------
// <HAXE>
/* --
-- */
// </HAXE>
// <AS3>
//------------------------------------------------------------------------------------------
/*
//------------------------------------------------------------------------------------------
		public function findMovieClipByName (
			__movieClip:flash.display.MovieClip,
			__className:String
			):flash.display.MovieClip {
				
			for (var i:uint = 0; i < __movieClip.numChildren; i++) {
				var m$:flash.display.MovieClip = __movieClip.getChildAt (i) as MovieClip;
				
				if (m$ != null) {
					if (m$.name == __className) {
						return m$;
					}
					else
					{
						m$ = findMovieClipByName (m$, __className);
					
						if (m$ != null) {
							return m$;
						}
					}
				}
			}
			
			return null;
		}

//------------------------------------------------------------------------------------------
		public function findClassByName (
			__movieClip:flash.display.MovieClip,
			__className:String
			):* {
				
			for (var i:uint = 0; i < __movieClip.numChildren; i++) {
				var m$:* = __movieClip.getChildAt (i);
				
				if (m$ != null) {
					if (m$.name == __className) {
						return m$;
					}
					else
					{
						var m:flash.display.MovieClip = m$ as MovieClip;
						
						if (m != null) {
							m$ = findClassByName (m, __className);
					
							if (m$ != null) {
								return m$;
							}
						}
					}
				}
			}
			
			return null;
		}
				
//------------------------------------------------------------------------------------------
		public function findTextFieldByName (
			__movieClip:flash.display.MovieClip,
			__className:String
			):TextField {
				
			for (var i:uint = 0; i < __movieClip.numChildren; i++) {
				var m$:flash.display.MovieClip = __movieClip.getChildAt (i) as flash.display.MovieClip;
				var t$:flash.text.TextField = __movieClip.getChildAt (i) as flash.text.TextField;
				
				if (m$ != null) {
					t$ = findTextFieldByName (m$, __className);
					
					if (t$ != null) {
						return t$;
					}
				}
				
				if (t$ != null) {
					if (t$.name == __className) {
						return t$;
					}
				}
			}
			
			return null;
		}
*/
		
//------------------------------------------------------------------------------------------
/*
		public function localToGlobalXX (__obj:XLogicObject, __pos:XPoint):XPoint {
			var __x:Number;
			var __y:Number;
			
			__x = __pos.x + __obj.getPos ().x;
			__y = __pos.y + __obj.getPos ().y;
			
			__pos = new XPoint (__x, __y);
			
			if (__obj.m_parent != null) {
				__pos = localToGlobalXX (__obj.m_parent, __pos);
			}
			
			return __pos;
		}
		
//------------------------------------------------------------------------------------------
		public function localToGlobalX (__obj:XLogicObject, __pos:XPoint):XPoint {
			var __x:Number;
			var __y:Number;
			var __newPos:XPoint;
			
			if (__obj.m_parent != null) {
				__x = __pos.x + __obj.m_parent.getPos ().x;
				__y = __pos.y + __obj.m_parent.getPos ().y;
			
				__newPos = localToGlobalX (__obj.m_parent, new XPoint (__x, __y));
			}
			else
			{
				__newPos = __pos;
			}
			
			return __newPos;
		}

//------------------------------------------------------------------------------------------
		public function globalToLocalX (__obj:XLogicObject, __pos:XPoint):XPoint {
			var __x:Number;
			var __y:Number;
			var __newPos:XPoint;
			
			if (__obj.m_parent != null) {
				__x = __obj.m_parent.getPos ().x - __pos.x;
				__y = __obj.m_parent.getPos ().y - __pos.y;
			
				__newPos = localToGlobalX (__obj.m_parent, new XPoint (__x, __y));
			}
			else
			{
				__newPos = __pos;
			}
			
			return __newPos;
		}
*/
// </AS3>
		
//------------------------------------------------------------------------------------------
		public function setPoolClass (__class:Class /* <Dynamic> */):void {
			m_poolClass = __class;
		}
		
//------------------------------------------------------------------------------------------
// get a map of all our child sprites that live in the World
//------------------------------------------------------------------------------------------	
		public function getSprites ():XDict /* <XDepthSprite, Int> */ {
			return m_worldSprites;
		}
		
//------------------------------------------------------------------------------------------	
		public function sprites ():XDict /* <XDepthSprite, Int> */ {
			return m_worldSprites;
		}
		
//------------------------------------------------------------------------------------------
// get a map of all our child sprites that live in the HUD
//------------------------------------------------------------------------------------------	
		public function getHudSprites ():XDict /* <XDepthSprite, Int> */ {
			return m_hudSprites;
		}
		
//------------------------------------------------------------------------------------------
// get a map of all the our child XLogicObjects
//------------------------------------------------------------------------------------------	
		public function getXLogicObjects ():XDict /* <XLogicObject, Int> */ {
			return m_XLogicObjects;
		}

//------------------------------------------------------------------------------------------
		public function createXBitmap (__name:String):XBitmap {	
			var __bitmap:XBitmap = xxx.getXBitmapPoolManager ().borrowObject () as XBitmap;
			__bitmap.setup ();
			__bitmap.initWithClassName (xxx, null, __name);
			__bitmap.alpha = 1.0;
			__bitmap.scaleX = __bitmap.scaleY = 1.0;
			
			m_bitmaps.set (__name, __bitmap);
			
			return __bitmap;
		}

//------------------------------------------------------------------------------------------
		public function createXMovieClip (__name:String):XMovieClip {
			var __xmovieClip:XMovieClip = new XMovieClip ();
			
			__xmovieClip.setup ();
			
			__xmovieClip.initWithClassName (xxx, null, __name);
			
			m_movieClips.set (__name, __xmovieClip);
			
			return __xmovieClip;
		}
			
//------------------------------------------------------------------------------------------
		public function createXTextSprite (
			__width:Number=32,
			__height:Number=32,
			__text:String="",
			__fontName:String="Aller",
			__fontSize:int=12,
			__color:int=0x000000,
			__bold:Boolean=false,
			__embedFonts:Boolean=true
			):XTextSprite {
			
			var __textSprite:XTextSprite = new XTextSprite (
				__width,
				__height,
				__text,
				__fontName,
				__fontSize,
				__color,
				__bold,
				__embedFonts
			);

			m_textSprites.set (__textSprite, 0);
			
			return __textSprite;
		}
		
//------------------------------------------------------------------------------------------
		public function removeAllXBitmaps ():void {
			m_bitmaps.forEach (
				function (__name:*):void {
					var __bitmap:XBitmap = m_bitmaps.get (__name) as XBitmap;
					
					__bitmap.cleanup ();
					
					xxx.getXBitmapPoolManager ().returnObject (__bitmap);
				}
			);
			
			m_bitmaps.removeAllKeys ();
		}
		
//------------------------------------------------------------------------------------------
		public function removeAllMovieClips ():void {
			m_movieClips.forEach (
				function (__name:*):void {
					var __xmovieClip:XMovieClip = m_movieClips.get (__name) as XMovieClip;
					
					if (CONFIG::starling) {
						__xmovieClip.cleanup ();
					}
					else
					{
						__xmovieClip.cleanup ();
						
						xxx.unloadClass (/* @:cast */ __name as String);
					}
				}
			);
			
			m_movieClips.removeAllKeys ();
		}

//------------------------------------------------------------------------------------------
		public function removeXTextSprite (__textSprite:XTextSprite):void {
			if (m_textSprites.exists (__textSprite)) {
				__textSprite.cleanup();
				
				m_textSprites.remove (__textSprite);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function removeAllXTextSprites ():void {
			m_textSprites.forEach (
				function (x:*):void {
					var __textSprite:XTextSprite = x as XTextSprite;
					
					__textSprite.cleanup ();
				}
			);
			
			m_textSprites.removeAllKeys ();
		}
		
//------------------------------------------------------------------------------------------
// add sprite to another sprite
//------------------------------------------------------------------------------------------
		public function addDetachedSprite (
			__sprite:Sprite,
			__sprite2:Sprite,
			__dx:Number, __dy:Number
			):void {
	
			__sprite2.addChild (__sprite);
			
			__sprite.x = -__dx;
			__sprite.y = -__dy;
			
			m_detachedSprites.set (__sprite, __sprite2);
		}
		
//------------------------------------------------------------------------------------------
// add sprite to another sprite
//------------------------------------------------------------------------------------------
		public function addChildSprite (
			__sprite:Sprite,
			__sprite2:Sprite,
			__dx:Number, __dy:Number
			):void {
	
			__sprite2.addChild (__sprite);
			
			__sprite.x = -__dx;
			__sprite.y = -__dy;
			
			m_childSprites.set (__sprite, __sprite2);
		}
		
//------------------------------------------------------------------------------------------
// add a sprite the World
//------------------------------------------------------------------------------------------	
		public function addSprite (__sprite:Sprite):XDepthSprite {
			return addSpriteAt (__sprite, 0, 0);
		}

//------------------------------------------------------------------------------------------
		public function addSpriteAt (__sprite:DisplayObject, __dx:Number, __dy:Number, __relative:Boolean = false):XDepthSprite {
			if (m_layer == -1) {
				return addSpriteToHudAt (__sprite, __dx, __dy);
			}
			
			var __depthSprite:XDepthSprite;
			
			if (__relative || getRelativeDepthFlag ()) {
				__depthSprite = xxx.getXWorldLayer (m_layer).addSprite (__sprite, 0);
				__depthSprite.setRelativeDepthFlag (true);				
			}
			else
			{
				__depthSprite = xxx.getXWorldLayer (m_layer).addSprite (__sprite, getDepth ());
			}
				
			__depthSprite.setRegistration (__dx, __dy);
			
			m_worldSprites.set (__depthSprite, 0);
			
			return __depthSprite;
		}
				
//------------------------------------------------------------------------------------------
// remove a sprite from the World
//------------------------------------------------------------------------------------------	
		public function removeSprite (__sprite:XDepthSprite):void {
			if (m_worldSprites.exists (__sprite)) {
				m_worldSprites.remove (__sprite);
				
				xxx.getXWorldLayer (m_layer).removeSprite (__sprite);
			}
		}

//------------------------------------------------------------------------------------------
		public function removeAllWorldSprites ():void {
			m_worldSprites.forEach (
				function (x:*):void {
					removeSprite (x);
				}
			);
		}
		
//------------------------------------------------------------------------------------------
// add a sprite to the HUD
//------------------------------------------------------------------------------------------	
		public function addSpriteToHud (__sprite:Sprite):XDepthSprite {
			return addSpriteToHudAt (__sprite, 0, 0);
		}

//------------------------------------------------------------------------------------------
		public function addSpriteToHudAt (__sprite:DisplayObject, __dx:Number, __dy:Number, __relative:Boolean = false):XDepthSprite {
			var __depthSprite:XDepthSprite;
			
			if (__relative || getRelativeDepthFlag ()) {
				__depthSprite = xxx.getXHudLayer ().addSprite (__sprite, 0);
				__depthSprite.setRelativeDepthFlag (true);				
			}
			else
			{
				__depthSprite = xxx.getXHudLayer ().addSprite (__sprite, getDepth ());
			}
							
			__depthSprite.setRegistration (__dx, __dy);
			
			m_hudSprites.set (__depthSprite, 0);
			
			return __depthSprite;
		}
		
//------------------------------------------------------------------------------------------
// remove a sprite from the HUD
//------------------------------------------------------------------------------------------	
		public function removeSpriteFromHud (__sprite:XDepthSprite):void {
			if (m_hudSprites.exists (__sprite)) {
				m_hudSprites.remove (__sprite);
				
				xxx.getXHudLayer ().removeSprite (__sprite);
			}
		}

//------------------------------------------------------------------------------------------
		public function removeAllHudSprites ():void {
			m_hudSprites.forEach (
				function (x:*):void {
					removeSpriteFromHud (x);
				}
			);
		}
		
//------------------------------------------------------------------------------------------
// add an XLogicObject to the World
//------------------------------------------------------------------------------------------	
		public function addXLogicObject (__XLogicObject:XLogicObject):XLogicObject {
			m_XLogicObjects.set (__XLogicObject, 0);
			
			return __XLogicObject;
		}
		
//------------------------------------------------------------------------------------------
// remove an XLogicObject from the World
//------------------------------------------------------------------------------------------	
		public function removeXLogicObject (__XLogicObject:XLogicObject):void {
			if (m_XLogicObjects.exists (__XLogicObject)) {
				m_XLogicObjects.remove (__XLogicObject);
				
				__XLogicObject.cleanup ();
			}
		}
		
//------------------------------------------------------------------------------------------
// remove an XLogicObject from the World but don't kill it
//------------------------------------------------------------------------------------------	
		public function removeXLogicObject0 (__XLogicObject:XLogicObject):void {
			if (m_XLogicObjects.exists (__XLogicObject)) {
				m_XLogicObjects.remove (__XLogicObject);
			}
		}

//------------------------------------------------------------------------------------------
		public function removeAllXLogicObjects ():void {
			m_XLogicObjects.forEach (
				function (x:*):void {
					removeXLogicObject (x);
				}
			);
		}
		
//------------------------------------------------------------------------------------------
// not implemented: XLogicObjects that are spawned from a level can contain intialization
// parameters
//------------------------------------------------------------------------------------------	
		public function getDefaultParams ():XSimpleXMLNode {
			return null;
		}

//------------------------------------------------------------------------------------------
		/* @:get, set autoCulling Bool */
		
		public function get autoCulling ():Boolean {
			return m_autoCulling;
		}
		
		public function set autoCulling (__val:Boolean): /* @:set_type */ void {
			m_autoCulling = __val;
			
			if (autoCulling) {
				boundingRect = new XRect (-32, -32, +64, +64);
			}
			
			/* @:set_return true; */	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function setItem (__item:XMapItemModel):void {
			m_item = __item;
			
			if (m_item != null) {
				m_boundingRect = __item.boundingRect.cloneX ();
				
				m_item.boundingRect.copy2 (m_itemRect);
				m_itemPos.x = m_item.x;
				m_itemPos.y = m_item.y;
				m_itemRect.offsetPoint (m_itemPos);
			}
		}

//------------------------------------------------------------------------------------------
		/* @:get, set item XMapItemModel */
		
		public function get item ():XMapItemModel {
			return m_item;
		}
		
		public function set item (__val:XMapItemModel): /* @:set_type */ void {
			/* @:set_return null; */	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function setupItemParamsXML ():void {
			m_xml = new XSimpleXMLNode ();
			
			if (item != null && item.params != null && item.params != "") {
				m_xml.setupWithXMLString (item.params);
			}
		}

//------------------------------------------------------------------------------------------
		public function setXML (__xml:XSimpleXMLNode):void {
			m_xml = __xml;
		}
		
//------------------------------------------------------------------------------------------
		public function getXML ():XSimpleXMLNode {
			return m_xml;
		}
		
//------------------------------------------------------------------------------------------
		public function itemHasAttribute (__attr:String):Boolean {
			return m_xml.hasAttribute (__attr);	
		}
		
//------------------------------------------------------------------------------------------
		public function itemGetAttribute (__attr:String):* {
			return m_xml.getAttribute (__attr);
		}
		
//------------------------------------------------------------------------------------------
		public function setLayer (__layer:int):void {
			if (__layer != m_layer && m_layer != -1) {
				m_worldSprites.forEach (
					function (x:*):void {
						xxx.getXWorldLayer (m_layer).moveSprite (x);
						xxx.getXWorldLayer (__layer).addDepthSprite (x);
					}
				);
			}
			
			m_layer = __layer;
		}

//------------------------------------------------------------------------------------------
		public function getLayer ():int {
			return m_layer;
		}
		
//------------------------------------------------------------------------------------------
		public function setValues ():void {		
			setRegistration (-getPos ().x, -getPos ().y);
		}

//------------------------------------------------------------------------------------------
		public function getArg(__args:Array /* <Dynamic> */, i:int):* {
			return __args[i];
		}
		
//------------------------------------------------------------------------------------------
		/* @:get, set o Dynamic */
			
		public function get o ():Object {
			return /* @:cast */ this as Object;
		}	
	
		public function set o (__val:*): /* @:set_type */ void {
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set isDead Bool */
			
		public function get isDead ():Boolean {
			return m_isDead;
		}
		
		public function set isDead (__val:Boolean): /* @:set_type */ void {
			m_isDead = __val;
			
			/* @:set_return true; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function collisionCallback ():void {	
		}
		
//------------------------------------------------------------------------------------------
		/* @:get, set oXLogicManager XLogicManager */
		
		public function get oXLogicManager ():XLogicManager {
			return m_XLogicManager;
		}
		
		public function set oXLogicManager (__val:XLogicManager): /* @:set_type */ void {
			m_XLogicManager = __val;
			
			/* @:set_return null; */	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function getXLogicManager ():XLogicManager {
			return m_XLogicManager;
		}
		
//------------------------------------------------------------------------------------------
		/* @:get, set boundingRect XRect */

		[Inline]
		public function get boundingRect ():XRect {
			return m_boundingRect;
		}
		
		[Inline]
		public function set boundingRect (__val:XRect): /* @:set_type */ void {
			m_boundingRect = __val;
			
			/* @:set_return null; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set pos XPoint */
		
		[Inline]
		public function get pos ():XPoint{
			return m_pos;
		}
				
		[Inline]
		public function set pos (__pos:XPoint): /* @:set_type */ void {
			m_pos = __pos;
			
			/* @:set_return null; */	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set oX Float */
		
		[Inline]
		public function get oX ():Number {
			return m_pos.x;
		}

		[Inline]
		public function set oX (__val:Number): /* @:set_type */ void {
			m_pos.x = __val;
			
			/* @:set_return 0; */	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set oY Float */
		
		[Inline]
		public function get oY ():Number {
			return m_pos.y;
		}		

		[Inline]
		public function set oY (__val:Number): /* @:set_type */ void {
			m_pos.y = __val;

			/* @:set_return 0; */	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		[Inline]
		public function getPos ():XPoint {
			return m_pos;
		}
	
		[Inline]
		public function setPos (__pos:XPoint):void {
			m_pos = __pos;
		}
		
//------------------------------------------------------------------------------------------
		/* @:get, set oAlpha Float */
		
		[Inline]
		public function get oAlpha ():Number {
			return m_alpha;
		}
		
		[Inline]
		public function set oAlpha (__alpha:Number): /* @:set_type */ void {
			m_alpha = __alpha;
			
			/* @:set_return 0; */	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		[Inline]
		public function getAlpha ():Number {
			return m_alpha;
		}
		
		[Inline]
		public function setAlpha (__alpha:Number):void {
			m_alpha = __alpha;
		}

//------------------------------------------------------------------------------------------		
		public function setMasterAlpha (__alpha:Number):void {
			m_masterAlpha = __alpha;
		}
		
//------------------------------------------------------------------------------------------		
		public function getMasterAlpha ():Number {
			return m_masterAlpha;
		}
			
//------------------------------------------------------------------------------------------
		/* @:get, set oVisible Bool */
		
		public function get oVisible ():Boolean {
			return m_visible;
		}
		
		public function set oVisible (__val:Boolean): /* @:set_type */ void {
			m_visible = __val;
			
			/* @:set_return true; */	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function getVisible ():Boolean {
			return m_visible;
		}

		public function setVisible (__val:Boolean):void {
			m_visible = __val;
		}
		
//------------------------------------------------------------------------------------------		
		public function setMasterVisible (__visible:Boolean):void {
			m_masterVisible = __visible;
		}
		
//------------------------------------------------------------------------------------------		
		public function getMasterVisible ():Boolean {
			return m_masterVisible;
		}
					
//------------------------------------------------------------------------------------------
		/* @:get, set oRotation Float */
		
		[Inline]
		public function get oRotation ():Number {
			return m_rotation;
		}
		
		[Inline]
		public function set oRotation (__val:Number): /* @:set_type */ void {
			m_rotation = __val % 360;
			
			/* @:set_return 0; */	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		[Inline]
		public function getRotation ():Number {
			return m_rotation;
		}
		
		[Inline]
		public function setRotation (__rotation:Number):void {
			m_rotation = __rotation % 360;
		}
		
//------------------------------------------------------------------------------------------		
		public function setMasterRotation (__rotation:Number):void {
			m_masterRotation = __rotation % 360;
		}
		
//------------------------------------------------------------------------------------------		
		public function getMasterRotation ():Number {
			return m_masterRotation;
		}
				
//------------------------------------------------------------------------------------------
		/* @:get, set oScale Float */
		
		[Inline]
		public function get oScale ():Number {
			return m_scaleX;
		}

		[Inline]
		public function set oScale (__val:Number): /* @:set_type */ void {
			m_scaleX  = m_scaleY = __val;
			
			/* @:set_return 0; */	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		[Inline]
		public function getScale ():Number {
			return m_scaleX;
		}
		
		[Inline]
		public function setScale (__scale:Number):void {
			m_scaleX  = m_scaleY = __scale;
		}
		
//------------------------------------------------------------------------------------------
		/* @:get, set oScaleX Float */
		
		[Inline]
		public function get oScaleX ():Number {
			return m_scaleX;
		}
		
		[Inline]
		public function set oScaleX (__val:Number): /* @:set_type */ void {
			m_scaleX = __val;
			
			/* @:set_return 0; */	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		[Inline]
		public function getScaleX ():Number {
			return m_scaleX;
		}

		[Inline]
		public function setScaleX (__scale:Number):void {
			m_scaleX = __scale;
		}
		
//------------------------------------------------------------------------------------------
		/* @:get, set oScaleY Float */
		
		[Inline]
		public function get oScaleY ():Number {
			return m_scaleY;
		}
		
		[Inline]
		public function set oScaleY (__val:Number): /* @:set_type */ void {
			m_scaleY = __val;
			
			/* @:set_return 0; */	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		[Inline]
		public function getScaleY ():Number {
			return m_scaleY;
		}
		
		[Inline]
		public function setScaleY (__scale:Number):void {
			m_scaleY = __scale;
		}
		
//------------------------------------------------------------------------------------------
/*		
		public function setMasterScale (__scale:Number):void {
			m_masterScaleX = m_masterScaleY = __scale;
		}
		
//------------------------------------------------------------------------------------------
		public function getMasterScale ():Number {
			return m_masterScaleX;
		}
*/

//------------------------------------------------------------------------------------------		
		public function setMasterScaleX (__scale:Number):void {
			m_masterScaleX = __scale;
		}
		
//------------------------------------------------------------------------------------------		
		public function getMasterScaleX ():Number {
			return m_masterScaleX;
		}

//------------------------------------------------------------------------------------------		
		public function setMasterScaleY (__scale:Number):void {
			m_masterScaleY = __scale;
		}
		
//------------------------------------------------------------------------------------------		
		public function getMasterScaleY ():Number {
			return m_masterScaleY;
		}
				
//------------------------------------------------------------------------------------------
		[Inline]
		public function setDepth (__depth:Number):void {
			m_depth = __depth;
		}		
		
//------------------------------------------------------------------------------------------
		[Inline]
		public function getDepth ():Number {
			return m_depth;
		}

//------------------------------------------------------------------------------------------		
		public function setMasterDepth (__depth:Number):void {
			m_masterDepth = __depth;
		}
		
//------------------------------------------------------------------------------------------		
		public function getMasterDepth ():Number {
			return m_masterDepth;
		}
	
//------------------------------------------------------------------------------------------	
		public function setRelativeDepthFlag (__relative:Boolean):void {
			m_relativeDepthFlag = __relative;
		}		
		
//------------------------------------------------------------------------------------------
		public function getRelativeDepthFlag ():Boolean {
			return m_relativeDepthFlag;
		}

//------------------------------------------------------------------------------------------
// the function updates all the children that live inside the XLogicObject container
//
// children in the XLogicObject sense aren't DisplayObject children.  This is done
// so that the depth sorting on each child can be controlled explicitly.
//------------------------------------------------------------------------------------------	
		public function updateDisplay ():void {
			if (m_delayed > 0) {
				m_delayed--;
				
				return;
			}

//------------------------------------------------------------------------------------------			
			var i:*;

			var __x:Number = x;
			var __y:Number = y;
			var __visible:Boolean = getMasterVisible ();
			var __scaleX:Number = getMasterScaleX ();
			var __scaleY:Number = getMasterScaleY ();
			var __rotation:Number = getMasterRotation ();
			var __depth:Number = getMasterDepth ();
			var __alpha:Number = getMasterAlpha ();
			
//------------------------------------------------------------------------------------------
			var logicObject:XLogicObject;
			
// update children XLogicObjects
			m_XLogicObjects.forEach (
				function (i:*):void {
					logicObject = i as XLogicObject;
							
					if (logicObject != null) {	
						logicObject.x2 = __x;
						logicObject.y2 = __y;
						logicObject.rotation2 = __rotation;
						logicObject.visible = __visible;
						logicObject.scaleX2 = __scaleX;
						logicObject.scaleY2 = __scaleY;
						logicObject.alpha = __alpha;
						
						// propagate rotation, scale, visibility, alpha
						logicObject.setMasterRotation (logicObject.getRotation () + __rotation);
						logicObject.setMasterScaleX (logicObject.getScaleX () * __scaleX);
						logicObject.setMasterScaleY (logicObject.getScaleY () * __scaleY);
						logicObject.setMasterVisible (logicObject.getVisible () && __visible);
						if (logicObject.getRelativeDepthFlag ()) {
							logicObject.setMasterDepth (logicObject.getDepth () + __depth);
						}
						else
						{
							logicObject.setMasterDepth (logicObject.getDepth ());
						}
						logicObject.setMasterAlpha (logicObject.getAlpha () * __alpha);
						
						logicObject.updateDisplay ();
					}
				}
			);
			
//------------------------------------------------------------------------------------------
			var sprite:XDepthSprite;

// update child sprites that live as children of the Sprite
			m_childSprites.forEach (
				function (i:*):void {
				}
			);
								
// update child sprites that live in the World
			m_worldSprites.forEach (
				function (i:*):void {
					sprite = i as XDepthSprite;
					
					if (sprite != null) {
						sprite.x2 = __x;
						sprite.y2 = __y;
						sprite.rotation2 = __rotation;
						sprite.visible = sprite.visible2 && __visible;
						if (sprite.relativeDepthFlag) {
							sprite.depth2 = sprite.depth + __depth;
						}
						else
						{
							sprite.depth2 = sprite.depth;
						}
						sprite.scaleX2 = __scaleX;
						sprite.scaleY2 = __scaleY;
						sprite.alpha = __alpha;
					}
				}
			);
			
// update child sprites that live in the HUD
			m_hudSprites.forEach (
				function (i:*):void {
					sprite = i as XDepthSprite;
					
					if (sprite != null) {
						sprite.x2 = __x;
						sprite.y2 = __y;
						sprite.rotation2 = __rotation;
						sprite.visible = sprite.visible2 && __visible;
						if (sprite.relativeDepthFlag) {
							sprite.depth2 = sprite.depth + __depth;
						}
						else
						{
							sprite.depth2 = sprite.depth;
						}
						sprite.scaleX2 = __scaleX;
						sprite.scaleY2 = __scaleY;
						sprite.alpha = __alpha;
					}
				}
			);
		}

//------------------------------------------------------------------------------------------
		public function gotoAndPlay (__frame:int):void {
		}
		
//------------------------------------------------------------------------------------------
		public function gotoAndStop (__frame:int):void {
		}
		
//------------------------------------------------------------------------------------------
		public function createXSignal ():XSignal {
			var __signal:XSignal = xxx.getXSignalManager ().createXSignal ();
		
			if (!(m_XSignals.exists (__signal))) {
				m_XSignals.set (__signal, 0);
			}
			
			__signal.setParent (this);
			
			return __signal;
		}

//------------------------------------------------------------------------------------------
		public function removeXSignal (__signal:XSignal):void {	
			if (m_XSignals.exists (__signal)) {
				m_XSignals.remove (__signal);
					
				xxx.getXSignalManager ().removeXSignal (__signal);
			}
		}

//------------------------------------------------------------------------------------------
		public function removeAllXSignals ():void {
			m_XSignals.forEach (
				function (x:*):void {
					removeXSignal (/* @:cast */ x as XSignal);
				}
			);
		}

//------------------------------------------------------------------------------------------
// XTaskManager0
//------------------------------------------------------------------------------------------	
//		public function getXTaskManager0 ():XTaskManager {
//			return xxx.getXTaskManager0 ();
//		}
		
//------------------------------------------------------------------------------------------
		public function addTask0 (
			__taskList:Array /* <Dynamic> */,
			__findLabelsFlag:Boolean = true
		):XTask {
			
			var __task:XTask = m_XTaskSubManager0.addTask (__taskList, __findLabelsFlag);
			
			__task.setParent (this);
			
			return __task;
		}
		
//------------------------------------------------------------------------------------------
		public function changeTask0 (
			__task:XTask,
			__taskList:Array /* <Dynamic> */,
			__findLabelsFlag:Boolean = true
		):XTask {
			
			return m_XTaskSubManager0.changeTask (__task, __taskList, __findLabelsFlag);
		}
		
//------------------------------------------------------------------------------------------
		public function isTask0 (__task:XTask):Boolean {
			return m_XTaskSubManager0.isTask (__task);
		}		
		
//------------------------------------------------------------------------------------------
		public function removeTask0 (__task:XTask):void {
			m_XTaskSubManager0.removeTask (__task);	
		}
		
//------------------------------------------------------------------------------------------
		public function removeAllTasks0 ():void {
			m_XTaskSubManager0.removeAllTasks ();
		}
		
//------------------------------------------------------------------------------------------
		public function addEmptyTask0 ():XTask {
			return m_XTaskSubManager0.addEmptyTask ();
		}
		
//------------------------------------------------------------------------------------------
//		public function getEmptyTask0$ ():Array /* <Dynamic> */ {
//			return m_XTaskSubManager0.getEmptyTaskX ();
//		}	
		
//------------------------------------------------------------------------------------------
		public function getEmptyTask0X ():Array /* <Dynamic> */ {
			return m_XTaskSubManager0.getEmptyTaskX ();
		}	
		
//------------------------------------------------------------------------------------------
		public function gotoLogic0 (__logic:Function):void {
			m_XTaskSubManager0.gotoLogic (__logic);
		}
		
//------------------------------------------------------------------------------------------
// XTaskManager
//------------------------------------------------------------------------------------------		
		public function getXTaskManager ():XTaskManager {
			return xxx.getXTaskManager ();
		}

//------------------------------------------------------------------------------------------
		public function addTask (
			__taskList:Array /* <Dynamic> */,
			__findLabelsFlag:Boolean = true
			):XTask {

			var __task:XTask = m_XTaskSubManager.addTask (__taskList, __findLabelsFlag);
			
			__task.setParent (this);
			
			return __task;
		}

//------------------------------------------------------------------------------------------
		public function changeTask (
			__task:XTask,
			__taskList:Array /* <Dynamic> */,
			__findLabelsFlag:Boolean = true
			):XTask {
				
			return m_XTaskSubManager.changeTask (__task, __taskList, __findLabelsFlag);
		}

//------------------------------------------------------------------------------------------
		public function isTask (__task:XTask):Boolean {
			return m_XTaskSubManager.isTask (__task);
		}		
		
//------------------------------------------------------------------------------------------
		public function removeTask (__task:XTask):void {
			m_XTaskSubManager.removeTask (__task);	
		}

//------------------------------------------------------------------------------------------
		public function removeAllTasks ():void {
			m_XTaskSubManager.removeAllTasks ();
		}

//------------------------------------------------------------------------------------------
		public function addEmptyTask ():XTask {
			return m_XTaskSubManager.addEmptyTask ();
		}

//------------------------------------------------------------------------------------------
//		public function getEmptyTask$ ():Array /* <Dynamic> */ {
//			return m_XTaskSubManager.getEmptyTaskX ();
//		}	
			
//------------------------------------------------------------------------------------------
		public function getEmptyTaskX ():Array /* <Dynamic> */ {
			return m_XTaskSubManager.getEmptyTaskX ();
		}	
		
//------------------------------------------------------------------------------------------
		public function gotoLogic (__logic:Function):void {
			m_XTaskSubManager.gotoLogic (__logic);
		}
		
//------------------------------------------------------------------------------------------
// XTaskManagerCX
//------------------------------------------------------------------------------------------			
		public function getXTaskManagerCX ():XTaskManager {
			return xxx.getXTaskManagerCX ();
		}
		
//------------------------------------------------------------------------------------------
		public function addTaskCX (
			__taskList:Array /* <Dynamic> */,
			__findLabelsFlag:Boolean = true
		):XTask {
			
			var __task:XTask = m_XTaskSubManagerCX.addTask (__taskList, __findLabelsFlag);
			
			__task.setParent (this);
			
			return __task;
		}
		
//------------------------------------------------------------------------------------------
		public function changeTaskCX (
			__task:XTask,
			__taskList:Array /* <Dynamic> */,
			__findLabelsFlag:Boolean = true
		):XTask {
			
			return m_XTaskSubManagerCX.changeTask (__task, __taskList, __findLabelsFlag);
		}
		
//------------------------------------------------------------------------------------------
		public function isTaskCX (__task:XTask):Boolean {
			return m_XTaskSubManagerCX.isTask (__task);
		}		
		
//------------------------------------------------------------------------------------------
		public function removeTaskCX (__task:XTask):void {
			m_XTaskSubManagerCX.removeTask (__task);	
		}
		
//------------------------------------------------------------------------------------------
		public function removeAllTasksCX ():void {
			m_XTaskSubManagerCX.removeAllTasks ();
		}
		
//------------------------------------------------------------------------------------------
		public function addEmptyTaskCX ():XTask {
			return m_XTaskSubManagerCX.addEmptyTask ();
		}
		
//------------------------------------------------------------------------------------------
//		public function getEmptyTaskCX$ ():Array /* <Dynamic> */ {
//			return m_XTaskSubManagerCX.getEmptyTaskX ();
//		}	
		
//------------------------------------------------------------------------------------------
		public function getEmptyTaskCX ():Array /* <Dynamic> */ {
			return m_XTaskSubManagerCX.getEmptyTaskX ();
		}	
		
//------------------------------------------------------------------------------------------
		public function gotoLogicCX (__logic:Function):void {
			m_XTaskSubManagerCX.gotoLogic (__logic);
		}

//------------------------------------------------------------------------------------------
		public function setCollisions ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function updateLogic ():void {
		}

//------------------------------------------------------------------------------------------
		public function updatePhysics ():void {
		}
						
//------------------------------------------------------------------------------------------	
		public function createSprites ():void {
		}
					
//------------------------------------------------------------------------------------------
		public function show ():void {
			setVisible (true);
		}
		
//------------------------------------------------------------------------------------------
		public function hide ():void {
			setVisible (false);
		}		

//------------------------------------------------------------------------------------------
// initializer setters
//
// for use by createXLogicObjectFromXML
//------------------------------------------------------------------------------------------
		/* @:get, set iX Float */
		
		public function get iX ():Number {
			return m_iX;
		}
		
		public function set iX (__val:Number): /* @:set_type */ void {
			m_iX = __val;
			
			/* @:set_return 0; */	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set iY Float */
		
		public function get iY ():Number {
			return m_iY;
		}
		
		public function set iY (__val:Number): /* @:set_type */ void {
			m_iY = __val;
			
			/* @:set_return 0; */	
		}	
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set iScale Float */
		
		public function get iScale ():Number {
			return m_iScale;
		}
		
		public function set iScale (__val:Number): /* @:set_type */ void {
			m_iScale = __val;
			
			/* @:set_return 0; */	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set iRotation Float */
		
		public function get iRotation ():Number {
			return m_iRotation;
		}
		
		public function set iRotation (__val:Number): /* @:set_type */ void {
			m_iRotation = __val;
			
			/* @:set_return 0; */	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set iItem XMapItemModel */
		
		public function get iItem ():XMapItemModel {
			return m_iItem;
		}
		
		public function set iItem (__val:XMapItemModel): /* @:set_type */ void {
			m_iItem = __val;
			
			/* @:set_return null; */	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set iLayer Int */
		
		public function get iLayer ():int {
			return m_iLayer;
		}
		
		public function set iLayer (__val:int): /* @:set_type */ void {
			m_iLayer = __val;
			
			/* @:set_return 0; */	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set iDepth Float */
		
		public function get iDepth ():Number {
			return m_iDepth;
		}

		public function set iDepth (__val:Number): /* @:set_type */ void {
			m_iDepth = __val;
			
			/* @:set_return 0; */	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set iRelativeDepth Bool */
		
		public function get iRelativeDepth ():Boolean {
			return m_iRelativeDepth;
		}

		public function set iRelativeDepth (__val:Boolean): /* @:set_type */ void {
			m_iRelativeDepth = __val;
			
			/* @:set_return true; */	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set iClassName String */
		
		public function get iClassName ():String {
			return m_iClassName;
		}
				
		public function set iClassName (__val:String): /* @:set_type */ void {
			m_iClassName = __val;
			
			/* @:set_return ""; */	
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
