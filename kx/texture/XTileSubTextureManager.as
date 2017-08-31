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
	import flash.display.BitmapData;
	import flash.geom.*;
	
	import kx.XApp;
	import kx.collections.*;
	import kx.task.*;
	import kx.texture.MaxRectPacker;
	import kx.type.*;
	import kx.world.sprite.*;
	import kx.xml.*;
	
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
	// this class takes one or more flash.display.MovieClip's and dynamically creates HaXe/OpenFl texture/atlases
	//------------------------------------------------------------------------------------------
	public class XTileSubTextureManager extends XSubTextureManager {
		protected var m_testers:Array; // <MaxRectPacker>
		protected var m_packers:Array; // <MaxRectPacker>
		protected var m_tilesets:Array; // <Tileset>
		
		protected var m_currentTester:MaxRectPacker;
		protected var m_currentPacker:MaxRectPacker;
		protected var m_currentBitmap:BitmapData;
		protected var m_currentIndex:int;
		
		//------------------------------------------------------------------------------------------
		public function XTileSubTextureManager (__XApp:XApp, __width:int=2048, __height:int=2048) {
			super (__XApp, __width, __height);
		}
		
		//------------------------------------------------------------------------------------------
		public override function reset ():void {
		}
		
		//------------------------------------------------------------------------------------------
		public override function start ():void {
			reset ();
			
			m_movieClips = new XDict ();  // <String, Array<Dynamic>>
			m_testers = new Array (); // <MaxRectPacker>
			m_packers = new Array (); // <MaxRectPacker>
			m_tilesets = new Array (); // <Tileset>
			
			__begin ();
		}
		 
		//------------------------------------------------------------------------------------------
		public override function finish ():void {
			__end ();
			
			m_movieClips.forEach (
				function (x:*):void {
					var __className:String = x as String;
					
					var __movieClipMetadata:Array /* <Dynamic> */ = m_movieClips.get (__className);
				}
			);	
		}
		
		//------------------------------------------------------------------------------------------
		public override function isDynamic ():Boolean {
			return false;	
		}
		
		//------------------------------------------------------------------------------------------
		public override function add (__className:String):void {
			var __class:Class /* <Dynamic> */ = m_XApp.getClass (__className);
			
			m_movieClips.set (__className, []);
			
			if (__class != null) {
				createTexture (__className, __class);
				
				m_XApp.unloadClass (__className);
			}
			else
			{
				m_queue.set (__className, 0);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function movieClipExists (__className:String):Boolean {
			if (m_movieClips.exists (__className)) {
				return true;
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
		protected function findFreeTexture (__movieClip:flash.display.MovieClip):int {
			var __scaleX:Number = 1.0;
			var __scaleY:Number = 1.0;
			var __padding:Number = 2.0;
			var __rect:Rectangle = null;
			var __realBounds:Rectangle = null;
			
			var __found:Boolean;
			
			var t:int;
			
			for (t=0; t < m_count; t++) {
				var __tester:MaxRectPacker = m_testers[t] as MaxRectPacker;
				var __packer:MaxRectPacker = m_packers[t] as MaxRectPacker;
				
				__tester.copyFrom(__packer.freeRectangles);
			
				__free = true;
				
				var i:int;
				
				for (i=0; i<__movieClip.totalFrames; i++) {
					__movieClip.gotoAndStop (i+1);
					
					__realBounds = __getRealBounds (__movieClip);
					
					__rect = __tester.quickInsert (
						(__realBounds.width * __scaleX) + __padding * 2, (__realBounds.height * __scaleY) + __padding * 2
					);
					
					if (__rect == null) {
						__free = false;
						
						break;
					}
				}
				
				if (__free) {
					return t;
					
					return;
				}
			}
			
			__end (); __begin ();
			
			return m_count;
		}
		
		//------------------------------------------------------------------------------------------
		public override function createTexture (__className:String, __class:Class /* <Dynamic> */):void {	
			var __movieClip:flash.display.MovieClip = XType.createInstance (__class);
			
			var __scaleX:Number = 1.0;
			var __scaleY:Number = 1.0;
			var __padding:Number = 2.0;
			var __rect:Rectangle = null;
			var __realBounds:Rectangle = null;

			var i:int;
			
			trace (": XTileSubTextureManager: totalFrames: ", __className, __movieClip.totalFrames);
			
			var __index = findFreeTexture (__movieClip);
			
			m_currentPacker = m_packers[__index] as MaxRectPacker;
			
			var __movieClipMetadata:Array /* <Dynamic> */ = new Array (); // <Dynamic>
			__movieClipMetadata.push(__index)
			__movieClipMetadata.push (null /* __realBounds */);
			
			for (i=0; i<__movieClip.totalFrames; i++) {
				__movieClip.gotoAndStop (i+1);
				
				trace (": getBounds: ", __className, __getRealBounds (__movieClip));
				
				__realBounds = __getRealBounds (__movieClip);
				
				__rect = m_currentPacker.quickInsert (
					(__realBounds.width * __scaleX) + __padding * 2, (__realBounds.height * __scaleY) + __padding * 2
				);
				
				__rect.x += __padding;
				__rect.y += __padding;
				__rect.width -= __padding * 2;
				__rect.height -= __padding * 2;
				
				trace (": rect: ", __rect);
				
				__movieClipMetadata.push (__rect);
			}
			
			m_movieClips.set (__className, __movieClipMetadata);
		}	
		
		//------------------------------------------------------------------------------------------
		protected override function __begin ():void {
			var __tester:MaxRectPacker = new MaxRectPacker (TEXTURE_WIDTH, TEXTURE_HEIGHT);			
			var __packer:MaxRectPacker = new MaxRectPacker (TEXTURE_WIDTH, TEXTURE_HEIGHT);

			m_testers[m_count] = __tester;
			m_packers[m_count] = __packer;
			
			m_count++;
			
			trace (": XTileSubTextureManager: count: ", m_count);
		}
		
		//------------------------------------------------------------------------------------------
		protected override function __end ():void {	
		}
		
	//------------------------------------------------------------------------------------------
	}
				
//------------------------------------------------------------------------------------------
}
