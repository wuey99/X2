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
	import flash.display.*;
	import flash.geom.*;
	
	import kx.*;
	import kx.bitmap.*;
	import kx.collections.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.texture.*;
	import kx.world.*;
	import kx.world.logic.*;
	
	// <HAXE>
	/* --
	-- */
	// </HAXE>
	// <AS3>
	import kx.texture.openfl.*;
	// </AS3>
	
	//------------------------------------------------------------------------------------------	
	public class XTilemap extends XSplat {
		public static var g_XApp:XApp;
		
		public var m_tilemap:Tilemap;
		public var m_tileArray:TileArray;

		//------------------------------------------------------------------------------------------
		public function XTilemap () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup ():void {
			super.setup ();
			
			m_tilemap = null;
		}
		
		//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
			
			if (m_tilemap != null) {
				var __tile:Tile;
				
				var i:int;
				
				for (i = 0; i < m_tilemap.numTiles; i++) {
					__tile = m_tilemap.getTileAt (i);
					
					g_XApp.getTilePoolManager ().returnObject (__tile);
				}
				
				m_tilemap.removeTiles ();
				
				removeChild (m_tilemap);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public static function setXApp (__XApp:XApp):void {
			g_XApp = __XApp;
		}
		
		//------------------------------------------------------------------------------------------
		public override function initWithClassName (__xxx:XWorld, __XApp:XApp, __className:String):void {		
			m_className = __className;
			
			var __taskManager:XTaskManager =
				__xxx != null ? __xxx.getXTaskManager () : __XApp.getXTaskManager ();
			
			var __textureManager:XTextureManager =
				__xxx != null ? __xxx.getTextureManager () : __XApp.getTextureManager ();
				
			m_tilemap = __textureManager.createMovieClip (__className) as Tilemap;
				
			function __init ():void {
				addChild (m_tilemap);
				
				var __tileArray:TileArray = m_tilemap.getTiles ();
				
				var i:int;
				
				for (i = 0; i < __tileArray.length; i++) {
					__tileArray.position = i;
					__tileArray.visible = false;
				}
				
				m_tilemap.setTiles (__tileArray);
				
				gotoAndStop (1);
			}
			
			if (m_tilemap == null) {
				__taskManager.addTask ([
					XTask.LABEL, "loop",
						XTask.WAIT, 0x0100,
							
						XTask.FLAGS, function (__task:XTask):void {
							m_tilemap = __textureManager.createMovieClip (__className) as Tilemap;
								
							__task.ifTrue (m_tilemap != null);
						}, XTask.BNE, "loop",
							
						function ():void {
							__init ();
						},
						
					XTask.RETN,
				]);
					
				return;
			}
			
			__init ();	
		}
		
		//------------------------------------------------------------------------------------------
		public override function gotoAndStop (__frame:int):void {
			goto (__frame);
		}
		
		//------------------------------------------------------------------------------------------
		public override function goto (__frame:int):void {
			var __tileArray:TileArray = m_tilemap.getTiles ();
			
			if (m_frame >= 0) {
				__tileArray.position = m_frame;
				__tileArray.visible = false;
			}
			
			m_frame = __frame - 1;
			
			__tileArray.position = m_frame;
			__tileArray.visible = true;
			
			m_tilemap.setTiles (__tileArray);
		}

		//------------------------------------------------------------------------------------------
		public override function gotoX (__name:String):void {
		}
		
	//------------------------------------------------------------------------------------------	
	}
	
	//------------------------------------------------------------------------------------------
}