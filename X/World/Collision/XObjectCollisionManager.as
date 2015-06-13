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
package X.World.Collision {
	
	import X.Collections.*;
	import X.Geom.*;
	import X.Pool.*;
	import X.World.XWorld;
	import X.XMap.*;
	
//------------------------------------------------------------------------------------------
	public class XObjectCollisionManager extends Object {
		protected var xxx:XWorld;
		protected var m_collisionLists:XDict; // <XObjectCollisionList, Int>
		
//------------------------------------------------------------------------------------------
		public function XObjectCollisionManager (__xxx:XWorld) {
			super ();
			
			xxx = __xxx;
			
			m_collisionLists = new XDict (); // <XObjectCollisionList, Int>
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
