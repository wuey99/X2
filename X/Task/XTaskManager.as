//------------------------------------------------------------------------------------------
// <$begin$/>
// The MIT License (MIT)
// 
// Copyright (c) 2014 Jimmy Huey
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
package X.Task {

	import X.*;
	import X.Collections.*;
	import X.Pool.*;
	import X.World.Logic.*;
	
//------------------------------------------------------------------------------------------	
	public class XTaskManager extends Object {
		protected var m_XTasks:XDict;
		protected var m_paused:Number;
		protected var m_XApp:XApp;
		protected var m_pools:Array;
		protected var m_currentPool:Number;
		protected var m_poolCycle:Number;

		public const NUM_POOLS:Number = 8;
		public const POOL_MASK:Number = 7;
		
//------------------------------------------------------------------------------------------
		public function XTaskManager (__XApp:XApp) {
			m_XApp = __XApp;
			
			m_XTasks = new XDict ();
			
			m_paused = 0;
			
			m_pools = new Array (NUM_POOLS);
			
			for (var i:Number=0; i<NUM_POOLS; i++) {
				m_pools[i] = new XObjectPoolManager (
					function ():* {
						return new XTask ();
					},
					
					function (__src:*, __dst:*):* {
						return null;
					},
					
					2048, 256,
					
					function (x:*):void {
					}
				);
			}
			
			m_currentPool = 0;
			m_poolCycle = 0;
		}

//------------------------------------------------------------------------------------------
		public function getXApp ():XApp {
			return m_XApp;
		}
		
//------------------------------------------------------------------------------------------
		public function pause ():void {
			m_paused++;
		}
		
//------------------------------------------------------------------------------------------
		public function unpause ():void {
			m_paused--;
		}

//------------------------------------------------------------------------------------------
		public function isTask (__task:XTask):Boolean {
			return m_XTasks.exists (__task);
		}	

//------------------------------------------------------------------------------------------
		public function getTasks ():XDict {
			return m_XTasks;
		}

//------------------------------------------------------------------------------------------
		public function removeAllTasks ():void {
			m_XTasks.forEach (
				function (__task:*):void {
					removeTask (__task);
				}
			);
		}		
		
//------------------------------------------------------------------------------------------
		public function addTask (__taskList:Array, __findLabelsFlag:Boolean = true):XTask {
			var __pool:XObjectPoolManager = m_pools[m_currentPool];
			
			var __task:XTask = __pool.borrowObject () as XTask;
			__task.setup (__taskList, __findLabelsFlag);
			
			__task.setManager (this);
			__task.setParent (this);
			__task.setPool (__pool);
			
			m_XTasks.put (__task, 0);
			
			return __task;
		}

//------------------------------------------------------------------------------------------
		public function addXTask (__task:XTask):XTask {
			__task.setManager (this);
			__task.setParent (this);
			
			m_XTasks.put (__task, 0);
			
			return __task;
		}
		
//------------------------------------------------------------------------------------------
		public function removeTask (__task:XTask):void {
			if (m_XTasks.exists (__task)) {
				__task.kill ();
				
				__task.getPool ().returnObjectTo (m_pools[(m_currentPool + POOL_MASK) & (POOL_MASK)], __task);
				
				m_XTasks.remove (__task);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function updateTasks ():void {	
			if (m_paused) {
				return;
			}
			
			m_poolCycle++; m_poolCycle &= 63;
			
			if (m_poolCycle == 0) {
				m_currentPool = (m_currentPool + 1) & (POOL_MASK);
			}
			
			m_XTasks.forEach (
				function (x:XTask):void {
					x.run ();
				}
			);
		}

//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
