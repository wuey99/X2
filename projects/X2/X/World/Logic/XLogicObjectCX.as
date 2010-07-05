//------------------------------------------------------------------------------------------
package X.World.Logic {

	import X.Task.*;
	import X.World.*;
	import X.World.Sprite.*;
	import X.XMap.*;
	
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------
	public class XLogicObjectCX extends XLogicObject {
		private var m_vel:Point;
		private var m_oldPos:Point;
		
		protected var m_cx:Rectangle;
		protected var m_namedCX:Dictionary;
		
		public static var CELLSWIDE:Number = 80;
		public static var CELLSHIGH:Number = 60;
		
		protected var m_cmap:Array;
		
		private var m_CX_Collide_Flag:Number;
		
		public static var CELLSIZE:Number = 16;
		public static var CELLMASK:Number = 0xfffffff0;
	
		public static var CX_COLLIDE_LF:Number = 0x0001;
		public static var CX_COLLIDE_RT:Number = 0x0002;
		public static var CX_COLLIDE_HORZ:Number = (CX_COLLIDE_LF+CX_COLLIDE_RT) 
		public static var CX_COLLIDE_UP:Number = 0x0004;
		public static var CX_COLLIDE_DN:Number = 0x0008;
		public static var CX_COLLIDE_VERT:Number = (CX_COLLIDE_UP+CX_COLLIDE_DN)
		
//------------------------------------------------------------------------------------------
		public function XLogicObjectCX () {
			super ();
		}
		
//------------------------------------------------------------------------------------------
		public override function init (__xxx:XWorld, ...args):void {
			super.init (__xxx, args);
		}

//------------------------------------------------------------------------------------------
		public override function initX ():void {
			setVel (new Point (0, 0));
			setOld (new Point (0, 0));
			
			m_cx = new Rectangle (0, 0, 0, 0);
			m_namedCX = new Dictionary ();
		}

//------------------------------------------------------------------------------------------
		public function setCX (
			__x1:Number,
			__x2:Number,
			__y1:Number,
			__y2:Number
			):void {
				
			m_cx = new Rectangle (__x1, __y1, __x2-__x1+1, __y2-__y1+1);
		}

//------------------------------------------------------------------------------------------
		public function setNamedCX (
			__name:String,
			__x1:Number,
			__x2:Number,
			__y1:Number,
			__y2:Number
			):void {
				
			m_namedCX[__name] = new Rectangle (__x1, __y1, __x2-__x1+1, __y2-__y1+1);
		}

//------------------------------------------------------------------------------------------
		public function getNamedCX (__name:String):Rectangle {
			return m_namedCX[__name].clone ();
		}
		
//------------------------------------------------------------------------------------------
		public function getAdjustedNamedCX (__name:String):Rectangle {
			var __rect:Rectangle = m_namedCX[__name].clone ();	
			__rect.offset (oX, oY);
			return __rect;
		}
		
//------------------------------------------------------------------------------------------
		public function setVel (__vel:Point):void {
			m_vel = __vel;
		}
		
		public function set oDX (__value:Number):void {
			var __vel:Point = getVel ();
			__vel.x = __value;
			setVel (__vel);
		}

		public function set oDY (__value:Number):void {
			var __vel:Point = getVel ();
			__vel.y = __value;
			setVel (__vel);
		}
		
//------------------------------------------------------------------------------------------
		public function getVel ():Point {
			return m_vel;
		}
		
		public function get oDX ():Number {
			return getVel ().x
		}

		public function get oDY ():Number {
			return getVel ().y
		}
		
//------------------------------------------------------------------------------------------
		public function setOld (__pos:Point):void {
			m_oldPos = __pos;
		}
		
		public function set oldX (__value:Number):void {
			var __pos:Point = getOld ();
			__pos.x = __value;
			setOld (__pos);
		}

		public function set oldY (__value:Number):void {
			var __pos:Point = getOld ();
			__pos.y = __value;
			setOld (__pos);
		}
		
//------------------------------------------------------------------------------------------
		public function getOld ():Point {
			return m_oldPos;
		}
		
		public function get oldX ():Number {
			return getOld ().x
		}

		public function get oldY ():Number {
			return getOld ().y
		}

//------------------------------------------------------------------------------------------
		public function collidesWithNamedCX (__name:String, __rectDst:Rectangle):Boolean {
			var __rectSrc:Rectangle = getAdjustedNamedCX (__name);
			
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
			
			x1 = Math.floor (oX) + m_cx.left;
			x2 = Math.floor (oX) + m_cx.right;
			y1 = Math.floor (oY) + m_cx.top;
			y2 = Math.floor (oY) + m_cx.bottom;
						
			y1 &= CELLMASK;
			
			for (__x = (x1 & CELLMASK); __x <= (x2 & CELLMASK); __x += CELLSIZE) {
				i = (Math.floor (y1/CELLSIZE) * CELLSWIDE) + Math.floor (__x/CELLSIZE);
				
				if (m_cmap[i] == 1) {
					m_CX_Collide_Flag |= CX_COLLIDE_UP;
		
					oY = (y1 + CELLSIZE - m_cx.top);
		
					return true;
				}
			}
			
			return false;
		}
		
//------------------------------------------------------------------------------------------
		public function Ck_Collide_DN ():Boolean {
			var x1:Number, y1:Number, x2:Number, y2:Number;
			var i:Number, __x:Number, __y:Number;
			
			x1 = Math.floor (oX) + m_cx.left;
			x2 = Math.floor (oX) + m_cx.right;
			y1 = Math.floor (oY) + m_cx.top;
			y2 = Math.floor (oY) + m_cx.bottom;
						
			y2 &= CELLMASK;
			
			for (__x = (x1 & CELLMASK); __x <= (x2 & CELLMASK); __x += CELLSIZE) {
				i = (Math.floor (y2/CELLSIZE) * CELLSWIDE) + Math.floor (__x/CELLSIZE);
				
				if (m_cmap[i] == 1) {
					m_CX_Collide_Flag |= CX_COLLIDE_DN;
		
					oY = (y2 - m_cx.bottom - 1);
		
					return true;
				}
			}
			
			return false;
		}
	
//------------------------------------------------------------------------------------------
		public function Ck_Collide_LF ():Boolean {
			var x1:Number, y1:Number, x2:Number, y2:Number;
			var i:Number, __x:Number, __y:Number;
			
			x1 = Math.floor (oX) + m_cx.left;
			x2 = Math.floor (oX) + m_cx.right;
			y1 = Math.floor (oY) + m_cx.top;
			y2 = Math.floor (oY) + m_cx.bottom;
	
			x1 &= CELLMASK;
			
			for (__y = (y1 & CELLMASK); __y <= (y2 & CELLMASK); __y += CELLSIZE) {
				i = (Math.floor (__y/CELLSIZE) * CELLSWIDE) + Math.floor (x1/CELLSIZE);
				
				if (m_cmap[i] == 1) {
					m_CX_Collide_Flag |= CX_COLLIDE_LF;
		
					oX = (x1 + CELLSIZE - m_cx.left);
		
					return true;
				}
			}
			
			return false;
		}
		
//------------------------------------------------------------------------------------------
		public function Ck_Collide_RT ():Boolean {
			var x1:Number, y1:Number, x2:Number, y2:Number;
			var i:Number, __x:Number, __y:Number;
			
			x1 = Math.floor (oX) + m_cx.left;
			x2 = Math.floor (oX) + m_cx.right;
			y1 = Math.floor (oY) + m_cx.top;
			y2 = Math.floor (oY) + m_cx.bottom;
						
			x2 &= CELLMASK;
			
			for (__y = (y1 & CELLMASK); __y <= (y2 & CELLMASK); __y += CELLSIZE) {
				i = (Math.floor (__y/CELLSIZE) * CELLSWIDE) + Math.floor (x2/CELLSIZE);
				
				if (m_cmap[i] == 1) {
					m_CX_Collide_Flag |= CX_COLLIDE_RT;
		
					oX = (x2 - m_cx.right - 1);
		
					return true;
				}
			}
			
			return false;
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
