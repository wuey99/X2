//------------------------------------------------------------------------------------------
// <$license$/>
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
		