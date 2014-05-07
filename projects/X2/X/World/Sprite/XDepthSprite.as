//------------------------------------------------------------------------------------------
// Copyright (C) 2014 Jimmy Huey
//
// Some Rights Reserved.
//
// The "X-Engine" is licensed under a Creative Commons
// Attribution-Share Alike 3.0 United States License.
// (CC BY-SA 3.0)
//
// You are free to:
//
//      SHARE - to copy, distribute, display and perform the work.
//      ADAPT - remix, transform build upon this material, even for commercial works.
//
//      The licensor cannot revoke these freedoms as long as you follow the license terms.
//
// Under the following terms:
//
//      ATTRIBUTION — 
//      You must give appropriate credit, provide a link to the license, and
//      indicate if changes were made.  You may do so in any reasonable manner,
//      but not in any way that suggests the licensor endorses you or your use.
//
//      SHARE-ALIKE -
//      If you remix, transform, or build upon the material, you must
//      distribute your contributions under the same license as the original.
//
// No additional restrictions — You may not apply legal terms or technological measures
// that legally restrict others from doing anything the license permits. 
//
// The full summary can be located at:
// http://creativecommons.org/licenses/by-sa/3.0/us/ 
//
// The human-readable summary of the Legal Code can be located at:
// http://creativecommons.org/licenses/by-sa/3.0/us/legalcode
//------------------------------------------------------------------------------------------
package X.World.Sprite {

	import X.World.*;

	include "..\\..\\flash.h";
	import flash.geom.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------	
	public class XDepthSprite extends XSprite {
		public var m_depth:Number;
		public var m_depth2:int;
		public var m_relativeDepthFlag:Boolean;
		public var m_sprite:DisplayObject;
		public var x_layer:XSpriteLayer;
		
//------------------------------------------------------------------------------------------
		public function XDepthSprite () {
			super ();
			
			clear ();
		}

//------------------------------------------------------------------------------------------
		public function clear ():void {
			while (numChildren) {
				if (CONFIG::starling) {
					removeChildAt (0, true);
				}
				else
				{
					removeChildAt (0);
				}
			}
		}
			
//------------------------------------------------------------------------------------------
		public function addSprite (
			__sprite:DisplayObject,
			__depth:Number,
			__layer:XSpriteLayer,
			__relative:Boolean = false
			):void {
				
			m_sprite = __sprite;
			x_layer = __layer;
			setDepth (__depth);
// !!!
			childList.addChild (__sprite);
			visible = false;
			relativeDepthFlag = __relative;
		}

//------------------------------------------------------------------------------------------
		public function replaceSprite (__sprite:DisplayObject):void {
			clear ();
			
			m_sprite = __sprite;
			
			childList.addChild (__sprite);
			
			visible = true;
		}
		
//------------------------------------------------------------------------------------------
		public override function set visible (__visible:Boolean):void {
			super.visible = __visible;
			
			m_sprite.visible = __visible;
		}
		
//------------------------------------------------------------------------------------------	
		public function setDepth (__depth:Number):void {
			m_depth = __depth;
			depth2 = __depth;
		}		
		
//------------------------------------------------------------------------------------------	
		public function getDepth ():Number {
			return m_depth;
		}
		
//------------------------------------------------------------------------------------------
		public function get depth ():Number {
			return m_depth;
		}

//------------------------------------------------------------------------------------------		
		public function set depth (__depth:Number): void {
			m_depth = __depth;
			depth2 = __depth;
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
		public function set relativeDepthFlag (__relative:Boolean):void {
			m_relativeDepthFlag = __relative;
		}
		
//------------------------------------------------------------------------------------------
		public function get relativeDepthFlag ():Boolean {
			return m_relativeDepthFlag;
		}
		
//------------------------------------------------------------------------------------------
		public function get depth2 ():int {
			return m_depth2;
		}
		
		public function set depth2 (__depth:int): void {
			if (__depth != m_depth2) {
				m_depth2 = __depth;
				x_layer.forceSort = true;
			}
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
