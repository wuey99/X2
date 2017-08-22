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
package kx.texture {
	
	// X classes
	import kx.collections.*;
	import kx.task.*;
	import kx.world.sprite.*;
	import kx.XApp;
	import kx.texture.*;
	
	import flash.display.BitmapData;
	import flash.geom.*;
	
	// <HAXE>
	/* --
	import kx.texture.starling.*;
	import openfl.display.*;
	-- */
	// </HAXE>
	// <AS3>
	import starling.display.*;
	import starling.textures.*;
	// </AS3>
	
	//------------------------------------------------------------------------------------------
	// this class takes one or more flash.display.MovieClip's and dynamically creates texture/atlases
	//------------------------------------------------------------------------------------------
	public class XStarlingSubTextureManager extends XSubTextureManager {
		protected var m_atlases:Array; // <TextureAtlas>
		protected var m_currentAtlas:TextureAtlas;
		
		//------------------------------------------------------------------------------------------
		public function XStarlingSubTextureManager (__XApp:XApp, __width:int=2048, __height:int=2048) {
			super (__XApp, __width, __height);
		}
		
		//------------------------------------------------------------------------------------------
		public override function movieClipExists (__className:String):Boolean {
			if (m_movieClips.exists (__className)) {
				var __movieClipMetadata:Array /* <Dynamic> */ = m_movieClips.get (__className);
				
				if (__movieClipMetadata.length == 0) {
					return false;
				}		
				else
				{
					return true;
				}
			}
			else
			{
				return false;
			}
		}

		//------------------------------------------------------------------------------------------
		public override function createMovieClip (__className:String):* /* <Dynamic> */ {
			if (!isQueued (__className)) {
				return null;
			}
			
			var __movieClipMetadata:Array /* <Dynamic> */ = m_movieClips.get (__className);
			
			if (__movieClipMetadata.length == 0) {
				return null;
			}
			
			var __rect:Rectangle = __movieClipMetadata[0] as Rectangle;
			var __pivotX:Number = __rect.x; 
			var __pivotY:Number = __rect.y;
			
			var __textures:Vector.<Texture> = new Vector.<Texture> ();
			var __atlas:TextureAtlas;
			
			for (var i:int=1; i<=__movieClipMetadata.length-1; i++) {
				__atlas = __movieClipMetadata[i] as TextureAtlas;
				 
				__textures = __textures.concat (__atlas.getTextures (__className));
			}

			// <HAXE>
			/* --
			var __movieClip:MovieClip = new MovieClip ();
			-- */
			// </HAXE>
			// <AS3>
			var __movieClip:MovieClip = new MovieClip (__textures);
			__movieClip.pivotX = -__rect.x;
			__movieClip.pivotY = -__rect.y;
			// </AS3>
			
			return __movieClip;
		}
		
	//------------------------------------------------------------------------------------------
	}
				
//------------------------------------------------------------------------------------------
}
