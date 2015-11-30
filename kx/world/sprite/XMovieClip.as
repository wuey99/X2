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
package kx.world.sprite {
	
	import kx.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.type.*;
	import kx.texture.*;
	import kx.world.*;
	import kx.world.sprite.*;
	
	include "..\\..\\flash.h";
	
	import flash.display.Graphics;
	import flash.geom.*;
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------	
	public class XMovieClip extends XSprite {
		public var m_movieClip:MovieClip;
		public var m_className:String;
		
		//------------------------------------------------------------------------------------------
		public function XMovieClip () {
			super ();
			
			m_movieClip = null;
			m_className = "";
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup ():void {
			super.setup ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
			
			// <HAXE>
			/* --
			-- */
			// </HAXE>
			// <AS3>
			if (CONFIG::starling) {
				if (m_movieClip != null) {
					m_movieClip.removeFromParent (true);
			
					m_movieClip.dispose ();
	
					m_movieClip = null;
				}
			}
			// </AS3>
		}

		//------------------------------------------------------------------------------------------
		public function initWithMovieClip (__movieClip:MovieClip):void {
			m_movieClip = __movieClip;
			
			// <HAXE>
			/* --
			-- */
			// </HAXE>
			// <AS3>
			if (CONFIG::starling) {
				m_movieClip.touchable = true;
			}
			else
			// </AS3>
			{
				m_movieClip.mouseEnabled = false;
			}
			
			addChild (__movieClip);
		}
		
		//------------------------------------------------------------------------------------------
		public function initWithClassName (__xxx:XWorld, __XApp:XApp, __className:String):void {
			var __movieClip:MovieClip;
			
			m_className = __className;
			
			var __taskManager:XTaskManager =
				__xxx != null ? __xxx.getXTaskManager () : __XApp.getXTaskManager ();
			
			// <HAXE>
			/* --
			-- */
			// </HAXE>
			// <AS3>
			if (CONFIG::starling) {
				var __textureManager:XTextureManager =
					__xxx != null ? __xxx.getTextureManager () : __XApp.getTextureManager ();
							
				__movieClip = __textureManager.createMovieClip (__className);
				
				if (__movieClip == null) {
					__taskManager.addTask ([
						XTask.LABEL, "loop",
							XTask.WAIT, 0x0100,
						
							XTask.FLAGS, function (__task:XTask):void {
								__movieClip = __textureManager.createMovieClip (__className);
								
								__task.ifTrue (__movieClip != null);
							}, XTask.BNE, "loop",
							
							function ():void {
								initWithMovieClip (__movieClip);
								
								gotoAndStop (1);
							},
						
						XTask.RETN,
					]);
					
					return;
				}
			}
			else
			// </AS3>
			{
				var __class:Class /* <Dynamic> */ = __xxx.getClass (__className);
				
				if (__class != null) {
					__movieClip = XType.createInstance (__class);
				}
				else
				{
					__taskManager.addTask ([
						XTask.LABEL, "loop",
							XTask.WAIT, 0x0100,
							
							XTask.FLAGS, function (__task:XTask):void {
								__class = __xxx.getClass (__className);
								
								__task.ifTrue (__class != null);
							}, XTask.BNE, "loop",
						
							function ():void {
								__movieClip = XType.createInstance (__class);
								
								initWithMovieClip (__movieClip);
								
								gotoAndStop (1);
							},
							
						XTask.RETN,
					]);
					
					return;
				}
			}
			
			initWithMovieClip (__movieClip);
			
			gotoAndStop (1);	
		}
		
		//------------------------------------------------------------------------------------------
		public function getMovieClip ():MovieClip {
			return m_movieClip;
		}
			
		/* @:get, set movieclip MovieClip */
		
		public function get movieclip ():MovieClip {
			return m_movieClip;
		}
		
		public function set movieclip (__val:MovieClip): /* @:set_type */ void {
			m_movieClip = __val;
			
			/* @:set_return null; */			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		public function gotoAndPlay (__frame:int):void {
			// <HAXE>
			/* --
			-- */
			// </HAXE>
			// <AS3>
			if (CONFIG::starling) {
				if (m_movieClip != null) {
					if (__frame > m_movieClip.numFrames) {
						trace (": XMovieClip: ", m_className, " gotoAndPlay out of range @: ", __frame - 1);
						return;
					}
					m_movieClip.currentFrame = __frame-1;
					m_movieClip.play ();
				}
			}
			else
			// </AS3>
			{
				if (m_movieClip != null) {
					m_movieClip.gotoAndPlay (__frame);
				}
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function gotoAndStopAtLabel (__label:String) {
			// <HAXE>
			/* --
			-- */
			// </HAXE>
			// <AS3>
			if (CONFIG::starling) {	
			}
			else
			// </AS3>
			{
				m_movieClip.gotoAndStop (__label);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function gotoAndStop (__frame:int):void {
			// <HAXE>
			/* --
			-- */
			// </HAXE>
			// <AS3>
			if (CONFIG::starling) {
				if (m_movieClip != null) {
					if (__frame > m_movieClip.numFrames) {
						trace (": XMovieClip: ", m_className, " gotoAndStop out of range @: ", __frame - 1);
						return;
					}
					m_movieClip.currentFrame = __frame-1;
					m_movieClip.pause ();
				}
			}
			else
			// </AS3>
			{
				if (m_movieClip != null) {
					m_movieClip.gotoAndStop (__frame);
				}
			}
		}

		//------------------------------------------------------------------------------------------
		public function play ():void {
			if (m_movieClip != null) {
				m_movieClip.play ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function stop ():void {
			if (m_movieClip != null) {
				m_movieClip.stop ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		/* @:override get, set rotation Float */
		
		public override function get rotation ():Number {
			if (m_movieClip == null) {
				return 0.0;
			}
			
			// <HAXE>
			/* --
			-- */
			// </HAXE>
			// <AS3>
			if (CONFIG::starling) {
				return m_movieClip.rotation * 180/Math.PI;
			}
			else
			// </AS3>
			{
				return m_movieClip.rotation;
			}
		}
		
		public override function set rotation (__val:Number): /* @:set_type */ void {
			// <HAXE>
			/* --
			-- */
			// </HAXE>
			// <AS3>
			if (CONFIG::starling) {
				if (m_movieClip != null) {
					m_movieClip.rotation = __val * Math.PI/180;
				}
			}
			else
			// </AS3>
			{
				if (m_movieClip != null) {
					m_movieClip.rotation = __val;
				}
			}
			
			/* @:set_return m_movieClip.rotation; */			
		}
		/* @:end */

		//------------------------------------------------------------------------------------------
		/* @:override get, set alpha Float */
		
		public override function get alpha ():Number {
			if (m_movieClip == null) {
				return 1.0;
			}
			
			return m_movieClip.alpha;
		}
		
		public override function set alpha (__val:Number): /* @:set_type */ void {
			if (m_movieClip != null) {
				m_movieClip.alpha = __val;
			}
			
			/* @:set_return m_movieClip.alpha; */			
		}
		/* @:end */

		//------------------------------------------------------------------------------------------
// <HAXE>
/* --
-- */
// </HAXE>
// <AS3>
		if (CONFIG::starling) {
			public function get graphics ():Graphics {
				return null;
			}
		}
		else
		{
// </AS3>
			/* @:override get, set graphics Graphics */
			
			public override function get graphics ():Graphics {
				if (m_movieClip == null) {
					return null;
				}
				
				return m_movieClip.graphics;
			}
			
			public function set graphics (__val:Graphics): /* @:set_type */ void {
				
				/* @:set_return null; */			
			}
			/* @:end */
// <HAXE>
/* --
-- */
// </HAXE>
// <AS3>
		}
// </AS3>
		
		//------------------------------------------------------------------------------------------
		/* @:get, set dx Float */
		
		public function get dx ():Number {
			return 0;
		}
		
		public function set dx (__val:Number): /* @:set_type */ void {
			/* @:set_return 0; */			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		/* @:get, set dy Float */
		
		public function get dy ():Number {
			return 0;
		}
		
		public function set dy (__val): /* @:set_type */ void {
			/* @:set_return 0; */			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		/* @:override get, set scaleX Float */
		
		public override function get scaleX ():Number {
			if (m_movieClip == null) {
				return 1.0;
			}
			
			return m_movieClip.scaleX;
		}
		
		public override function set scaleX (__val:Number): /* @:set_type */ void {
			if (m_movieClip != null) {
				m_movieClip.scaleX = __val;
			}
			
			/* @:set_return m_movieClip.scaleX; */			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
		/* @:override get, set scaleY Float */
		
		public override function get scaleY ():Number {
			if (m_movieClip == null) {
				return 1.0;
			}
			
			return m_movieClip.scaleY;
		}		
		
		public override function set scaleY (__val:Number): /* @:set_type */ void {
			if (m_movieClip != null) {
				m_movieClip.scaleY = __val;
			}
			
			/* @:set_return m_movieClip.scaleY; */			
		}
		/* @:end */
		
		//------------------------------------------------------------------------------------------
	}
	
	//------------------------------------------------------------------------------------------
}
