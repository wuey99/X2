//------------------------------------------------------------------------------------------
package X.World.Logic {

	import X.Collections.*;
	import X.Geom.*;
	import X.Task.*;
	import X.World.*;
	import X.World.Sprite.*;
	import X.XMap.*;
	
//	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------
	public class XLogicObjectCX extends XLogicObject {
		private var m_vel:XPoint;
		private var m_oldPos:XPoint;
		
		protected var m_cx:XRect;
		protected var m_namedCX:XDict;
	
		public var m_XMapModel:XMapModel;
		public var m_XMapView:XMapView;
		public var m_XMapLayerModel:XMapLayerModel;
		private var m_XSubmaps:Array;
		private var m_submapWidth:int;
		private var m_submapHeight:int;
		private var m_submapWidthMask:int;
		private var m_submapHeightMask:int;
		private var m_cols:int;
		private var m_rows:int;

		private var m_CX_Collide_Flag:Number;
	
		public static const CX_COLLIDE_LF:Number = 0x0001;
		public static const CX_COLLIDE_RT:Number = 0x0002;
		public static const CX_COLLIDE_HORZ:Number = (CX_COLLIDE_LF+CX_COLLIDE_RT); 
		public static const CX_COLLIDE_UP:Number = 0x0004;
		public static const CX_COLLIDE_DN:Number = 0x0008;
		public static const CX_COLLIDE_VERT:Number = (CX_COLLIDE_UP+CX_COLLIDE_DN);
	
		// empty
		public static const CX_EMPTY:Number = 0;
		
		// solid solid
		public static const CX_SOLID:Number = 1;
		
		// soft
		public static const CX_SOFT:Number = 2;	
		
		// jump thru
		public static const CX_JUMP_THRU:Number = 3;
		
		// 45 degree diagonals
		public static const CX_UL45:Number = 4;
		public static const CX_UR45:Number = 5;
		public static const CX_LL45:Number = 6;
		public static const CX_LR45:Number = 7;
		
		// 22.5 degree diagonals
		public static const CX_UL225A:Number = 8;
		public static const CX_UL225B:Number = 9;
		public static const CX_UR225A:Number = 10;
		public static const CX_UR225B:Number = 11;
		public static const CX_LL225A:Number = 12;
		public static const CX_LL225B:Number = 13;
		public static const CX_LR225A:Number = 14;
		public static const CX_LR225B:Number = 15;
		
		// 67.5 degree diagonals
		public static const CX_UL675A:Number = 16;
		public static const CX_UL675B:Number = 17;
		public static const CX_UR675A:Number = 18;
		public static const CX_UR675B:Number = 19;
		public static const CX_LL675A:Number = 20;
		public static const CX_LL675B:Number = 21;
		public static const CX_LR675A:Number = 22;
		public static const CX_LR675B:Number = 23;
		
		// soft tiles
		public static const CX_SOFTLF:Number = 24;
		public static const CX_SOFTRT:Number = 25;
		public static const CX_SOFTUP:Number = 26;
		public static const CX_SOFTDN:Number = 27;
		
		public static const CX_MAX:Number = 28;
		
		// collision tile width, height
		public static const CX_TILE_WIDTH:Number = 16;
		public static const CX_TILE_HEIGHT:Number = 16;
		
		public static const CX_TILE_WIDTH_MASK:Number = 15;
		public static const CX_TILE_HEIGHT_MASK:Number = 15;
		
		public static const CX_TILE_WIDTH_UNMASK:Number = 0xfffffff0;
		public static const CX_TILE_HEIGHT_UNMASK:Number = 0xfffffff0;
		
		// alternate tile width, height
		public static const TX_TILE_WIDTH:Number = 64;
		public static const TX_TILE_HEIGHT:Number = 64;
		
		public static const TX_TILE_WIDTH_MASK:Number = 63;
		public static const TX_TILE_HEIGHT_MASK:Number = 63;
		
		public static const TX_TILE_WIDTH_UNMASK:Number = 0xffffffc0;
		public static const TX_TILE_HEIGHT_UNMASK:Number = 0xffffffc0;
		
//------------------------------------------------------------------------------------------
		public function XLogicObjectCX () {
			super ();
		}
		
//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
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
					
			m_namedCX = new XDict ();
		}

//------------------------------------------------------------------------------------------
		public function setXMapModel (__layer:Number, __XMapModel:XMapModel, __XMapView:XMapView=null):void {
			m_XMapModel = __XMapModel;
			m_XMapView = __XMapView;
			
			m_XMapLayerModel = m_XMapModel.getLayer (__layer);
			
			m_XSubmaps = m_XMapLayerModel.submaps ();
			
			m_submapWidth = m_XMapLayerModel.getSubmapWidth ();
			m_submapHeight = m_XMapLayerModel.getSubmapHeight ();
			
			m_submapWidthMask = m_submapWidth - 1;
			m_submapHeightMask = m_submapHeight - 1;
			
			m_cols = m_submapWidth/CX_TILE_WIDTH;
			m_rows = m_submapHeight/CX_TILE_HEIGHT;

			/*			
			trace (": --------------------------------:");
			trace (": submapWidth: ", m_submapWidth);
			trace (": submapHeight: ", m_submapHeight);
			trace (": submapWidthMask: ", m_submapWidthMask);
			trace (": submapHeightMask: ", m_submapHeightMask);
			trace (": m_cols: ", m_cols);
			trace (": m_rows: ", m_rows);
			trace (": tileWidth: ", CX_TILE_WIDTH);
			trace (": tileWidthMask: ", CX_TILE_WIDTH_MASK);
			trace (": tileWidthUnmask: ", CX_TILE_WIDTH_UNMASK);
			trace (": tileHeight: ", CX_TILE_HEIGHT);
			trace (": tileHeightMask: ", CX_TILE_HEIGHT_MASK);
			trace (": tileHeightUnMask: ", CX_TILE_HEIGHT_UNMASK);
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
		public function initItemStorage (__value:*):void {
			if (!hasItemStorage ()) {
				m_XMapLayerModel.getPersistentStorage ().put (item.id, __value);
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
				
			m_namedCX.put (__name, new XRect (__x1, __y1, __x2-__x1+1, __y2-__y1+1));
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
		public function setVel (__vel:XPoint):void {
			m_vel = __vel;
		}
		
		public function set oDX (__value:Number):void {
			var __vel:XPoint = getVel ();
			__vel.x = __value;
			setVel (__vel);
		}

		public function set oDY (__value:Number):void {
			var __vel:XPoint = getVel ();
			__vel.y = __value;
			setVel (__vel);
		}
		
//------------------------------------------------------------------------------------------
		public function getVel ():XPoint {
			return m_vel;
		}
		 
		public function get oDX ():Number {
			return getVel ().x
		}

		public function get oDY ():Number {
			return getVel ().y
		}
		
//------------------------------------------------------------------------------------------
		public function setOld (__pos:XPoint):void {
			m_oldPos = __pos;
		}
		
		public function set oldX (__value:Number):void {
			var __pos:XPoint = getOld ();
			__pos.x = __value;
			setOld (__pos);
		}

		public function set oldY (__value:Number):void {
			var __pos:XPoint = getOld ();
			__pos.y = __value;
			setOld (__pos);
		}
		
//------------------------------------------------------------------------------------------
		public function getOld ():XPoint {
			return m_oldPos;
		}
		
		public function get oldX ():Number {
			return getOld ().x
		}

		public function get oldY ():Number {
			return getOld ().y
		}

//------------------------------------------------------------------------------------------
		public function collidesWithNamedCX (__name:String, __rectDst:XRect):Boolean {
			var __rectSrc:XRect = getAdjustedNamedCX (__name);
			
			return __rectSrc.intersects (__rectDst);
		}
		
//------------------------------------------------------------------------------------------
		public function get CX_Collide_Flag ():Number {
			return m_CX_Collide_Flag;
		}

//------------------------------------------------------------------------------------------
		public function handleCollision (__collider:XLogicObject):void {
		}

//------------------------------------------------------------------------------------------
		public override function updatePhysics ():void {
			handleCX ();	
		}
		
//------------------------------------------------------------------------------------------
		public  function handleCX ():void {
			m_CX_Collide_Flag = 0;

//------------------------------------------------------------------------------------------			
			oX += oDX;
			
//			if (Math.floor (oX) != Math.floor (oldX)) {
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
			
//			if (Math.floor (oY) != Math.floor (oldY)) {
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
			var x1:Number, y1:Number, x2:Number, y2:Number;
			var i:Number, __x:Number, __y:Number;
			var collided:Boolean;
			var cx:Number;
			var r:int, c:int;
			
			x1 = Math.floor (oX) + m_cx.left;
			x2 = Math.floor (oX) + m_cx.right;
			y1 = Math.floor (oY) + m_cx.top;
			y2 = Math.floor (oY) + m_cx.bottom;
						
			y1 &= CX_TILE_HEIGHT_UNMASK;
			
			collided = false;
			
			for (__x = (x1 & CX_TILE_WIDTH_UNMASK); __x <= (x2 & CX_TILE_WIDTH_UNMASK); __x += CX_TILE_WIDTH) {
				c = __x/m_submapWidth;
				r = y1/m_submapHeight;
				i = (Math.floor ((y1 & m_submapHeightMask)/CX_TILE_HEIGHT) * m_cols) + Math.floor ((__x & m_submapWidthMask)/CX_TILE_WIDTH);
				cx = m_XSubmaps[r][c].cmap[i];
				switch (cx) {
				// ([
					case CX_EMPTY:
						break;
					case CX_SOLID:
						// function ():void {
							m_CX_Collide_Flag |= CX_COLLIDE_UP;
				
							oY = (y1 + CX_TILE_HEIGHT - m_cx.top);
			
							collided = true;
						break; // },
					case CX_SOFT:
						break;
					case CX_JUMP_THRU:
						break;
						
					case CX_UL45:
						break;
					case CX_UR45:
						break;
					case CX_LL45:
						break;
					case CX_LR45:
						break;
					
					case CX_UL225A:
						break;
					case CX_UL225B:
						break;
					case CX_UR225A:
						break;
					case CX_UR225B:
						break;
					case CX_LL225A:
						break;
					case CX_LL225B:
						break;
					case CX_LR225A:
						break;
					case CX_LR225B:
						break;
					
					case CX_UL675A:
						break;
					case CX_UL675B:
						break;
					case CX_UR675A:
						break;
					case CX_UR675B:
						break;
					case CX_LL675A:
						break;
					case CX_LL675B:
						break;
					case CX_LR675A:
						break;
					case CX_LR675B:
						break;
						
					case CX_SOFTLF:
						break;
					case CX_SOFTRT:
						break;
					case CX_SOFTUP:
						break;
					case CX_SOFTDN:
						// function ():void {
							m_CX_Collide_Flag |= CX_COLLIDE_UP;
				
							oY = (y1 + CX_TILE_HEIGHT - m_cx.top);
			
							collided = true;
						break; // },
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
			}
			
			return false;
		}
		
//------------------------------------------------------------------------------------------
		public function Ck_Collide_DN ():Boolean {
			var x1:Number, y1:Number, x2:Number, y2:Number;
			var i:Number, __x:Number, __y:Number;
			var collided:Boolean;
			var cx:Number;
			var r:int, c:int;
			
			x1 = Math.floor (oX) + m_cx.left;
			x2 = Math.floor (oX) + m_cx.right;
			y1 = Math.floor (oY) + m_cx.top;
			y2 = Math.floor (oY) + m_cx.bottom;
							
			y2 &= CX_TILE_HEIGHT_UNMASK;
			
			collided = false;
			
			for (__x = (x1 & CX_TILE_WIDTH_UNMASK); __x <= (x2 & CX_TILE_WIDTH_UNMASK); __x += CX_TILE_WIDTH) {
				c = __x/m_submapWidth;
				r = y2/m_submapHeight;
				i = (Math.floor ((y2 & m_submapHeightMask)/CX_TILE_HEIGHT) * m_cols) + Math.floor ((__x & m_submapWidthMask)/CX_TILE_WIDTH);
				cx = m_XSubmaps[r][c].cmap[i];
				switch (cx) {
				// ([
					case CX_EMPTY:
						break;
					case CX_SOLID:
						// function ():void {
							m_CX_Collide_Flag |= CX_COLLIDE_DN;
				
							oY = (y2 - (m_cx.bottom) - 1);
										
							collided = true;
						break; // },
					case CX_SOFT:
						break;
					case CX_JUMP_THRU:
						break;
						
					case CX_UL45:
						break;
					case CX_UR45:
						break;
					case CX_LL45:
						break;
					case CX_LR45:
						break;
					
					case CX_UL225A:
						break;
					case CX_UL225B:
						break;
					case CX_UR225A:
						break;
					case CX_UR225B:
						break;
					case CX_LL225A:
						break;
					case CX_LL225B:
						break;
					case CX_LR225A:
						break;
					case CX_LR225B:
						break;
					
					case CX_UL675A:
						break;
					case CX_UL675B:
						break;
					case CX_UR675A:
						break;
					case CX_UR675B:
						break;
					case CX_LL675A:
						break;
					case CX_LL675B:
						break;
					case CX_LR675A:
						break;
					case CX_LR675B:
						break;
						
					case CX_SOFTLF:
						break;
					case CX_SOFTRT:
						break;
					case CX_SOFTUP:
						// function ():void {
							m_CX_Collide_Flag |= CX_COLLIDE_DN;
				
							oY = (y2 - (m_cx.bottom) - 1);
										
							collided = true;
						break; // },
					case CX_SOFTDN:
						break;
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
			}
			
			return false;
		}
	
//------------------------------------------------------------------------------------------
		public function Ck_Collide_LF ():Boolean {
			var x1:Number, y1:Number, x2:Number, y2:Number;
			var i:Number, __x:Number, __y:Number;
			var collided:Boolean;
			var cx:Number;
			var r:int, c:int;
			
			x1 = Math.floor (oX) + m_cx.left;
			x2 = Math.floor (oX) + m_cx.right;
			y1 = Math.floor (oY) + m_cx.top;
			y2 = Math.floor (oY) + m_cx.bottom;
	
			x1 &= CX_TILE_WIDTH_UNMASK;
			
			collided = false;
			
			for (__y = (y1 & CX_TILE_HEIGHT_UNMASK); __y <= (y2 & CX_TILE_HEIGHT_UNMASK); __y += CX_TILE_HEIGHT) {
				c = x1/m_submapWidth;
				r = __y/m_submapHeight;
				i = (Math.floor ((__y & m_submapHeightMask)/CX_TILE_HEIGHT) * m_cols) + Math.floor ((x1 & m_submapWidthMask)/CX_TILE_WIDTH);
				cx = m_XSubmaps[r][c].cmap[i];
				switch (cx) {
				// ([
					case CX_EMPTY:
						break;
					case CX_SOLID:
							// function ():void {
								m_CX_Collide_Flag |= CX_COLLIDE_LF;
			
								oX = (x1 + CX_TILE_WIDTH - m_cx.left);
				
								collided = true;
							break; // },
					case CX_SOFT:
						break;
					case CX_JUMP_THRU:
						break;
						
					case CX_UL45:
						break;
					case CX_UR45:
						break;
					case CX_LL45:
						break;
					case CX_LR45:
						break;
					
					case CX_UL225A:
						break;
					case CX_UL225B:
						break;
					case CX_UR225A:
						break;
					case CX_UR225B:
						break;
					case CX_LL225A:
						break;
					case CX_LL225B:
						break;
					case CX_LR225A:
						break;
					case CX_LR225B:
						break;
					
					case CX_UL675A:
						break;
					case CX_UL675B:
						break;
					case CX_UR675A:
						break;
					case CX_UR675B:
						break;
					case CX_LL675A:
						break;
					case CX_LL675B:
						break;
					case CX_LR675A:
						break;
					case CX_LR675B:
						break;
						
					case CX_SOFTLF:
						break;
					case CX_SOFTRT:
							// function ():void {
								m_CX_Collide_Flag |= CX_COLLIDE_LF;
			
								oX = (x1 + CX_TILE_WIDTH - m_cx.left);
				
								collided = true;
							break; // },
					case CX_SOFTUP:
						break;
					case CX_SOFTDN:
						break;
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
			}
			
			return false;
		}
		
//------------------------------------------------------------------------------------------
		public function Ck_Collide_RT ():Boolean {
			var x1:Number, y1:Number, x2:Number, y2:Number;
			var i:Number, __x:Number, __y:Number;
			var collided:Boolean;
			var cx:Number;
			var r:int, c:int;
			
			x1 = Math.floor (oX) + m_cx.left;
			x2 = Math.floor (oX) + m_cx.right;
			y1 = Math.floor (oY) + m_cx.top;
			y2 = Math.floor (oY) + m_cx.bottom;
						
			x2 &= CX_TILE_WIDTH_UNMASK;
			
			collided = false;
			
			for (__y = (y1 & CX_TILE_HEIGHT_UNMASK); __y <= (y2 & CX_TILE_HEIGHT_UNMASK); __y += CX_TILE_HEIGHT) {
				c = x2/m_submapWidth;
				r = __y/m_submapHeight;
				i = (Math.floor ((__y & m_submapHeightMask)/CX_TILE_HEIGHT) * m_cols) + Math.floor ((x2 & m_submapWidthMask)/CX_TILE_WIDTH);
				cx = m_XSubmaps[r][c].cmap[i];
				switch (cx) {
				// ([
					case CX_EMPTY:
						break;
					case CX_SOLID:
						// function ():void {
							m_CX_Collide_Flag |= CX_COLLIDE_RT;
		
							oX = (x2 - (m_cx.right) - 1);
			
							collided = true;
						break; // },
					case CX_SOFT:
						break;
					case CX_JUMP_THRU:
						break;
						
					case CX_UL45:
						break;
					case CX_UR45:
						break;
					case CX_LL45:
						break;
					case CX_LR45:
						break;
					
					case CX_UL225A:
						break;
					case CX_UL225B:
						break;
					case CX_UR225A:
						break;
					case CX_UR225B:
						break;
					case CX_LL225A:
						break;
					case CX_LL225B:
						break;
					case CX_LR225A:
						break;
					case CX_LR225B:
						break;
					
					case CX_UL675A:
						break;
					case CX_UL675B:
						break;
					case CX_UR675A:
						break;
					case CX_UR675B:
						break;
					case CX_LL675A:
						break;
					case CX_LL675B:
						break;
					case CX_LR675A:
						break;
					case CX_LR675B:
						break;
						
					case CX_SOFTLF:
						// function ():void {
							m_CX_Collide_Flag |= CX_COLLIDE_RT;
		
							oX = (x2 - (m_cx.right) - 1);
			
							collided = true;
						break; // },
					case CX_SOFTRT:
						break;
					case CX_SOFTUP:
						break;
					case CX_SOFTDN:
						break;
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
			}
			
			return false;
		}
				
//------------------------------------------------------------------------------------------
		public function Ck_Slope_RT ():Boolean {
			var x1:Number, y1:Number, x2:Number, y2:Number;
			var i:Number, __x:Number, __y:Number;
			var collided:Boolean;
			var looking:Boolean = true;
			var cx:Number;
			var r:int, c:int;
			
			collided = false;
			
//------------------------------------------------------------------------------------------
// top
//------------------------------------------------------------------------------------------
			x1 = Math.floor (oX) + m_cx.left;
			x2 = Math.floor (oX) + m_cx.right;
			y1 = Math.floor (oY) + m_cx.top;
			y2 = Math.floor (oY) + m_cx.bottom;
		
			looking = true;
			
			while (looking) {
				c = x2/m_submapWidth;
				r = y1/m_submapHeight;
				i = (Math.floor ((y1 & m_submapHeightMask)/CX_TILE_HEIGHT) * m_cols) + Math.floor ((x2 & m_submapWidthMask)/CX_TILE_WIDTH);
				cx = m_XSubmaps[r][c].cmap[i];
				switch (cx) {
				// ([
					case CX_EMPTY:
						looking = false;
						break;
					case CX_SOLID:
						looking = false;
						break;
					case CX_SOFT:
						// function ():void {
							y1 = (y1 & CX_TILE_HEIGHT_UNMASK) + CX_TILE_HEIGHT;
						break; // },
					case CX_JUMP_THRU:
						looking = false;
						break;
						
					case CX_UL45:
						looking = false;
						break;
					case CX_UR45:
						looking = false;
						break;
					case CX_LL45:
						// function ():void {	
							var __x_LL45:Array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
							
							var x15:Number = x2 & CX_TILE_WIDTH_MASK;
							var y15:Number = y1 & CX_TILE_HEIGHT_MASK;

							if (y15 <= __x_LL45[x15]) {
								oY = ((y1 & CX_TILE_HEIGHT_UNMASK) + __x_LL45[x15] - m_cx.top);
							}
	
							looking = false;
						break; // },
					case CX_LR45:
						looking = false;
						break;
					
					case CX_UL225A:
						looking = false;
						break;
					case CX_UL225B:
						looking = false;
						break;
					case CX_UR225A:
						looking = false;
						break;
					case CX_UR225B:
						looking = false;
						break;
					case CX_LL225A:
						// function ():void {	
							var __x_LL225A:Array = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7];
							
							var x15:Number = x2 & CX_TILE_WIDTH_MASK;
							var y15:Number = y1 & CX_TILE_HEIGHT_MASK;

							if (y15 <= __x_LL225A[x15]) {
								oY = ((y1 & CX_TILE_HEIGHT_UNMASK) + __x_LL225A[x15] - m_cx.top);
							}
	
							looking = false;
						break; // },
					case CX_LL225B:
						// function ():void {	
							var __x_LL225B:Array = [8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15];
							
							var x15:Number = x2 & CX_TILE_WIDTH_MASK;
							var y15:Number = y1 & CX_TILE_HEIGHT_MASK;

							if (y15 <= __x_LL225B[x15]) {
								oY = ((y1 & CX_TILE_HEIGHT_UNMASK) + __x_LL225B[x15] - m_cx.top);
							}
	
							looking = false;
						break; // },
					case CX_LR225A:
						looking = false;
						break;
					case CX_LR225B:
						looking = false;
						break;
					
					case CX_UL675A:
						looking = false;
						break;
					case CX_UL675B:
						looking = false;
						break;
					case CX_UR675A:
						looking = false;
						break;
					case CX_UR675B:
						looking = false;
						break;
					case CX_LL675A:
						looking = false;
						break;
					case CX_LL675B:
						looking = false;
						break;
					case CX_LR675A:
						looking = false;
						break;
					case CX_LR675B:
						looking = false;
						break;
						
					case CX_SOFTLF:
						looking = false;
						break;
					case CX_SOFTRT:
						looking = false;
						break;
					case CX_SOFTUP:
						looking = false;
						break;
					case CX_SOFTDN:
						// function ():void {
							oY = ((y1 & CX_TILE_HEIGHT_UNMASK) + CX_TILE_HEIGHT - m_cx.top);
							
							looking = false;
						break; // },
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
			}
			
//------------------------------------------------------------------------------------------
// bottom
//------------------------------------------------------------------------------------------
			x1 = Math.floor (oX) + m_cx.left;
			x2 = Math.floor (oX) + m_cx.right;
			y1 = Math.floor (oY) + m_cx.top;
			y2 = Math.floor (oY) + m_cx.bottom;
			
			looking = true;
			
			while (looking) {
				c = x2/m_submapWidth;
				r = y2/m_submapHeight;
				i = (Math.floor ((y2 & m_submapHeightMask)/CX_TILE_HEIGHT) * m_cols) + Math.floor ((x2 & m_submapWidthMask)/CX_TILE_WIDTH);
				cx = m_XSubmaps[r][c].cmap[i];
				switch (cx) {
				// ([
					case CX_EMPTY:
						looking = false;
						break;
					case CX_SOLID:
						looking = false;
						break;
					case CX_SOFT:
						// function ():void {
							y2 = (y2 & CX_TILE_HEIGHT_UNMASK) - 1;
						break; // },
					case CX_JUMP_THRU:
						looking = false;
						break;
						
					case CX_UL45:
						// function ():void {	
							var __x_UL45:Array = [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
							
							var x15:Number = x2 & CX_TILE_WIDTH_MASK;
							var y15:Number = y2 & CX_TILE_HEIGHT_MASK;

							if (y15 >= __x_UL45[x15]) {
								oY = ((y2 & CX_TILE_HEIGHT_UNMASK) + __x_UL45[x15] - m_cx.bottom - 1);
							}
	
							looking = false;
						break; // },			
					case CX_UR45:
						looking = false;
						break;
					case CX_LL45:
						looking = false;
						break;
					case CX_LR45:
						looking = false;
						break;
					
					case CX_UL225A:
						// function ():void {	
							var __x_UL225A:Array = [15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8, 8];
							
							var x15:Number = x2 & CX_TILE_WIDTH_MASK;
							var y15:Number = y2 & CX_TILE_HEIGHT_MASK;

							if (y15 >= __x_UL225A[x15]) {
								oY = ((y2 & CX_TILE_HEIGHT_UNMASK) + __x_UL225A[x15] - m_cx.bottom - 1);
							}
	
							looking = false;
						break; // },	
					case CX_UL225B:
						// function ():void {	
							var __x_UL225B:Array = [7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0, 0];
							
							var x15:Number = x2 & CX_TILE_WIDTH_MASK;
							var y15:Number = y2 & CX_TILE_HEIGHT_MASK;

							if (y15 >= __x_UL225B[x15]) {
								oY = ((y2 & CX_TILE_HEIGHT_UNMASK) + __x_UL225B[x15] - m_cx.bottom - 1);
							}
	
							looking = false;
						break; // },	
					case CX_UR225A:
						looking = false;
						break;
					case CX_UR225B:
						looking = false;
						break;
					case CX_LL225A:
						looking = false;
						break;
					case CX_LL225B:
						looking = false;
						break;
					case CX_LR225A:
						looking = false;
						break;
					case CX_LR225B:
						looking = false;
						break;
					
					case CX_UL675A:
						looking = false;
						break;
					case CX_UL675B:
						looking = false;
						break;
					case CX_UR675A:
						looking = false;
						break;
					case CX_UR675B:
						looking = false;
						break;
					case CX_LL675A:
						looking = false;
						break;
					case CX_LL675B:
						looking = false;
						break;
					case CX_LR675A:
						looking = false;
						break;
					case CX_LR675B:
						looking = false;
						break;
						
					case CX_SOFTLF:
						looking = false;
						break;
					case CX_SOFTRT:
						looking = false;
						break;
					case CX_SOFTUP:
							// function ():void {
								oY = ((y2 & CX_TILE_HEIGHT_UNMASK) - (m_cx.bottom) - 1);
								
								looking = false;								
							break; // },
					case CX_SOFTDN:
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
			var x1:Number, y1:Number, x2:Number, y2:Number;
			var i:Number, __x:Number, __y:Number;
			var collided:Boolean;
			var looking:Boolean = true;
			var cx:Number;
			var r:int, c:int;
			
			collided = false;
			
//------------------------------------------------------------------------------------------
// top
//------------------------------------------------------------------------------------------
			x1 = Math.floor (oX) + m_cx.left;
			x2 = Math.floor (oX) + m_cx.right;
			y1 = Math.floor (oY) + m_cx.top;
			y2 = Math.floor (oY) + m_cx.bottom;
			
			looking = true;
			
			while (looking) {
				c = x1/m_submapWidth;
				r = y1/m_submapHeight;
				i = (Math.floor ((y1 & m_submapHeightMask)/CX_TILE_HEIGHT) * m_cols) + Math.floor ((x1 & m_submapWidthMask)/CX_TILE_WIDTH);
				cx = m_XSubmaps[r][c].cmap[i];
				
				switch (cx) {
				// ([
					case CX_EMPTY:
						looking = false;
						break;
					case CX_SOLID:
						looking = false;
						break;
					case CX_SOFT:
						// function ():void {
							y1 = (y1 & CX_TILE_HEIGHT_UNMASK) + CX_TILE_HEIGHT;
						break; // },
					case CX_JUMP_THRU:
						looking = false;
						break;
						
					case CX_UL45:
						looking = false;
						break;
					case CX_UR45:
						looking = false;
						break;
					case CX_LL45:
						looking = false;
						break;
					case CX_LR45:
						// function ():void {	
							var __x_LR45:Array = [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
							
							var x15:Number = x1 & CX_TILE_WIDTH_MASK;
							var y15:Number = y1 & CX_TILE_HEIGHT_MASK;

							if (y15 <= __x_LR45[x15]) {
								oY = ((y1 & CX_TILE_HEIGHT_UNMASK) + __x_LR45[x15] - m_cx.top);
							}
	
							looking = false;
						break; // },			
					case CX_UL225A:
						looking = false;
						break;
					case CX_UL225B:
						looking = false;
						break;
					case CX_UR225A:
						looking = false;
						break;
					case CX_UR225B:
						looking = false;
						break;
					case CX_LL225A:
						looking = false;
						break;
					case CX_LL225B:
						looking = false;
						break;
					case CX_LR225A:
						// function ():void {	
							var __x_LR225A:Array = [15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8, 8];
							
							var x15:Number = x1 & CX_TILE_WIDTH_MASK;
							var y15:Number = y1 & CX_TILE_HEIGHT_MASK;

							if (y15 <= __x_LR225A[x15]) {
								oY = ((y1 & CX_TILE_HEIGHT_UNMASK) + __x_LR225A[x15] - m_cx.top);
							}
	
							looking = false;
						break; // },		
					case CX_LR225B:
						// function ():void {	
							var __x_LR225B:Array = [7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0, 0];
							
							var x15:Number = x1 & CX_TILE_WIDTH_MASK;
							var y15:Number = y1 & CX_TILE_HEIGHT_MASK;

							if (y15 <= __x_LR225B[x15]) {
								oY = ((y1 & CX_TILE_HEIGHT_UNMASK) + __x_LR225B[x15] - m_cx.top);
							}
	
							looking = false;
						break; // },		
					
					case CX_UL675A:
						looking = false;
						break;
					case CX_UL675B:
						looking = false;
						break;
					case CX_UR675A:
						looking = false;
						break;
					case CX_UR675B:
						looking = false;
						break;
					case CX_LL675A:
						looking = false;
						break;
					case CX_LL675B:
						looking = false;
						break;
					case CX_LR675A:
						looking = false;
						break;
					case CX_LR675B:
						looking = false;
						break;
						
					case CX_SOFTLF:
						looking = false;
						break;
					case CX_SOFTRT:
						looking = false;
						break;
					case CX_SOFTUP:
						looking = false;
						break;
					case CX_SOFTDN:
						// function ():void {
							oY = ((y1 & CX_TILE_HEIGHT_UNMASK) + CX_TILE_HEIGHT - m_cx.top);
							
							looking = false;
						break; // },
				} // ])[cx] ();
				
				if (collided) {
					return true;
				}
			}
			
//------------------------------------------------------------------------------------------
// bottom
//------------------------------------------------------------------------------------------
			x1 = Math.floor (oX) + m_cx.left;
			x2 = Math.floor (oX) + m_cx.right;
			y1 = Math.floor (oY) + m_cx.top;
			y2 = Math.floor (oY) + m_cx.bottom;
			
			looking = true;
			
			while (looking) {
				c = x1/m_submapWidth;
				r = y2/m_submapHeight;
				i = (Math.floor ((y2 & m_submapHeightMask)/CX_TILE_HEIGHT) * m_cols) + Math.floor ((x1 & m_submapWidthMask)/CX_TILE_WIDTH);
				cx = m_XSubmaps[r][c].cmap[i];
				switch (cx) {
				// ([
					case CX_EMPTY:
						looking = false;
						break;
					case CX_SOLID:
						looking = false;
						break;
					case CX_SOFT:
						// function ():void {
							y2 = (y2 & CX_TILE_HEIGHT_UNMASK) - 1;
						break; // },
					case CX_JUMP_THRU:
						looking = false;
						break;
						
					case CX_UL45:
						looking = false;
						break;
					case CX_UR45:
						// function ():void {	
							var __x_UR45:Array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
							
							var x15:Number = x1 & CX_TILE_WIDTH_MASK;
							var y15:Number = y2 & CX_TILE_HEIGHT_MASK;

							if (y15 >= __x_UR45[x15]) {
								oY = ((y2 & CX_TILE_HEIGHT_UNMASK) + __x_UR45[x15] - m_cx.bottom - 1);
							}
	
							looking = false;
						break; // },
					case CX_LL45:
						looking = false;
						break;
					case CX_LR45:
						looking = false;
						break;
					
					case CX_UL225A:
						looking = false;
						break;
					case CX_UL225B:
						looking = false;
						break;
					case CX_UR225A:
						// function ():void {	
							var __x_UR225A:Array = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7];
							
							var x15:Number = x1 & CX_TILE_WIDTH_MASK;
							var y15:Number = y2 & CX_TILE_HEIGHT_MASK;

							if (y15 >= __x_UR225A[x15]) {
								oY = ((y2 & CX_TILE_HEIGHT_UNMASK) + __x_UR225A[x15] - m_cx.bottom - 1);
							}
	
							looking = false;
						break; // },
					case CX_UR225B:
						// function ():void {	
							var __x_UR225B:Array = [8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15];
							
							var x15:Number = x1 & CX_TILE_WIDTH_MASK;
							var y15:Number = y2 & CX_TILE_HEIGHT_MASK;

							if (y15 >= __x_UR225B[x15]) {
								oY = ((y2 & CX_TILE_HEIGHT_UNMASK) + __x_UR225B[x15] - m_cx.bottom - 1);
							}
	
							looking = false;
						break; // },
					case CX_LL225A:
						looking = false;
						break;
					case CX_LL225B:
						looking = false;
						break;
					case CX_LR225A:
						looking = false;
						break;
					case CX_LR225B:
						looking = false;
						break;
					
					case CX_UL675A:
						looking = false;
						break;
					case CX_UL675B:
						looking = false;
						break;
					case CX_UR675A:
						looking = false;
						break;
					case CX_UR675B:
						looking = false;
						break;
					case CX_LL675A:
						looking = false;
						break;
					case CX_LL675B:
						looking = false;
						break;
					case CX_LR675A:
						looking = false;
						break;
					case CX_LR675B:
						looking = false;
						break;
						
					case CX_SOFTLF:
						looking = false;
						break;
					case CX_SOFTRT:
						looking = false;
						break;
					case CX_SOFTUP:
							// function ():void {
								oY = ((y2 & CX_TILE_HEIGHT_UNMASK) - (m_cx.bottom) - 1);
								
								looking = false;								
							break; // },
					case CX_SOFTDN:
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
			var x1:Number, y1:Number, x2:Number, y2:Number;
			var i:Number, __x:Number, __y:Number;
			var collided:Boolean;
			var looking:Boolean = true;
			var cx:Number;
			var r:int, c:int;
			
			collided = false;

//------------------------------------------------------------------------------------------
// left
//------------------------------------------------------------------------------------------
			x1 = Math.floor (oX) + m_cx.left;
			x2 = Math.floor (oX) + m_cx.right;
			y1 = Math.floor (oY) + m_cx.top;
			y2 = Math.floor (oY) + m_cx.bottom;
			
			looking = true;
			
			while (looking) {
				c = x1/m_submapWidth;
				r = y2/m_submapHeight;
				i = (Math.floor ((y2 & m_submapHeightMask)/CX_TILE_HEIGHT) * m_cols) + Math.floor ((x1 & m_submapWidthMask)/CX_TILE_WIDTH);
				cx = m_XSubmaps[r][c].cmap[i];
				switch (cx) {
				// ([
					case CX_EMPTY:
						looking = false;
						break;
					case CX_SOLID:
						looking = false;
						break;
					case CX_SOFT:
						// function ():void {
							x1 = (x1 & CX_TILE_WIDTH_UNMASK) + CX_TILE_WIDTH;
						break; // },
					case CX_JUMP_THRU:
						looking = false;
						break;
			
					case CX_UL45:
						looking = false;
						break;
					case CX_UR45:
						// function ():void {				
							var __y_UR45:Array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
							
							var x15:Number = x1 & CX_TILE_WIDTH_MASK;
							var y15:Number = y2 & CX_TILE_HEIGHT_MASK;
						
							if (x15 <= __y_UR45[y15]) {
								oX = ((x1 & CX_TILE_WIDTH_UNMASK) + __y_UR45[y15] - m_cx.left);
							}
	
							looking = false;
						break; // },
					case CX_LL45:
						looking = false;
						break;
					case CX_LR45:
						looking = false;
						break;
					
					case CX_UL225A:
						looking = false;
						break;
					case CX_UL225B:
						looking = false;
						break;
					case CX_UR225A:
						// function ():void {				
							var __y_UR225A:Array = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7];
							var __x_UR225A:Array = [2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32];
							
							var x15:Number = x1 & CX_TILE_WIDTH_MASK;
							var y15:Number = y2 & CX_TILE_HEIGHT_MASK;
						
							if (y15 >= __y_UR225A[x15]) {
								oX = ((x1 & CX_TILE_WIDTH_UNMASK) + __x_UR225A[y15] - m_cx.left);
							}
	
							looking = false;
						break; // },
					case CX_UR225B:
						// function ():void {				
							var __y_UR225B:Array = [8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15];
							var __x_UR225B:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 6, 8, 10, 12, 14, 16];
							
							var x15:Number = x1 & CX_TILE_WIDTH_MASK;
							var y15:Number = y2 & CX_TILE_HEIGHT_MASK;
						
							if (y15 >= __y_UR225B[x15]) {
								oX = ((x1 & CX_TILE_WIDTH_UNMASK) + __x_UR225B[y15] - m_cx.left);
							}
	
							looking = false;
						break; // },
					case CX_LL225A:
						looking = false;
						break;
					case CX_LL225B:
						looking = false;
						break;
					case CX_LR225A:
						looking = false;
						break;
					case CX_LR225B:
						looking = false;
						break;
					
					case CX_UL675A:
						looking = false;
						break;
					case CX_UL675B:
						looking = false;
						break;
					case CX_UR675A:
						looking = false;
						break;
					case CX_UR675B:
						looking = false;
						break;
					case CX_LL675A:
						looking = false;
						break;
					case CX_LL675B:
						looking = false;
						break;
					case CX_LR675A:
						looking = false;
						break;
					case CX_LR675B:
						looking = false;
						break;
						
					case CX_SOFTLF:
						looking = false;
						break;
					case CX_SOFTRT:
							// function ():void {
								m_CX_Collide_Flag |= CX_COLLIDE_LF;
			
								oX = ((x1 & CX_TILE_WIDTH_UNMASK) + CX_TILE_WIDTH - m_cx.left);
				
								collided = true;
							break; // },
					case CX_SOFTUP:
						looking = false;
						break;
					case CX_SOFTDN:
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
			x1 = Math.floor (oX) + m_cx.left;
			x2 = Math.floor (oX) + m_cx.right;
			y1 = Math.floor (oY) + m_cx.top;
			y2 = Math.floor (oY) + m_cx.bottom;
			
			looking = true;
			
			while (looking) {
				c = x2/m_submapWidth;
				r = y2/m_submapHeight;
				i = (Math.floor ((y2 & m_submapHeightMask)/CX_TILE_HEIGHT) * m_cols) + Math.floor ((x2 & m_submapWidthMask)/CX_TILE_WIDTH);
				cx = m_XSubmaps[r][c].cmap[i];
				switch (cx) {
				// ([
					case CX_EMPTY:
						looking = false;
						break;
					case CX_SOLID:
						looking = false;
						break;
					case CX_SOFT:
						// function ():void {
							x2 = (x2 & CX_TILE_WIDTH_UNMASK) - 1;
						break; // },
					case CX_JUMP_THRU:
						looking = false;
						break;
			
					case CX_UL45:
						// function ():void {				
							var __y_UL45:Array = [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
							
							var x15:Number = x2 & CX_TILE_WIDTH_MASK;
							var y15:Number = y2 & CX_TILE_HEIGHT_MASK;

							if (x15 >= __y_UL45[y15]) {
								oX = ((x2 & CX_TILE_WIDTH_UNMASK) + __y_UL45[y15] - m_cx.right - 1);
							}
	
							looking = false;
						break; // },
					case CX_UR45:
						looking = false;
						break;
					case CX_LL45:
						looking = false;
						break;
					case CX_LR45:
						looking = false;
						break;
					
					case CX_UL225A:
						// function ():void {				
							var __y_UL225A:Array = [15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8, 8];
							var __x_UL225A:Array = [0, 0, 0, 0, 0, 0, 0, 0, 13, 11, 9, 7, 5, 3, 1, -1];   
							
							var x15:Number = x2 & CX_TILE_WIDTH_MASK;
							var y15:Number = y2 & CX_TILE_HEIGHT_MASK;

							if (y15 >= __y_UL225A[x15]) {
								oX = ((x2 & CX_TILE_WIDTH_UNMASK) + __x_UL225A[y15] - m_cx.right - 1);
							}
	
							looking = false;
						break; // },
					case CX_UL225B:
						// function ():void {				
							var __y_UL225B:Array = [7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0, 0];
							var __x_UL225B:Array = [13, 11, 9, 7, 5, 3, 1, -1, -3, -5, -7, -9, -11, -13, -15, -17];
							
							var x15:Number = x2 & CX_TILE_WIDTH_MASK;
							var y15:Number = y2 & CX_TILE_HEIGHT_MASK;

							if (y15 >= __y_UL225B[x15]) {
								oX = ((x2 & CX_TILE_WIDTH_UNMASK) + __x_UL225B[y15] - m_cx.right - 1);
							}
	
							looking = false;
						break; // },
					case CX_UR225A:
						looking = false;
						break;
					case CX_UR225B:
						looking = false;
						break;
					case CX_LL225A:
						looking = false;
						break;
					case CX_LL225B:
						looking = false;
						break;
					case CX_LR225A:
						looking = false;
						break;
					case CX_LR225B:
						looking = false;
						break;
					
					case CX_UL675A:
						looking = false;
						break;
					case CX_UL675B:
						looking = false;
						break;
					case CX_UR675A:
						looking = false;
						break;
					case CX_UR675B:
						looking = false;
						break;
					case CX_LL675A:
						looking = false;
						break;
					case CX_LL675B:
						looking = false;
						break;
					case CX_LR675A:
						looking = false;
						break;
					case CX_LR675B:
						looking = false;
						break;
						
					case CX_SOFTLF:
						// function ():void {
							m_CX_Collide_Flag |= CX_COLLIDE_RT;
		
							oX = ((x2 & CX_TILE_WIDTH_UNMASK) - (m_cx.right) - 1);
			
							collided = true;
						break; // },
					case CX_SOFTRT:
						looking = false;
						break;
					case CX_SOFTUP:
						looking = false;
						break;
					case CX_SOFTDN:
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
			var x1:Number, y1:Number, x2:Number, y2:Number;
			var i:int, __x:Number, __y:Number;
			var collided:Boolean;
			var looking:Boolean = true;
			var cx:Number;
			var r:int, c:int;
			
			collided = false;

//------------------------------------------------------------------------------------------
// left
//------------------------------------------------------------------------------------------
			x1 = Math.floor (oX) + m_cx.left;
			x2 = Math.floor (oX) + m_cx.right;
			y1 = Math.floor (oY) + m_cx.top;
			y2 = Math.floor (oY) + m_cx.bottom;
			
			looking = true;
			
			while (looking) {
				c = x1/m_submapWidth;
				r = y1/m_submapHeight;
				i = (Math.floor ((y1 & m_submapHeightMask)/CX_TILE_HEIGHT) * m_cols) + Math.floor ((x1 & m_submapWidthMask)/CX_TILE_WIDTH);
				cx = m_XSubmaps[r][c].cmap[i];
				switch (cx) {
				// ([
					case CX_EMPTY:
						looking = false;
						break;
					case CX_SOLID:
						looking = false;
						break;
					case CX_SOFT:
						// function ():void {
							x1 = (x1 & CX_TILE_WIDTH_UNMASK) + CX_TILE_WIDTH;
						break; // },
					case CX_JUMP_THRU:
						looking = false;
						break;
			
					case CX_UL45:
						looking = false;
						break;
					case CX_UR45:
						looking = false;
						break;
					case CX_LL45:
						looking = false;
						break;
					case CX_LR45:
						// function ():void {				
							var __y_LR45:Array = [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
							
							var x15:Number = x1 & CX_TILE_WIDTH_MASK;
							var y15:Number = y1 & CX_TILE_HEIGHT_MASK;
						
							if (x15 <= __y_LR45[y15]) {
								oX = ((x1 & CX_TILE_WIDTH_UNMASK) + __y_LR45[y15] - m_cx.left);
							}
	
							looking = false;
						break; // },
					
					case CX_UL225A:
						looking = false;
						break;
					case CX_UL225B:
						looking = false;
						break;
					case CX_UR225A:
						looking = false;
						break;
					case CX_UR225B:
						looking = false;
						break;
					case CX_LL225A:
						looking = false;
						break;
					case CX_LL225B:
						looking = false;
						break;
					case CX_LR225A:
						// function ():void {								
							var __y_LR225A:Array = [15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8, 8];
							var __x_LR225A:Array = [32, 30, 28, 26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2];
							
							var x15:Number = x1 & CX_TILE_WIDTH_MASK;
							var y15:Number = y1 & CX_TILE_HEIGHT_MASK;
						
							if (y15 <= __y_LR225A[x15]) {
								oX = ((x1 & CX_TILE_WIDTH_UNMASK) + __x_LR225A[y15] - m_cx.left);
							}
	
							looking = false;
						break; // },
					case CX_LR225B:
						// function ():void {							
							var __y_LR225B:Array = [7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0, 0];
							var __x_LR225B:Array = [16, 14, 12, 10, 8, 6, 4, 2, 0, 0, 0, 0, 0, 0, 0, 0];
													
							var x15:Number = x1 & CX_TILE_WIDTH_MASK;
							var y15:Number = y1 & CX_TILE_HEIGHT_MASK;
						
							if (y15 <= __y_LR225B[x15]) {
								oX = ((x1 & CX_TILE_WIDTH_UNMASK) + __x_LR225B[y15] - m_cx.left);
							}
	
							looking = false;
						break; // },
					
					case CX_UL675A:
						looking = false;
						break;
					case CX_UL675B:
						looking = false;
						break;
					case CX_UR675A:
						looking = false;
						break;
					case CX_UR675B:
						looking = false;
						break;
					case CX_LL675A:
						looking = false;
						break;
					case CX_LL675B:
						looking = false;
						break;
					case CX_LR675A:
						looking = false;
						break;
					case CX_LR675B:
						looking = false;
						break;
						
					case CX_SOFTLF:
						looking = false;
						break;
					case CX_SOFTRT:
							// function ():void {
								m_CX_Collide_Flag |= CX_COLLIDE_LF;
			
								oX = ((x1 & CX_TILE_WIDTH_UNMASK) + CX_TILE_WIDTH - m_cx.left);
				
								collided = true;
							break; // },
					case CX_SOFTUP:
						looking = false;
						break;
					case CX_SOFTDN:
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
			x1 = Math.floor (oX) + m_cx.left;
			x2 = Math.floor (oX) + m_cx.right;
			y1 = Math.floor (oY) + m_cx.top;
			y2 = Math.floor (oY) + m_cx.bottom;
			
			looking = true;
			
			while (looking) {
				c = x2/m_submapWidth;
				r = y1/m_submapHeight;
				i = (Math.floor ((y1 & m_submapHeightMask)/CX_TILE_HEIGHT) * m_cols) + Math.floor ((x2 & m_submapWidthMask)/CX_TILE_WIDTH);
				cx = m_XSubmaps[r][c].cmap[i];
				switch (cx) {
				// ([
					case CX_EMPTY:
						looking = false;
						break;
					case CX_SOLID:
						looking = false;
						break;
					case CX_SOFT:
						// function ():void {
							x2 = (x2 & CX_TILE_WIDTH_UNMASK) - 1;
						break; // },
					case CX_JUMP_THRU:
						looking = false;
						break;
			
					case CX_UL45:
						looking = false;
						break;
					case CX_UR45:
						looking = false;
						break;
					case CX_LL45:
						// function ():void {				
							var __y_LL45:Array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
							
							var x15:Number = x2 & CX_TILE_WIDTH_MASK;
							var y15:Number = y1 & CX_TILE_HEIGHT_MASK;

							if (x15 >= __y_LL45[y15]) {
								oX = ((x2 & CX_TILE_WIDTH_UNMASK) + __y_LL45[y15] - m_cx.right - 1);
							}
	
							looking = false;
						break; // },
					case CX_LR45:
						looking = false;
						break;
					
					case CX_UL225A:
						looking = false;
						break;
					case CX_UL225B:
						looking = false;
						break;
					case CX_UR225A:
						looking = false;
						break;
					case CX_UR225B:
						looking = false;
						break;
					case CX_LL225A:
						// function ():void {					
							var __y_LL225A:Array = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7];
							var __x_LL225A:Array = [0, 2, 4, 6, 8, 10, 12, 14, 0, 0, 0, 0, 0, 0, 0, 0];
							
							var x15:Number = x2 & CX_TILE_WIDTH_MASK;
							var y15:Number = y1 & CX_TILE_HEIGHT_MASK;
	
							if (y15 <= __y_LL225A[x15]) {		
								oX = ((x2 & CX_TILE_WIDTH_UNMASK) + __x_LL225A[y15] - m_cx.right - 1);
							}
	
							looking = false;
						break; // },
					case CX_LL225B:
						// function ():void {				
							var __y_LL225B:Array = [8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15];
							var __x_LL225B:Array = [-16, -14, -12, -10, -8, -6, -4, -2, 0, 2, 4, 6, 8, 10, 12, 14];
							
							var x15:Number = x2 & CX_TILE_WIDTH_MASK;
							var y15:Number = y1 & CX_TILE_HEIGHT_MASK;
	
							if (y15 <= __y_LL225B[x15]) {
								oX = ((x2 & CX_TILE_WIDTH_UNMASK) + __x_LL225B[y15] - m_cx.right - 1);
							}
	
							looking = false;
						break; // },
					case CX_LR225A:
						looking = false;
						break;
					case CX_LR225B:
						looking = false;
						break;
					
					case CX_UL675A:
						looking = false;
						break;
					case CX_UL675B:
						looking = false;
						break;
					case CX_UR675A:
						looking = false;
						break;
					case CX_UR675B:
						looking = false;
						break;
					case CX_LL675A:
						looking = false;
						break;
					case CX_LL675B:
						looking = false;
						break;
					case CX_LR675A:
						looking = false;
						break;
					case CX_LR675B:
						looking = false;
						break;
						
					case CX_SOFTLF:
						// function ():void {
							m_CX_Collide_Flag |= CX_COLLIDE_RT;
		
							oX = ((x2 & CX_TILE_WIDTH_UNMASK) - (m_cx.right) - 1);
			
							collided = true;
						break; // },
					case CX_SOFTRT:
						looking = false;
						break;
					case CX_SOFTUP:
						looking = false;
						break;
					case CX_SOFTDN:
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
	}
	
//------------------------------------------------------------------------------------------
}