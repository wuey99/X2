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
	import X.World.Sprite.*;
	import X.XApp;
	
	import flash.display.BitmapData;
	import flash.geom.*;
	
	import starling.display.*;
	import starling.textures.*;
	
	//------------------------------------------------------------------------------------------
	// this class takes one or more flash.display.MovieClip's and dynamically creates texture/atlases
	//------------------------------------------------------------------------------------------
	public class XSubTextureManager extends Object {
		protected var m_XApp:XApp;
		
		protected var m_movieClips:XDict;
		 
		protected var m_atlases:Array;
		protected var m_currentAtlas:TextureAtlas;
		
		protected var m_packer:MaxRectPacker;
		
		protected var TEXTURE_WIDTH:Number = 2048;
		protected var TEXTURE_HEIGHT:Number = 2048;
			
		protected var m_queue:XDict;
		
		protected var m_count:Number;
		
		//------------------------------------------------------------------------------------------
		public function XSubTextureManager (__XApp:XApp, __width:Number=2048, __height:Number=2048) {
			m_XApp = __XApp;
			
			TEXTURE_WIDTH = __width;
			TEXTURE_HEIGHT = __height;
			
			m_count = 0;
			
			m_queue = new XDict ();
			
			m_XApp.getXTaskManager ().addTask ([
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
				
					function ():void {
						m_queue.forEach (
							function (x:*):void {
								var __className:String = x as String;
								var __class:Class = m_XApp.getClass (__className);
							
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
				var __movieClipMetadata:Array = m_movieClips.get (__className);
				
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
		public function createTexture (__className:String, __class:Class):void {	
		}
		
		//------------------------------------------------------------------------------------------
		public function createMovieClip (__className:String):starling.display.MovieClip {
			if (!isQueued (__className)) {
				return null;
			}
			
			var __movieClipMetadata:Array = m_movieClips.get (__className);
			
			if (__movieClipMetadata.length == 0) {
				return null;
			}
			
			var __rect:Rectangle = __movieClipMetadata[0] as Rectangle;
			var __pivotX:Number = __rect.x; 
			var __pivotY:Number = __rect.y;
			
			var __textures:Vector.<Texture> = new Vector.<Texture> ();
			var __atlas:TextureAtlas;
			
			for (var i:Number=1; i<=__movieClipMetadata.length-1; i++) {
				__atlas = __movieClipMetadata[i] as TextureAtlas;
				 
				__textures = __textures.concat (__atlas.getTextures (__className));
			}

			var __movieClip:MovieClip = new MovieClip (__textures);
			
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
			
			// Checking filters in case we need to expand the outer bounds
			if (clip.filters.length > 0)
			{
				// filters
				var j:int = 0;
				//var clipFilters:Array = clipChild.filters.concat();
				var clipFilters:Array = clip.filters;
				var clipFiltersLength:int = clipFilters.length;
				var tmpBData:BitmapData;
				var filterRect:Rectangle;
				
				tmpBData = new BitmapData(realBounds.width, realBounds.height, false);
				filterRect = tmpBData.generateFilterRect(tmpBData.rect, clipFilters[j]);
				tmpBData.dispose();
				
				while (++j < clipFiltersLength)
				{
					tmpBData = new BitmapData(filterRect.width, filterRect.height, true, 0);
					filterRect = tmpBData.generateFilterRect(tmpBData.rect, clipFilters[j]);
					realBounds = realBounds.union(filterRect);
					tmpBData.dispose();
				}
			}
			
			realBounds.offset(bounds.x, bounds.y);
			realBounds.width = Math.max(realBounds.width, 1);
			realBounds.height = Math.max(realBounds.height, 1);
			
			tmpBData = null;
			return realBounds;
		}
		
	//------------------------------------------------------------------------------------------
	}
				
//------------------------------------------------------------------------------------------
}
