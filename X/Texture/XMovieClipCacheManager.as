//------------------------------------------------------------------------------------------
// <$begin$/>
// Copyright (C) 2014 Jimmy Huey
//
// Some Rights Reserved.
//
// The "X-Engine" is licensed under a Creative Commons
// Attribution-NonCommerical-ShareAlike 3.0 Unported License.
// (CC BY-NC-SA 3.0)
//
// You are free to:
//
//      SHARE - to copy, distribute, display and perform the work.
//      ADAPT - remix, transform build upon this material.
//
//      The licensor cannot revoke these freedoms as long as you follow the license terms.
//
// Under the following terms:
//
//      ATTRIBUTION -
//          You must give appropriate credit, provide a link to the license, and
//          indicate if changes were made.  You may do so in any reasonable manner,
//          but not in any way that suggests the licensor endorses you or your use.
//
//      SHAREALIKE -
//          If you remix, transform, or build upon the material, you must
//          distribute your contributions under the same license as the original.
//
//      NONCOMMERICIAL -
//          You may not use the material for commercial purposes.
//
// No additional restrictions - You may not apply legal terms or technological measures
// that legally restrict others from doing anything the license permits.
//
// The full summary can be located at:
// http://creativecommons.org/licenses/by-nc-sa/3.0/
//
// The human-readable summary of the Legal Code can be located at:
// http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode
//
// The "X-Engine" is free for non-commerical use.
// For commercial use, you will need to provide proper credits.
// Please contact me @ wuey99[dot]gmail[dot]com for more details.
// <$end$/>
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
			
			var __movieClip:XMovieClip = __createXMovieClip (__className);
			
			m_movieClips.put (__className, __movieClip);
			
			return __movieClip;
		}

//------------------------------------------------------------------------------------------
		public function isQueued (__className:String):Boolean {
			var __movieClip:XMovieClip = m_movieClips.get (__className);
			
			if (!__movieClip.getMovieClip ()) {
				return true;
			}
			else
			{
				return false;
			}
		}

//------------------------------------------------------------------------------------------
		private function __createXMovieClip (__className:String):XMovieClip {
			if (CONFIG::starling) {
				var __xmovieClip:XMovieClip = new XMovieClip ();
				
				__xmovieClip.setup ();
				
				__xmovieClip.initWithClassName (null, m_XApp, __className);
				
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
