//------------------------------------------------------------------------------------------
package X.Texture {
	
	// X classes
	import X.Collections.*;
	import X.Task.*;
	import X.World.Sprite.*;
	import X.XApp;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.*;
	
	import starling.display.*;
	import starling.textures.*;
	
	//------------------------------------------------------------------------------------------
	// this class takes one or more flash.display.MovieClip's and dynamically creates texture/atlases
	//------------------------------------------------------------------------------------------
	public class XSubDynamicTextureManager extends XSubTextureManager {
		protected var m_textures:Array;
		protected var m_currentTexture:RenderTexture;
		
		//------------------------------------------------------------------------------------------
		public function XSubDynamicTextureManager (__XApp:XApp, __width:Number=2048, __height:Number=2048) {
			super (__XApp, __width, __height);
		}
		
		//------------------------------------------------------------------------------------------
		public override function reset ():void {
			var i:Number;
			
			if (m_atlases) {				
				for (i=0; i<m_atlases.length; i++) {
					m_atlases[i].dispose ();
				}
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function start ():void {
			reset ();
			
			m_movieClips = new XDict ();
			m_textures = new Array ();
			m_atlases = new Array ();
			
			__begin ();
		}
		 
		//------------------------------------------------------------------------------------------
		public override function add (__className:String):void {	
			var __movieClip:flash.display.MovieClip = new (m_XApp.getClass (__className)) ();
			
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
	
				var __matrix:Matrix = new Matrix ();
				__matrix.scale (__scaleX, __scaleY);
				__matrix.translate (-__realBounds.x*__scaleX, -__realBounds.y*__scaleY);
				
				var __bitmapData:BitmapData = new BitmapData (__rect.width, __rect.height);
				var __fillRect:Rectangle = new Rectangle (0, 0, __rect.width, __rect.height);
				__bitmapData.fillRect (
					__fillRect, 0x00000000
				);
				
				__bitmapData.draw (__movieClip, __matrix);
				
				var __bitmap:Bitmap = new Bitmap (__bitmapData);
				var __image:Image = Image.fromBitmap (__bitmap);
				
				__bitmapData.dispose ();
				
				__image.x = __rect.x; __image.y = __rect.y;
				
				m_currentTexture.draw (__image);
				
				var __subText:String = '<SubTexture name="'+__className+'_' + __generateIndex (i) + '" ' +
					'x="'+__rect.x+'" y="'+__rect.y+'" width="'+__rect.width+'" height="'+__rect.height+'" frameX="0" frameY="0" ' +
					'frameWidth="'+__rect.width+'" frameHeight="'+__rect.height+'"/>';
				
				m_currentAtlasText = m_currentAtlasText + __subText;
			}

			var __movieClipMetadata:Array = new Array ();
			__movieClipMetadata.push (__realBounds);
			
			m_movieClips.put (__className, __movieClipMetadata);
		}	

		//------------------------------------------------------------------------------------------
		protected override function __begin ():void {
			m_packer = new MaxRectPacker (TEXTURE_WIDTH, TEXTURE_HEIGHT);
			
			m_currentAtlasText = "";
			
			m_currentTexture = new RenderTexture (TEXTURE_WIDTH, TEXTURE_HEIGHT);
			m_textures.push (m_currentTexture);
			
			m_currentTexture.clear ();
		}
		
		//------------------------------------------------------------------------------------------
		protected override function __end ():void {
			if (1) {
				m_currentAtlasText = '<TextureAtlas imagePath="atlas.png">' + m_currentAtlasText + "</TextureAtlas>";
				var __atlasXML:XML = new XML (m_currentAtlasText);
				
				trace (": atlasXML: ", m_currentAtlasText);
				
				var __atlas:TextureAtlas = new TextureAtlas (m_currentTexture, __atlasXML);
				m_atlases.push (__atlas);
			}			
		}

		
	//------------------------------------------------------------------------------------------
	}
				
//------------------------------------------------------------------------------------------
}
