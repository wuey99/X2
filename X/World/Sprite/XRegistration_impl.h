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
		