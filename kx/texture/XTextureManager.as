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
	
	import flash.display.*;
	import flash.geom.*;
	
	// <HAXE>
	/* --
	-- */
	// </HAXE>
	// <AS3>
	import starling.display.*;
	import starling.textures.*;
	// </AS3>
	
	//------------------------------------------------------------------------------------------
	// this class manages XSubMovieClipCacheManagers
	//------------------------------------------------------------------------------------------
	public class XTextureManager extends Object {
		private var m_XApp:XApp;
		
		private var m_subManagers:XDict; // <String, XSubTextureManager>
			
		//------------------------------------------------------------------------------------------
		public function XTextureManager (__XApp:XApp) {
			m_XApp = __XApp;
			
			m_subManagers = new XDict (); // <String, XSubTextureManager>
		}

		//------------------------------------------------------------------------------------------
		public function setup ():void {	
		}
		
		//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}

		//------------------------------------------------------------------------------------------
		public function createSubManager (__name:String, __width:int=2048, __height:int=2048):XSubTextureManager {
			var __subManager:XSubTextureManager = new XTileSubTextureManager (m_XApp, __width, __height);
			m_subManagers.set (__name, __subManager);
			
			return __subManager;
		}
		
		//------------------------------------------------------------------------------------------
		public function removeSubManager (__name:String):void {	
			if (m_subManagers.exists (__name)) {
				var __subManager:XSubTextureManager = m_subManagers.get (__name);
				__subManager.cleanup ();
			
				m_subManagers.remove (__name);
			}
		}

		//------------------------------------------------------------------------------------------
		public function getSubManager (__name:String):XSubTextureManager {
			return m_subManagers.get (__name) as XSubTextureManager;
		}
		
		//------------------------------------------------------------------------------------------
		// TODO: figure out a better way of deciding which dynamic texture manager to use
		// to create the MovieClip to.  Currently, it'll always use the first one.  It might
		// make sense to only support one dynamic texture manager?
		//------------------------------------------------------------------------------------------
		// <HAXE>
		/* --
		public function createMovieClip (__className:String):* {
			var __tilemap:Tilemap = null;
		
			var __dynamicSubManagers:Array<XSubTextureManager> = new Array<XSubTextureManager> ();
			
			for (__key__ in m_subManagers.keys ()) {
					if (__tilemap == null) {
						var __subManager:XSubTextureManager = m_subManagers.get (cast __key__);
						
						__tilemap = cast __subManager.createMovieClip (__className);
					}
			}
		
			return __tilemap;
		}
		-- */
		// </HAXE>
		// <AS3>
		public function createMovieClip (__className:String):flash.display.MovieClip {
			var __movieClip:flash.display.MovieClip = null;
			
			var __dynamicSubManagers:Array /* <XSubTextureManager> */ = new Array (); /* <XSubTextureManager> */
			
// look for texture in static managers first
			m_subManagers.forEach (
				function (x:*):void {
					if (__movieClip == null) {
						var __subManager:XSubTextureManager = m_subManagers.get (/* @:cast */ x as String);
					
						if (__subManager.isDynamic ()) {
							__dynamicSubManagers.push (__subManager);
						}	
						else if (__subManager.movieClipExists (__className)) {
							__movieClip = __subManager.createMovieClip (__className);
						}
					}
				}
			);

			var i:int;
			
// try and find one in a dynamic manager
			if (__movieClip == null) {	
				for (i=0; i<__dynamicSubManagers.length; i++) {
					if (__dynamicSubManagers[i].movieClipExists (__className)) {
						__movieClip = __dynamicSubManagers[i].createMovieClip (__className);
					}
				}
			}
			
// if nothing is found, try and add it to a dynamic manager
			if (__movieClip == null) {
				for (i=0; i<__dynamicSubManagers.length; i++) {
					if (!__dynamicSubManagers[i].isQueued (__className)) {
						__dynamicSubManagers[i].add (__className);
					}
					
					return null;
				}	
			}
			
			return __movieClip;
		}
		// </AS3>
		
	//------------------------------------------------------------------------------------------
	}
				
//------------------------------------------------------------------------------------------
}
