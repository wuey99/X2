//------------------------------------------------------------------------------------------
// <$begin$/>
// <$end$/>
//------------------------------------------------------------------------------------------
package X.Game {
	
	import X.Collections.*;
	import X.Geom.*;
	import X.Pool.*;
	import X.World.XWorld;
	import X.XMap.*;
	
//------------------------------------------------------------------------------------------
	public class XBulletCollisionManager extends Object {
		private var xxx:XWorld;
		private var m_collisionLists:XDict;
		
//------------------------------------------------------------------------------------------
		public function XBulletCollisionManager (__xxx:XWorld) {
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
		public function clearCollisions ():void {
			m_collisionLists.forEach (
				function (x:*):void {
					var __collisionList:XBulletCollisionList = x as XBulletCollisionList;
					
					__collisionList.clear ();
				}
			);
		}
	
//------------------------------------------------------------------------------------------
		public function addCollisionList ():XBulletCollisionList {
			var __collisionList:XBulletCollisionList = new XBulletCollisionList ();
			
			__collisionList.setup (xxx);
			
			m_collisionLists.put (__collisionList, 0);
			
			return __collisionList;
		}

//------------------------------------------------------------------------------------------
		public function removeCollisionList (__collisionList:XBulletCollisionList):void {
			__collisionList.cleanup ();
			
			m_collisionLists.remove (__collisionList);
		}
		
//------------------------------------------------------------------------------------------
		public function removeAllCollisionLists ():void {
			m_collisionLists.forEach (
				function (x:*):void {
					var __collisionList:XBulletCollisionList = x as XBulletCollisionList;
					
					__collisionList.cleanup ();
					
					m_collisionLists.remove (x);
				}
			);			
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
