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
package X.Pool {
	
	import X.Pool.*;
	import X.Collections.*;
	import X.World.*;
	
//------------------------------------------------------------------------------------------	
	public class XClassPoolManager extends Object {
		private var m_pools:XDict;
		
//------------------------------------------------------------------------------------------
		public function XClassPoolManager () {
			m_pools = new XDict ();
		}

//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}

//------------------------------------------------------------------------------------------
		public function setupPool (
			__class:Class,
			__numObjects:Number,
			__overflow:Number
		):XObjectPoolManager {
			
			return new XObjectPoolManager (
				function ():* {
					return new __class ();
				},
				
				function (__src:*, __dst:*):* {
					return null;
				},
				
				__numObjects, __overflow,
				
				function (x:*):void {
				}
			);
		}

//------------------------------------------------------------------------------------------
		public function preAllocate (__class:Class, __numObjects:Number):void {
			var __pool:XObjectPoolManager;
			
			if (!m_pools.exists (__class)) {
				__pool = setupPool (__class, 16, 16);
				
				m_pools.put (__class, __pool);
			}	
			
			__pool = m_pools.get (__class);
			
			var i:Number;
			
			for (i=0; i<__numObjects; i++) {
				__pool.borrowObject ();
			}
			
			returnAllObjects (__class);
		}
		
//------------------------------------------------------------------------------------------
		public function returnAllObjects (__class:Class = null):void {
			var __pool:XObjectPoolManager;
			
			if (__class) {
				if (m_pools.exists (__class)) {
					__pool = m_pools.get (__class);
					
					__pool.returnAllObjects ();
				}
			}
			else
			{
				m_pools.forEach (
					function (x:*):void {
						__pool = m_pools.get (__class);
						
						__pool.returnAllObjects ();
					}
				);
			}
		}		
		
//------------------------------------------------------------------------------------------
		public function returnObject (__class:Class, __object:Object):void {
			var __pool:XObjectPoolManager;
			
			if (m_pools.exists (__class)) {
				__pool = m_pools.get (__class);
				
				__pool.returnObject (__object);
			}
		}

//------------------------------------------------------------------------------------------
		public function borrowObject (__class:Class):Object {
			var __pool:XObjectPoolManager;
			
			if (!m_pools.exists (__class)) {
				__pool = setupPool (__class, 16, 16);
				
				m_pools.put (__class, __pool);
			}
			else
			{
				__pool = m_pools.get (__class);
			}
			
			return __pool.borrowObject ();
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
