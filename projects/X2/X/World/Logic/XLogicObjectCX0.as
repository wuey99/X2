//------------------------------------------------------------------------------------------
// <$license$/>
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
	public class XLogicObjectCX0 extends XLogicObject {
		private var m_vel:XPoint;
		private var m_oldPos:XPoint;
		
		protected var m_cx:XRect;
		protected var m_namedCX:XDict;
		
		public static var CELLSWIDE:Number = 80;
		public static var CELLSHIGH:Number = 60;
		
		protected var m_cmap:Array;
		
		private var m_CX_Collide_Flag:Number;
		
		public static var CELLSIZE:Number = 16;
		public static var CELLMASK:Number = 0xfffffff0;
	
		public static var CX_COLLIDE_LF:Number = 0x0001;
		public static var CX_COLLIDE_RT:Number = 0x0002;
		public static var CX_COLLIDE_HORZ:Number = (CX_COLLIDE_LF+CX_COLLIDE_RT); 
		public static var CX_COLLIDE_UP:Number = 0x0004;
		public static var CX_COLLIDE_DN:Number = 0x0008;
		public static var CX_COLLIDE_VERT:Number = (CX_COLLIDE_UP+CX_COLLIDE_DN);
		
//------------------------------------------------------------------------------------------
		public function XLogicObjectCX0 () {
			super ();
		}
		
//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
		}
		
//------------------------------------------------------------------------------------------
		public override function setupX ():void {
			setVel (new XPoint (0, 0));
			setOld (new XPoint (0, 0));
			
			m_cx = new XRect (0, 0, 0, 0);
			m_namedCX = new XDict ();
		}

//------------------------------------------------------------------------------------------
		public function setCX (
			__x1:Number,
			__x2:Number,
			__y1:Number,
			__y2:Number
			):void {
				
			m_cx = new XRect (__x1, __y1, __x2-__x1+1, __y2-__y1+1);
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
		public override function updatePhysics ():void {
			m_CX_Collide_Flag = 0;

//------------------------------------------------------------------------------------------			
			oX += oDX;
			
//			if (Math.floor (oX) != Math.floor (oldX)) {
			{
				if (oDX < 0) {
					Ck_Collide_LF ();
				}
				else
				{
					Ck_Collide_RT ();
				}
			}
			
//------------------------------------------------------------------------------------------
			oY += oDY;
			
//			if (Math.floor (oY) != Math.floor (oldY)) {
			{
				if (oDY < 0) {
					Ck_Collide_UP ();
				}
				else
				{
					Ck_Collide_DN ();
				}
			}
		}

//------------------------------------------------------------------------------------------
		public function Ck_Collide_UP ():Boolean {
			var x1:Number, y1:Number, x2:Number, y2:Number;
			var i:Number, __x:Number, __y:Number;
			var collided:Boolean;
			
			x1 = Math.floor (oX) + m_cx.left;
			x2 = Math.floor (oX) + m_cx.right;
			y1 = Math.floor (oY) + m_cx.top;
			y2 = Math.floor (oY) + m_cx.bottom;
						
			y1 &= CELLMASK;
			
			collided = false;
			
			for (__x = (x1 & CELLMASK); __x <= (x2 & CELLMASK); __x += CELLSIZE) {
				i = (Math.floor (y1/CELLSIZE) * CELLSWIDE) + Math.floor (__x/CELLSIZE);
				var cx:Number = m_cmap[i];
				if (cx >=0 && cx < XSubmapModel.CX_MAX)
				([
					// CX_EMPTY:
						nothing,
					// CX_SOLID:
						function ():void {
							m_CX_Collide_Flag |= CX_COLLIDE_UP;
				
							oY = (y1 + CELLSIZE - m_cx.top);
			
							collided = true;
						},
					// CX_SOFT:
						nothing,
					// CX_JUMP_THRU:
						nothing,
						
					// CX_UL45:
						nothing,
					// CX_UR45:
						nothing,
					// CX_LL45:
						nothing,
					// CX_LR45:
						nothing,
					
					// CX_UL225A:
						nothing,
					// CX_UL225B:
						nothing,
					// CX_UR225A:
						nothing,
					// CX_UR225B:
						nothing,
					// CX_LL225A:
						nothing,
					// CX_LL225B:
						nothing,
					// CX_LR225A:
						nothing,
					// CX_LR225B:
						nothing,
					
					// CX_UL675A:
						nothing,
					// CX_UL675B:
						nothing,
					// CX_UR675A:
						nothing,
					// CX_UR675B:
						nothing,
					// CX_LL675A:
						nothing,
					// CX_LL675B:
						nothing,
					// CX_LR675A:
						nothing,
					// CX_LR675B:
						nothing
				])[cx] ();
				
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
			
			x1 = Math.floor (oX) + m_cx.left;
			x2 = Math.floor (oX) + m_cx.right;
			y1 = Math.floor (oY) + m_cx.top;
			y2 = Math.floor (oY) + m_cx.bottom;
						
			y2 &= CELLMASK;
			
			collided = false;
			
			for (__x = (x1 & CELLMASK); __x <= (x2 & CELLMASK); __x += CELLSIZE) {
				i = (Math.floor (y2/CELLSIZE) * CELLSWIDE) + Math.floor (__x/CELLSIZE);
				var cx:Number = m_cmap[i];
				if (cx >=0 && cx < XSubmapModel.CX_MAX)
				([
					// CX_EMPTY:
						nothing,
					// CX_SOLID:
						function ():void {
							m_CX_Collide_Flag |= CX_COLLIDE_DN;
				
							oY = (y2 - m_cx.bottom - 1);
				
							collided = true;
						},
					// CX_SOFT:
						nothing,
					// CX_JUMP_THRU:
						nothing,
						
					// CX_UL45:
						nothing,
					// CX_UR45:
						nothing,
					// CX_LL45:
						nothing,
					// CX_LR45:
						nothing,
					
					// CX_UL225A:
						nothing,
					// CX_UL225B:
						nothing,
					// CX_UR225A:
						nothing,
					// CX_UR225B:
						nothing,
					// CX_LL225A:
						nothing,
					// CX_LL225B:
						nothing,
					// CX_LR225A:
						nothing,
					// CX_LR225B:
						nothing,
					
					// CX_UL675A:
						nothing,
					// CX_UL675B:
						nothing,
					// CX_UR675A:
						nothing,
					// CX_UR675B:
						nothing,
					// CX_LL675A:
						nothing,
					// CX_LL675B:
						nothing,
					// CX_LR675A:
						nothing,
					// CX_LR675B:
						nothing
				])[cx] ();
				
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
			
			x1 = Math.floor (oX) + m_cx.left;
			x2 = Math.floor (oX) + m_cx.right;
			y1 = Math.floor (oY) + m_cx.top;
			y2 = Math.floor (oY) + m_cx.bottom;
	
			x1 &= CELLMASK;
			
			collided = false;
			
			for (__y = (y1 & CELLMASK); __y <= (y2 & CELLMASK); __y += CELLSIZE) {
				i = (Math.floor (__y/CELLSIZE) * CELLSWIDE) + Math.floor (x1/CELLSIZE);
				var cx:Number = m_cmap[i];
				if (cx >=0 && cx < XSubmapModel.CX_MAX)
				([
					// CX_EMPTY:
						nothing,
					// CX_SOLID:
							function ():void {
								m_CX_Collide_Flag |= CX_COLLIDE_LF;
			
								oX = (x1 + CELLSIZE - m_cx.left);
				
								collided = true;
							},
					// CX_SOFT:
						nothing,
					// CX_JUMP_THRU:
						nothing,
						
					// CX_UL45:
						nothing,
					// CX_UR45:
						nothing,
					// CX_LL45:
						nothing,
					// CX_LR45:
						nothing,
					
					// CX_UL225A:
						nothing,
					// CX_UL225B:
						nothing,
					// CX_UR225A:
						nothing,
					// CX_UR225B:
						nothing,
					// CX_LL225A:
						nothing,
					// CX_LL225B:
						nothing,
					// CX_LR225A:
						nothing,
					// CX_LR225B:
						nothing,
					
					// CX_UL675A:
						nothing,
					// CX_UL675B:
						nothing,
					// CX_UR675A:
						nothing,
					// CX_UR675B:
						nothing,
					// CX_LL675A:
						nothing,
					// CX_LL675B:
						nothing,
					// CX_LR675A:
						nothing,
					// CX_LR675B:
						nothing
				])[cx] ();
				
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
			
			x1 = Math.floor (oX) + m_cx.left;
			x2 = Math.floor (oX) + m_cx.right;
			y1 = Math.floor (oY) + m_cx.top;
			y2 = Math.floor (oY) + m_cx.bottom;
						
			x2 &= CELLMASK;
			
			collided = false;
			
			for (__y = (y1 & CELLMASK); __y <= (y2 & CELLMASK); __y += CELLSIZE) {
				i = (Math.floor (__y/CELLSIZE) * CELLSWIDE) + Math.floor (x2/CELLSIZE);
				var cx:Number = m_cmap[i];
				if (cx >=0 && cx < XSubmapModel.CX_MAX)
				([
					// CX_EMPTY:
						nothing,
					// CX_SOLID:
						function ():void {
							m_CX_Collide_Flag |= CX_COLLIDE_RT;
		
							oX = (x2 - m_cx.right - 1);
			
							collided = true;
						},
					// CX_SOFT:
						nothing,
					// CX_JUMP_THRU:
						nothing,
						
					// CX_UL45:
						nothing,
					// CX_UR45:
						nothing,
					// CX_LL45:
						nothing,
					// CX_LR45:
						nothing,
					
					// CX_UL225A:
						nothing,
					// CX_UL225B:
						nothing,
					// CX_UR225A:
						nothing,
					// CX_UR225B:
						nothing,
					// CX_LL225A:
						nothing,
					// CX_LL225B:
						nothing,
					// CX_LR225A:
						nothing,
					// CX_LR225B:
						nothing,
					
					// CX_UL675A:
						nothing,
					// CX_UL675B:
						nothing,
					// CX_UR675A:
						nothing,
					// CX_UR675B:
						nothing,
					// CX_LL675A:
						nothing,
					// CX_LL675B:
						nothing,
					// CX_LR675A:
						nothing,
					// CX_LR675B:
						nothing
				])[cx] ();
				
				if (collided) {
					return true;
				}
			}
			
			return false;
		}

//------------------------------------------------------------------------------------------
		public function nothing ():void {
		}
			
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
