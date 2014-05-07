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
package X.World.Sprite {
	
	import X.*;
	import X.Bitmap.*;
	import X.Geom.*;
	import X.World.*;
	
	import flash.geom.*;
	import flash.utils.*;
	
	import starling.display.*;
	import starling.textures.RenderTexture;
	
	//------------------------------------------------------------------------------------------	
	// starling equivalent of the XBitmap class.  Curently supports only a single texture.
	//------------------------------------------------------------------------------------------
	public class XImage extends Image implements XRegistration {
		public var m_frame:Number;
		public var m_scale:Number;
		public var m_visible:Boolean;
		public var m_pos:XPoint;
		public var m_rect:XRect;
		public var m_id:Number;
		public static var g_id:Number = 0;
		public var rp:XPoint;
		public static var g_XApp:XApp;
		
		//------------------------------------------------------------------------------------------
		include "..\\Sprite\\XRegistration_impl.h";
		
		//------------------------------------------------------------------------------------------
		public function XImage (__texture:RenderTexture) {
			super (__texture);
			
			m_pos = g_XApp.getXPointPoolManager ().borrowObject () as XPoint;
			m_rect = g_XApp.getXRectPoolManager ().borrowObject () as XRect;
			rp = g_XApp.getXPointPoolManager ().borrowObject () as XPoint;
			
			setRegistration ();
			
			m_scale = 1.0;
			m_visible = true;
			
			m_id = g_id++;
		}
		
		//------------------------------------------------------------------------------------------
		public function setup ():void {	
		}
		
		//------------------------------------------------------------------------------------------
		public function cleanup ():void {
			g_XApp.getXPointPoolManager ().returnObject (m_pos);
			g_XApp.getXPointPoolManager ().returnObject (m_rect);
			g_XApp.getXPointPoolManager ().returnObject (rp);
			
			if (texture) {
				texture.dispose ();
			}
			
			dispose ();
		}

		//------------------------------------------------------------------------------------------
		public static function setXApp (__XApp:XApp):void {
			g_XApp = __XApp;
		}
		
		//------------------------------------------------------------------------------------------
		public function getTexture ():RenderTexture {
			return texture as RenderTexture;
		}

		//------------------------------------------------------------------------------------------
		public function get id ():Number {
			return m_id;
		}
		
		//------------------------------------------------------------------------------------------
		public function get mouseX ():Number {
			return 0;
		}
		
		//------------------------------------------------------------------------------------------
		public function get mouseY ():Number {
			return 0;
		}
		
		//------------------------------------------------------------------------------------------
		public function get dx ():Number {
			return 0;
		}
		
		//------------------------------------------------------------------------------------------
		public function get dy ():Number {
			return 0;
		}
		
		//------------------------------------------------------------------------------------------
		public function viewPort (__canvasWidth:Number, __canvasHeight:Number):XRect {
			m_rect.x = -x/m_scale;
			m_rect.y = -y/m_scale;
			m_rect.width = __canvasWidth/m_scale;
			m_rect.height = __canvasHeight/m_scale;
			
			return m_rect;
		}
		
		//------------------------------------------------------------------------------------------
		public function getPos ():XPoint {
			m_pos.x = x2;
			m_pos.y = y2;
			
			return m_pos;
		}
		
		//------------------------------------------------------------------------------------------		
		public function setPos (__p:XPoint):void {
			x2 = __p.x;
			y2 = __p.y;
		}
		
		//------------------------------------------------------------------------------------------
		public function setScale (__scale:Number):void {
			m_scale = __scale;
			
			scaleX2 = __scale;
			scaleY2 = __scale;
		}
		
		//------------------------------------------------------------------------------------------
		public function getScale ():Number {
			return m_scale;
		}
		
		//------------------------------------------------------------------------------------------	
		public function set visible2 (__visible:Boolean):void {
			m_visible = __visible;
		}
		
		//------------------------------------------------------------------------------------------			
		public function get visible2 ():Boolean {
			return m_visible;
		}
		
		//------------------------------------------------------------------------------------------
	}
	
	//------------------------------------------------------------------------------------------
}
