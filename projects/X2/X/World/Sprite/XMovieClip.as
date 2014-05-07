//------------------------------------------------------------------------------------------
// Copyright (C) 2014 Jimmy Huey
//
// Some Rights Reserved.
//
// The "X-Engine" is licensed under a Creative Commons
// Attribution-Share Alike 3.0 United States License.
// (CC BY-SA 3.0)
//
// You are free to:
//
//      SHARE - to copy, distribute, display and perform the work.
//      ADAPT - remix, transform build upon this material, even for commercial works.
//
//      The licensor cannot revoke these freedoms as long as you follow the license terms.
//
// Under the following terms:
//
//      ATTRIBUTION — 
//      You must give appropriate credit, provide a link to the license, and
//      indicate if changes were made.  You may do so in any reasonable manner,
//      but not in any way that suggests the licensor endorses you or your use.
//
//      SHARE-ALIKE -
//      If you remix, transform, or build upon the material, you must
//      distribute your contributions under the same license as the original.
//
// No additional restrictions — You may not apply legal terms or technological measures
// that legally restrict others from doing anything the license permits. 
//
// The full summary can be located at:
// http://creativecommons.org/licenses/by-sa/3.0/us/ 
//
// The human-readable summary of the Legal Code can be located at:
// http://creativecommons.org/licenses/by-sa/3.0/us/legalcode
//------------------------------------------------------------------------------------------
package X.World.Sprite {
	
	import X.*;
	import X.Geom.*;
	import X.Task.*;
	import X.Texture.*;
	import X.World.*;
	import X.World.Sprite.*;
	
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
			
			if (CONFIG::starling) {
				if (m_movieClip) {
					m_movieClip.removeFromParent (true);
			
					m_movieClip.dispose ();
	
					m_movieClip = null;
				}
			}
		}

		//------------------------------------------------------------------------------------------
		public function initWithMovieClip (__movieClip:MovieClip):void {
			m_movieClip = __movieClip;
			
			if (CONFIG::starling) {
				m_movieClip.touchable = true;
			}
			else
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
								
								__task.ifTrue (__movieClip);
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
			{
				var __class:Class = __xxx.getClass (__className);
				
				if (__class) {
					__movieClip = new (__class) ();
				}
				else
				{
					__taskManager.addTask ([
						XTask.LABEL, "loop",
							XTask.WAIT, 0x0100,
							
							XTask.FLAGS, function (__task:XTask):void {
								__class = __xxx.getClass (__className);
								
								__task.ifTrue (__class);
							}, XTask.BNE, "loop",
						
							function ():void {
								__movieClip = new (__class) ();
								
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
		
		public function set movieclip (__value:MovieClip):void {
			m_movieClip = __value;
		}
		
		public function get movieclip ():MovieClip {
			return m_movieClip;
		}
		
		//------------------------------------------------------------------------------------------
		public function gotoAndPlay (__frame:Number):void {
			if (CONFIG::starling) {
				if (m_movieClip) {
					if (__frame > m_movieClip.numFrames) {
						trace (": XMovieClip: ", m_className, " gotoAndPlay out of range @: ", __frame - 1);
						return;
					}
					m_movieClip.currentFrame = __frame-1;
					m_movieClip.play ();
				}
			}
			else
			{
				if (m_movieClip) {
					m_movieClip.gotoAndPlay (__frame);
				}
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function gotoAndStopAtLabel (__label:String) {
			if (CONFIG::starling) {	
			}
			else
			{
				m_movieClip.gotoAndStop (__label);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function gotoAndStop (__frame:Number):void {
			if (CONFIG::starling) {
				if (m_movieClip) {
					if (__frame > m_movieClip.numFrames) {
						trace (": XMovieClip: ", m_className, " gotoAndStop out of range @: ", __frame - 1);
						return;
					}
					m_movieClip.currentFrame = __frame-1;
					m_movieClip.pause ();
				}
			}
			else
			{
				if (m_movieClip) {
					m_movieClip.gotoAndStop (__frame);
				}
			}
		}

		//------------------------------------------------------------------------------------------
		public function play ():void {
			if (m_movieClip) {
				m_movieClip.play ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function stop ():void {
			if (m_movieClip) {
				m_movieClip.stop ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function set rotation (__value:Number):void {
			if (!m_movieClip) {
				return;
			}
			
			if (CONFIG::starling) {
				m_movieClip.rotation = __value * Math.PI/180;
			}
			else
			{
				m_movieClip.rotation = __value;
			}
		}
		
		public override function get rotation ():Number {
			if (!m_movieClip) {
				return 0.0;
			}
			
			if (CONFIG::starling) {
				return m_movieClip.rotation * 180/Math.PI;
			}
			else
			{
				return m_movieClip.rotation;
			}
		}

		//------------------------------------------------------------------------------------------
		public override function set alpha (__value:Number):void {
			if (!m_movieClip) {
				return;
			}
			
			m_movieClip.alpha = __value;
		}
		
		public override function get alpha ():Number {
			if (!m_movieClip) {
				return 1.0;
			}
			
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
				if (!m_movieClip) {
					return null;
				}
				
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
			if (!m_movieClip) {
				return;
			}
			
			m_movieClip.scaleX = __value;
		}
		
		public override function get scaleX ():Number {
			if (!m_movieClip) {
				return 1.0;
			}
			
			return m_movieClip.scaleX;
		}
		
		//------------------------------------------------------------------------------------------
		public override function set scaleY (__value:Number):void {
			if (!m_movieClip) {
				return;
			}
			
			m_movieClip.scaleY = __value;
		}
		
		public override function get scaleY ():Number {
			if (!m_movieClip) {
				return 1.0;
			}
			
			return m_movieClip.scaleY;
		}		
		
		//------------------------------------------------------------------------------------------
	}
	
	//------------------------------------------------------------------------------------------
}
