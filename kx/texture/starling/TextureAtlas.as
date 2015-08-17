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
package kx.texture.starling {
	
	import kx.xml.*;
	
	import flash.display.*;
	import flash.geom.*;
	
	//------------------------------------------------------------------------------------------
	public class TextureAtlas extends Object {
		
		//------------------------------------------------------------------------------------------
		public function TextureAtlas (texture:Texture, atlasXML:XML = null):void {
		}

		//------------------------------------------------------------------------------------------
		public function dispose ():void {	
		}
		
		//------------------------------------------------------------------------------------------
		public function addRegion (name:String, region:Rectangle, frame:Rectangle = null, rotated:Boolean = false):void {	
		}
		
		//------------------------------------------------------------------------------------------
		public function getTexture(name:String):Texture {
			return null;
		}
		
		//------------------------------------------------------------------------------------------
		public function getTextures (prefix:String, result:Vector.<Texture> = null):Vector.<Texture> {
			return null;
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}