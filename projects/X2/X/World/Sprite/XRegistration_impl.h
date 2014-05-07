//------------------------------------------------------------------------------------------
// <$begin$/>
// Copyright (C) 2014 Jimmy Huey
//
// Some Rights Reserved.
//
// The "X-Engine" is licensed under a Creative Commons
// Attribution-NonCommerical-ShareAlike 3.0 Unported License.
// (CC BY-NC-SA 3.0)
//
// You are free to:
//
//      SHARE - to copy, distribute, display and perform the work.
//      ADAPT - remix, transform build upon this material.
//
//      The licensor cannot revoke these freedoms as long as you follow the license terms.
//
// Under the following terms:
//
//      ATTRIBUTION -
//          You must give appropriate credit, provide a link to the license, and
//          indicate if changes were made.  You may do so in any reasonable manner,
//          but not in any way that suggests the licensor endorses you or your use.
//
//      SHAREALIKE -
//          If you remix, transform, or build upon the material, you must
//          distribute your contributions under the same license as the original.
//
//      NONCOMMERICIAL -
//          You may not use the material for commercial purposes.
//
// No additional restrictions - You may not apply legal terms or technological measures
// that legally restrict others from doing anything the license permits.
//
// The full summary can be located at:
// http://creativecommons.org/licenses/by-nc-sa/3.0/
//
// The human-readable summary of the Legal Code can be located at:
// http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode
//
// The "X-Engine" is free for non-commerical use.
// For commercial use, you will need to provide proper credits.
// Please contact me @ wuey99[dot]gmail[dot]com for more details.
// <$end$/>
//------------------------------------------------------------------------------------------
import X.Geom.XPoint;

//------------------------------------------------------------------------------------------
		public function globalToParent():Point {
// unused
			return null;
		}

//------------------------------------------------------------------------------------------
		public function setRegistration(x:Number=0, y:Number=0):void {
			rp.x = x;
			rp.y = y;
		}

//------------------------------------------------------------------------------------------
		public function getRegistration():XPoint {
			return rp;
		}
				
//------------------------------------------------------------------------------------------		
		[Inline]
		public function get x2():Number {
			var p:Point = parent.globalToLocal (localToGlobal (rp));
			
			return p.x;
		}

//------------------------------------------------------------------------------------------
		[Inline]
		public function set x2(value:Number):void {
			var p:Point = parent.globalToLocal (localToGlobal (rp));
			
			this.x += value - p.x;
		}

//------------------------------------------------------------------------------------------
		[Inline]
		public function get y2():Number {
			var p:Point = parent.globalToLocal (localToGlobal (rp));
			
			return p.y;
		}

//------------------------------------------------------------------------------------------
		[Inline]
		public function set y2(value:Number):void {
			var p:Point = parent.globalToLocal (localToGlobal (rp));
			
			this.y += value - p.y;
		}

//------------------------------------------------------------------------------------------
		[Inline]
		public function get scaleX2():Number {
			return this.scaleX;
		}

//------------------------------------------------------------------------------------------
		[Inline]
		public function set scaleX2(value:Number):void {
			var a:Point = parent.globalToLocal (localToGlobal (rp));
			
			this.scaleX = value;

			var b:Point = parent.globalToLocal (localToGlobal (rp));

			this.x -= b.x - a.x;
			this.y -= b.y - a.y;
		}

//------------------------------------------------------------------------------------------
		[Inline]
		public function get scaleY2():Number {
			return this.scaleY;
		}

//------------------------------------------------------------------------------------------
		[Inline]
		public function set scaleY2(value:Number):void {
			var a:Point = parent.globalToLocal (localToGlobal (rp));
			
			this.scaleY = value;

			var b:Point = parent.globalToLocal (localToGlobal (rp));

			this.x -= b.x - a.x;
			this.y -= b.y - a.y;
		}

//------------------------------------------------------------------------------------------
		[Inline]
		public function get rotation2():Number {
			return this.rotation;
		}

//------------------------------------------------------------------------------------------
		[Inline]
		public function set rotation2(value:Number):void {
			var a:Point = parent.globalToLocal (localToGlobal (rp));
			
			this.rotation = value;

			var b:Point = parent.globalToLocal (localToGlobal (rp));

			this.x -= b.x - a.x;
			this.y -= b.y - a.y;
		}

//------------------------------------------------------------------------------------------
		public function get mouseX2():Number {
			return Math.round (this.mouseX - rp.x);
		}

//------------------------------------------------------------------------------------------
		public function get mouseY2():Number {
			return Math.round (this.mouseY - rp.y);
		}

//------------------------------------------------------------------------------------------
		public function setProperty2(prop:String, n:Number):void {			
// unused
		}
		