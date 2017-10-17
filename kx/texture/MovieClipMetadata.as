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
	import kx.type.*;
	import kx.world.sprite.*;
	import kx.xml.*;
	
	//------------------------------------------------------------------------------------------
	// MovieClipMetadata
	//------------------------------------------------------------------------------------------
	public class MovieClipMetadata extends Object {
		
		public var m_tilesetIndex:int;
		public var m_tileset:Tileset;
		public var m_movieClip:flash.display.MovieClip;
		public var m_totalFrames:int;
		public var m_realBounds:Rectangle;
		
		public var m_tileIds:Array; // <int>
		public var m_tilesets:Array; // <Tileset>
		public var m_rects:Array; // <Rectangle>

		public var m_tileIndex:int;
		
		//------------------------------------------------------------------------------------------
		public function MovieClipMetadata () {
		}

		//------------------------------------------------------------------------------------------
		public function setup (
			__tilesetIndex:int,
			__tileset:Tileset,
			__movieClip:flash.display.MovieClip,
			__totalFrames:int,
			__realBounds:Rectangle
		) {
			m_tilesetIndex = __tilesetIndex;
			m_tileset = __tileset;
			m_movieClip = __movieClip;
			m_totalFrames = __totalFrames;
			m_realBounds = __realBounds;
			
			m_tileIds = new Array (); // <Int>
			m_tilesets = new Array (); // <Tileset>
			m_rects = new Array (); // <Rectangle>
			
			m_tileIndex = 0;
		}
		
		//------------------------------------------------------------------------------------------
		public function cleanup () {	
		}

		//------------------------------------------------------------------------------------------
		public function getMasterTileset ():Tileset {
			return m_tileset;
		}
		
		//------------------------------------------------------------------------------------------
		public function setMasterTileset (__tileset:Tileset):void {
			m_tileset = __tileset;
		}

		//------------------------------------------------------------------------------------------
		public function setRealBounds (__realBounds:Rectangle):void {
			m_realBounds = __realBounds;
		}
		
		//------------------------------------------------------------------------------------------
		public function getRealBounds ():Rectangle {
			return m_realBounds;
		}
		
		//------------------------------------------------------------------------------------------
		public function getTilesetIndex ():int {
			return m_tilesetIndex;
		}
		
		//------------------------------------------------------------------------------------------
		public function getMovieClip ():flash.display.MovieClip {
			return m_movieClip;
		}
		
		//------------------------------------------------------------------------------------------
		public function getTotalFrames ():int {
			return m_totalFrames;
		}
		
		//------------------------------------------------------------------------------------------
		public function addTile (__tileId:int, __tileset:Tileset, __rect:Rectangle):void {	
			m_tileIds[m_tileIndex] = __tileId;
			m_tilesets[m_tileIndex] = __tileset;
			m_rects[m_tileIndex] = __rect;
			
			m_tileIndex++;
		}

		//------------------------------------------------------------------------------------------
		public function setTileId (__tileIndex:int, __tileId:int):void {
			m_tileIds[__tileIndex] = __tileId;	
		}
		
		//------------------------------------------------------------------------------------------
		public function getTileId (__tileIndex:int):int {
			return m_tileIds[__tileIndex];	
		}
		
		//------------------------------------------------------------------------------------------
		public function setTileset (__tileIndex:int, __tileset:Tileset):void {
			m_tilesets[__tileIndex] = __tileset;	
		}
		
		//------------------------------------------------------------------------------------------
		public function getTileset (__tileIndex:int):Tileset {
			return m_tilesets[__tileIndex];	
		}
		
		//------------------------------------------------------------------------------------------
		public function getRect (__tileIndex:int):Rectangle {
			return m_rects[__tileIndex];
		}
		
	//------------------------------------------------------------------------------------------
	}
	
	//------------------------------------------------------------------------------------------
}