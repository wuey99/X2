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
		protected var m_XTaskPoolManager:XObjectPoolManager;
		protected var m_killQueue:XDict;
		protected var m_delay:Number = 0;

//------------------------------------------------------------------------------------------
		public function XTaskManager (__XApp:XApp) {
			m_XApp = __XApp;
			
			m_XTasks = new XDict ();
			m_killQueue = new XDict ();
		
			m_paused = 0;
			m_delay = 0;
			
			m_XTaskPoolManager = new XObjectPoolManager (
				function ():* {
					return new XTask ();
				},
				
				function (__src:*, __dst:*):* {
					return null;
				},
				
				256, 128,
				
				function (x:*):void {
				}
			);
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
//			var __task:XTask = m_XTaskPoolManager.borrowObject () as XTask;
			var __task:XTask = new XTask ();
			__task.setup (__taskList, __findLabelsFlag);
			
			__task.setManager (this);
			__task.setParent (this);
			
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
				
				m_XTasks.remove (__task);
				
//				m_killQueue.put (__task, 4);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function updateTasks ():void {	
			if (m_paused) {
				return;
			}
			
			m_delay += 1;
			
			if ((m_delay & 63) == 0) {
				m_killQueue.forEach (
					function (__task:*):void {
						var __count:Number = m_killQueue.get (__task); __count--;
						
						if (__count == 0) {
							m_XTaskPoolManager.returnObject (__task);
							
							m_killQueue.remove (__task);
						}
						else
						{
							m_killQueue.put (__task, __count);
						}
					}
				);
			}
			
			m_XTasks.forEach (
				function (x:*):void {
					x.run ();
				}
			);
		}

//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
