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
		protected var m_textures:Array;
		protected var m_atlases:Array;
		
		protected var m_currentAtlas:TextureAtlas;
		protected var m_currentAtlasText:String;
		protected var m_currentBitmap:BitmapData;
		
		protected var m_packer:MaxRectPacker;
		
		protected var TEXTURE_WIDTH:Number = 2048;
		protected var TEXTURE_HEIGHT:Number = 2048;
			
		//------------------------------------------------------------------------------------------
		public function XSubTextureManager (__XApp:XApp, __width:Number=2048, __height:Number=2048) {
			m_XApp = __XApp;
			
			TEXTURE_WIDTH = __width;
			TEXTURE_HEIGHT = __height;
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
			__end ();
			
			m_movieClips.forEach (
				function (x:*):void {
					var __className:String = x as String;
					
					var __movieClipMetadata:Array = m_movieClips.get (__className);
						
					for (var i:Number = 0; i <m_atlases.length; i++) {
						var __atlas:TextureAtlas = m_atlases[i] as TextureAtlas;
						
						var __texture:Texture = __atlas.getTexture (__className + "_" + __generateIndex (0));
						
						if (__texture) {
							__movieClipMetadata.push (__atlas);
						}
					}
				}
			);	
		}
		 
		//------------------------------------------------------------------------------------------
		public function add (__className:String):void {	
		}	

		//------------------------------------------------------------------------------------------
		public function isQueued (__className:String):Boolean {
			return false;	
		}
		
		//------------------------------------------------------------------------------------------
		public function movieClipExists (__className:String):Boolean {
			return m_movieClips.exists (__className);
		}
		
		//------------------------------------------------------------------------------------------
		public function createMovieClip (__className:String):starling.display.MovieClip {
			if (!m_movieClips.exists (__className)) {
				throw (new Error (": unable to find XMovieClip: " + __className));
			}
			
			var __movieClipMetadata:Array = m_movieClips.get (__className);
			
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
