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
		public var m_movieclip:MovieClip;
		
		//------------------------------------------------------------------------------------------
		public function XMovieClip () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public function setup (__movieclip:MovieClip):void {
			m_movieclip = __movieclip;
			
			addChild (__movieclip);
		}
		
		//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}

		//------------------------------------------------------------------------------------------
		public function getMovieClip ():MovieClip {
			return m_movieclip;
		}
		
		public function set movieclip (__value:MovieClip):void {
			m_movieclip = __value;
		}
		
		public function get movieclip ():MovieClip {
			return m_movieclip;
		}
		
		//------------------------------------------------------------------------------------------
		public function gotoAndPlay (__frame:Number):void {
			if (CONFIG::starling) {
				m_movieclip.currentFrame = __frame;
				m_movieclip.stop ();
			}
			else
			{
				m_movieclip.gotoAndPlay (__frame);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function gotoAndStop (__frame:Number):void {
			if (CONFIG::starling) {
				m_movieclip.currentFrame = __frame;
				m_movieclip.stop ();
			}
			else
			{
				m_movieclip.gotoAndStop (__frame);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function set rotation (__value:Number):void {
			m_movieclip.rotation = __value;
		}
		
		public override function get rotation ():Number {
			return m_movieclip.rotation;
		}

		//------------------------------------------------------------------------------------------
		public override function set alpha (__value:Number):void {
			m_movieclip.alpha = __value;
		}
		
		public override function get alpha ():Number {
			return m_movieclip.alpha;
		}
		
		//------------------------------------------------------------------------------------------
		if (CONFIG::starling) {
		}
		else
		{
			public override function get graphics ():Graphics {
				return m_movieclip.graphics;
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function set scaleX (__value:Number):void {
			m_movieclip.scaleX = __value;
		}
		
		public override function get scaleX ():Number {
			return m_movieclip.scaleX;
		}
		
		//------------------------------------------------------------------------------------------
		public override function set scaleY (__value:Number):void {
			m_movieclip.scaleY = __value;
		}
		
		public override function get scaleY ():Number {
			return m_movieclip.scaleY;
		}		
		
		//------------------------------------------------------------------------------------------
	}
	
	//------------------------------------------------------------------------------------------
}
