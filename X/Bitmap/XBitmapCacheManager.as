//------------------------------------------------------------------------------------------
package X.Bitmap {
	
// X classes
	import X.Collections.*;
	import X.World.Sprite.XBitmap;
	import X.XApp;
	
	import flash.display.MovieClip;
	
//------------------------------------------------------------------------------------------	
	public class XBitmapCacheManager extends Object {
		private var m_XApp:XApp;
		private var m_bitmaps:XDict;
		private var m_count:Object;
		
//------------------------------------------------------------------------------------------
		public function XBitmapCacheManager (__XApp:XApp) {
			m_XApp = __XApp;
			
			m_bitmaps = new XDict ();
			m_count = new Object ();
		}

//------------------------------------------------------------------------------------------
		public function addMovieClipToCache (__className:String):XBitmap {
			if (m_bitmaps.exists (__className)) {
				m_count[__className]++;
				
				return m_bitmaps.get (__className);
			}
			
			var __class:Class = m_XApp.getClass (__className);
			
			if (__class == null) {
				return null;
			}
			
			var __movieClip:MovieClip = new (__class) ();		
			var __XBitmap:XBitmap = new XBitmap ();			
			__XBitmap.initWithScaling (__movieClip, 1.0);
		
			m_count[__className] = 1;
			m_bitmaps.put (__className, __XBitmap);
			
			return __XBitmap;
		}
		
//------------------------------------------------------------------------------------------
		public function removeMovieClipFromCache (__className:String):void {
			if (m_bitmaps.exists (__className)) {
				m_count[__className]--;
				
				if (m_count[__className] == 0) {
					var __XBitmap:XBitmap = m_bitmaps.get (__className);
				
					__XBitmap.cleanup ();
					
					m_bitmaps.remove (__className);
				}
			}		
		}

//------------------------------------------------------------------------------------------
		public function getBitmapFromMovieClip (__className:String):XBitmap {
			if (m_bitmaps.exists (__className)) {
				return m_bitmaps.get (__className);
			}

			return null;
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
