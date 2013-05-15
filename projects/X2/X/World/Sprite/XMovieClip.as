//------------------------------------------------------------------------------------------
package X.World.Sprite {
	
	import X.*;
	import X.Geom.*;
	import X.World.*;
	import X.World.Sprite.*;
	import X.Texture.*;
	
	import flash.geom.*;
	import flash.utils.*;
	
	include "..\\..\\flash.h";
	import flash.display.Graphics;
	
	//------------------------------------------------------------------------------------------	
	public class XMovieClip extends XSprite {
		public var m_movieClip:MovieClip;
		
		//------------------------------------------------------------------------------------------
		public function XMovieClip () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public function setup ():void {
		}
		
		//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}

		//------------------------------------------------------------------------------------------
		public function initWithMovieClip (__movieclip:MovieClip):void {
			m_movieClip = __movieclip;
			
			addChild (__movieclip);
		}
		
		//------------------------------------------------------------------------------------------
		public function initWithClassName (__xxx:XWorld, __XApp:XApp, __className:String):void {
			var __movieClip:MovieClip;
			
			var __textureManager:XTextureManager =
				__xxx != null ? __xxx.getTextureManager () : __XApp.getTextureManager ();
			
			if (CONFIG::starling) {
				__movieClip = __textureManager.createMovieClip (__className);
			}
			else
			{
				__movieClip = new (xxx.getClass (__className)) ();
			}
			
			initWithMovieClip (__movieClip);
			
			gotoAndStop (1);	
		}
		
		//------------------------------------------------------------------------------------------
		public function getMovieClip ():MovieClip {
			return m_movieClip;
		}
		
		public function set movieclip (__value:MovieClip):void {
			m_movieClip = __value;
		}
		
		public function get movieclip ():MovieClip {
			return m_movieClip;
		}
		
		//------------------------------------------------------------------------------------------
		public function gotoAndPlay (__frame:Number):void {
			if (CONFIG::starling) {
				m_movieClip.currentFrame = __frame-1;
				m_movieClip.play ();
			}
			else
			{
				m_movieClip.gotoAndPlay (__frame);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function gotoAndStop (__frame:Number):void {
			if (CONFIG::starling) {
				m_movieClip.currentFrame = __frame-1;
				m_movieClip.pause ();
			}
			else
			{
				m_movieClip.gotoAndStop (__frame);
			}
		}

		//------------------------------------------------------------------------------------------
		public function play ():void {
			m_movieClip.play ();
		}
		
		//------------------------------------------------------------------------------------------
		public function stop ():void {
			m_movieClip.stop ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function set rotation (__value:Number):void {
			if (CONFIG::starling) {
				m_movieClip.rotation = __value * Math.PI/180;
			}
			else
			{
				m_movieClip.rotation = __value;
			}
		}
		
		public override function get rotation ():Number {
			if (CONFIG::starling) {
				return m_movieClip.rotation * 180/Math.PI;
			}
			else
			{
				m_movieClip.rotation = __value;
			}
		}

		//------------------------------------------------------------------------------------------
		public override function set alpha (__value:Number):void {
			m_movieClip.alpha = __value;
		}
		
		public override function get alpha ():Number {
			return m_movieClip.alpha;
		}
		
		//------------------------------------------------------------------------------------------
		if (CONFIG::starling) {
			public function get graphics ():Graphics {
				return null;
			}
		}
		else
		{
			public override function get graphics ():Graphics {
				return m_movieClip.graphics;
			}
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
		public override function set scaleX (__value:Number):void {
			m_movieClip.scaleX = __value;
		}
		
		public override function get scaleX ():Number {
			return m_movieClip.scaleX;
		}
		
		//------------------------------------------------------------------------------------------
		public override function set scaleY (__value:Number):void {
			m_movieClip.scaleY = __value;
		}
		
		public override function get scaleY ():Number {
			return m_movieClip.scaleY;
		}		
		
		//------------------------------------------------------------------------------------------
	}
	
	//------------------------------------------------------------------------------------------
}
