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
package X.Bitmap {
	
// X classes
	import X.Collections.*;
	import X.Task.*;
	import X.World.Sprite.XBitmap;
	import X.XApp;
	
	import flash.display.MovieClip;
	
//------------------------------------------------------------------------------------------	
	public class XBitmapCacheManager extends Object {
		private var m_XApp:XApp;
		private var m_bitmaps:XDict;
		private var m_count:Object;
		private var m_queue:XDict;
		
//------------------------------------------------------------------------------------------
		public function XBitmapCacheManager (__XApp:XApp) {
			m_XApp = __XApp;
			
			m_bitmaps = new XDict ();
			m_count = new Object ();
			m_queue = new XDict ();
			
// checked queued images and cache the ones that have loaded.
			m_XApp.getXTaskManager ().addTask ([
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					
					function ():void {
						m_queue.forEach (
							function (x:*):void {
								var __className:String = x as String;
								var __class:Class = m_XApp.getClass (__className);
								
								if (__class != null) {
									var __bitmap:XBitmap = m_bitmaps.get (__className);
									
									if (__bitmap == null) {
										__bitmap = __createBitmap (__className, __class);
									}								
									
									if (__bitmap.getBitmapDataAnim ()) {
										m_queue.remove (__className);
									}
									
									m_XApp.unloadClass (__className);
								}
							}
						);
					},
					
					XTask.GOTO, "loop",
							
				XTask.RETN,
			]);
		}

//------------------------------------------------------------------------------------------
		public function add (__className:String):XBitmap {
			if (__className == "ErrorImages:undefinedClass") {
				return null;
			}

			if (m_bitmaps.exists (__className)) {
				m_count[__className]++;
				
// this could return null if the image is still loading.	
				return m_bitmaps.get (__className);
			}
			
			m_count[__className] = 1;
			m_bitmaps.put (__className, null);
					
			var __class:Class = m_XApp.getClass (__className);
			
			trace (": caching: ", __className, __class);
			
			trace (": queuing: ", __className);
			
			if (__class) {
				var __bitmap:XBitmap = __createBitmap (__className, __class);
				
				m_XApp.unloadClass (__className);
				
				return __bitmap;
			}
			else
			{
				// wait for image to load before caching it.
				m_queue.put (__className, 0);	
			}
			
			return null;
		}

//------------------------------------------------------------------------------------------
		public function isQueued (__className:String):Boolean {
			return m_queue.exists (__className);	
		}
		
//------------------------------------------------------------------------------------------
		private function __createBitmap (__className:String, __class:Class):XBitmap {
			var __movieClip:MovieClip = new (__class) ();
			__movieClip.stop ();
			
			var __XBitmap:XBitmap = new XBitmap ();
			__XBitmap.setup ();
			__XBitmap.initWithClassName (null, m_XApp, __className);
		
			trace (": adding bitmap: ", __movieClip, __XBitmap, __XBitmap.bitmapData);
	
			m_bitmaps.put (__className, __XBitmap);
			
			return __XBitmap;			
		}
			
//------------------------------------------------------------------------------------------
		public function remove (__className:String):void {
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
		public function get (__className:String):XBitmap {
			if (m_bitmaps.exists (__className)) {
				return m_bitmaps.get (__className);
			}

			return null;
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
