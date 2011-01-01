//------------------------------------------------------------------------------------------
package X.World.Logic {

// Box2D classes
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import X.Collections.*;
	import X.Geom.*;
	import X.MVC.*;
	import X.Signals.XSignal;
	import X.Task.*;
	import X.World.*;
	import X.World.Sprite.*;
	import X.XMap.*;
	
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------
// XLogicObject: Game object's that live in a "World".  These are essentially containers
// that wrap up neat-and-tidy, game logic, sprites, etc.
//
// XLogicObjects can either be instantiated dynamically from code or from an externally
// created level via a Level Manager.
//
// XLogicObjects that are craated from a Level Manager are responsible for handling their
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
		public var m_parent:XLogicObject;
		public var m_item:XMapItemModel;
		public var m_layer:Number;
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
		public var m_delayed:Number;
		public var m_XLogicObjects:XDict;
		public var m_worldSprites:XDict;
		public var m_hudSprites:XDict;
		public var m_childSprites:XDict;
		public var m_detachedSprites:XDict;
		public var m_GUID:Number;
		public var m_alpha:Number;
		public var m_masterAlpha:Number;
		public var m_XSignals:XDict;
		public var self:XLogicObject;
		public var m_killSignal:XSignal;
		public var m_XTaskSubManager:XTaskSubManager;
		
		public var m_iX:Number;
		public var m_iY:Number;
		public var m_iScale:Number;
		public var m_iRotation:Number;
		public var m_iItem:XMapItemModel;
		public var m_iLayer:Number;
		public var m_iDepth:Number;
		public var m_iRelativeDepth:Boolean;
		public var m_iClassName:String;
		
		private static var g_GUID:Number = 0;
		
//------------------------------------------------------------------------------------------
		include "..\\Sprite\\XRegistration_impl.as";
						
//------------------------------------------------------------------------------------------
		public function XLogicObject () {
			super ();
			
			self = this;
			m_item = null;
			m_parent = null;
			m_boundingRect = null;
			m_delayed = 1;
			
			m_GUID = g_GUID++;
			
			setRegistration ();
			
			iX = 0;
			iY = 0;
			iScale = 1.0;
			iRotation = 0.0;
			iItem = null;
			iDepth = 0;
			iRelativeDepth = false;
			iLayer = 0;
			iClassName = "";
		}
		
//------------------------------------------------------------------------------------------
		public function setup (__xxx:XWorld, args:Array):void {
			xxx = __xxx;
						
			m_masterScaleX = m_masterScaleY = 1.0;
			m_masterRotation = 0;
			m_masterVisible = true;
			m_masterDepth = 0;
			m_masterAlpha = 1.0;
				
			m_XLogicObjects = new XDict ();
			m_worldSprites = new XDict ();
			m_hudSprites = new XDict ();
			m_childSprites = new XDict ();
			m_detachedSprites = new XDict ();
			m_XSignals = new XDict ();
			m_XTaskSubManager = new XTaskSubManager (getXTaskManager ());

			m_killSignal = createXSignal ();
			
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
		public function cleanup ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function quit ():void {		
			m_worldSprites.forEach (
				function (x:*):void {
					removeSprite (x);
				}
			);

			m_hudSprites.forEach (
				function (x:*):void {
					removeSpriteFromHud (x);
				}
			);
			
			m_XLogicObjects.forEach (
				function (x:*):void {
					XLogicObject (x).kill ();
				}
			);
			
			removeAllXSignals ();
			removeAllTasks ();
		}

//------------------------------------------------------------------------------------------
// kill this object and remove it from the World
//------------------------------------------------------------------------------------------
		public function kill ():void {
			
// let the Object Manager handle the kill
			xxx.getXLogicManager ().kill (this);
			
// if this item was spawned from a Level, decrement the item count and
// broadcast a "kill" signal.  it's possible for outsiders to subscribe
// to a the "kill" event.
			if (m_item != null) {
				fireKillSignal (m_item);
							
				m_item.inuse--;
				
				m_item = null;
			}
		}
				
//------------------------------------------------------------------------------------------
// cull this object if it strays outside the current viewPort
//------------------------------------------------------------------------------------------	
		public function cullObject ():void {
// if this object wasn't ever spawned from a level, don't perform any culling
			if (m_item == null) {
				return;
			}
			
// determine whether this object is outside the current viewPort
			var v:XRect = xxx.getXMapModel ().getViewRect ();
				
			var r:XRect = xxx.getXWorldLayer (m_layer).viewPort (v.width, v.height);
			r.inflate (256, 256);

			var i:XRect;
						
			i = m_item.boundingRect.cloneX ();
			i.offsetPoint (getPos ());
			
			if (r.intersects (i)) {
				return;
			}
			
			i = m_boundingRect.cloneX ();
			i.offsetPoint (getPos ());
			
			if (r.intersects (i)) {
				return;
			}
			
// yep, kill it
			trace (": ---------------------------------------: ");
			trace (": cull: ", this);
			
			kill ();
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
		public function findMovieClipByName (
			__movieClip:MovieClip,
			__className:String
			):MovieClip {
				
			for (var i:uint = 0; i < __movieClip.numChildren; i++) {
				var m$:MovieClip = __movieClip.getChildAt (i) as MovieClip;
				
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
			__movieClip:MovieClip,
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
						var m:MovieClip = m$ as MovieClip;
						
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
			__movieClip:MovieClip,
			__className:String
			):TextField {
				
			for (var i:uint = 0; i < __movieClip.numChildren; i++) {
				var m$:MovieClip = __movieClip.getChildAt (i) as MovieClip;
				var t$:TextField = __movieClip.getChildAt (i) as TextField;
				
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
		
//------------------------------------------------------------------------------------------
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
				
//------------------------------------------------------------------------------------------
// get a map of all our child sprites that live in the World
//------------------------------------------------------------------------------------------	
		public function getSprites ():XDict {
			return m_worldSprites;
		}
		
//------------------------------------------------------------------------------------------	
		public function sprites ():XDict {
			return m_worldSprites;
		}
		
//------------------------------------------------------------------------------------------
// get a map of all our child sprites that live in the HUD
//------------------------------------------------------------------------------------------	
		public function getHudSprites ():XDict {
			return m_hudSprites;
		}
		
//------------------------------------------------------------------------------------------
// get a map of all the our child XLogicObjects
//------------------------------------------------------------------------------------------	
		public function getXLogicObjects ():XDict {
			return m_XLogicObjects;
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
			
			m_detachedSprites.put (__sprite, __sprite2);
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
			
			m_childSprites.put (__sprite, __sprite2);
		}
		
//------------------------------------------------------------------------------------------
// add a sprite the World
//------------------------------------------------------------------------------------------	
		public function addSprite (__sprite:Sprite):XDepthSprite {
			return addSpriteAt (__sprite, 0, 0);
		}

//------------------------------------------------------------------------------------------
		public function addSpriteAt (__sprite:DisplayObject, __dx:Number, __dy:Number, __relative:Boolean = false):XDepthSprite {
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
			
			m_worldSprites.put (__depthSprite, 0);
			
			return __depthSprite;
		}
				
//------------------------------------------------------------------------------------------
// remove a sprite from the World
//------------------------------------------------------------------------------------------	
		public function removeSprite (__sprite:Sprite):void {
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
		public function addSpriteToHudAt (__sprite:Sprite, __dx:Number, __dy:Number, __relative:Boolean = false):XDepthSprite {
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
			
			m_hudSprites.put (__depthSprite, 0);
			
			return __depthSprite;
		}
		
//------------------------------------------------------------------------------------------
// remove a sprite from the HUD
//------------------------------------------------------------------------------------------	
		public function removeSpriteFromHud (__sprite:Sprite):void {
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
			m_XLogicObjects.put (__XLogicObject, 0);
			
			return __XLogicObject;
		}
		
//------------------------------------------------------------------------------------------
// remove an XLogicObject from the World
//------------------------------------------------------------------------------------------	
		public function removeXLogicObject (__XLogicObject:XLogicObject):void {
			if (m_XLogicObjects.exists (__XLogicObject)) {
				m_XLogicObjects.remove (__XLogicObject);
				
				__XLogicObject.kill ();
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
					XLogicObject (x).kill ();
				}
			);
		}
		
//------------------------------------------------------------------------------------------
// not implemented: XLogicObjects that are spawned from a level can contain intialization
// parameters
//------------------------------------------------------------------------------------------	
		public function getDefaultParams ():XML {
			return null;
		}

//------------------------------------------------------------------------------------------
		public function setItem (__item:XMapItemModel):void {
			m_item = __item;
			
			if (m_item != null) {
				m_boundingRect = __item.boundingRect.cloneX ();
			}
		}

//------------------------------------------------------------------------------------------
		public function setLayer (__layer:Number):void {
			m_layer = __layer;
		}

//------------------------------------------------------------------------------------------
		public function setValues ():void {		
			setRegistration (-getPos ().x, -getPos ().y);
		}

//------------------------------------------------------------------------------------------
		public function getArg(__args:Array, i:Number):* {
			return __args[i];
		}
		
//------------------------------------------------------------------------------------------
		public function get o ():Object {
			return this as Object;
		}	
	
//------------------------------------------------------------------------------------------
		public function setPos (__pos:XPoint):void {
			m_pos = __pos;
		}
		
		public function set oX (__value:Number):void {
			var __pos:XPoint = getPos ();
			__pos.x = __value;
			setPos (__pos);
		}

		public function set oY (__value:Number):void {
			var __pos:XPoint = getPos ();
			__pos.y = __value;
			setPos (__pos);
		}
				
//------------------------------------------------------------------------------------------
		public function getPos ():XPoint {
			return m_pos;
		}
		
		public function get oX ():Number {
			return getPos ().x
		}

		public function get oY ():Number {
			return getPos ().y
		}
		
//------------------------------------------------------------------------------------------
		public function setAlpha (__alpha:Number):void {
			m_alpha = __alpha;
		}
		
		public function set oAlpha (__alpha:Number):void {
			setAlpha (__alpha);
		}
		
//------------------------------------------------------------------------------------------
		public function getAlpha ():Number {
			return m_alpha;
		}
		
		public function get oAlpha ():Number {
			return getAlpha ();
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
		public function setVisible (__value:Boolean):void {
			m_visible = __value;
		}
		
		public function set oVisible (__value:Boolean):void {
			setVisible (__value);
		}
		
//------------------------------------------------------------------------------------------
		public function getVisible ():Boolean {
			return m_visible;
		}
		
		public function get oVisible ():Boolean {
			return getVisible ();
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
		public function setRotation (__rotation:Number):void {
			m_rotation = __rotation % 360;
		}
		
		public function set oRotation (__value:Number):void {
			setRotation (__value);
		}

//------------------------------------------------------------------------------------------		
		public function getRotation ():Number {
			return m_rotation;
		}
		
		public function get oRotation ():Number {
			return getRotation ();
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
		public function setScale (__scale:Number):void {
			m_scaleX  = m_scaleY = __scale;
		}
		
		public function set oScale (__value:Number):void {
			setScale (__value);
		}
		
//------------------------------------------------------------------------------------------
		public function getScale ():Number {
			return m_scaleX;
		}
		
		public function get oScale ():Number {
			return getScale ();
		}

//------------------------------------------------------------------------------------------
		public function setScaleX (__scale:Number):void {
			m_scaleX = __scale;
		}
		
		public function set oScaleX (__value:Number):void {
			setScaleX (__value);
		}

//------------------------------------------------------------------------------------------
		public function getScaleX ():Number {
			return m_scaleX;
		}
		
		public function get oScaleX ():Number {
			return getScaleX ();
		}

//------------------------------------------------------------------------------------------
		public function setScaleY (__scale:Number):void {
			m_scaleY = __scale;
		}
		
		public function set oScaleY (__value:Number):void {
			setScaleY (__value);
		}

//------------------------------------------------------------------------------------------
		public function getScaleY ():Number {
			return m_scaleY;
		}
		
		public function get oScaleY ():Number {
			return getScaleY ();
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
		public function setDepth (__depth:Number):void {
			m_depth = __depth;
		}		
		
//------------------------------------------------------------------------------------------	
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
			if (m_delayed) {
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
						logicObject.x2 = __x
						logicObject.y2 = __y
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
							logicObject.setMasterDepth (logicObject.getDepth ())
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
		public function createXSignal ():XSignal {
			var __signal:XSignal = xxx.getXSignalManager ().createXSignal ();
		
			if (!(m_XSignals.exists (__signal))) {
				m_XSignals.put (__signal, 0);
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
					removeXSignal (x as XSignal);
				}
			);
		}
				
//------------------------------------------------------------------------------------------
		public function getXTaskManager ():XTaskManager {
			return xxx.getXTaskManager ();
		}
		
//------------------------------------------------------------------------------------------
		public function addTask (
			__taskList:Array,
			__findLabelsFlag:Boolean = true
			):XTask {

			var __task:XTask = m_XTaskSubManager.addTask (__taskList, __findLabelsFlag);
			
			__task.setParent (this);
			
			return __task;
		}

//------------------------------------------------------------------------------------------
		public function changeTask (
			__task:XTask,
			__taskList:Array,
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
		public function getEmptyTask$ ():Array {
			return m_XTaskSubManager.getEmptyTask$ ();
		}	
			
//------------------------------------------------------------------------------------------
		public function gotoLogic (__logic:Function):void {
			m_XTaskSubManager.gotoLogic (__logic);
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
		public function set iX (__value:Number):void {
			m_iX = __value;
		}
		
		public function get iX ():Number {
			return m_iX;
		}
		
//------------------------------------------------------------------------------------------
		public function set iY (__value:Number):void {
			m_iY = __value;
		}	
		
		public function get iY ():Number {
			return m_iY;
		}
		
//------------------------------------------------------------------------------------------
		public function set iScale (__value:Number):void {
			m_iScale = __value;
		}

		public function get iScale ():Number {
			return m_iScale;
		}
		
//------------------------------------------------------------------------------------------
		public function set iRotation (__value:Number):void {
			m_iRotation = __value;
		}

		public function get iRotation ():Number {
			return m_iRotation;
		}
		
//------------------------------------------------------------------------------------------
		public function set iItem (__value:XMapItemModel):void {
			m_iItem = __value;
		}
		
		public function get iItem ():XMapItemModel {
			return m_iItem;
		}
		
//------------------------------------------------------------------------------------------
		public function set iLayer (__value:Number):void {
			m_iLayer = __value;
		}

		public function get iLayer ():Number {
			return m_iLayer;
		}
		
//------------------------------------------------------------------------------------------
		public function set iDepth (__value:Number):void {
			m_iDepth = __value;
		}
		
		public function get iDepth ():Number {
			return m_iDepth;
		}

//------------------------------------------------------------------------------------------
		public function set iRelativeDepth (__value:Boolean):void {
			m_iRelativeDepth = __value;
		}
		
		public function get iRelativeDepth ():Boolean {
			return m_iRelativeDepth;
		}

//------------------------------------------------------------------------------------------
		public function set iClassName (__value:String):void {
			m_iClassName = __value;
		}
		
		public function get iClassName ():String {
			return m_iClassName;
		}
				
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
