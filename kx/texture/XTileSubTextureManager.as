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
	
	// flash classes
	import flash.display.*;
	import flash.geom.*;
	
	import kx.XApp;
	import kx.collections.*;
	import kx.task.*;
	import kx.texture.MaxRectPacker;
	import kx.texture.MovieClipMetadata;
	import kx.type.*;
	import kx.world.sprite.*;
	import kx.xml.*;

	// <HAXE>
	/* --
	-- */
	// </HAXE>
	// <AS3>
	import kx.texture.openfl.*;
	// </AS3>
	
	//------------------------------------------------------------------------------------------
	// this class takes one or more flash.display.MovieClip's and dynamically creates HaXe/OpenFl texture/atlases
	//------------------------------------------------------------------------------------------
	public class XTileSubTextureManager extends XSubTextureManager {
		protected var m_movieClips:XDict; // <String, MovieClipMetadata>
		
		protected var m_testers:Array; // <MaxRectPacker>
		protected var m_packers:Array; // <MaxRectPacker>
		protected var m_tilesets:Array; // <Tileset>
		
		protected var m_currentTester:MaxRectPacker;
		protected var m_currentPacker:MaxRectPacker;
		protected var m_currentBitmap:BitmapData;
		protected var m_currentBitmapIndex:int;
		
		protected var wrapFlag:Boolean;
		
		//------------------------------------------------------------------------------------------
		public function XTileSubTextureManager (__XApp:XApp, __width:int=2048, __height:int=2048) {
			super (__XApp, __width, __height);
			
			wrapFlag = false;
		}
		
		//------------------------------------------------------------------------------------------
		public override function reset ():void {
		}
		
		//------------------------------------------------------------------------------------------
		public override function start ():void {
			reset ();
			
			m_movieClips = new XDict ();  // <String, MovieClipMetadata>
			m_testers = new Array (); // <MaxRectPacker>
			m_packers = new Array (); // <MaxRectPacker>
			m_tilesets = new Array (); // <Tileset>
			
			__begin ();
		}
		 
		//------------------------------------------------------------------------------------------
		public override function finish ():void {
			if (!wrapFlag) {
				__finishFit ();
			}
			else
			{
				__finishWrap ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		private function __finishFit ():void {
			__end ();
			
			var i:int;
			
			var __scaleX:Number = 1.0;
			var __scaleY:Number = 1.0;
			var __padding:Number = 2.0;
			var __rect:Rectangle = null;
			var __realBounds:Rectangle;
			
			var __index:int;
			var __movieClip:flash.display.MovieClip;
			
			//------------------------------------------------------------------------------------------
			for (m_currentBitmapIndex = 0; m_currentBitmapIndex < m_count; m_currentBitmapIndex++) {
				__rect = new Rectangle (0, 0, TEXTURE_WIDTH, TEXTURE_HEIGHT);
				m_currentBitmap = new BitmapData (TEXTURE_WIDTH, TEXTURE_HEIGHT);
				m_currentBitmap.fillRect (__rect, 0x00000000);
				
				//------------------------------------------------------------------------------------------
				m_movieClips.forEach (
					function (x:*):void {
						var __className:String = x as String;
						
						var __movieClipMetadata:MovieClipMetadata = m_movieClips.get (__className);
						
						__index = __movieClipMetadata.getMasterTilesetIndex ();
						__movieClip = __movieClipMetadata.getMovieClip ();
						__realBounds = __movieClipMetadata.getRealBounds ();
						
						if (__index == m_currentBitmapIndex) {
							for (i=0; i<__movieClip.totalFrames; i++) {
								__movieClip.gotoAndStop (i+1);
								__rect = __movieClipMetadata.getRect (i);
								var __matrix:Matrix = new Matrix ();
								__matrix.scale (__scaleX, __scaleY);
								__matrix.translate (__rect.x - __realBounds.x, __rect.y - __realBounds.y);
								m_currentBitmap.draw (__movieClip, __matrix);
							}
						}
					}
				);	
				
				//------------------------------------------------------------------------------------------
				var __tileset:Tileset = new Tileset (m_currentBitmap);
				var __tileId:int;
				
				m_tilesets.push (__tileset);
				
				//------------------------------------------------------------------------------------------
				m_movieClips.forEach (
					function (x:*):void {
						var __className:String = x as String;
						
						trace (": ===================================================: ");
						trace (": finishing: ", __className);
						
						var __movieClipMetadata:MovieClipMetadata = m_movieClips.get (__className);
						
						__index = __movieClipMetadata.getMasterTilesetIndex ();
						__movieClip = __movieClipMetadata.getMovieClip ();
						__realBounds = __movieClipMetadata.getRealBounds ();
						
						trace (": index: ", __index);
						trace (": tileset: ", __tileset);
						trace (": movieClip: ", __movieClip);
						trace (": realBounds: ", __realBounds);
						
						if (__index == m_currentBitmapIndex) {
							__movieClipMetadata.setMasterTileset (__tileset);
							
							for (i = 0; i < __movieClip.totalFrames; i++) {
								__rect = __movieClipMetadata.getRect (i);
								__tileId = __tileset.addRect (__rect);
								__movieClipMetadata.setTileId (i, __tileId);
								__movieClipMetadata.setTileset (i, __tileset);
								
								trace (":    frame: ", i);
								trace (":    tileId: ", __tileId);
								trace (":    rect: ", __rect);
							}
						}
					}
				);	
				
				//------------------------------------------------------------------------------------------
//				m_currentBitmap.dispose ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		private function __finishWrap ():void {
			__end ();
			
			var i:int;
			
			var __scaleX:Number = 1.0;
			var __scaleY:Number = 1.0;
			var __padding:Number = 2.0;
			var __rect:Rectangle = null;
			var __realBounds:Rectangle;
			
			var __index:int;
			var __movieClip:flash.display.MovieClip;
			
			//------------------------------------------------------------------------------------------
			for (m_currentBitmapIndex = 0; m_currentBitmapIndex < m_count; m_currentBitmapIndex++) {
				__rect = new Rectangle (0, 0, TEXTURE_WIDTH, TEXTURE_HEIGHT);
				m_currentBitmap = new BitmapData (TEXTURE_WIDTH, TEXTURE_HEIGHT);
				m_currentBitmap.fillRect (__rect, 0x00000000);
				
				//------------------------------------------------------------------------------------------
				m_movieClips.forEach (
					function (x:*):void {
						var __className:String = x as String;
						
						var __movieClipMetadata:MovieClipMetadata = m_movieClips.get (__className);
						
						__index = __movieClipMetadata.getMasterTilesetIndex ();
						__movieClip = __movieClipMetadata.getMovieClip ();
						__realBounds = __movieClipMetadata.getRealBounds ();
						
						for (i=0; i<__movieClip.totalFrames; i++) {
							__index = __movieClipMetadata.getTilesetIndex (i);
							
							if (__index == m_currentBitmapIndex) {
								__movieClip.gotoAndStop (i+1);
								__rect = __movieClipMetadata.getRect (i);
								var __matrix:Matrix = new Matrix ();
								__matrix.scale (__scaleX, __scaleY);
								__matrix.translate (__rect.x - __realBounds.x, __rect.y - __realBounds.y);
								m_currentBitmap.draw (__movieClip, __matrix);
							}
						}
					}
				);	
				
				//------------------------------------------------------------------------------------------
				var __tileset:Tileset = new Tileset (m_currentBitmap);
				var __tileId:int;
				
				m_tilesets.push (__tileset);
				
				//------------------------------------------------------------------------------------------
				m_movieClips.forEach (
					function (x:*):void {
						var __className:String = x as String;
						
						trace (": ===================================================: ");
						trace (": finishing: ", __className);
						
						var __movieClipMetadata:MovieClipMetadata = m_movieClips.get (__className);
						
						__index = __movieClipMetadata.getMasterTilesetIndex ();
						__movieClip = __movieClipMetadata.getMovieClip ();
						__realBounds = __movieClipMetadata.getRealBounds ();
						
						trace (": index: ", __index);
						trace (": tileset: ", __tileset);
						trace (": movieClip: ", __movieClip);
						trace (": realBounds: ", __realBounds);
						
						for (i = 0; i < __movieClip.totalFrames; i++) {
							__index = __movieClipMetadata.getTilesetIndex (i);
							
							if (__index == m_currentBitmapIndex) {
								__rect = __movieClipMetadata.getRect (i);
								__tileId = __tileset.addRect (__rect);
								__movieClipMetadata.setTileId (i, __tileId);
								__movieClipMetadata.setTileset (i, __tileset);
									
								trace (":    frame: ", i);
								trace (":    tileId: ", __tileId);
								trace (":    rect: ", __rect);
							}
						}
					}
				);	
				
				//------------------------------------------------------------------------------------------
				// m_currentBitmap.dispose ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function isDynamic ():Boolean {
			return false;	
		}
		
		//------------------------------------------------------------------------------------------
		public override function add (__className:String):void {
			var __class:Class /* <Dynamic> */ = m_XApp.getClass (__className);
			
			m_movieClips.set (__className, null);
			
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
		public override function isQueued (__className:String):Boolean {
			return m_movieClips.exists (__className);
		}
		
		//------------------------------------------------------------------------------------------
		public override function movieClipExists (__className:String):Boolean {
			if (m_movieClips.exists (__className)) {
				return true;
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
			
			var __movieClipMetadata:MovieClipMetadata = m_movieClips.get (__className);
			
			var __tileset:Tileset = __movieClipMetadata.getMasterTileset ();
			var __frames:int = __movieClipMetadata.getTotalFrames ();
			var __realBounds:Rectangle = __movieClipMetadata.getRealBounds ();
			
			var __tilemap:Tilemap = new Tilemap (int (__realBounds.width), int (__realBounds.height));
			__tilemap.tileset = __tileset;
			
			var i:int;
			
			var __tileId:int;
			var __tile:Tile;
			var __rect:Rectangle;
			
			for (i = 0; i < __frames; i++) {
				__tileset = __movieClipMetadata.getTileset (i);
				__rect = __movieClipMetadata.getRect (i);
				__tileId = __movieClipMetadata.getTileId (i);
				
//				__tile = new Tile (0, 0, 0, 1.0, 1.0, 0.0);
				
				__tile = m_XApp.getTilePoolManager ().borrowObject () as Tile;
				__tile.id = __tileId;
				
				__tile.x = 0;
				__tile.y = 0;
				
				if (wrapFlag) {
					__tile.tileset = __tileset;
				}
				
				__tilemap.addTileAt (__tile, i);
			}
			
			__tilemap.x = __realBounds.x;
			__tilemap.y = __realBounds.y;
			
			return __tilemap;
		}

		//------------------------------------------------------------------------------------------
		protected function findFreeTexture (__movieClip:flash.display.MovieClip):int {
			var __scaleX:Number = 1.0;
			var __scaleY:Number = 1.0;
			var __padding:Number = 2.0;
			var __rect:Rectangle = null;
			var __realBounds:Rectangle = null;
			
			var __free:Boolean;
			
			var __index:int;
			
			for (__index=0; __index < m_count; __index++) {
				var __tester:MaxRectPacker = m_testers[__index] as MaxRectPacker;
				var __packer:MaxRectPacker = m_packers[__index] as MaxRectPacker;
				
				__tester.copyFrom (__packer.freeRectangles);
			
				__free = true;
				
				var i:int = 0;
				
				while (i < __movieClip.totalFrames && __free) {
					__movieClip.gotoAndStop (i+1);
					
					__realBounds = __getRealBounds (__movieClip);
					
					__rect = __tester.quickInsert (
						(__realBounds.width * __scaleX) + __padding * 2, (__realBounds.height * __scaleY) + __padding * 2
					);
					
					if (__rect == null) {
						__free = false;
					}
					
					i++;
				}
				
				if (__free) {
					return __index;
				}
			}
			
			__end (); __begin ();
			
			return m_count - 1;
		}
		
		//------------------------------------------------------------------------------------------
		public override function createTexture (__className:String, __class:Class /* <Dynamic> */):void {	
			if (!wrapFlag) {
				__createTextureFit (__className, __class);	
			}
			else
			{
				__createTextureWrap (__className, __class);
			}
		}
		
		//------------------------------------------------------------------------------------------
		private function __createTextureFit (__className:String, __class:Class /* <Dynamic> */):void {	
			var __movieClip:flash.display.MovieClip = XType.createInstance (__class);
			
			var __scaleX:Number = 1.0;
			var __scaleY:Number = 1.0;
			var __padding:Number = 2.0;
			var __rect:Rectangle = null;
			var __realBounds:Rectangle = null;

			var i:int;
			
			trace (": XTileSubTextureManager: totalFrames: ", __className, __movieClip.totalFrames);
			
			var __index:int = findFreeTexture (__movieClip);
			
			m_currentPacker = m_packers[__index] as MaxRectPacker;
			
			var __movieClipMetadata:MovieClipMetadata = new MovieClipMetadata ();
			__movieClipMetadata.setup (
				__index,					// TilesetIndex
				null,						// Tileset
				__movieClip,				// MovieClip
				__movieClip.totalFrames,	// totalFrames
				__realBounds				// realBounds
				);
			
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
				
				__movieClipMetadata.addTile (0, __index, __rect);
			}
			
			__movieClipMetadata.setRealBounds (__realBounds);
			
			m_movieClips.set (__className, __movieClipMetadata);
		}	
		
		//------------------------------------------------------------------------------------------
		private function __createTextureWrap (__className:String, __class:Class /* <Dynamic> */):void {	
			var __movieClip:flash.display.MovieClip = XType.createInstance (__class);
			
			var __scaleX:Number = 1.0;
			var __scaleY:Number = 1.0;
			var __padding:Number = 2.0;
			var __rect:Rectangle = null;
			var __realBounds:Rectangle = null;
			
			var i:int;
			
			trace (": XTileSubTextureManager: totalFrames: ", __className, __movieClip.totalFrames);
			
			var __index:int = m_count - 1;
			
			m_currentPacker = m_packers[__index] as MaxRectPacker;
			
			var __movieClipMetadata:MovieClipMetadata = new MovieClipMetadata ();
			__movieClipMetadata.setup (
				__index,					// TilesetIndex
				null,						// Tileset
				__movieClip,				// MovieClip
				__movieClip.totalFrames,	// totalFrames
				__realBounds				// realBounds
			);
			
			for (i=0; i<__movieClip.totalFrames; i++) {
				__movieClip.gotoAndStop (i+1);
				
				trace (": getBounds: ", __className, __getRealBounds (__movieClip));
				
				__realBounds = __getRealBounds (__movieClip);
				
				__rect = m_currentPacker.quickInsert (
					(__realBounds.width * __scaleX) + __padding * 2, (__realBounds.height * __scaleY) + __padding * 2
				);
				
				if (__rect == null) {
					trace (": split @: ", m_count, __className, i);
					
					__end (); __begin ();
					
					__index = m_count - 1;
					
					m_currentPacker = m_packers[__index] as MaxRectPacker;
					
					__rect = m_currentPacker.quickInsert (
						(__realBounds.width * __scaleX) + __padding * 2, (__realBounds.height * __scaleY) + __padding * 2
					);
				}
				
				__rect.x += __padding;
				__rect.y += __padding;
				__rect.width -= __padding * 2;
				__rect.height -= __padding * 2;
				
				trace (": rect: ", __rect);
				
				__movieClipMetadata.addTile (0, __index, __rect);
			}
			
			__movieClipMetadata.setRealBounds (__realBounds);
			
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
