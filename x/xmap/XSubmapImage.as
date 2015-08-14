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
package x.xmap {

	import x.geom.*;
	import x.world.*;
	import x.world.sprite.*;
	
	import flash.geom.*;
	import flash.utils.*;
	
	// <HAXE>
	/* --
	import x.texture.starling.*;
	-- */
	// </HAXE>
	// <AS3>
	import starling.textures.*;
	// </AS3>
	
//------------------------------------------------------------------------------------------	
	public class XSubmapImage extends XImage {

//------------------------------------------------------------------------------------------
		public function XSubmapImage (__texture:RenderTexture) {
			super (__texture);
		}

//------------------------------------------------------------------------------------------
		public override function setup ():void {
			super.setup ();
		}
		
//------------------------------------------------------------------------------------------
		public override function cleanup ():void {	
			super.cleanup ();
		}

//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
