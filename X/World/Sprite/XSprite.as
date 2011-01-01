//------------------------------------------------------------------------------------------
package X.World.Sprite {

// X classes
	import X.Geom.*;
	import X.World.*;
	
// flash classes
	import flash.display.Sprite;
	import flash.geom.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------	
	public class XSprite extends XSprite0 implements XRegistration {
		public var m_scale:Number;
		public var m_visible:Boolean;

//------------------------------------------------------------------------------------------
		include "..\\Sprite\\XRegistration_impl.as";
				
//------------------------------------------------------------------------------------------
		public function XSprite () {
			super ();
			
			setRegistration ();
			
			m_scale = 1.0;
			m_visible = true;
		}

//------------------------------------------------------------------------------------------
		public function globalToLocalXPoint (__p:XPoint):XPoint {
			var __x:Point = globalToLocal (__p.getPoint ());
			
			return new XPoint (__x.x, __x.y);
		}
		
//------------------------------------------------------------------------------------------
		public function viewPort (__canvasWidth:Number, __canvasHeight:Number):XRect {
			return new XRect (-x/m_scale, -y/m_scale, __canvasWidth/m_scale, __canvasHeight/m_scale);
		}
		
//------------------------------------------------------------------------------------------
		public function getPos ():XPoint {
			return new XPoint (x2, y2);
		}

//------------------------------------------------------------------------------------------		
		public function setPos (__p:XPoint):void {
			x2 = __p.x;
			y2 = __p.y;
		}

//------------------------------------------------------------------------------------------
		public function setScale (__scale:Number):void {
			m_scale = __scale;
			
			scaleX2 = __scale;
			scaleY2 = __scale;
		}
		
//------------------------------------------------------------------------------------------
		public function getScale ():Number {
			return m_scale;
		}

//------------------------------------------------------------------------------------------	
		public function set visible2 (__visible:Boolean):void {
			m_visible = __visible;
		}

//------------------------------------------------------------------------------------------			
		public function get visible2 ():Boolean {
			return m_visible;
		}

//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
