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
package X.World.BG {

// Box2D classes
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import X.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	
	import flash.display.MovieClip;
	import flash.text.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------	
	public class BGSpriteStaticBodyCollision extends XLogicObjectBox2D {
		private var m_sprite:MovieClip;
		private var m_spriteClassName:String;
		
//------------------------------------------------------------------------------------------	
		public function BGSpriteStaticBodyCollision () {
		}

//------------------------------------------------------------------------------------------			
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			m_spriteClassName = args[0];
			
			createSprites ();
				
			createCollision ();
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
		}
		
//------------------------------------------------------------------------------------------
// create sprites
//------------------------------------------------------------------------------------------
		public override function createSprites ():void {		
			m_sprite = new (xxx.getClass (m_spriteClassName)) ();

// !STARLING!
			if (CONFIG::flash) {
				addSprite (m_sprite);
			}
			
			show ();
		}

//------------------------------------------------------------------------------------------
		public override function createCollision ():void {
		}
		
//------------------------------------------------------------------------------------------
// create collision
//------------------------------------------------------------------------------------------
		public function createShapeCircle ():void {
			var x$:XShapeCircle = getXShapeCircleFromMovieClip (m_sprite);
			
// create collision
			var m_shapeDef:b2CircleDef = new b2CircleDef();
			m_shapeDef.density = 1.0;
			m_shapeDef.friction = Math.random();
			m_shapeDef.restitution = 1;
			m_shapeDef.radius = x$.getRadius ();
			m_shapeDef.localPosition = x$.getPos ();
// create body			
			m_body = xxx.getWorld ().CreateDynamicBody(m_bodyDef);
			m_body.CreateShape(m_shapeDef);
			m_body.SetMassFromShapes();	
		}
		
//------------------------------------------------------------------------------------------
// create collision
//------------------------------------------------------------------------------------------
		public function createShapeRect ():void {
			var x$:XShapeRect = getXShapeRectFromMovieClip (m_sprite);	
	
// create collision
			var m_shapeDef:b2PolygonDef = new b2PolygonDef();
//			m_shapeDef.SetAsBox (x$.getWidth ()/2, x$.getHeight ()/2);
			trace (": x$: ", x$, ": width: ", x$.getWidth (), ", height: ", x$.getHeight ());
			var pos:b2Vec2 = x$.getPos ();
			pos.x *= m_sprite.scaleX;
			pos.y *= m_sprite.scaleY;
			m_shapeDef.SetAsOrientedBox (x$.getWidth ()/2*m_sprite.scaleX, x$.getHeight ()/2*m_sprite.scaleY, pos, x$.getAngle ()); 
			m_shapeDef.density = 1.0;
			m_shapeDef.friction = 0.5;
			m_shapeDef.restitution = 0.2;
// create body			
			m_body = xxx.getWorld ().CreateDynamicBody(m_bodyDef);
			m_body.CreateShape(m_shapeDef);
			m_body.SetMassFromShapes();	
		}

//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
