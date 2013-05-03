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
	public class XMovieClipManager extends Object {
		private var m_XApp:XApp;
		
		private var m_movieClips:XDict;
		private var m_textures:Array;
		private var m_atlases:Array;
		
		private var m_texture:Texture;
		private var m_atlas:TextureAtlas;
		private var m_atlasText:String;
		private var m_bitmap:BitmapData;
		private var m_packer:MaxRectPacker;
		
		private const TEXTURE_WIDTH:Number = 1024;
		private const TEXTURE_HEIGHT:Number = 1024;
			
		//------------------------------------------------------------------------------------------
		public function XMovieClipManager () {
		}

		//------------------------------------------------------------------------------------------
		public function setup (__XApp:XApp):void {
			m_XApp = __XApp;
			
			m_movieClips = new XDict ();
			m_textures = new Array ();
			m_atlases = new Array ();
			
			__begin ();
		}
		
		//------------------------------------------------------------------------------------------
		public function cleanup ():void {	
		}

		//------------------------------------------------------------------------------------------
		public function end ():void {
			__end ();
		}
		 
		//------------------------------------------------------------------------------------------
		public function add (__name:String):void {	
			var __movieClip:flash.display.MovieClip = new (m_XApp.getClass (__name)) ();
			
			var __scaleX:Number = 1.0;
			var __scaleY:Number = 1.0;
			var __padding:Number = 2.0;
			var __rect:Rectangle;
			var __realBounds:Rectangle;
			
			var i:Number;
			
			for (i=0; i<__movieClip.totalFrames; i++) {
				__movieClip.gotoAndStop (i+1);
				
				trace (": getBounds: ", __getRealBounds (__movieClip));
				
				__realBounds = __getRealBounds (__movieClip);
				
				__rect = m_packer.quickInsert (
					(__realBounds.width * __scaleX) + __padding * 2, (__realBounds.height * __scaleY) + __padding * 2
				);
				
				if (__rect == null) {
					__end (); __begin ();
					
					__rect = m_packer.quickInsert (
						(__realBounds.width * __scaleX) + __padding * 2, (__realBounds.height * __scaleY) + __padding * 2
					);
				}
				
				__rect.x += __padding;
				__rect.y += __padding;
				__rect.width -= __padding * 2;
				__rect.height -= __padding * 2;
				
				trace (": rect: ", __rect);
				
				var __matrix:Matrix = new Matrix ();
				__matrix.scale (__scaleX, __scaleY);
				__matrix.translate (__rect.x - __realBounds.x, __rect.y - __realBounds.y)
				m_bitmap.draw (__movieClip, __matrix);
				
				var __subText:String = '<SubTexture name="'+__name+'_' + __generateIndex (i) + '" ' +
					'x="'+__rect.x+'" y="'+__rect.y+'" width="'+__rect.width+'" height="'+__rect.height+'" frameX="0" frameY="0" ' +
					'frameWidth="'+__rect.width+'" frameHeight="'+__rect.height+'"/>';
				
				m_atlasText = m_atlasText + __subText;
			}
			
			function __generateIndex (__index:int):String {
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
		}	
		
		//------------------------------------------------------------------------------------------
		public function getXMovieClip (__name:String):XMovieClip {
			return null;
		}

		//------------------------------------------------------------------------------------------
		public function getBitmapData ():BitmapData {
			return m_bitmap;
		}
		
		//------------------------------------------------------------------------------------------
		private function __begin ():void {
			var __rect:Rectangle = new Rectangle (0, 0, TEXTURE_WIDTH, TEXTURE_HEIGHT);
			m_bitmap = new BitmapData (TEXTURE_WIDTH, TEXTURE_HEIGHT);
			m_bitmap.fillRect (__rect, 0x00000000);
			
			m_packer = new MaxRectPacker (TEXTURE_WIDTH, TEXTURE_HEIGHT);
			
			m_atlasText = "";
		}
		
		//------------------------------------------------------------------------------------------
		private function __end ():void {
			if (m_bitmap) {
				m_atlasText = '<TextureAtlas imagePath="atlas.png">' + m_atlasText + "</TextureAtlas>";
				var __atlasXML:XML = new XML (m_atlasText);
				
				trace (": atlasXML: ", m_atlasText);
				
				/*
				var __texture:Texture = Texture.fromBitmapData (m_bitmap, false);
				var __atlas:TextureAtlas = new TextureAtlas (__texture, __atlasXML);
				
				m_textures.push (__texture);
				m_atlases.push (__atlas);
				*/
				
				m_bitmap.dispose ();
			}			
		}
		
		//------------------------------------------------------------------------------------------
		private function __getRealBounds(clip:flash.display.DisplayObject):Rectangle {
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
