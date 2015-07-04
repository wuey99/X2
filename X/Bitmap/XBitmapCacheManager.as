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
package X.Bitmap {
	
// X classes
	import X.Collections.*;
	import X.Task.*;
	import X.Type.*;
	import X.World.Sprite.XBitmap;
	import X.XApp;
	
	import flash.display.MovieClip;
	
//------------------------------------------------------------------------------------------	
	public class XBitmapCacheManager extends Object {
		private var m_XApp:XApp;
		private var m_bitmaps:XDict; // <String, XBitmap>
		private var m_count:XDict; // <String, Float>
		private var m_queue:XDict; // <String, Float>
		
//------------------------------------------------------------------------------------------
		public function XBitmapCacheManager (__XApp:XApp) {
			m_XApp = __XApp;
			
			m_bitmaps = new XDict (); // <String, XBitmap>
			m_count = new XDict (); // <String, Float>
			m_queue = new XDict (); // <String, Float>
			
// checked queued images and cache the ones that have loaded.
			m_XApp.getXTaskManager ().addTask ([
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
					
					function ():void {
						m_queue.forEach (
							function (x:*):void {
								var __className:String = x as String;
								var __class:Class  /* <Dynamic> */ = m_XApp.getClass (__className);
								
								if (__class != null) {
									var __bitmap:XBitmap = m_bitmaps.get (__className);
									
									if (__bitmap == null) {
										__bitmap = __createBitmap (__className, __class);
									}								
									
									if (__bitmap.getBitmapDataAnim () != null) {
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
//				m_count[__className]++;
				var __count:Number = m_count.get (__className);
				__count++;
				m_count.set (__className, __count);
				
// this could return null if the image is still loading.	
				return m_bitmaps.get (__className);
			}
			
//			m_count[__className] = 1;
			m_count.set (__className, 1);
			
			m_bitmaps.set (__className, null);
					
			var __class:Class /* <Dynamic> */ = m_XApp.getClass (__className);
			
			trace (": caching: ", __className, __class);
			
			trace (": queuing: ", __className);
			
			if (__class != null) {
				var __bitmap:XBitmap = __createBitmap (__className, __class);
				
				m_XApp.unloadClass (__className);
				
				return __bitmap;
			}
			else
			{
				// wait for image to load before caching it.
				m_queue.set (__className, 0);	
			}
			
			return null;
		}

//------------------------------------------------------------------------------------------
		public function isQueued (__className:String):Boolean {
			return m_queue.exists (__className);	
		}
		
//------------------------------------------------------------------------------------------
		private function __createBitmap (__className:String, __class:Class /* <Dynamic> */):XBitmap {
			var __movieClip:MovieClip = XType.createInstance (__class);
			__movieClip.stop ();
			
			var __XBitmap:XBitmap = new XBitmap ();
			__XBitmap.setup ();
			__XBitmap.initWithClassName (null, m_XApp, __className);
		
			trace (": adding bitmap: ", __movieClip, __XBitmap, __XBitmap.bitmapData);
	
			m_bitmaps.set (__className, __XBitmap);
			
			return __XBitmap;			
		}
			
//------------------------------------------------------------------------------------------
		public function remove (__className:String):void {
			if (m_bitmaps.exists (__className)) {
//				m_count[__className]--
				var __count:Number = m_count.get (__className);
				__count--;
				m_count.set (__className, __count);
				
//				if (m_count[__className] == 0) {
				if (__count == 0) {
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
