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
package kx.world.sprite {

// X classes
	import kx.geom.*;
	
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
	
// <HAXE>
/* --
		//------------------------------------------------------------------------------------------		
		function get_x2():Number;
		
		//------------------------------------------------------------------------------------------
		function set_x2(value:Number):Number;
		
		//------------------------------------------------------------------------------------------
		function get_y2():Number;
		
		//------------------------------------------------------------------------------------------
		function set_y2(value:Number):Number;
		
		//------------------------------------------------------------------------------------------
		function get_scaleX2():Number;
		
		//------------------------------------------------------------------------------------------
		function set_scaleX2(value:Number):Number;
		
		//------------------------------------------------------------------------------------------
		function get_scaleY2():Number;
		
		//------------------------------------------------------------------------------------------
		function set_scaleY2(value:Number):Number;
		
		//------------------------------------------------------------------------------------------
		function get_rotation2():Number;
		
		//------------------------------------------------------------------------------------------
		function set_rotation2(value:Number):Number;
		
		//------------------------------------------------------------------------------------------
		function get_mouseX2():Number;
		
		//------------------------------------------------------------------------------------------
		function get_mouseY2():Number;
		
-- */
// </HAXE>
// <AS3>
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
// </AS3>
		
//------------------------------------------------------------------------------------------
		function setProperty2(prop:String, n:Number):void;	
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}