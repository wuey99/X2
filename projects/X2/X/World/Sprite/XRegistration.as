//------------------------------------------------------------------------------------------
package X.World.Sprite {

// X classes
	import X.Geom.*;
	
// flash classes
	import flash.geom.*;
		
//------------------------------------------------------------------------------------------	
	public interface XRegistration {
		
//------------------------------------------------------------------------------------------
		function globalToParent():Point;

//------------------------------------------------------------------------------------------
		function setRegistration(x:Number=0, y:Number=0):void;

//------------------------------------------------------------------------------------------
		function getRegistration():XPoint;
				
//------------------------------------------------------------------------------------------		
		function get x2():Number;

//------------------------------------------------------------------------------------------
		function set x2(value:Number):void;

//------------------------------------------------------------------------------------------
		function get y2():Number;

//------------------------------------------------------------------------------------------
		function set y2(value:Number):void;

//------------------------------------------------------------------------------------------
		function get scaleX2():Number;

//------------------------------------------------------------------------------------------
		function set scaleX2(value:Number):void;

//------------------------------------------------------------------------------------------
		function get scaleY2():Number;

//------------------------------------------------------------------------------------------
		function set scaleY2(value:Number):void;

//------------------------------------------------------------------------------------------
		function get rotation2():Number;

//------------------------------------------------------------------------------------------
		function set rotation2(value:Number):void;

//------------------------------------------------------------------------------------------
		function get mouseX2():Number;

//------------------------------------------------------------------------------------------
		function get mouseY2():Number;

//------------------------------------------------------------------------------------------
		function setProperty2(prop:String, n:Number):void;	
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
