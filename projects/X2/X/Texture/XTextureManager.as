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
			var __subManager:XSubTextureManager = new XDynamicSubTextureManager (m_XApp, __width, __height);
			
			m_subManagers.put (__name, __subManager);
			
			return __subManager;
		}
		
		//------------------------------------------------------------------------------------------
		public function removeSubManager (__name:String):void {	
			var __subManager:XSubTextureManager = m_subManagers.get (__name) as XSubTextureManager;
			__subManager.cleanup ();
			
			m_subManagers.remove (__name);
		}

		//------------------------------------------------------------------------------------------
		public function getSubManager (__name:String):XSubTextureManager {
			return m_subManagers.get (__name) as XSubTextureManager;
		}
		
		//------------------------------------------------------------------------------------------
		public function createMovieClip (__className:String):starling.display.MovieClip {
			var __movieClip:starling.display.MovieClip = null;
			
			var __dynamicSubManagers:Array = new Array ();
			
			m_subManagers.forEach (
				function (x:*):void {
					if (__movieClip == null) {
						var __subManager:XSubTextureManager = m_subManagers.get (x as String);
					
						if (__subManager.isDynamic ()) {
							__dynamicSubManagers.push (__subManager);
						}
						
						if (__subManager.movieClipExists (__className)) {
							__movieClip = __subManager.createMovieClip (__className);
						}
					}
				}
			);
			
			if (__movieClip == null) {
				var i:Number;
				
				for (i=0; i<__dynamicSubManagers.length; i++) {
					__dynamicSubManagers[i].add (__className);
					
					__movieClip = __dynamicSubManagers[i].createMovieClip (__className);
				}
				
				if (__movieClip == null) {
					throw (new Error (": unable to find XMovieClip: " + __className));
				}
			}
			
			return __movieClip;
		}
		
	//------------------------------------------------------------------------------------------
	}
				
//------------------------------------------------------------------------------------------
}
