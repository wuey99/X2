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
		protected var m_toCull:XDict;

//------------------------------------------------------------------------------------------
		public function XTaskManager (__XApp:XApp) {
			m_XApp = __XApp;
			
			m_XTasks = new XDict ();
			m_toCull = new XDict ();
			
			m_paused = 0;
			
			m_XTaskPoolManager = new XObjectPoolManager (
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
			var __task:XTask = m_XTaskPoolManager.borrowObject () as XTask;
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
				
				m_toCull.put (__task, 0);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function updateTasks ():void {	
			if (m_paused) {
				return;
			}
			
			var __task:XTask;
			
			m_toCull.forEach (
				function (x:*):void {
					__task = x as XTask;
					
					if (__task.cullDelay == 0) {
						m_toCull.remove (__task);
					
						m_XTaskPoolManager.returnObject (__task);
					}
					else
					{
						__task.cullDelay--;
					}
				}
			);
			
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
