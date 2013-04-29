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
		private var m_textures:XDict;
		private var m_atlases:XDict;
		
		private var m_texture:Texture;
		private var m_atlas:TextureAtlas;
		private var m_bitmap:BitmapData;
		private var m_packer:MaxRectPacker;
			
		//------------------------------------------------------------------------------------------
		public function XMovieClipManager (__XApp:XApp) {
			m_movieClips = new XDict ();
			m_textures = new XDict ();
			m_atlases = new XDict ();
			
			m_bitmap = null;
			
			m_packer = new MaxRectPacker (2048, 2048);
			
			__createNewTexture ();
		}

		//------------------------------------------------------------------------------------------
		public function add (__name:String):void {	
			var __movieClip:flash.display.MovieClip = new (m_XApp.getClass (__name)) ();
			
			var __scaleX:Number = 1.0;
			var __scaleY:Number = 1.0;
			var __padding:Number = 2.0;
			var __rect:Rectangle;
			
			var i:Number;
			
			for (i=0; i<__movieClip.totalFrames; i++) {
				__movieClip.gotoAndStop (i+1);
				
				__rect = m_packer.quickInsert (
					(__movieClip.width * __scaleX) + __padding * 2, (__movieClip.height * __scaleY) + __padding * 2
				);
				
				__rect.x += __padding;
				__rect.y += __padding;
				__rect.width -= __padding * 2;
				__rect.height -= __padding * 2;
				
				var __matrix:Matrix = new Matrix ();
				__matrix.scale (__scaleX, __scaleY);
				__matrix.translate (__rect.x, __rect.y)
				m_bitmap.draw (__movieClip, __matrix);
			}
		}	
		
		//------------------------------------------------------------------------------------------
		public function getXMovieClip (__name:String):XMovieClip {
			return null;
		}

		//------------------------------------------------------------------------------------------
		private function __createNewTexture ():void {
			if (m_bitmap) {
				m_bitmap.dispose ();
			}
		}
		
	//------------------------------------------------------------------------------------------
	}
				
//------------------------------------------------------------------------------------------
}
