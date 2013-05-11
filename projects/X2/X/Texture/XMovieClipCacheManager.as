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
	public class XMovieClipCacheManager extends Object {
		private var m_XApp:XApp;
		
		private var m_subManagers:XDict;
			
		//------------------------------------------------------------------------------------------
		public function XMovieClipCacheManager (__XApp:XApp) {
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
		public function createSubManager (__name:String, __width:Number=2048, __height:Number=2048):XSubMovieClipCacheManager {
			var __subManager:XSubMovieClipCacheManager = new XSubMovieClipCacheManager (m_XApp);
			
			m_subManagers.put (__name, __subManager);
			
			return __subManager;
		}
		
		//------------------------------------------------------------------------------------------
		public function removeSubManager (__name:String):void {	
			var __subManager:XSubMovieClipCacheManager = m_subManagers.get (__name) as XSubMovieClipCacheManager;
			
			__subManager.cleanup ();
			
			m_subManagers.remove (__name);
		}

		//------------------------------------------------------------------------------------------
		public function getSubManager (__name:String):XSubMovieClipCacheManager {
			return m_subManagers.get (__name) as XSubMovieClipCacheManager;
		}
		
		//------------------------------------------------------------------------------------------
		public function createXMovieClip (__movieClipName:String):starling.display.MovieClip {
			var __movieClip:starling.display.MovieClip;
			
			m_subManagers.forEach (
				function (x:*):void {
					if (__movieClip == null) {
						var __subManager:XSubMovieClipCacheManager = m_subManagers.get (x as String);
					
						if (__subManager.movieClipExists (__movieClipName)) {
							__movieClip = __subManager.createXMovieClip (__movieClipName);
						}
					}
				}
			);
			
			return __movieClip;
		}
		
	//------------------------------------------------------------------------------------------
	}
				
//------------------------------------------------------------------------------------------
}
