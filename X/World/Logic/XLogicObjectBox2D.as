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
package X.World.Logic {

// Box2D classes
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import X.Geom.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Sprite.*;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.*;
	import flash.geom.*;
	
//------------------------------------------------------------------------------------------	
	public class XLogicObjectBox2D extends XLogicObject {
		public var m_bodyDef:b2BodyDef;
		public var m_body:b2Body;
		
//------------------------------------------------------------------------------------------
		public function XLogicObjectBox2D () {
		}
		
//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {			
			super.setup (__xxx, args);
					
			m_bodyDef = new b2BodyDef();
			m_bodyDef.userData = this;
		}
	
//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
		}
		
//------------------------------------------------------------------------------------------
		public override function setPos (__pos:XPoint):void {
			var __pos2:b2Vec2 = new b2Vec2 (__pos.x/30, __pos.y/30);
			
			m_body.SetXForm (__pos2, __getNativeAngle ());
		}
		
//------------------------------------------------------------------------------------------
		public override function getPos ():XPoint {
			var __pos2:b2Vec2 = m_body.GetPosition ();
			
			var __pos:XPoint = new XPoint (__pos2.x*30, __pos2.y*30);
			
			return __pos;
		}

//------------------------------------------------------------------------------------------		
		public function __getNativePos ():b2Vec2 {
			return m_body.GetPosition ()
		}
		
//------------------------------------------------------------------------------------------		
		public override function setRotation (__rotation:Number):void {	
			m_body.SetXForm (__getNativePos (), __rotation*Math.PI/180);
		}
			
//------------------------------------------------------------------------------------------	
		public override function getRotation ():Number {
			return __getNativeAngle ()*180/Math.PI;
		}
		
//------------------------------------------------------------------------------------------		
		public function __getNativeAngle ():Number {
			return m_body.GetAngle ();
		}
		
//------------------------------------------------------------------------------------------
// create collision
//------------------------------------------------------------------------------------------
		public function createShape ():void {
		}

//------------------------------------------------------------------------------------------
		public function createCollision ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function getCollisionInfo (__movieClip:Sprite):Array {		
			for (var i:uint = 0; i < __movieClip.numChildren; i++) {
				var x$:MovieClip = __movieClip.getChildAt (i) as MovieClip;
				
				if (x$ != null) {
					var __type:String = x$.name.substr (0, 2);
					
					if (__type == "x$") {
						x$.visible = false;
							
						var __rectCollision:XShapeRect = new XShapeRect ();
							
						__rectCollision.setup  (
							x$.x, x$.y, x$.width, x$.height, x$.rotation
							);
							
						return ["x$", __rectCollision];
					}
						
					if (__type == "c$") {
						x$.visible = false;
		
						var __circleCollision:XShapeCircle = new XShapeCircle ();
							
						__circleCollision.setup (
							x$.x, x$.y, x$.width
							);
							
						return ["c$", __circleCollision];		
					}	
				}
			}
			
			return null;
		}
		
//------------------------------------------------------------------------------------------
// get shape from MovieClip (rect)
//------------------------------------------------------------------------------------------
		public function getXShapeRectFromMovieClip (__movieClip:Sprite):XShapeRect {
			trace (": !: ", __movieClip.numChildren, __movieClip);
/*
			for (var i:uint = 0; i < __movieClip.numChildren; i++) {
				var x$:MovieClip = __movieClip.getChildAt (i) as MovieClip;
				
				if (x$ != null) {				
					if (x$.name.substr (0, 2) == "x$") {					
						x$.visible = false;
				
						var z$:XShapeRect = new XShapeRect ();
							
						z$.init (
							x$.x, x$.y, x$.width, x$.height, x$.rotation
						);
							
						return z$;
					}
				}
			}
*/
			return null;
		}

//------------------------------------------------------------------------------------------
// get shape from MovieClip (circle)
//------------------------------------------------------------------------------------------
		public function getXShapeCircleFromMovieClip (__movieClip:Sprite):XShapeCircle {
			trace (": !: ", __movieClip.numChildren, __movieClip);
/*
			for (var i:uint = 0; i < __movieClip.numChildren; i++) {
				var x$:MovieClip = __movieClip.getChildAt (i) as MovieClip;
							
				if (x$ != null) {						
					if (x$.name.substr (0, 2) == "x$") {					
						x$.visible = false;
		
						var z$:XShapeCircle = new XShapeCircle ();
							
						z$.init (
							x$.x, x$.y, x$.width
						);
										
						return z$;
					}
				}
			}
*/	
			return null;
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}	