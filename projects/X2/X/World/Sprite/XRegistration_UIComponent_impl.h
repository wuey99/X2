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
		public var rp:XPoint;
		
//------------------------------------------------------------------------------------------
		public function globalToParent():XPoint {
			return parent.globalToLocal (localToGlobal (rp));
		}

//------------------------------------------------------------------------------------------
		public function setRegistration(x:Number=0, y:Number=0):void {
			rp = new XPoint(x, y);
		}

//------------------------------------------------------------------------------------------
		public function getRegistration():XPoint {
			return rp;
		}
				
//------------------------------------------------------------------------------------------		
		public function get x2():Number {
			var p:XPoint = globalToParent ();
			
			return p.x;
		}

//------------------------------------------------------------------------------------------
		public function set x2(value:Number):void {
			var p:XPoint = globalToParent ();
			
			this.x += value - p.x;
		}

//------------------------------------------------------------------------------------------
		public function get y2():Number {
			var p:XPoint = globalToParent ();
			
			return p.y;
		}

//------------------------------------------------------------------------------------------
		public function set y2(value:Number):void {
			var p:XPoint = globalToParent ();
			
			this.y += value - p.y;
		}

//------------------------------------------------------------------------------------------
		public function get scaleX2():Number {
			return this.scaleX;
		}

//------------------------------------------------------------------------------------------
		public function set scaleX2(value:Number):void {
			var a:XPoint = globalToParent ();			
			this.scaleX = value;
			this.validateNow (); 			
			var b:XPoint = globalToParent ();
			x -= b.x - a.x;
		}

//------------------------------------------------------------------------------------------
		public function get scaleY2():Number {
			return this.scaleY;
		}

//------------------------------------------------------------------------------------------
		public function set scaleY2(value:Number):void {
			var a:XPoint = globalToParent ();	
			this.scaleY = value;
			this.validateNow ();
			var b:XPoint = globalToParent ();	
			y -= b.y - a.y;
		}

//------------------------------------------------------------------------------------------
		public function get rotation2():Number {
			return this.rotation;
		}

//------------------------------------------------------------------------------------------
		public function set rotation2(value:Number):void {
			var a:XPoint = globalToParent ();
			this.rotation = value;
			this.validateNow ();
			var b:XPoint = globalToParent ();
			x -= b.x - a.x;
			y -= b.y - a.y;
		}

//------------------------------------------------------------------------------------------
		public function get mouseX2():Number {
			return Math.round(this.mouseX - rp.x);
		}

//------------------------------------------------------------------------------------------
		public function get mouseY2():Number {
			return Math.round(this.mouseY - rp.y);
		}

//------------------------------------------------------------------------------------------
		public function setProperty2(prop:String, n:Number):void {	
		}
		