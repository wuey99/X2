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
package kx.xmap {

	import flash.display.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import kx.*;
	import kx.geom.*;
	import kx.world.*;
	import kx.world.sprite.*;
	
	// <HAXE>
	/* --
	-- */
	// </HAXE>
	// <AS3>
	import kx.texture.openfl.*;
	// </AS3>
	
//------------------------------------------------------------------------------------------	
	public class XSubmapTilemap extends Tilemap {
		public static var g_XApp:XApp;
		
//------------------------------------------------------------------------------------------
		public function XSubmapTilemap (__width:int, __height:int, __tileset:Tileset) {
			super (__width, __height, __tileset);
		}

//------------------------------------------------------------------------------------------
		public function setup ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function cleanup ():void {
			/*
			var __tile:Tile;
			
			var i:int;
			
			for (i = 0; i < numTiles; i++) {
				__tile = getTileAt (i);
				
				g_XApp.getTilePoolManager ().returnObject (__tile);
			}
			*/
			
			removeTiles ();
		}
		
		//------------------------------------------------------------------------------------------
		public static function setXApp (__XApp:XApp):void {
			g_XApp = __XApp;
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
