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
package x.texture {
	
	// X classes
	import x.collections.*;
	import x.task.*;
	import x.world.sprite.*;
	import x.XApp;
	import x.texture.*;
	
	import flash.display.BitmapData;
	import flash.geom.*;
	
	// <HAXE>
	/* --
	import x.texture.starling.*;
	import flash.display.*;
	-- */
	// </HAXE>
	// <AS3>
	import starling.display.*;
	import starling.textures.*;
	// </AS3>
	
	//------------------------------------------------------------------------------------------
	// this class takes one or more flash.display.MovieClip's and dynamically creates texture/atlases
	//------------------------------------------------------------------------------------------
	public class XSubTextureManager extends Object {
		protected var m_XApp:XApp;
		
		protected var m_movieClips:XDict; // <String, Array<Dynamic>>
		 
		protected var m_atlases:Array; // <TextureAtlas>
		protected var m_currentAtlas:TextureAtlas;
		
		protected var m_packer:MaxRectPacker;
		
		protected var TEXTURE_WIDTH:int = 2048;
		protected var TEXTURE_HEIGHT:int = 2048;
			
		protected var m_queue:XDict; // <String, Int>
		
		protected var m_count:int;
		
		//------------------------------------------------------------------------------------------
		public function XSubTextureManager (__XApp:XApp, __width:int=2048, __height:int=2048) {
			m_XApp = __XApp;
			
			TEXTURE_WIDTH = __width;
			TEXTURE_HEIGHT = __height;
			
			m_count = 0;
			
			m_queue = new XDict ();  // <String, Int>
			
			m_XApp.getXTaskManager ().addTask ([
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
				
					function ():void {
						m_queue.forEach (
							function (x:*):void {
								var __className:String = x as String;
								var __class:Class /* <Dynamic> */ = m_XApp.getClass (__className);
							
								if (__class != null) {
									createTexture (__className, __class);
								
									m_queue.remove (__className);
								
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
		public function cleanup ():void {
			reset ();
		}

		//------------------------------------------------------------------------------------------
		public function reset ():void {
		}
		
		//------------------------------------------------------------------------------------------
		public function start ():void {
		}
		
		//------------------------------------------------------------------------------------------
		public function finish ():void {
		}

		//------------------------------------------------------------------------------------------
		public function isDynamic ():Boolean {
			return false;	
		}
		
		//------------------------------------------------------------------------------------------
		public function add (__className:String):void {	
		}	

		//------------------------------------------------------------------------------------------
		public function isQueued (__className:String):Boolean {
			return m_movieClips.exists (__className);
		}
		
		//------------------------------------------------------------------------------------------
		public function movieClipExists (__className:String):Boolean {
			if (m_movieClips.exists (__className)) {
				var __movieClipMetadata:Array /* <Dynamic> */ = m_movieClips.get (__className);
				
				if (__movieClipMetadata.length == 0) {
					return false;
				}		
				else
				{
					return true;
				}
			}
			else
			{
				return false;
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function createTexture (__className:String, __class:Class /* <Dynamic> */):void {	
		}
		
		//------------------------------------------------------------------------------------------
		public function createMovieClip (__className:String):starling.display.MovieClip {
			if (!isQueued (__className)) {
				return null;
			}
			
			var __movieClipMetadata:Array /* <Dynamic> */ = m_movieClips.get (__className);
			
			if (__movieClipMetadata.length == 0) {
				return null;
			}
			
			var __rect:Rectangle = __movieClipMetadata[0] as Rectangle;
			var __pivotX:Number = __rect.x; 
			var __pivotY:Number = __rect.y;
			
			var __textures:Vector.<Texture> = new Vector.<Texture> ();
			var __atlas:TextureAtlas;
			
			for (var i:int=1; i<=__movieClipMetadata.length-1; i++) {
				__atlas = __movieClipMetadata[i] as TextureAtlas;
				 
				__textures = __textures.concat (__atlas.getTextures (__className));
			}

			// <HAXE>
			/* --
			var __movieClip:MovieClip = new MovieClip ();
			-- */
			// </HAXE>
			// <AS3>
			var __movieClip:MovieClip = new MovieClip (__textures);
			// </AS3>
			
			__movieClip.pivotX = -__rect.x;
			__movieClip.pivotY = -__rect.y;
			
			return __movieClip;
		}

		//------------------------------------------------------------------------------------------
		protected function __begin ():void {
		}
		
		//------------------------------------------------------------------------------------------
		protected function __end ():void {	
		}

		//------------------------------------------------------------------------------------------
		protected function __generateIndex (__index:int):String {
			var __indexString:String = String (__index);
			
			switch (__indexString.length) {
				case 1:
					return "00" + __indexString;
					break;
				case 2:
					return "0" + __indexString;
					break;
				case 3:
					return __indexString;
					break;
			}
			
			return __indexString;
		}
		
		//------------------------------------------------------------------------------------------
		protected function __getRealBounds(clip:flash.display.DisplayObject):Rectangle {
			var bounds:Rectangle = clip.getBounds(clip.parent);
			bounds.x = Math.floor(bounds.x);
			bounds.y = Math.floor(bounds.y);
			bounds.height = Math.ceil(bounds.height);
			bounds.width = Math.ceil(bounds.width);
			
			var _margin:Number = 2.0;
			
			var realBounds:Rectangle = new Rectangle(0, 0, bounds.width + _margin * 2, bounds.height + _margin * 2);
			var tmpBData:BitmapData;
			
			// Checking filters in case we need to expand the outer bounds
			if (clip.filters.length > 0)
			{
				// filters
				var j:int = 0;
				//var clipFilters:Array /* <Dynamic> */ = clipChild.filters.concat();
				var clipFilters:Array /* <Dynamic> */ = clip.filters;
				var clipFiltersLength:int = clipFilters.length;
				var filterRect:Rectangle;
				
				tmpBData = new BitmapData (int (realBounds.width), int (realBounds.height), false);
				filterRect = tmpBData.generateFilterRect(tmpBData.rect, clipFilters[j]);
				tmpBData.dispose();
				
				while (++j < clipFiltersLength)
				{
					tmpBData = new BitmapData (int (filterRect.width), int (filterRect.height), true, 0);
					filterRect = tmpBData.generateFilterRect(tmpBData.rect, clipFilters[j]);
					realBounds = realBounds.union(filterRect);
					tmpBData.dispose();
				}
			}
			
			realBounds.offset (bounds.x, bounds.y);
			realBounds.width = Math.max(realBounds.width, 1);
			realBounds.height = Math.max(realBounds.height, 1);
			
			tmpBData = null;
			return realBounds;
		}
		
	//------------------------------------------------------------------------------------------
	}
				
//------------------------------------------------------------------------------------------
}
