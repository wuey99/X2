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
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.sprite.*;
	import kx.xmap.*;
	import kx.type.*;
	
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------
	public class XLogicObjectCX extends XLogicObject {
		protected var m_vel:XPoint;
		protected var m_oldPos:XPoint;
		
		protected var m_cx:XRect;
		protected var m_namedCX:XDict; // <String, XRect>
	
		public var m_XMapModel:XMapModel;
		public var m_XMapView:XMapView;
		public var m_XMapLayerModel:XMapLayerModel;
		public var m_XSubmaps:Vector.<Vector.<XSubmapModel>>;
		public var m_submapWidth:int;
		public var m_submapHeight:int;
		public var m_submapWidthMask:int;
		public var m_submapHeightMask:int;
		public var m_cols:int;
		public var m_rows:int;

		protected var m_CX_Collide_Flag:int;
		
		protected var m_objectCollisionList:XDict; // <XLogicObject, XRect>
	
		public var CX_COLLIDE_LF:int = 0x0001;
		public var CX_COLLIDE_RT:int = 0x0002;
		public var CX_COLLIDE_HORZ:int = 0x0001 | 0x0002; 
		public var CX_COLLIDE_UP:int = 0x0004;
		public var CX_COLLIDE_DN:int = 0x0008;
		public var CX_COLLIDE_VERT:int = 0x0004 | 0x0008;
		
//------------------------------------------------------------------------------------------
		public function XLogicObjectCX () {
			super ();
		}
		
//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array /* <Dynamic> */):void {
			super.setup (__xxx, args);
			
			m_XMapModel = null;
			m_XMapView = null;
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
			
			xxx.getXPointPoolManager ().returnObject (m_vel);
			xxx.getXPointPoolManager ().returnObject (m_oldPos);
			xxx.getXRectPoolManager ().returnObject (m_cx);
			
			m_vel = null;
			m_oldPos = null;
			m_cx = null;
		}
		
//------------------------------------------------------------------------------------------
		public override function setupX ():void {
			var __vel:XPoint = xxx.getXPointPoolManager ().borrowObject () as XPoint;
			var __old:XPoint = xxx.getXPointPoolManager ().borrowObject () as XPoint;
//			var __vel:XPoint = new XPoint ();
//			var __old:XPoint = new XPoint ();
					
			__vel.x = __vel.y = 0;
			__old.x = __old.y = 0;
			
			setVel (__vel);
			setOld (__old);

			m_cx = xxx.getXRectPoolManager ().borrowObject () as XRect;
//			m_cx = new XRect (0, 0, 0, 0);
					
			m_cx.x = 0;
			m_cx.y = 0;
			m_cx.width = 0;
			m_cx.height = 0;
			
			m_objectCollisionList = null;
					
			m_namedCX = new XDict (); // <String, XRect>
		}

//------------------------------------------------------------------------------------------
		public function setXMapModel (__layer:int, __XMapModel:XMapModel, __XMapView:XMapView=null):void {
			m_XMapModel = __XMapModel;
			m_XMapView = __XMapView;
			
			m_XMapLayerModel = m_XMapModel.getLayer (__layer);
			
			m_XSubmaps = m_XMapLayerModel.submaps ();
			
			m_submapWidth = m_XMapLayerModel.getSubmapWidth ();
			m_submapHeight = m_XMapLayerModel.getSubmapHeight ();
			
			m_submapWidthMask = m_submapWidth - 1;
			m_submapHeightMask = m_submapHeight - 1;
			
			m_cols = int (m_submapWidth/XSubmapModel.CX_TILE_WIDTH);
			m_rows = int (m_submapHeight/XSubmapModel.CX_TILE_HEIGHT);

			/*			
			trace (": --------------------------------:");
			trace (": submapWidth: ", m_submapWidth);
			trace (": submapHeight: ", m_submapHeight);
			trace (": submapWidthMask: ", m_submapWidthMask);
			trace (": submapHeightMask: ", m_submapHeightMask);
			trace (": m_cols: ", m_cols);
			trace (": m_rows: ", m_rows);
			trace (": tileWidth: ", XSubmapModel.CX_TILE_WIDTH);
			trace (": tileWidthMask: ", XSubmapModel.CX_TILE_WIDTH_MASK);
			trace (": tileWidthUnmask: ", XSubmapModel.CX_TILE_WIDTH_UNMASK);
			trace (": tileHeight: ", XSubmapModel.CX_TILE_HEIGHT);
			trace (": tileHeightMask: ", XSubmapModel.CX_TILE_HEIGHT_MASK);
			trace (": tileHeightUnMask: ", XSubmapModel.CX_TILE_HEIGHT_UNMASK);
			*/
		}

//------------------------------------------------------------------------------------------
		public function getXMapModel ():XMapModel {
			return m_XMapModel;
		}
		
//------------------------------------------------------------------------------------------
		public function getXMapLayerModel ():XMapLayerModel {
			return m_XMapLayerModel;
		}
		
//------------------------------------------------------------------------------------------
		public function getXMapView ():XMapView {
			return m_XMapView;
		}

//------------------------------------------------------------------------------------------
		public function hasItemStorage ():Boolean {
			if (item == null) {
				return false;
			}
			
			return m_XMapLayerModel.getPersistentStorage ().exists (item.id);
		}
		
//------------------------------------------------------------------------------------------
		public function initItemStorage (__val:*):void {
			if (!hasItemStorage ()) {
				m_XMapLayerModel.getPersistentStorage ().set (item.id, __val);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function getItemStorage ():* {
			if (hasItemStorage ()) {		
				return m_XMapLayerModel.getPersistentStorage ().get (item.id);
			}
			else
			{
				return null;
			}
		}

//------------------------------------------------------------------------------------------
		public function setCX (
			__x1:Number,
			__x2:Number,
			__y1:Number,
			__y2:Number
			):void {
				
//			m_cx = new XRect (__x1, __y1, __x2-__x1+1, __y2-__y1+1);
	
			m_cx.x = __x1;
			m_cx.y = __y1;
			m_cx.width = __x2-__x1+1;
			m_cx.height = __y2-__y1+1;
				
//			trace (": left, right, top, bottom ", m_cx.left, m_cx.right, m_cx.top, m_cx.bottom);
//			trace (": width, height: ", m_cx.width, m_cx.height);
		}

//------------------------------------------------------------------------------------------
		public function getCX ():XRect {
			return m_cx;
		}
		
//------------------------------------------------------------------------------------------
		public function setNamedCX (
			__name:String,
			__x1:Number,
			__x2:Number,
			__y1:Number,
			__y2:Number
			):void {
				
			m_namedCX.set (__name, new XRect (__x1, __y1, __x2-__x1+1, __y2-__y1+1));
		}

//------------------------------------------------------------------------------------------
		public function getNamedCX (__name:String):XRect {
			return m_namedCX.get (__name).cloneX ();
		}
		
//------------------------------------------------------------------------------------------
		public function getAdjustedNamedCX (__name:String):XRect {
			var __rect:XRect = m_namedCX.get (__name).cloneX ();	
			__rect.offset (oX, oY);
			return __rect;
		}
		
//------------------------------------------------------------------------------------------
		public function getVel ():XPoint {
			return m_vel;
		}
		 
		public function setVel (__vel:XPoint):void {
			m_vel = __vel;
		}
		
//------------------------------------------------------------------------------------------
		/* @:get, set oDX Float */
		
		[Inline]
		public function get oDX ():Number {
			return m_vel.x;
		}

		[Inline]
		public function set oDX (__val:Number): /* @:set_type */ void {
			m_vel.x = __val;
			
			/* @:set_return __val; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set oDY Float */
		
		[Inline]
		public function get oDY ():Number {
			return m_vel.y;
		}
		
		[Inline]
		public function set oDY (__val:Number): /* @:set_type */ void {
			m_vel.y = __val;
			
			/* @:set_return __val; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function getOld ():XPoint {
			return m_oldPos;
		}
		
		public function setOld (__pos:XPoint):void {
			m_oldPos = __pos;
		}
		
//------------------------------------------------------------------------------------------
		/* @:get, set oldX Float */
		
		public function get oldX ():Number {
			return m_oldPos.x;
		}

		public function set oldX (__val:Number): /* @:set_type */ void {
			m_oldPos.x = __val;
			
			/* @:set_return __val; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set oldY Float */
		
		public function get oldY ():Number {
			return m_oldPos.y;
		}

		public function set oldY (__val:Number): /* @:set_type */ void {
			m_oldPos.y = __val;
			
			/* @:set_return __val; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function collidesWithNamedCX (__name:String, __rectDst:XRect):Boolean {
			var __rectSrc:XRect = getAdjustedNamedCX (__name);
			
			return __rectSrc.intersects (__rectDst);
		}
		
//------------------------------------------------------------------------------------------
		/* @:get, set CX_Collide_Flag Int */
		
		public function get CX_Collide_Flag ():int {
			return m_CX_Collide_Flag;
		}

		public function set CX_Collide_Flag (__val:int): /* @:set_type */ void {
			m_CX_Collide_Flag = __val;
			
			/* @:set_return __val; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function handleCollision (__collider:XLogicObject):void {
		}

//------------------------------------------------------------------------------------------
		public function objectCollisionCallback (__logicObject:XLogicObject):void {	
		}
		
//------------------------------------------------------------------------------------------
		/* @:get, set allowLFCollisions Bool */
		
		public function get allowLFCollisions ():Boolean {
			return true;
		}

		public function set allowLFCollisions (__val:Boolean): /* @:set_type */ void {
			
			/* @:set_return true; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set allowRTCollisions Bool */
		
		public function get allowRTCollisions ():Boolean {
			return true;
		}
		
		public function set allowRTCollisions (__val:Boolean): /* @:set_type */ void {
			
			/* @:set_return true; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set allowUPCollisions Bool */
		
		public function get allowUPCollisions ():Boolean {
			return true;
		}
	
		public function set allowUPCollisions (__val:Boolean): /* @:set_type */ void {
			
			/* @:set_return true; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set allowDNCollisions Bool */
		
		public function get allowDNCollisions ():Boolean {
			return true;
		}
		
		public function set allowDNCollisions (__val:Boolean): /* @:set_type */ void {
			
			/* @:set_return true; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public override function updatePhysics ():void {
			handleCX ();	
		}
		
//------------------------------------------------------------------------------------------
		public function handleCX ():void {
			m_CX_Collide_Flag = 0;

//------------------------------------------------------------------------------------------			
			oX += oDX;
			
//			if (int (oX) != int (oldX)) {
			{
				if (oDX == 0) {
					
				}
				else if (oDX < 0) {
					Ck_Collide_LF ();
					Ck_Slope_LF ();
				}
				else
				{
					Ck_Collide_RT ();
					Ck_Slope_RT (); 
				}
			}
			
//------------------------------------------------------------------------------------------
			oY += oDY;
			
//			if (int (oY) != int (oldY)) {
			{
				if (oDY == 0) {
					
				}
				else if (oDY < 0) {
					Ck_Collide_UP ();
					Ck_Slope_UP ();
				}
				else
				{
					Ck_Collide_DN ();
					Ck_Slope_DN ();
				}
			}
		}

//------------------------------------------------------------------------------------------
		public function Ck_Collide_UP ():Boolean {
			var x1:int, y1:int, x2:int, y2:int;
			var i:int, __x:int, __y:int;
			var collided:Boolean;
			var r:int, c:int;
			var submapRow:int, submapCol:int;
			
			x1 = int (oX + m_cx.left);
			x2 = int (oX + m_cx.right);
			y1 = int (oY + m_cx.top);
			y2 = int (oY + m_cx.bottom);
						
			y1 &= XSubmapModel.CX_TILE_HEIGHT_UNMASK;
			r = y1 >> 9;
			submapRow = ((y1 & 496) << 1);
			
			collided = false;
			
			__x = (x1 & XSubmapModel.CX_TILE_WIDTH_UNMASK);
//			for (__x = (x1 & XSubmapModel.CX_TILE_WIDTH_UNMASK); __x <= (x2 & XSubmapModel.CX_TILE_WIDTH_UNMASK); __x += XSubmapModel.CX_TILE_WIDTH) {
			while (__x <= (x2 & XSubmapModel.CX_TILE_WIDTH_UNMASK)) {
//				c = __x/m_submapWidth;
//				r = y1/m_submapHeight;
//				i = (int ((y1 & m_submapHeightMask)/XSubmapModel.CX_TILE_HEIGHT) * m_cols) + int ((__x & m_submapWidthMask)/XSubmapModel.CX_TILE_WIDTH);
//				switch (m_XSubmaps[r][c].cmap[i]) {
					
				switch (m_XSubmaps[r][__x >> 9].cmap[submapRow + ((__x & 511) >> 4)]) {
				// ([
					case XSubmapModel.CX_EMPTY:
						break;
					case XSubmapModel.CX_SOLID:
						// function ():void {
						m_CX_Collide_Flag |= CX_COLLIDE_UP;
						
						oY = (y1 + XSubmapModel.CX_TILE_HEIGHT - m_cx.top);
						
						collided = true;
						break; // },
					case XSubmapModel.CX_SOLIDX001:
						// function ():void {
							m_CX_Collide_Flag |= CX_COLLIDE_UP;
				
							oY = (y1 + XSubmapModel.CX_TILE_HEIGHT - m_cx.top);
			
							collided = true;
						break; // },
					case XSubmapModel.CX_SOFT:
						break;
					case XSubmapModel.CX_JUMP_THRU:
						break;
						
					case XSubmapModel.CX_UL45:
						break;
					case XSubmapModel.CX_UR45:
						break;
					case XSubmapModel.CX_LL45:
						break;
					case XSubmapModel.CX_LR45:
						break;
					
					case XSubmapModel.CX_UL225A:
						break;
					case XSubmapModel.CX_UL225B:
						break;
					case XSubmapModel.CX_UR225A:
						break;
					case XSubmapModel.CX_UR225B:
						break;
					case XSubmapModel.CX_LL225A:
						break;
					case XSubmapModel.CX_LL225B:
						break;
					case XSubmapModel.CX_LR225A:
						break;
					case XSubmapModel.CX_LR225B:
						break;
					
					case XSubmapModel.CX_UL675A:
						break;
					case XSubmapModel.CX_UL675B:
						break;
					case XSubmapModel.CX_UR675A:
						break;
					case XSubmapModel.CX_UR675B:
						break;
					case XSubmapModel.CX_LL675A:
						break;
					case XSubmapModel.CX_LL675B:
						break;
					case XSubmapModel.CX_LR675A:
						break;
					case XSubmapModel.CX_LR675B:
						break;
						
					case XSubmapModel.CX_SOFTLF:
						break;
					case XSubmapModel.CX_SOFTRT:
						break;
					case XSubmapModel.CX_SOFTUP:
						break;
					case XSubmapModel.CX_SOFTDN:
						// function ():void {
							m_CX_Collide_Flag |= CX_COLLIDE_UP;
				
							oY = (y1 + XSubmapModel.CX_TILE_HEIGHT - m_cx.top);
			
							collided = true;
						break;
					case XSubmapModel.CX_DEATH:
						break;
					default:
						break;
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
				
				__x += XSubmapModel.CX_TILE_WIDTH;
			}
			
			return false;
		}
		
//------------------------------------------------------------------------------------------
		public function Ck_Collide_DN ():Boolean {
			var x1:int, y1:int, x2:int, y2:int;
			var i:int, __x:int, __y:int;
			var collided:Boolean;
			var r:int, c:int;
			var submapRow:int, submapCol:int;
			
			x1 = int (oX + m_cx.left);
			x2 = int (oX + m_cx.right);
			y1 = int (oY + m_cx.top);
			y2 = int (oY + m_cx.bottom);
							
			y2 &= XSubmapModel.CX_TILE_HEIGHT_UNMASK;
			r = y2 >> 9;
			submapRow = ((y2 & 496) << 1);
			
			collided = false;
			
			__x = (x1 & XSubmapModel.CX_TILE_WIDTH_UNMASK);
//			for (__x = (x1 & XSubmapModel.CX_TILE_WIDTH_UNMASK); __x <= (x2 & XSubmapModel.CX_TILE_WIDTH_UNMASK); __x += XSubmapModel.CX_TILE_WIDTH) {
			while (__x <= (x2 & XSubmapModel.CX_TILE_WIDTH_UNMASK)) {
//				c = __x/m_submapWidth;
//				r = y2/m_submapHeight;
//				i = (int ((y2 & m_submapHeightMask)/XSubmapModel.CX_TILE_HEIGHT) * m_cols) + int ((__x & m_submapWidthMask)/XSubmapModel.CX_TILE_WIDTH);
//				switch (m_XSubmaps[r][c].cmap[i]) {
					
				switch (m_XSubmaps[r][__x >> 9].cmap[submapRow + ((__x & 511) >> 4)]) {
				// ([
					case XSubmapModel.CX_EMPTY:
						break;
					case XSubmapModel.CX_SOLID:
						// function ():void {
						m_CX_Collide_Flag |= CX_COLLIDE_DN;
						
						oY = (y2 - (m_cx.bottom) - 1);
						
						collided = true;
						break; // },
					case XSubmapModel.CX_SOLIDX001:
						// function ():void {
						m_CX_Collide_Flag |= CX_COLLIDE_DN;
						
						oY = (y2 - (m_cx.bottom) - 1);
						
						collided = true;
						break; // },
					case XSubmapModel.CX_JUMP_THRU:
						// function ():void {
							m_CX_Collide_Flag |= CX_COLLIDE_DN;
				
							oY = (y2 - (m_cx.bottom) - 1);
										
							collided = true;
						break; // },
					case XSubmapModel.CX_SOFT:
						break;
//					case XSubmapModel.CX_JUMP_THRU:
//						break;
						
					case XSubmapModel.CX_UL45:
						break;
					case XSubmapModel.CX_UR45:
						break;
					case XSubmapModel.CX_LL45:
						break;
					case XSubmapModel.CX_LR45:
						break;
					
					case XSubmapModel.CX_UL225A:
						break;
					case XSubmapModel.CX_UL225B:
						break;
					case XSubmapModel.CX_UR225A:
						break;
					case XSubmapModel.CX_UR225B:
						break;
					case XSubmapModel.CX_LL225A:
						break;
					case XSubmapModel.CX_LL225B:
						break;
					case XSubmapModel.CX_LR225A:
						break;
					case XSubmapModel.CX_LR225B:
						break;
					
					case XSubmapModel.CX_UL675A:
						break;
					case XSubmapModel.CX_UL675B:
						break;
					case XSubmapModel.CX_UR675A:
						break;
					case XSubmapModel.CX_UR675B:
						break;
					case XSubmapModel.CX_LL675A:
						break;
					case XSubmapModel.CX_LL675B:
						break;
					case XSubmapModel.CX_LR675A:
						break;
					case XSubmapModel.CX_LR675B:
						break;
						
					case XSubmapModel.CX_SOFTLF:
						break;
					case XSubmapModel.CX_SOFTRT:
						break;
					case XSubmapModel.CX_SOFTUP:
						// function ():void {
							m_CX_Collide_Flag |= CX_COLLIDE_DN;
				
							oY = (y2 - (m_cx.bottom) - 1);
										
							collided = true;
						break;
					case XSubmapModel.CX_SOFTDN:
						break;
					case XSubmapModel.CX_DEATH:
						break;
					default:
						break;
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
				
				__x += XSubmapModel.CX_TILE_WIDTH;
			}
			
			return false;
		}
	
//------------------------------------------------------------------------------------------
		public function Ck_Collide_LF ():Boolean {
			var x1:int, y1:int, x2:int, y2:int;
			var i:int, __x:int, __y:int;
			var collided:Boolean;
			var r:int, c:int;
			var submapRow:int, submapCol:int;
			
			x1 = int (oX + m_cx.left);
			x2 = int (oX + m_cx.right);
			y1 = int (oY + m_cx.top);
			y2 = int (oY + m_cx.bottom);
	
			x1 &= XSubmapModel.CX_TILE_WIDTH_UNMASK;
			c = x1 >> 9;
			submapCol = (x1 & 511) >> 4;
			
			collided = false;
			
			__y = (y1 & XSubmapModel.CX_TILE_HEIGHT_UNMASK);
//			for (__y = (y1 & XSubmapModel.CX_TILE_HEIGHT_UNMASK); __y <= (y2 & XSubmapModel.CX_TILE_HEIGHT_UNMASK); __y += XSubmapModel.CX_TILE_HEIGHT) {
			while (__y <= (y2 & XSubmapModel.CX_TILE_HEIGHT_UNMASK)) {
//				c = x1/m_submapWidth;
//				r = __y/m_submapHeight;
//				i = (int ((__y & m_submapHeightMask)/XSubmapModel.CX_TILE_HEIGHT) * m_cols) + int ((x1 & m_submapWidthMask)/XSubmapModel.CX_TILE_WIDTH);
//				switch (m_XSubmaps[r][c].cmap[i]) {
					
				switch (m_XSubmaps[__y >> 9][c].cmap[((__y & 496) << 1) + submapCol]) {
				// ([
					case XSubmapModel.CX_EMPTY:
						break;
					case XSubmapModel.CX_SOLID:
						// function ():void {
						m_CX_Collide_Flag |= CX_COLLIDE_LF;
						
						oX = (x1 + XSubmapModel.CX_TILE_WIDTH - m_cx.left);
						
						collided = true;
						break; // },
					case XSubmapModel.CX_SOLIDX001:
							// function ():void {
								m_CX_Collide_Flag |= CX_COLLIDE_LF;
			
								oX = (x1 + XSubmapModel.CX_TILE_WIDTH - m_cx.left);
				
								collided = true;
							break; // },
					case XSubmapModel.CX_SOFT:
						break;
					case XSubmapModel.CX_JUMP_THRU:
						break;
						
					case XSubmapModel.CX_UL45:
						break;
					case XSubmapModel.CX_UR45:
						break;
					case XSubmapModel.CX_LL45:
						break;
					case XSubmapModel.CX_LR45:
						break;
					
					case XSubmapModel.CX_UL225A:
						break;
					case XSubmapModel.CX_UL225B:
						break;
					case XSubmapModel.CX_UR225A:
						break;
					case XSubmapModel.CX_UR225B:
						break;
					case XSubmapModel.CX_LL225A:
						break;
					case XSubmapModel.CX_LL225B:
						break;
					case XSubmapModel.CX_LR225A:
						break;
					case XSubmapModel.CX_LR225B:
						break;
					
					case XSubmapModel.CX_UL675A:
						break;
					case XSubmapModel.CX_UL675B:
						break;
					case XSubmapModel.CX_UR675A:
						break;
					case XSubmapModel.CX_UR675B:
						break;
					case XSubmapModel.CX_LL675A:
						break;
					case XSubmapModel.CX_LL675B:
						break;
					case XSubmapModel.CX_LR675A:
						break;
					case XSubmapModel.CX_LR675B:
						break;
						
					case XSubmapModel.CX_SOFTLF:
						break;
					case XSubmapModel.CX_SOFTRT:
							// function ():void {
								m_CX_Collide_Flag |= CX_COLLIDE_LF;
			
								oX = (x1 + XSubmapModel.CX_TILE_WIDTH - m_cx.left);
				
								collided = true;
							break; 
					case XSubmapModel.CX_SOFTUP:
						break;
					case XSubmapModel.CX_SOFTDN:
						break;
					case XSubmapModel.CX_DEATH:
						break;
					default:
						break;
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
				
				__y += XSubmapModel.CX_TILE_HEIGHT;
			}
			
			return false;
		}
		
//------------------------------------------------------------------------------------------
		public function Ck_Collide_RT ():Boolean {
			var x1:int, y1:int, x2:int, y2:int;
			var i:int, __x:int, __y:int;
			var collided:Boolean;
			var r:int, c:int;
			var submapRow:int, submapCol:int;
			
			x1 = int (oX + m_cx.left);
			x2 = int (oX + m_cx.right);
			y1 = int (oY + m_cx.top);
			y2 = int (oY + m_cx.bottom);
						
			x2 &= XSubmapModel.CX_TILE_WIDTH_UNMASK;
			c = x2 >> 9;
			submapCol = (x2 & 511) >> 4;
			
			collided = false;
			
			__y = (y1 & XSubmapModel.CX_TILE_HEIGHT_UNMASK);
//			for (__y = (y1 & XSubmapModel.CX_TILE_HEIGHT_UNMASK); __y <= (y2 & XSubmapModel.CX_TILE_HEIGHT_UNMASK); __y += XSubmapModel.CX_TILE_HEIGHT) {
			while (__y <= (y2 & XSubmapModel.CX_TILE_HEIGHT_UNMASK)) {
//				c = x2/m_submapWidth;
//				r = __y/m_submapHeight;
//				i = (int ((__y & m_submapHeightMask)/XSubmapModel.CX_TILE_HEIGHT) * m_cols) + int ((x2 & 511)/XSubmapModel.CX_TILE_WIDTH);
//				switch (m_XSubmaps[r][c].cmap[i]) {
					
				switch (m_XSubmaps[__y >> 9][c].cmap[((__y & 496) << 1) + submapCol]) {
				// ([
					case XSubmapModel.CX_EMPTY:
						break;
					case XSubmapModel.CX_SOLID:
						// function ():void {
						m_CX_Collide_Flag |= CX_COLLIDE_RT;
						
						oX = (x2 - (m_cx.right) - 1);
						
						collided = true;
						break; // },
					case XSubmapModel.CX_SOLIDX001:
						// function ():void {
							m_CX_Collide_Flag |= CX_COLLIDE_RT;
		
							oX = (x2 - (m_cx.right) - 1);
			
							collided = true;
						break; // },
					case XSubmapModel.CX_SOFT:
						break;
					case XSubmapModel.CX_JUMP_THRU:
						break;
						
					case XSubmapModel.CX_UL45:
						break;
					case XSubmapModel.CX_UR45:
						break;
					case XSubmapModel.CX_LL45:
						break;
					case XSubmapModel.CX_LR45:
						break;
					
					case XSubmapModel.CX_UL225A:
						break;
					case XSubmapModel.CX_UL225B:
						break;
					case XSubmapModel.CX_UR225A:
						break;
					case XSubmapModel.CX_UR225B:
						break;
					case XSubmapModel.CX_LL225A:
						break;
					case XSubmapModel.CX_LL225B:
						break;
					case XSubmapModel.CX_LR225A:
						break;
					case XSubmapModel.CX_LR225B:
						break;
					
					case XSubmapModel.CX_UL675A:
						break;
					case XSubmapModel.CX_UL675B:
						break;
					case XSubmapModel.CX_UR675A:
						break;
					case XSubmapModel.CX_UR675B:
						break;
					case XSubmapModel.CX_LL675A:
						break;
					case XSubmapModel.CX_LL675B:
						break;
					case XSubmapModel.CX_LR675A:
						break;
					case XSubmapModel.CX_LR675B:
						break;
						
					case XSubmapModel.CX_SOFTLF:
						// function ():void {
							m_CX_Collide_Flag |= CX_COLLIDE_RT;
		
							oX = (x2 - (m_cx.right) - 1);
			
							collided = true;
						break;
					case XSubmapModel.CX_SOFTRT:
						break;
					case XSubmapModel.CX_SOFTUP:
						break;
					case XSubmapModel.CX_SOFTDN:
						break;
					case XSubmapModel.CX_DEATH:
						break;
					default:
						break;
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
				
				__y += XSubmapModel.CX_TILE_HEIGHT;
			}
			
			return false;
		}
				
		//------------------------------------------------------------------------------------------
		public function Ck_Slope_RT ():Boolean {
			var x1:int, y1:int, x2:int, y2:int;
			var i:int, __x:int, __y:int;
			var collided:Boolean;
			var looking:Boolean = true;
			var r:int, c:int;
			var x15:int;
			var y15:int;
			
			collided = false;
			
			//------------------------------------------------------------------------------------------
			// top
			//------------------------------------------------------------------------------------------
			x1 = int (oX + m_cx.left);
			x2 = int (oX + m_cx.right);
			y1 = int (oY + m_cx.top);
			y2 = int (oY + m_cx.bottom);
			
			looking = true;
			
			while (looking) {
				//				c = x2/m_submapWidth;
				//				r = y1/m_submapHeight;
				//				i = (int ((y1 & m_submapHeightMask)/XSubmapModel.CX_TILE_HEIGHT) * m_cols) + int ((x2 & m_submapWidthMask)/XSubmapModel.CX_TILE_WIDTH);
				
				c = x2 >> 9;
				r = y1 >> 9;
				i = ( ((y1 & m_submapHeightMask) >> 4) * m_cols) + ((x2 & m_submapWidthMask) >> 4);
				
				switch (m_XSubmaps[r][c].cmap[i]) {
					// ([
					case XSubmapModel.CX_EMPTY:
						looking = false;
						break;
					case XSubmapModel.CX_SOLIDX001:
						looking = false;
						break;
					case XSubmapModel.CX_SOLID:
						looking = false;
						break;
					case XSubmapModel.CX_SOFT:
						// function ():void {
						y1 = (y1 & XSubmapModel.CX_TILE_HEIGHT_UNMASK) + XSubmapModel.CX_TILE_HEIGHT;
						break; // },
					case XSubmapModel.CX_JUMP_THRU:
						looking = false;
						break;
					
					case XSubmapModel.CX_UL45:
						looking = false;
						break;
					case XSubmapModel.CX_UR45:
						looking = false;
						break;
					case XSubmapModel.CX_LL45:
						// function ():void {	
						var __x_LL45:Array /* <Int> */ = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
						
						x15 = x2 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y1 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (y15 <= __x_LL45[x15]) {
							oY = ((y1 & XSubmapModel.CX_TILE_HEIGHT_UNMASK) + __x_LL45[x15] - m_cx.top);
						}
						
						looking = false;
						break; // },
					case XSubmapModel.CX_LR45:
						looking = false;
						break;
					
					case XSubmapModel.CX_UL225A:
						looking = false;
						break;
					case XSubmapModel.CX_UL225B:
						looking = false;
						break;
					case XSubmapModel.CX_UR225A:
						looking = false;
						break;
					case XSubmapModel.CX_UR225B:
						looking = false;
						break;
					case XSubmapModel.CX_LL225A:
						// function ():void {	
						var __x_LL225A:Array /* <Int> */ = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7];
						
						x15 = x2 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y1 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (y15 <= __x_LL225A[x15]) {
							oY = ((y1 & XSubmapModel.CX_TILE_HEIGHT_UNMASK) + __x_LL225A[x15] - m_cx.top);
						}
						
						looking = false;
						break; // },
					case XSubmapModel.CX_LL225B:
						// function ():void {	
						var __x_LL225B:Array /* <Int> */ = [8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15];
						
						x15 = x2 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y1 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (y15 <= __x_LL225B[x15]) {
							oY = ((y1 & XSubmapModel.CX_TILE_HEIGHT_UNMASK) + __x_LL225B[x15] - m_cx.top);
						}
						
						looking = false;
						break; // },
					case XSubmapModel.CX_LR225A:
						looking = false;
						break;
					case XSubmapModel.CX_LR225B:
						looking = false;
						break;
					
					case XSubmapModel.CX_UL675A:
						looking = false;
						break;
					case XSubmapModel.CX_UL675B:
						looking = false;
						break;
					case XSubmapModel.CX_UR675A:
						looking = false;
						break;
					case XSubmapModel.CX_UR675B:
						looking = false;
						break;
					case XSubmapModel.CX_LL675A: // new
						// function ():void {								
						var __x_LL675A:Array /* <Int> */ = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7];
						var __y_LL675A:Array /* <Int> */ = [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30];
						
						x15 = x2 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y1 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (x15 >= __x_LL675A[y15]) {
							oY = ((y1 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __y_LL675A[x15] - m_cx.top);
						}
						
						looking = false;
						
						break;
					case XSubmapModel.CX_LL675B: // new
						// function ():void {							
						var __x_LL675B:Array /* <Int> */ = [8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15];
						var __y_LL675B:Array /* <Int> */ = [0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 4, 6, 8, 10, 12, 14];
						
						x15 = x2 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y1 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (x15 >= __x_LL675B[y15]) {
							oY = ((y1 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __y_LL675B[x15] - m_cx.top);
						}
						
						looking = false;
						
						break;	
					case XSubmapModel.CX_LR675A:
						looking = false;
						break;
					case XSubmapModel.CX_LR675B:
						looking = false;
						break;
					
					case XSubmapModel.CX_SOFTLF:
						looking = false;
						break;
					case XSubmapModel.CX_SOFTRT:
						looking = false;
						break;
					case XSubmapModel.CX_SOFTUP:
						looking = false;
						break;
					case XSubmapModel.CX_SOFTDN:
						// function ():void {
						oY = ((y1 & XSubmapModel.CX_TILE_HEIGHT_UNMASK) + XSubmapModel.CX_TILE_HEIGHT - m_cx.top);
						
						looking = false;
						break; // },
					case XSubmapModel.CX_DEATH:
						looking = false;
						break;
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
			}
			
			//------------------------------------------------------------------------------------------
			// bottom
			//------------------------------------------------------------------------------------------
			x1 = int (oX + m_cx.left);
			x2 = int (oX + m_cx.right);
			y1 = int (oY + m_cx.top);
			y2 = int (oY + m_cx.bottom);
			
			looking = true;
			
			while (looking) {
				//				c = x2/m_submapWidth;
				//				r = y2/m_submapHeight;
				//				i = (int ((y2 & m_submapHeightMask)/XSubmapModel.CX_TILE_HEIGHT) * m_cols) + int ((x2 & m_submapWidthMask)/XSubmapModel.CX_TILE_WIDTH);
				
				c = x2 >> 9;
				r = y2 >> 9;
				i = ( ((y2 & m_submapHeightMask) >> 4) * m_cols) + ((x2 & m_submapWidthMask) >> 4);
				
				switch (m_XSubmaps[r][c].cmap[i]) {
					// ([
					case XSubmapModel.CX_EMPTY:
						looking = false;
						break;
					case XSubmapModel.CX_SOLIDX001:
						looking = false;
						break;
					case XSubmapModel.CX_SOLID:
						looking = false;
						break;
					case XSubmapModel.CX_SOFT:
						// function ():void {
						y2 = (y2 & XSubmapModel.CX_TILE_HEIGHT_UNMASK) - 1;
						break; // },
					case XSubmapModel.CX_JUMP_THRU:
						looking = false;
						break;
					
					case XSubmapModel.CX_UL45:
						// function ():void {	
						var __x_UL45:Array /* <Int> */ = [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
						
						x15 = x2 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y2 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (y15 >= __x_UL45[x15]) {
							oY = ((y2 & XSubmapModel.CX_TILE_HEIGHT_UNMASK) + __x_UL45[x15] - m_cx.bottom - 1);
						}
						
						looking = false;
						break; // },			
					case XSubmapModel.CX_UR45:
						looking = false;
						break;
					case XSubmapModel.CX_LL45:
						looking = false;
						break;
					case XSubmapModel.CX_LR45:
						looking = false;
						break;
					
					case XSubmapModel.CX_UL225A:
						// function ():void {	
						var __x_UL225A:Array /* <Int> */ = [15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8, 8];
						
						x15 = x2 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y2 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (y15 >= __x_UL225A[x15]) {
							oY = ((y2 & XSubmapModel.CX_TILE_HEIGHT_UNMASK) + __x_UL225A[x15] - m_cx.bottom - 1);
						}
						
						looking = false;
						break; // },	
					case XSubmapModel.CX_UL225B:
						// function ():void {	
						var __x_UL225B:Array /* <Int> */ = [7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0, 0];
						
						x15 = x2 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y2 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (y15 >= __x_UL225B[x15]) {
							oY = ((y2 & XSubmapModel.CX_TILE_HEIGHT_UNMASK) + __x_UL225B[x15] - m_cx.bottom - 1);
						}
						
						looking = false;
						break; // },	
					case XSubmapModel.CX_UR225A:
						looking = false;
						break;
					case XSubmapModel.CX_UR225B:
						looking = false;
						break;
					case XSubmapModel.CX_LL225A:
						looking = false;
						break;
					case XSubmapModel.CX_LL225B:
						looking = false;
						break;
					case XSubmapModel.CX_LR225A:
						looking = false;
						break;
					case XSubmapModel.CX_LR225B:
						looking = false;
						break;
					
					case XSubmapModel.CX_UL675A: // new
						// function ():void {								
						var __x_UL675A:Array /* <Int> */ = [15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8, 8];
						var __y_UL675A:Array /* <Int> */ = [0, 0, 0, 0, 0, 0, 0, 0, 14, 12, 10, 8, 6, 4, 2, 0];
						
						x15 = x2 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y2 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (x15 >= __x_UL675A[y15]) {
							oY = ((y2 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __y_UL675A[x15] - m_cx.bottom - 1);
						}
						
						looking = false;
						
						break;
					case XSubmapModel.CX_UL675B: // new
						// function ():void {							
						var __x_UL675B:Array /* <Int> */ = [7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0, 0];
						var __y_UL675B:Array /* <Int> */ = [14, 12, 10, 8, 6, 4, 2, 0, -2, -4, -6, -8, -10, -12, -14, -16];
						
						x15 = x2 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y2 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (x15 >= __x_UL675B[y15]) {
							oY = ((y2 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __y_UL675B[x15] - m_cx.bottom - 1);
						}
						
						looking = false;
						
						break;	
					case XSubmapModel.CX_UR675A:
						looking = false;
						break;
					case XSubmapModel.CX_UR675B:
						looking = false;
						break;
					case XSubmapModel.CX_LL675A:
						looking = false;
						break;
					case XSubmapModel.CX_LL675B:
						looking = false;
						break;
					case XSubmapModel.CX_LR675A:
						looking = false;
						break;
					case XSubmapModel.CX_LR675B:
						looking = false;
						break;
					
					case XSubmapModel.CX_SOFTLF:
						looking = false;
						break;
					case XSubmapModel.CX_SOFTRT:
						looking = false;
						break;
					case XSubmapModel.CX_SOFTUP:
						// function ():void {
						oY = ((y2 & XSubmapModel.CX_TILE_HEIGHT_UNMASK) - (m_cx.bottom) - 1);
						
						looking = false;								
						break; // },
					case XSubmapModel.CX_SOFTDN:
						looking = false;
						break;
					case XSubmapModel.CX_DEATH:
						looking = false;
						break;
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
			}
			
			return false;
		}
		
		//------------------------------------------------------------------------------------------
		public function Ck_Slope_LF ():Boolean {
			var x1:int, y1:int, x2:int, y2:int;
			var i:int, __x:int, __y:int;
			var collided:Boolean;
			var looking:Boolean = true;
			var r:int, c:int;
			var x15:int;
			var y15:int;
			
			collided = false;
			
			//------------------------------------------------------------------------------------------
			// top
			//------------------------------------------------------------------------------------------
			x1 = int (oX + m_cx.left);
			x2 = int (oX + m_cx.right);
			y1 = int (oY + m_cx.top);
			y2 = int (oY + m_cx.bottom);
			
			looking = true;
			
			while (looking) {
				//				c = x1/m_submapWidth;
				//				r = y1/m_submapHeight;
				//				i = (int ((y1 & m_submapHeightMask)/XSubmapModel.CX_TILE_HEIGHT) * m_cols) + int ((x1 & m_submapWidthMask)/XSubmapModel.CX_TILE_WIDTH);
				
				c = x1 >> 9;
				r = y1 >> 9;
				i = ( ((y1 & m_submapHeightMask) >> 4) * m_cols) + ((x1 & m_submapWidthMask) >> 4);
				
				switch (m_XSubmaps[r][c].cmap[i]) {
					// ([
					case XSubmapModel.CX_EMPTY:
						looking = false;
						break;
					case XSubmapModel.CX_SOLIDX001:
						looking = false;
						break;
					case XSubmapModel.CX_SOLID:
						looking = false;
						break;
					case XSubmapModel.CX_SOFT:
						// function ():void {
						y1 = (y1 & XSubmapModel.CX_TILE_HEIGHT_UNMASK) + XSubmapModel.CX_TILE_HEIGHT;
						break; // },
					case XSubmapModel.CX_JUMP_THRU:
						looking = false;
						break;
					
					case XSubmapModel.CX_UL45:
						looking = false;
						break;
					case XSubmapModel.CX_UR45:
						looking = false;
						break;
					case XSubmapModel.CX_LL45:
						looking = false;
						break;
					case XSubmapModel.CX_LR45:
						// function ():void {	
						var __x_LR45:Array /* <Int> */ = [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
						
						x15 = x1 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y1 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (y15 <= __x_LR45[x15]) {
							oY = ((y1 & XSubmapModel.CX_TILE_HEIGHT_UNMASK) + __x_LR45[x15] - m_cx.top);
						}
						
						looking = false;
						break; // },			
					case XSubmapModel.CX_UL225A:
						looking = false;
						break;
					case XSubmapModel.CX_UL225B:
						looking = false;
						break;
					case XSubmapModel.CX_UR225A:
						looking = false;
						break;
					case XSubmapModel.CX_UR225B:
						looking = false;
						break;
					case XSubmapModel.CX_LL225A:
						looking = false;
						break;
					case XSubmapModel.CX_LL225B:
						looking = false;
						break;
					case XSubmapModel.CX_LR225A:
						// function ():void {	
						var __x_LR225A:Array /* <Int> */ = [15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8, 8];
						
						x15 = x1 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y1 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (y15 <= __x_LR225A[x15]) {
							oY = ((y1 & XSubmapModel.CX_TILE_HEIGHT_UNMASK) + __x_LR225A[x15] - m_cx.top);
						}
						
						looking = false;
						break; // },		
					case XSubmapModel.CX_LR225B:
						// function ():void {	
						var __x_LR225B:Array /* <Int> */ = [7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0, 0];
						
						x15 = x1 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y1 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (y15 <= __x_LR225B[x15]) {
							oY = ((y1 & XSubmapModel.CX_TILE_HEIGHT_UNMASK) + __x_LR225B[x15] - m_cx.top);
						}
						
						looking = false;
						break; // },		
					
					case XSubmapModel.CX_UL675A:
						looking = false;
						break;
					case XSubmapModel.CX_UL675B:
						looking = false;
						break;
					case XSubmapModel.CX_UR675A:
						looking = false;
						break;
					case XSubmapModel.CX_UR675B:
						looking = false;
						break;
					case XSubmapModel.CX_LL675A:
						looking = false;
						break;
					case XSubmapModel.CX_LL675B:
						looking = false;
						break;
					case XSubmapModel.CX_LR675A: // new
						// function ():void {								
						var __x_LR675A:Array /* <Int> */ = [15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8, 8];
						var __y_LR675A:Array /* <Int> */ = [32, 30, 28, 26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2];
						
						x15 = x1 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y1 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (x15 <= __x_LR675A[y15]) {
							oY = ((y1 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __y_LR675A[x15] - m_cx.top);
						}
						
						looking = false;
						
						break;
					case XSubmapModel.CX_LR675B: // new
						// function ():void {							
						var __x_LR675B:Array /* <Int> */ = [7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0, 0];
						var __y_LR675B:Array /* <Int> */ = [16, 14, 12, 10, 8, 6, 4, 2, 0, 0, 0, 0, 0, 0, 0, 0];
						
						x15 = x1 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y1 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (x15 <= __x_LR675B[y15]) {
							oY = ((y1 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __y_LR675B[x15] - m_cx.top);
						}
						
						looking = false;
						
						break;	
					
					case XSubmapModel.CX_SOFTLF:
						looking = false;
						break;
					case XSubmapModel.CX_SOFTRT:
						looking = false;
						break;
					case XSubmapModel.CX_SOFTUP:
						looking = false;
						break;
					case XSubmapModel.CX_SOFTDN:
						// function ():void {
						oY = ((y1 & XSubmapModel.CX_TILE_HEIGHT_UNMASK) + XSubmapModel.CX_TILE_HEIGHT - m_cx.top);
						
						looking = false;
						break; // },
					case XSubmapModel.CX_DEATH:
						looking = false;
						break;
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
			}
			
			//------------------------------------------------------------------------------------------
			// bottom
			//------------------------------------------------------------------------------------------
			x1 = int (oX + m_cx.left);
			x2 = int (oX + m_cx.right);
			y1 = int (oY + m_cx.top);
			y2 = int (oY + m_cx.bottom);
			
			looking = true;
			
			while (looking) {
				//				c = x1/m_submapWidth;
				//				r = y2/m_submapHeight;
				//				i = (int ((y2 & m_submapHeightMask)/XSubmapModel.CX_TILE_HEIGHT) * m_cols) + int ((x1 & m_submapWidthMask)/XSubmapModel.CX_TILE_WIDTH);
				
				c = x1 >> 9;
				r = y2 >> 9;
				i = ( ((y2 & m_submapHeightMask) >> 4) * m_cols) + ((x1 & m_submapWidthMask) >> 4);
				
				switch (m_XSubmaps[r][c].cmap[i]) {
					// ([
					case XSubmapModel.CX_EMPTY:
						looking = false;
						break;
					case XSubmapModel.CX_SOLIDX001:
						looking = false;
						break;
					case XSubmapModel.CX_SOLID:
						looking = false;
						break;
					case XSubmapModel.CX_SOFT:
						// function ():void {
						y2 = (y2 & XSubmapModel.CX_TILE_HEIGHT_UNMASK) - 1;
						break; // },
					case XSubmapModel.CX_JUMP_THRU:
						looking = false;
						break;
					
					case XSubmapModel.CX_UL45:
						looking = false;
						break;
					case XSubmapModel.CX_UR45:
						// function ():void {	
						var __x_UR45:Array /* <Int> */ = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
						
						x15 = x1 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y2 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (y15 >= __x_UR45[x15]) {
							oY = ((y2 & XSubmapModel.CX_TILE_HEIGHT_UNMASK) + __x_UR45[x15] - m_cx.bottom - 1);
						}
						
						looking = false;
						break; // },
					case XSubmapModel.CX_LL45:
						looking = false;
						break;
					case XSubmapModel.CX_LR45:
						looking = false;
						break;
					
					case XSubmapModel.CX_UL225A:
						looking = false;
						break;
					case XSubmapModel.CX_UL225B:
						looking = false;
						break;
					case XSubmapModel.CX_UR225A:
						// function ():void {	
						var __x_UR225A:Array /* <Int> */ = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7];
						
						x15 = x1 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y2 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (y15 >= __x_UR225A[x15]) {
							oY = ((y2 & XSubmapModel.CX_TILE_HEIGHT_UNMASK) + __x_UR225A[x15] - m_cx.bottom - 1);
						}
						
						looking = false;
						break; // },
					case XSubmapModel.CX_UR225B:
						// function ():void {	
						var __x_UR225B:Array /* <Int> */ = [8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15];
						
						x15 = x1 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y2 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (y15 >= __x_UR225B[x15]) {
							oY = ((y2 & XSubmapModel.CX_TILE_HEIGHT_UNMASK) + __x_UR225B[x15] - m_cx.bottom - 1);
						}
						
						looking = false;
						break; // },
					case XSubmapModel.CX_LL225A:
						looking = false;
						break;
					case XSubmapModel.CX_LL225B:
						looking = false;
						break;
					case XSubmapModel.CX_LR225A:
						looking = false;
						break;
					case XSubmapModel.CX_LR225B:
						looking = false;
						break;
					
					case XSubmapModel.CX_UL675A:
						looking = false;
						break;
					case XSubmapModel.CX_UL675B:
						looking = false;
						break;
					case XSubmapModel.CX_UR675A: //new
						// function ():void {				
						var __x_UR675A:Array /* <Int> */ = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7];
						var __y_UR675A:Array /* <Int> */ = [0, 2, 4, 6, 8, 10, 12, 14, 0, 0, 0, 0, 0, 0, 0, 0];
						
						x15 = x1 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y2 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (x15 <= __x_UR675A[y15]) {
							oY = ((y2 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __y_UR675A[x15] - m_cx.bottom - 1);
						}
						
						looking = false;
						break; // },
					case XSubmapModel.CX_UR675B: // new
						// function ():void {				
						var __x_UR675B:Array /* <Int> */ = [8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15];
						var __y_UR675B:Array /* <Int> */ = [-16, -14, -12, -10, -8, -6, -4, -2, 0, 2, 4, 6, 8, 10, 12, 14];
						
						x15 = x1 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y2 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (x15 <= __x_UR675B[y15]) {
							oY = ((y2 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __y_UR675B[x15] - m_cx.bottom - 1);
						}
						
						looking = false;
						break; // },
					case XSubmapModel.CX_LL675A:
						looking = false;
						break;
					case XSubmapModel.CX_LL675B:
						looking = false;
						break;
					case XSubmapModel.CX_LR675A:
						looking = false;
						break;
					case XSubmapModel.CX_LR675B:
						looking = false;
						break;
					
					case XSubmapModel.CX_SOFTLF:
						looking = false;
						break;
					case XSubmapModel.CX_SOFTRT:
						looking = false;
						break;
					case XSubmapModel.CX_SOFTUP:
						// function ():void {
						oY = ((y2 & XSubmapModel.CX_TILE_HEIGHT_UNMASK) - (m_cx.bottom) - 1);
						
						looking = false;								
						break; // },
					case XSubmapModel.CX_SOFTDN:
						looking = false;
						break;
					case XSubmapModel.CX_DEATH:
						looking = false;
						break;
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
			}
			
			return false;
		}
		
		//------------------------------------------------------------------------------------------
		public function Ck_Slope_DN ():Boolean {
			var x1:int, y1:int, x2:int, y2:int;
			var i:int, __x:int, __y:int;
			var collided:Boolean;
			var looking:Boolean = true;
			var r:int, c:int;
			var x15:int;
			var y15:int;
			
			collided = false;
			
			//------------------------------------------------------------------------------------------
			// left
			//------------------------------------------------------------------------------------------
			x1 = int (oX + m_cx.left);
			x2 = int (oX + m_cx.right);
			y1 = int (oY + m_cx.top);
			y2 = int (oY + m_cx.bottom);
			
			looking = true;
			
			while (looking) {
				//				c = x1/m_submapWidth;
				//				r = y2/m_submapHeight;
				//				i = (int ((y2 & m_submapHeightMask)/XSubmapModel.CX_TILE_HEIGHT) * m_cols) + int ((x1 & m_submapWidthMask)/XSubmapModel.CX_TILE_WIDTH);
				
				c = x1 >> 9;
				r = y2 >> 9;
				i = ( ((y2 & m_submapHeightMask) >> 4) * m_cols) + ((x1 & m_submapWidthMask) >> 4);
				
				switch (m_XSubmaps[r][c].cmap[i]) {
					// ([
					case XSubmapModel.CX_EMPTY:
						looking = false;
						break;
					case XSubmapModel.CX_SOLIDX001:
						looking = false;
						break;
					case XSubmapModel.CX_SOLID:
						looking = false;
						break;
					case XSubmapModel.CX_SOFT:
						// function ():void {
						x1 = (x1 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + XSubmapModel.CX_TILE_WIDTH;
						break; // },
					case XSubmapModel.CX_JUMP_THRU:
						looking = false;
						break;
					
					case XSubmapModel.CX_UL45:
						looking = false;
						break;
					case XSubmapModel.CX_UR45:
						// function ():void {				
						var __y_UR45:Array /* <Int> */ = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
						
						x15 = x1 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y2 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (x15 <= __y_UR45[y15]) {
							oX = ((x1 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __y_UR45[y15] - m_cx.left);
						}
						
						looking = false;
						break; // },
					case XSubmapModel.CX_LL45:
						looking = false;
						break;
					case XSubmapModel.CX_LR45:
						looking = false;
						break;
					
					case XSubmapModel.CX_UL225A:
						looking = false;
						break;
					case XSubmapModel.CX_UL225B:
						looking = false;
						break;
					case XSubmapModel.CX_UR225A:
						// function ():void {				
						var __y_UR225A:Array /* <Int> */ = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7];
						var __x_UR225A:Array /* <Int> */ = [2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32];
						
						x15 = x1 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y2 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (y15 >= __y_UR225A[x15]) {
							oX = ((x1 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __x_UR225A[y15] - m_cx.left);
						}
						
						looking = false;
						break; // },
					case XSubmapModel.CX_UR225B:
						// function ():void {				
						var __y_UR225B:Array /* <Int> */ = [8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15];
						var __x_UR225B:Array /* <Int> */ = [0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 6, 8, 10, 12, 14, 16];
						
						x15 = x1 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y2 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (y15 >= __y_UR225B[x15]) {
							oX = ((x1 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __x_UR225B[y15] - m_cx.left);
						}
						
						looking = false;
						break; // },
					case XSubmapModel.CX_LL225A:
						looking = false;
						break;
					case XSubmapModel.CX_LL225B:
						looking = false;
						break;
					case XSubmapModel.CX_LR225A:
						looking = false;
						break;
					case XSubmapModel.CX_LR225B:
						looking = false;
						break;
					
					case XSubmapModel.CX_UL675A:
						looking = false;
						break;
					case XSubmapModel.CX_UL675B:
						looking = false;
						break;
					
					case XSubmapModel.CX_UR675A: // new
						// function ():void {								
						var __x_UR675A:Array /* <Int> */ = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7];
						var __y_UR675A:Array /* <Int> */ = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7];
						
						x15 = x1 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y2 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (x15 <= __x_UR675A[y15]) {
							oX = ((x1 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __y_UR675A[y15] - m_cx.left);
						}
						
						looking = false;
						
						break;
					case XSubmapModel.CX_UR675B: // new
						// function ():void {							
						var __x_UR675B:Array /* <Int> */ = [8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15];
						var __y_UR675B:Array /* <Int> */ = [8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15];
						
						x15 = x1 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y2 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (x15 <= __x_UR675B[y15]) {
							oX = ((x1 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __y_UR675B[y15] - m_cx.left);
						}
						
						looking = false;
						
						break;	
					
					case XSubmapModel.CX_LL675A:
						looking = false;
						break;
					case XSubmapModel.CX_LL675B:
						looking = false;
						break;
					case XSubmapModel.CX_LR675A:
						looking = false;
						break;
					case XSubmapModel.CX_LR675B:
						looking = false;
						break;
					
					case XSubmapModel.CX_SOFTLF:
						looking = false;
						break;
					case XSubmapModel.CX_SOFTRT:
						// function ():void {
						m_CX_Collide_Flag |= CX_COLLIDE_LF;
						
						oX = ((x1 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + XSubmapModel.CX_TILE_WIDTH - m_cx.left);
						
						collided = true;
						break; // },
					case XSubmapModel.CX_SOFTUP:
						looking = false;
						break;
					case XSubmapModel.CX_SOFTDN:
						looking = false;
						break;
					case XSubmapModel.CX_DEATH:
						looking = false;
						break;
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
			}
			
			//------------------------------------------------------------------------------------------
			// right
			//------------------------------------------------------------------------------------------
			x1 = int (oX + m_cx.left);
			x2 = int (oX + m_cx.right);
			y1 = int (oY + m_cx.top);
			y2 = int (oY + m_cx.bottom);
			
			looking = true;
			
			while (looking) {
				//				c = x2/m_submapWidth;
				//				r = y2/m_submapHeight;
				//				i = (int ((y2 & m_submapHeightMask)/XSubmapModel.CX_TILE_HEIGHT) * m_cols) + int ((x2 & m_submapWidthMask)/XSubmapModel.CX_TILE_WIDTH);
				
				c = x2 >> 9;
				r = y2 >> 9;
				i = ( ((y2 & m_submapHeightMask) >> 4) * m_cols) + ((x2 & m_submapWidthMask) >> 4);
				
				switch (m_XSubmaps[r][c].cmap[i]) {
					// ([
					case XSubmapModel.CX_EMPTY:
						looking = false;
						break;
					case XSubmapModel.CX_SOLIDX001:
						looking = false;
						break;
					case XSubmapModel.CX_SOLID:
						looking = false;
						break;
					case XSubmapModel.CX_SOFT:
						// function ():void {
						x2 = (x2 & XSubmapModel.CX_TILE_WIDTH_UNMASK) - 1;
						break; // },
					case XSubmapModel.CX_JUMP_THRU:
						looking = false;
						break;
					case XSubmapModel.CX_UL45:
						// function ():void {				
						var __y_UL45:Array /* <Int> */ = [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
						
						x15 = x2 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y2 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (x15 >= __y_UL45[y15]) {
							oX = ((x2 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __y_UL45[y15] - m_cx.right - 1);
						}
						
						looking = false;
						break; // },
					case XSubmapModel.CX_UR45:
						looking = false;
						break;
					case XSubmapModel.CX_LL45:
						looking = false;
						break;
					case XSubmapModel.CX_LR45:
						looking = false;
						break;
					
					case XSubmapModel.CX_UL225A:
						// function ():void {				
						var __y_UL225A:Array /* <Int> */ = [15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8, 8];
						var __x_UL225A:Array /* <Int> */ = [0, 0, 0, 0, 0, 0, 0, 0, 13, 11, 9, 7, 5, 3, 1, -1];   
						
						x15 = x2 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y2 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (y15 >= __y_UL225A[x15]) {
							oX = ((x2 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __x_UL225A[y15] - m_cx.right - 1);
						}
						
						looking = false;
						break; // },
					case XSubmapModel.CX_UL225B:
						// function ():void {				
						var __y_UL225B:Array /* <Int> */ = [7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0, 0];
						var __x_UL225B:Array /* <Int> */ = [13, 11, 9, 7, 5, 3, 1, -1, -3, -5, -7, -9, -11, -13, -15, -17];
						
						x15 = x2 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y2 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (y15 >= __y_UL225B[x15]) {
							oX = ((x2 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __x_UL225B[y15] - m_cx.right - 1);
						}
						
						looking = false;
						break; // },
					case XSubmapModel.CX_UR225A:
						looking = false;
						break;
					case XSubmapModel.CX_UR225B:
						looking = false;
						break;
					case XSubmapModel.CX_LL225A:
						looking = false;
						break;
					case XSubmapModel.CX_LL225B:
						looking = false;
						break;
					case XSubmapModel.CX_LR225A:
						looking = false;
						break;
					case XSubmapModel.CX_LR225B:
						looking = false;
						break;
					
					case XSubmapModel.CX_UL675A: // new
						// function ():void {								
						var __x_UL675A:Array /* <Int> */ = [15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8, 8];
						var __y_UL675A:Array /* <Int> */ = [15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8, 8];
						
						x15 = x2 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y2 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (x15 >= __x_UL675A[y15]) {
							oX = ((x2 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __y_UL675A[y15] - m_cx.bottom - 1);
						}
						
						looking = false;
						
						break;
					case XSubmapModel.CX_UL675B: // new
						// function ():void {							
						var __x_UL675B:Array /* <Int> */ = [7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0, 0];
						var __y_UL675B:Array /* <Int> */ = [7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0, 0];
						
						x15 = x2 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y2 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (x15 >= __x_UL675B[y15]) {
							oX = ((x2 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __y_UL675B[y15] - m_cx.bottom - 1);
						}
						
						looking = false;
						
						break;
					
					case XSubmapModel.CX_UR675A:
						looking = false;
						break;
					case XSubmapModel.CX_UR675B:
						looking = false;
						break;
					case XSubmapModel.CX_LL675A:
						looking = false;
						break;
					case XSubmapModel.CX_LL675B:
						looking = false;
						break;
					case XSubmapModel.CX_LR675A:
						looking = false;
						break;
					case XSubmapModel.CX_LR675B:
						looking = false;
						break;
					
					case XSubmapModel.CX_SOFTLF:
						// function ():void {
						m_CX_Collide_Flag |= CX_COLLIDE_RT;
						
						oX = ((x2 & XSubmapModel.CX_TILE_WIDTH_UNMASK) - (m_cx.right) - 1);
						
						collided = true;
						break; // },
					case XSubmapModel.CX_SOFTRT:
						looking = false;
						break;
					case XSubmapModel.CX_SOFTUP:
						looking = false;
						break;
					case XSubmapModel.CX_SOFTDN:
						looking = false;
						break;
					case XSubmapModel.CX_DEATH:
						looking = false;
						break;
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
			}
			
			return false;		
		}
		
		//------------------------------------------------------------------------------------------
		public function Ck_Slope_UP ():Boolean {
			var x1:int, y1:int, x2:int, y2:int;
			var i:int, __x:int, __y:int;
			var collided:Boolean;
			var looking:Boolean = true;
			var r:int, c:int;
			var x15:int;
			var y15:int;
			
			collided = false;
			
			//------------------------------------------------------------------------------------------
			// left
			//------------------------------------------------------------------------------------------
			x1 = int (oX + m_cx.left);
			x2 = int (oX + m_cx.right);
			y1 = int (oY + m_cx.top);
			y2 = int (oY + m_cx.bottom);
			
			looking = true;
			
			while (looking) {
				//				c = x1/m_submapWidth;
				//				r = y1/m_submapHeight;
				//				i = (int ((y1 & m_submapHeightMask)/XSubmapModel.CX_TILE_HEIGHT) * m_cols) + int ((x1 & m_submapWidthMask)/XSubmapModel.CX_TILE_WIDTH);
				
				c = x1 >> 9;
				r = y1 >> 9;
				i = ( ((y1 & m_submapHeightMask) >> 4) * m_cols) +  ((x1 & m_submapWidthMask) >> 4);
				
				switch (m_XSubmaps[r][c].cmap[i]) {
					// ([
					case XSubmapModel.CX_EMPTY:
						looking = false;
						break;
					case XSubmapModel.CX_SOLIDX001:
						looking = false;
						break;
					case XSubmapModel.CX_SOLID:
						looking = false;
						break;
					case XSubmapModel.CX_SOFT:
						// function ():void {
						x1 = (x1 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + XSubmapModel.CX_TILE_WIDTH;
						break; // },
					case XSubmapModel.CX_JUMP_THRU:
						looking = false;
						break;
					
					case XSubmapModel.CX_UL45:
						looking = false;
						break;
					case XSubmapModel.CX_UR45:
						looking = false;
						break;
					case XSubmapModel.CX_LL45:
						looking = false;
						break;
					case XSubmapModel.CX_LR45:
						// function ():void {				
						var __y_LR45:Array /* <Int> */ = [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
						
						x15 = x1 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y1 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (x15 <= __y_LR45[y15]) {
							oX = ((x1 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __y_LR45[y15] - m_cx.left);
						}
						
						looking = false;
						break; // },
					
					case XSubmapModel.CX_UL225A:
						looking = false;
						break;
					case XSubmapModel.CX_UL225B:
						looking = false;
						break;
					case XSubmapModel.CX_UR225A:
						looking = false;
						break;
					case XSubmapModel.CX_UR225B:
						looking = false;
						break;
					case XSubmapModel.CX_LL225A:
						looking = false;
						break;
					case XSubmapModel.CX_LL225B:
						looking = false;
						break;
					case XSubmapModel.CX_LR225A:
						// function ():void {								
						var __y_LR225A:Array /* <Int> */ = [15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8, 8];
						var __x_LR225A:Array /* <Int> */ = [32, 30, 28, 26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2];
						
						x15 = x1 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y1 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (y15 <= __y_LR225A[x15]) {
							oX = ((x1 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __x_LR225A[y15] - m_cx.left);
						}
						
						looking = false;
						break; // },
					case XSubmapModel.CX_LR225B:
						// function ():void {							
						var __y_LR225B:Array /* <Int> */ = [7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0, 0];
						var __x_LR225B:Array /* <Int> */ = [16, 14, 12, 10, 8, 6, 4, 2, 0, 0, 0, 0, 0, 0, 0, 0];
						
						x15 = x1 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y1 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (y15 <= __y_LR225B[x15]) {
							oX = ((x1 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __x_LR225B[y15] - m_cx.left);
						}
						
						looking = false;
						break; // },
					
					case XSubmapModel.CX_UL675A:
						looking = false;
						break;
					case XSubmapModel.CX_UL675B:
						looking = false;
						break;
					case XSubmapModel.CX_UR675A:
						looking = false;
						break;
					case XSubmapModel.CX_UR675B:
						looking = false;
						break;
					case XSubmapModel.CX_LL675A:
						looking = false;
						break;
					case XSubmapModel.CX_LL675B:
						looking = false;
						break;
					
					case XSubmapModel.CX_LR675A: // new
						// function ():void {								
						var __x_LR675A:Array /* <Int> */ = [15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8, 8];
						var __y_LR675A:Array /* <Int> */ = [15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8, 8];
						
						x15 = x1 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y1 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (x15 <= __x_LR675A[y15]) {
							oX = ((x1 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __y_LR675A[y15] - m_cx.left);
						}
						
						looking = false;
						
						break;
					case XSubmapModel.CX_LR675B: // new
						// function ():void {							
						var __x_LR675B:Array /* <Int> */ = [7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0, 0];
						var __y_LR675B:Array /* <Int> */ = [7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0, 0];
						
						x15 = x1 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y1 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (x15 <= __x_LR675B[y15]) {
							oX = ((x1 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __y_LR675B[y15] - m_cx.left);
						}
						
						looking = false;
						
						break;	
					
					case XSubmapModel.CX_SOFTLF:
						looking = false;
						break;
					case XSubmapModel.CX_SOFTRT:
						// function ():void {
						m_CX_Collide_Flag |= CX_COLLIDE_LF;
						
						oX = ((x1 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + XSubmapModel.CX_TILE_WIDTH - m_cx.left);
						
						collided = true;
						break; // },
					case XSubmapModel.CX_SOFTUP:
						looking = false;
						break;
					case XSubmapModel.CX_SOFTDN:
						looking = false;
						break;
					case XSubmapModel.CX_DEATH:
						looking = false;
						break;
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
			}
			
			//------------------------------------------------------------------------------------------
			// right
			//------------------------------------------------------------------------------------------
			x1 = int (oX + m_cx.left);
			x2 = int (oX + m_cx.right);
			y1 = int (oY + m_cx.top);
			y2 = int (oY + m_cx.bottom);
			
			looking = true;
			
			while (looking) {
				//				c = x2/m_submapWidth;
				//				r = y1/m_submapHeight;
				//				i = (int ((y1 & m_submapHeightMask)/XSubmapModel.CX_TILE_HEIGHT) * m_cols) + int ((x2 & m_submapWidthMask)/XSubmapModel.CX_TILE_WIDTH);
				
				c = x2 >> 9;
				r = y1 >> 9;
				i = ( ((y1 & m_submapHeightMask) >> 4) * m_cols) + ((x2 & m_submapWidthMask) >> 4);
				
				switch (m_XSubmaps[r][c].cmap[i]) {
					// ([
					case XSubmapModel.CX_EMPTY:
						looking = false;
						break;
					case XSubmapModel.CX_SOLIDX001:
						looking = false;
						break;
					case XSubmapModel.CX_SOLID:
						looking = false;
						break;
					case XSubmapModel.CX_SOFT:
						// function ():void {
						x2 = (x2 & XSubmapModel.CX_TILE_WIDTH_UNMASK) - 1;
						break; // },
					case XSubmapModel.CX_JUMP_THRU:
						looking = false;
						break;
					
					case XSubmapModel.CX_UL45:
						looking = false;
						break;
					case XSubmapModel.CX_UR45:
						looking = false;
						break;
					case XSubmapModel.CX_LL45:
						// function ():void {				
						var __y_LL45:Array /* <Int> */ = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
						
						x15 = x2 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y1 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (x15 >= __y_LL45[y15]) {
							oX = ((x2 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __y_LL45[y15] - m_cx.right - 1);
						}
						
						looking = false;
						break; // },
					case XSubmapModel.CX_LR45:
						looking = false;
						break;
					
					case XSubmapModel.CX_UL225A:
						looking = false;
						break;
					case XSubmapModel.CX_UL225B:
						looking = false;
						break;
					case XSubmapModel.CX_UR225A:
						looking = false;
						break;
					case XSubmapModel.CX_UR225B:
						looking = false;
						break;
					case XSubmapModel.CX_LL225A:
						// function ():void {					
						var __y_LL225A:Array /* <Int> */ = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7];
						var __x_LL225A:Array /* <Int> */ = [0, 2, 4, 6, 8, 10, 12, 14, 0, 0, 0, 0, 0, 0, 0, 0];
						
						x15 = x2 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y1 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (y15 <= __y_LL225A[x15]) {		
							oX = ((x2 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __x_LL225A[y15] - m_cx.right - 1);
						}
						
						looking = false;
						break; // },
					case XSubmapModel.CX_LL225B:
						// function ():void {				
						var __y_LL225B:Array /* <Int> */ = [8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15];
						var __x_LL225B:Array /* <Int> */ = [-16, -14, -12, -10, -8, -6, -4, -2, 0, 2, 4, 6, 8, 10, 12, 14];
						
						x15 = x2 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y1 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (y15 <= __y_LL225B[x15]) {
							oX = ((x2 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __x_LL225B[y15] - m_cx.right - 1);
						}
						
						looking = false;
						break; // },
					case XSubmapModel.CX_LR225A:
						looking = false;
						break;
					case XSubmapModel.CX_LR225B:
						looking = false;
						break;
					
					case XSubmapModel.CX_UL675A:
						looking = false;
						break;
					case XSubmapModel.CX_UL675B:
						looking = false;
						break;
					case XSubmapModel.CX_UR675A:
						looking = false;
						break;
					case XSubmapModel.CX_UR675B:
						looking = false;
						break;
					
					case XSubmapModel.CX_LL675A: // new
						// function ():void {								
						var __x_LL675A:Array /* <Int> */ = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7];
						var __y_LL675A:Array /* <Int> */ = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7];
						
						x15 = x2 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y1 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (x15 >= __x_LL675A[y15]) {
							oX = ((x2 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __y_LL675A[y15] - m_cx.right - 1);
						}
						
						looking = false;
						
						break;
					case XSubmapModel.CX_LL675B: // new
						// function ():void {							
						var __x_LL675B:Array /* <Int> */ = [8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15];
						var __y_LL675B:Array /* <Int> */ = [8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15];
						
						x15 = x2 & XSubmapModel.CX_TILE_WIDTH_MASK;
						y15 = y1 & XSubmapModel.CX_TILE_HEIGHT_MASK;
						
						if (x15 >= __x_LL675B[y15]) {
							oX = ((x2 & XSubmapModel.CX_TILE_WIDTH_UNMASK) + __y_LL675B[y15] - m_cx.right - 1);
						}
						
						looking = false;
						
						break;	
					
					case XSubmapModel.CX_LR675A:
						looking = false;
						break;
					case XSubmapModel.CX_LR675B:
						looking = false;
						break;
					
					case XSubmapModel.CX_SOFTLF:
						// function ():void {
						m_CX_Collide_Flag |= CX_COLLIDE_RT;
						
						oX = ((x2 & XSubmapModel.CX_TILE_WIDTH_UNMASK) - (m_cx.right) - 1);
						
						collided = true;
						break; // },
					case XSubmapModel.CX_SOFTRT:
						looking = false;
						break;
					case XSubmapModel.CX_SOFTUP:
						looking = false;
						break;
					case XSubmapModel.CX_SOFTDN:
						looking = false;
						break;
					case XSubmapModel.CX_DEATH:
						looking = false;
						break;
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
			}
			
			return false;		
		}

//------------------------------------------------------------------------------------------		
		public function Ck_Obj_LF ():Boolean {
			if (m_objectCollisionList == null) {
				m_objectCollisionList = getObjectCollisionList ();
			}
			
			return Ck_Obj_LF9 (m_objectCollisionList);
		}
		
//------------------------------------------------------------------------------------------
		public function Ck_Obj_RT ():Boolean {
			if (m_objectCollisionList == null) {
				m_objectCollisionList = getObjectCollisionList ();
			}
			
			return Ck_Obj_RT9 (m_objectCollisionList);
		}
		
//------------------------------------------------------------------------------------------
		public function Ck_Obj_UP ():Boolean {
			if (m_objectCollisionList == null) {
				m_objectCollisionList = getObjectCollisionList ();
			}
			
			return Ck_Obj_UP9 (m_objectCollisionList);
		}
		
//------------------------------------------------------------------------------------------
		public function Ck_Obj_DN ():Boolean {
			if (m_objectCollisionList == null) {
				m_objectCollisionList = getObjectCollisionList ();
			}
			
			return Ck_Obj_DN9 (m_objectCollisionList);
		}
		
//------------------------------------------------------------------------------------------
		public function Ck_Obj_LF9 (__objectCollisionList:XDict /* <XLogicObject, XRect> */):Boolean {
			var x1:int, y1:int, x2:int, y2:int;
			
			x1 = int (oX + m_cx.left);
			x2 = int (oX + m_cx.right);
			y1 = int (oY + m_cx.top);
			y2 = int (oY + m_cx.bottom);
			
			var __collided:Boolean = false;
			
			function __collisionCallback (__logicObject:XLogicObjectCX, __rect:XRect):void {
				if (__logicObject.allowLFCollisions) {
					oX = __rect.right - m_cx.left + 1;
					
					__logicObject.objectCollisionCallback (self);
					
					m_CX_Collide_Flag |= CX_COLLIDE_LF;
				}
			}
			
			__objectCollisionList.doWhile ( /* @:castkey */
				function (__logicObject:XLogicObjectCX):Boolean {
					var __rect:XRect = __objectCollisionList.get (__logicObject) as XRect;
					
					if (x2 < __rect.left || x1 > __rect.right || y2 < __rect.top || y1 > __rect.bottom) {
						return true;
					}
					
					__collisionCallback (__logicObject, __rect);
					
					__collided = true;
					
					return true;
				}
			);
			
			return __collided;
		}
		
//------------------------------------------------------------------------------------------
		public function Ck_Obj_RT9 (__objectCollisionList:XDict /* <XLogicObject, XRect> */):Boolean {
			var x1:int, y1:int, x2:int, y2:int;
			
			x1 = int (oX + m_cx.left);
			x2 = int (oX + m_cx.right);
			y1 = int (oY + m_cx.top);
			y2 = int (oY + m_cx.bottom);
			
			var __collided:Boolean = false;
			
			function __collisionCallback (__logicObject:XLogicObjectCX, __rect:XRect):void {
				if (__logicObject.allowRTCollisions) {
					oX = __rect.left - m_cx.right - 1;
					
					__logicObject.objectCollisionCallback (self);
					
					m_CX_Collide_Flag |= CX_COLLIDE_RT;
				}
			}
			
			__objectCollisionList.doWhile ( /* @:castkey */
				function (__logicObject:XLogicObjectCX):Boolean {
					var __rect:XRect = __objectCollisionList.get (__logicObject) as XRect;
					
					if (x2 < __rect.left || x1 > __rect.right || y2 < __rect.top || y1 > __rect.bottom) {
						return true;
					}
					
					__collisionCallback (__logicObject, __rect);
					
					__collided = true;
					
					return true;
				}
			);
			
			return __collided;
		}
		
//------------------------------------------------------------------------------------------
		public function Ck_Obj_UP9 (__objectCollisionList:XDict /* <XLogicObject, XRect> */):Boolean {
			var x1:int, y1:int, x2:int, y2:int;
			
			x1 = int (oX + m_cx.left);
			x2 = int (oX + m_cx.right);
			y1 = int (oY + m_cx.top);
			y2 = int (oY + m_cx.bottom);
			
			var __collided:Boolean = false;

			function __collisionCallback (__logicObject:XLogicObjectCX, __rect:XRect):void {
				if (__logicObject.allowUPCollisions) {
					oY = __rect.bottom - m_cx.top + 1;
					
					__logicObject.objectCollisionCallback (self);
					
					m_CX_Collide_Flag |= CX_COLLIDE_UP;
				}
			}
			
			__objectCollisionList.doWhile ( /* @:castkey */
				function (__logicObject:XLogicObjectCX):Boolean {
					var __rect:XRect = __objectCollisionList.get (__logicObject) as XRect;
					
					if (x2 < __rect.left || x1 > __rect.right || y2 < __rect.top || y1 > __rect.bottom) {
						return true;
					}
					
					__collisionCallback (__logicObject, __rect);
					
					__collided = true;
					
					return true;
				}
			);
			
			return __collided;
		}
		
//------------------------------------------------------------------------------------------
		public function Ck_Obj_DN9 (__objectCollisionList:XDict /* <XLogicObject, XRect> */):Boolean {
			var x1:int, y1:int, x2:int, y2:int;
			
			x1 = int (oX + m_cx.left);
			x2 = int (oX + m_cx.right);
			y1 = int (oY + m_cx.top);
			y2 = int (oY + m_cx.bottom);
			
			var __collided:Boolean = false;
			
			function __collisionCallback (__logicObject:XLogicObjectCX, __rect:XRect):void {
				if (__logicObject.allowDNCollisions) {
					oY = __rect.top - m_cx.bottom - 1;
					
					__logicObject.objectCollisionCallback (self);
					
					m_CX_Collide_Flag |= CX_COLLIDE_DN;
				}
			}
			
			__objectCollisionList.doWhile ( /* @:castkey */
				function (__logicObject:XLogicObjectCX):Boolean {
					var __rect:XRect = __objectCollisionList.get (__logicObject) as XRect;
					
					if (x2 < __rect.left || x1 > __rect.right || y2 < __rect.top || y1 > __rect.bottom || y2 > __rect.bottom) {
						return true;
					}
					
					__collisionCallback (__logicObject, __rect);
					
					__collided = true;
					
					return true;
				}
			);
			
			return __collided;
		}

//------------------------------------------------------------------------------------------
		public function getObjectCollisionList ():XDict /* <XLogicObject, XRect> */ {
			return xxx.getObjectCollisionList ().getRects (getLayer ());	
		}
				
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}