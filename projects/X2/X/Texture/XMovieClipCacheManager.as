//------------------------------------------------------------------------------------------
package X.Texture {
	
// X classes
	import X.Collections.*;
	import X.Task.*;
	import X.World.Sprite.XMovieClip;
	import X.XApp;

	include "..\\flash.h";
	
//------------------------------------------------------------------------------------------	
	public class XMovieClipCacheManager extends Object {
		private var m_XApp:XApp;
		private var m_movieClips:XDict;
		private var m_count:Object;
		
//------------------------------------------------------------------------------------------
		public function XMovieClipCacheManager (__XApp:XApp) {
			m_XApp = __XApp;
			
			m_movieClips = new XDict ();
			m_count = new Object ();
		}

//------------------------------------------------------------------------------------------
		public function add (__className:String):XMovieClip {
			if (m_movieClips.exists (__className)) {
				m_count[__className]++;
				
				return m_movieClips.get (__className);
			}
			
			m_count[__className] = 1;
			
			var __movieClip:XMovieClip = __createMovieClip (__className);
			
			m_movieClips.put (__className, __movieClip);
			
			return __movieClip;
		}

//------------------------------------------------------------------------------------------
		public function isQueued (__className:String):Boolean {
			return false;	
		}

//------------------------------------------------------------------------------------------
		private function __createMovieClip (__className:String):XMovieClip {
			if (CONFIG::starling) {
				var __movieClip:MovieClip = m_XApp.getTextureManager ().createXMovieClip (__className);
			
				var __xmovieClip:XMovieClip = new XMovieClip ();
				__xmovieClip.setup (__movieClip);
			
				__xmovieClip.gotoAndStop (0);
			
				m_movieClips.put (__className, __xmovieClip);
			
				return __xmovieClip;
			}
			else
			{
				return null;
			}
		}
		
//------------------------------------------------------------------------------------------
		public function remove (__className:String):void {
			if (m_movieClips.exists (__className)) {
				m_count[__className]--;
				
				if (m_count[__className] == 0) {
					var __movieClip:XMovieClip = m_movieClips.get (__className);
				
					__movieClip.cleanup ();
					
					m_movieClips.remove (__className);
				}
			}		
		}

//------------------------------------------------------------------------------------------
		public function get (__className:String):XMovieClip {
			if (m_movieClips.exists (__className)) {
				return m_movieClips.get (__className);
			}

			return null;
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
