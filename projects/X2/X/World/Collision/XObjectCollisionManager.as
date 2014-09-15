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
package X.World.Collision {
	
	import X.Collections.*;
	import X.Geom.*;
	import X.Pool.*;
	import X.World.XWorld;
	import X.XMap.*;
	
//------------------------------------------------------------------------------------------
	public class XObjectCollisionManager extends Object {
		protected var xxx:XWorld;
		protected var m_collisionLists:XDict;
		
//------------------------------------------------------------------------------------------
		public function XObjectCollisionManager (__xxx:XWorld) {
			super ();
			
			xxx = __xxx;
			
			m_collisionLists = new XDict ();
		}
		
//------------------------------------------------------------------------------------------
		public function setup ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function cleanup ():void {
			removeAllCollisionLists ();
		}

//------------------------------------------------------------------------------------------
		public function createCollisionList ():XObjectCollisionList {
			return new XObjectCollisionList ();	
		}
		
//------------------------------------------------------------------------------------------
		public function clearCollisions ():void {
			m_collisionLists.forEach (
				function (x:*):void {
					var __collisionList:XObjectCollisionList = x as XObjectCollisionList;
					
					__collisionList.clear ();
				}
			);
		}
	
//------------------------------------------------------------------------------------------
		public function addCollisionList ():XObjectCollisionList {
			var __collisionList:XObjectCollisionList = createCollisionList ();
			
			__collisionList.setup (xxx);
			
			m_collisionLists.put (__collisionList, 0);
			
			return __collisionList;
		}

//------------------------------------------------------------------------------------------
		public function removeCollisionList (__collisionList:XObjectCollisionList):void {
			__collisionList.cleanup ();
			
			m_collisionLists.remove (__collisionList);
		}
		
//------------------------------------------------------------------------------------------
		public function removeAllCollisionLists ():void {
			m_collisionLists.forEach (
				function (x:*):void {
					var __collisionList:XObjectCollisionList = x as XObjectCollisionList;
					
					__collisionList.cleanup ();
					
					m_collisionLists.remove (x);
				}
			);			
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
