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
	public class XStaticSubTextureManager extends XSubTextureManager {
		protected var m_currentBitmap:BitmapData;
		protected var m_currentAtlasText:String;
		
		//------------------------------------------------------------------------------------------
		public function XStaticSubTextureManager (__XApp:XApp, __width:Number=2048, __height:Number=2048) {
			super (__XApp, __width, __height);
		}
		
		//------------------------------------------------------------------------------------------
		public override function reset ():void {
			var i:Number;
			
			if (m_currentBitmap) {
				m_currentBitmap.dispose ();	
				m_currentBitmap = null;
			}
			
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
			m_atlases = new Array ();
			
			__begin ();
		}
		 
		//------------------------------------------------------------------------------------------
		public override function finish ():void {
			__end ();
			
			m_movieClips.forEach (
				function (x:*):void {
					var __className:String = x as String;
					
					var __movieClipMetadata:Array = m_movieClips.get (__className);
					
					for (var i:Number = 0; i < m_atlases.length; i++) {
						var __atlas:TextureAtlas = m_atlases[i] as TextureAtlas;
						
						var __textures:Vector.<Texture> = __atlas.getTextures (__className);
						
						if (__textures.length) {
							__movieClipMetadata.push (__atlas);
						}
					}
				}
			);	
		}
		
		//------------------------------------------------------------------------------------------
		public override function isDynamic ():Boolean {
			return false;	
		}
		
		//------------------------------------------------------------------------------------------
		public override function add (__className:String):void {
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
			
			trace (": XStaticSubTextureManager: totalFrames: ", __className, __movieClip.totalFrames);
			
			for (i=0; i<__movieClip.totalFrames; i++) {
				__movieClip.gotoAndStop (i+1);
				
				trace (": getBounds: ", __className, __getRealBounds (__movieClip));
				
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
				
				trace (": rect: ", __rect);
				
				var __matrix:Matrix = new Matrix ();
				__matrix.scale (__scaleX, __scaleY);
				__matrix.translate (__rect.x - __realBounds.x, __rect.y - __realBounds.y)
				m_currentBitmap.draw (__movieClip, __matrix);
				
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
		protected override  function __begin ():void {
			var __rect:Rectangle = new Rectangle (0, 0, TEXTURE_WIDTH, TEXTURE_HEIGHT);
			m_currentBitmap = new BitmapData (TEXTURE_WIDTH, TEXTURE_HEIGHT);
			m_currentBitmap.fillRect (__rect, 0x00000000);
			
			m_packer = new MaxRectPacker (TEXTURE_WIDTH, TEXTURE_HEIGHT);
			
			m_currentAtlasText = "";
			
			m_count++;
			
			trace (": XStaticSubTextureManager: count: ", m_count);
		}
		
		//------------------------------------------------------------------------------------------
		protected override function __end ():void {
			if (m_currentBitmap) {
				m_currentAtlasText = '<TextureAtlas imagePath="atlas.png">' + m_currentAtlasText + "</TextureAtlas>";
				var __atlasXML:XML = new XML (m_currentAtlasText);
				
				trace (": atlasXML: ", m_currentAtlasText);
				
				var __texture:Texture = Texture.fromBitmapData (m_currentBitmap, false);
				var __atlas:TextureAtlas = new TextureAtlas (__texture, __atlasXML);

				m_atlases.push (__atlas);
				
				m_currentBitmap.dispose ();
				m_currentBitmap = null;
			}			
		}
		
	//------------------------------------------------------------------------------------------
	}
				
//------------------------------------------------------------------------------------------
}
