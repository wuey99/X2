//------------------------------------------------------------------------------------------
package X.World.Sprite {
	
	import X.*;
	import X.Geom.*;
	import X.World.*;
	import X.World.Sprite.*;
	
	import flash.geom.*;
	import flash.utils.*;
	
	include "..\\..\\flash.h";
	
	//------------------------------------------------------------------------------------------	
	public class XMovieClip extends XSprite {
		public var m_movieClip:MovieClip;
		
		//------------------------------------------------------------------------------------------
		public function XMovieClip () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public function setup (__movieclip:MovieClip):void {
			m_movieClip = __movieclip;
			
			addChild (__movieclip);
		}
		
		//------------------------------------------------------------------------------------------
		public function cleanup ():void {
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
				m_movieClip.currentFrame = __frame;
				m_movieClip.stop ();
			}
			else
			{
				m_movieClip.gotoAndPlay (__frame);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function gotoAndStop (__frame:Number):void {
			if (CONFIG::starling) {
				m_movieClip.currentFrame = __frame;
				m_movieClip.stop ();
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
			m_movieClip.rotation = __value;
		}
		
		public override function get rotation ():Number {
			return m_movieClip.rotation;
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
		}
		else
		{
			public override function get graphics ():Graphics {
				return m_movieClip.graphics;
			}
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