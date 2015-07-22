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
package X.Texture {
	
	// X classes
	import X.Collections.*;
	import X.Task.*;
	import X.Type.*;
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
			var i:int;
			
			if (m_currentBitmap != null) {
				m_currentBitmap.dispose ();	
				m_currentBitmap = null;
			}
			
			if (m_atlases != null) {				
				for (i=0; i<m_atlases.length; i++) {
					m_atlases[i].dispose ();
				}
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function start ():void {
			reset ();
			
			m_movieClips = new XDict ();  // <String, Array>
			m_atlases = new Array (); // <TextureAtlas>
			
			__begin ();
		}
		 
		//------------------------------------------------------------------------------------------
		public override function finish ():void {
			__end ();
			
			m_movieClips.forEach (
				function (x:*):void {
					var __className:String = x as String;
					
					var __movieClipMetadata:Array /* <Dynanmic> */ = m_movieClips.get (__className);
					
					for (var i:int = 0; i < m_atlases.length; i++) {
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
			var __class:Class /* <Dynamic> */ = m_XApp.getClass (__className);
			
			m_movieClips.set (__className, []);
			
			if (__class != null) {
				createTexture (__className, __class);
				
				m_XApp.unloadClass (__className);
			}
			else
			{
				m_queue.set (__className, 0);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function createTexture (__className:String, __class:Class /* <Dynamic> */):void {	
			var __movieClip:flash.display.MovieClip = XType.createInstance (__class);
			
			var __scaleX:Number = 1.0;
			var __scaleY:Number = 1.0;
			var __padding:Number = 2.0;
			var __rect:Rectangle;
			var __realBounds:Rectangle;

			var i:int;
			
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

			var __movieClipMetadata:Array /* <Rectangle> */ = new Array (); // <Rectangle>
			__movieClipMetadata.push (__realBounds);
			
			m_movieClips.set (__className, __movieClipMetadata);
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
			if (m_currentBitmap != null) {
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
