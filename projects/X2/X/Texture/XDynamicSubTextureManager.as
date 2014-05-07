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
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.*;
	
	import starling.display.*;
	import starling.textures.*;
	
	//------------------------------------------------------------------------------------------
	// this class takes one or more flash.display.MovieClip's and dynamically creates texture/atlases
	//------------------------------------------------------------------------------------------
	public class XDynamicSubTextureManager extends XSubTextureManager {
		protected var m_textures:Array;
		protected var m_currentTexture:RenderTexture;
		
		//------------------------------------------------------------------------------------------
		public function XDynamicSubTextureManager (__XApp:XApp, __width:Number=2048, __height:Number=2048) {
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
		public override function isDynamic ():Boolean {
			return true;	
		}
		
		//------------------------------------------------------------------------------------------
		public override function add (__className:String):void {
			trace (": XDynamicSubTextureManager: add: ", __className);
			
			var __class:Class = m_XApp.getClass (__className);
			
			m_movieClips.put (__className, []);
			
			if (__class != null) {
				createTexture (__className, __class);
				
				m_XApp.unloadClass (__className);
			}
			else
			{
				m_queue.put (__className, 0);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function createTexture (__className:String, __class:Class):void {	
			var __movieClip:flash.display.MovieClip = new (__class) ();
			
			var __scaleX:Number = 1.0;
			var __scaleY:Number = 1.0;
			var __padding:Number = 2.0;
			var __rect:Rectangle;
			var __realBounds:Rectangle;

			var i:Number;
			
			trace (": XDynamicSubTextureManager: totalFrames: ", __className, __movieClip.totalFrames);
			
			for (i=0; i<__movieClip.totalFrames; i++) {
				__movieClip.gotoAndStop (i+1);
				
				trace (": getBounds: ", i, __className, __getRealBounds (__movieClip));
				
				__realBounds = __getRealBounds (__movieClip);
				
				__rect = m_packer.quickInsert (
					(__realBounds.width * __scaleX) + __padding * 2, (__realBounds.height * __scaleY) + __padding * 2
				);
				
				if (__rect == null) {
					trace (": split @: ", m_count, __className, i);
					
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
				
				__image.x = __rect.x; __image.y = __rect.y;
				
				m_currentTexture.draw (__image);
				
				__bitmapData.dispose ();
				__image.texture.dispose ();
				
				m_currentAtlas.addRegion (__className + "_" + __generateIndex (i), __rect, new Rectangle (0, 0, __rect.width, __rect.height));
			}

			var __movieClipMetadata:Array = new Array ();
			__movieClipMetadata.push (__realBounds);
			
			for (i=0; i < m_atlases.length; i++) {
				var __atlas:TextureAtlas = m_atlases[i] as TextureAtlas;
				
				var __textures:Vector.<Texture> = __atlas.getTextures (__className);
				
				if (__textures.length) {
					__movieClipMetadata.push (__atlas);
				}
			}
			
			m_movieClips.put (__className, __movieClipMetadata);
		}	

		//------------------------------------------------------------------------------------------
		protected override function __begin ():void {
			m_packer = new MaxRectPacker (TEXTURE_WIDTH, TEXTURE_HEIGHT);
			
			m_currentTexture = new RenderTexture (TEXTURE_WIDTH, TEXTURE_HEIGHT);
			m_textures.push (m_currentTexture);

			m_currentAtlas = new TextureAtlas (m_currentTexture);
			m_atlases.push (m_currentAtlas);
			
			m_currentTexture.clear ();
			
			m_count++;
			
			trace (": XDynamicSubTextureManager: count: ", m_count);
		}
		
		//------------------------------------------------------------------------------------------
		protected override function __end ():void {		
		}

		
	//------------------------------------------------------------------------------------------
	}
				
//------------------------------------------------------------------------------------------
}
