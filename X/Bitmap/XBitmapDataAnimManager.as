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
	import X.World.Sprite.XBitmap;
	import X.XApp;
	
	import flash.display.MovieClip;
	
//------------------------------------------------------------------------------------------	
	public class XBitmapDataAnimManager extends Object {
		private var m_XApp:XApp;
		private var m_bitmapAnims:XDict;
		private var m_count:Object;
		private var m_queue:XDict;
		
//------------------------------------------------------------------------------------------
		public function XBitmapDataAnimManager (__XApp:XApp) {
			m_XApp = __XApp;
			
			m_bitmapAnims = new XDict ();
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
									var __bitmapAnim:XBitmapDataAnim = m_bitmapAnims.get (__className);
									
									if (__bitmapAnim == null) {
										__createBitmapAnim (__className, __class);
										
										__bitmapAnim = m_bitmapAnims.get (__className);
									}								
	
									if (__bitmapAnim.isReady ()) {
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
		public function add (__className:String):XBitmapDataAnim {
			if (m_bitmapAnims.exists (__className)) {
				m_count[__className]++;
								
				// this could return null if the image is still loading.	
				return m_bitmapAnims.get (__className);
			}
							
			m_count[__className] = 1;
			m_bitmapAnims.put (__className, null);
	
			trace (": queuing: ", __className);
			
			var __class:Class = m_XApp.getClass (__className);
							
			trace (": XBitmapDataAnimManager: caching: ", __className, __class);
							
			if (__class) {
				var __bitmapDataAnim:XBitmapDataAnim = __createBitmapAnim (__className, __class);
				
				m_XApp.unloadClass (__className);
				
				return __bitmapDataAnim;
			}
			else
			{
				// wait for image to load before caching it.
				m_queue.put (__className, 0);
			}
			
			return null;
		}


//------------------------------------------------------------------------------------------
		public function getXTaskManager ():XTaskManager {
			return m_XApp.getXTaskManager ();
		}
		
//------------------------------------------------------------------------------------------
		public function isQueued (__className:String):Boolean {
			return m_queue.exists (__className);	
		}
						
//------------------------------------------------------------------------------------------
		private function __createBitmapAnim (__className:String, __class:Class):XBitmapDataAnim {
			var __movieClip:MovieClip = new (__class) ();
			__movieClip.stop ();
			
			var __XBitmapDataAnim:XBitmapDataAnim = new XBitmapDataAnim ();
			__XBitmapDataAnim.initWithScaling (m_XApp, __movieClip, 1.0);
							
			trace (": adding bitmap: ", __movieClip, __XBitmapDataAnim, __XBitmapDataAnim);
							
			m_bitmapAnims.put (__className, __XBitmapDataAnim);
							
			return __XBitmapDataAnim;			
		}
						
//------------------------------------------------------------------------------------------
		public function remove (__className:String):void {
			if (m_bitmapAnims.exists (__className)) {
				m_count[__className]--;
								
				if (m_count[__className] == 0) {
					var __XBitmapDataAnim:XBitmapDataAnim = m_bitmapAnims.get (__className);
									
					__XBitmapDataAnim.cleanup ();
									
					m_bitmapAnims.remove (__className);
				}
			}		
		}
						
	//------------------------------------------------------------------------------------------
		public function get (__className:String):XBitmapDataAnim {
			if (m_bitmapAnims.exists (__className)) {
				return m_bitmapAnims.get (__className);
			}
							
			return null;
		}
						
	//------------------------------------------------------------------------------------------
	}
				
//------------------------------------------------------------------------------------------
}
