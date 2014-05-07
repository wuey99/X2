//------------------------------------------------------------------------------------------
// Copyright (C) 2014 Jimmy Huey
//
// Some Rights Reserved.
//
// The "X-Engine" is licensed under a Creative Commons
// Attribution-Share Alike 3.0 United States License.
// (CC BY-SA 3.0)
//
// You are free to:
//
//      SHARE - to copy, distribute, display and perform the work.
//      ADAPT - remix, transform build upon this material, even for commercial works.
//
//      The licensor cannot revoke these freedoms as long as you follow the license terms.
//
// Under the following terms:
//
//      ATTRIBUTION — 
//      You must give appropriate credit, provide a link to the license, and
//      indicate if changes were made.  You may do so in any reasonable manner,
//      but not in any way that suggests the licensor endorses you or your use.
//
//      SHARE-ALIKE -
//      If you remix, transform, or build upon the material, you must
//      distribute your contributions under the same license as the original.
//
// No additional restrictions — You may not apply legal terms or technological measures
// that legally restrict others from doing anything the license permits. 
//
// The full summary can be located at:
// http://creativecommons.org/licenses/by-sa/3.0/us/ 
//
// The human-readable summary of the Legal Code can be located at:
// http://creativecommons.org/licenses/by-sa/3.0/us/legalcode
//------------------------------------------------------------------------------------------
package X.Texture {
	
	// X classes
	import X.Collections.*;
	import X.Task.*;
	import X.World.Sprite.*;
	import X.XApp;
	
	import flash.display.BitmapData;
	import flash.geom.*;
	
	import starling.display.*;
	import starling.textures.*;
	
	//------------------------------------------------------------------------------------------
	// this class manages XSubMovieClipCacheManagers
	//------------------------------------------------------------------------------------------
	public class XTextureManager extends Object {
		private var m_XApp:XApp;
		
		private var m_subManagers:XDict;
			
		//------------------------------------------------------------------------------------------
		public function XTextureManager (__XApp:XApp) {
			m_XApp = __XApp;
			
			m_subManagers = new XDict ();
		}

		//------------------------------------------------------------------------------------------
		public function setup ():void {	
		}
		
		//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}

		//------------------------------------------------------------------------------------------
		public function createSubManager (__name:String, __width:Number=2048, __height:Number=2048):XSubTextureManager {
			var __subManager:XSubTextureManager = new XStaticSubTextureManager (m_XApp, __width, __height);
			m_subManagers.put (__name, __subManager);
			
			return __subManager;
		}
		
		//------------------------------------------------------------------------------------------
		public function createDynamicSubManager (__name:String, __width:Number=2048, __height:Number=2048):XSubTextureManager {
			var __subManager:XSubTextureManager = new XDynamicSubTextureManager (m_XApp, __width, __height);
			m_subManagers.put (__name, __subManager);
			
			return __subManager;
		}
		
		//------------------------------------------------------------------------------------------
		public function createStaticSubManager (__name:String, __width:Number=2048, __height:Number=2048):XSubTextureManager {
			var __subManager:XSubTextureManager = new XStaticSubTextureManager (m_XApp, __width, __height);
			m_subManagers.put (__name, __subManager);
			
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
		public function createMovieClip (__className:String):starling.display.MovieClip {
			var __movieClip:starling.display.MovieClip = null;
			
			var __dynamicSubManagers:Array = new Array ();
			
// look for texture in static managers first
			m_subManagers.forEach (
				function (x:*):void {
					if (__movieClip == null) {
						var __subManager:XSubTextureManager = m_subManagers.get (x as String);
					
						if (__subManager.isDynamic ()) {
							__dynamicSubManagers.push (__subManager);
						}	
						else if (__subManager.movieClipExists (__className)) {
							__movieClip = __subManager.createMovieClip (__className);
						}
					}
				}
			);

			var i:Number;
			
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
		
	//------------------------------------------------------------------------------------------
	}
				
//------------------------------------------------------------------------------------------
}
