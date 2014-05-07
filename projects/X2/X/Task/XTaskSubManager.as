//------------------------------------------------------------------------------------------
// <$license$/>
//------------------------------------------------------------------------------------------
package X.Task {

	import X.*;
	import X.Collections.*;
	import X.World.Logic.*;
	
//------------------------------------------------------------------------------------------	
	public class XTaskSubManager extends Object {
		public var m_manager:XTaskManager;
		
		private var m_XTasks:XDict;
		
//------------------------------------------------------------------------------------------
		public function XTaskSubManager (__manager:XTaskManager) {
			super ();
			
			m_manager = __manager;
			
			m_XTasks = new XDict ();
		}

//------------------------------------------------------------------------------------------
		public function setup ():void {
		}	
		
//------------------------------------------------------------------------------------------
		public function cleanup ():void {
			removeAllTasks ();
		}

//------------------------------------------------------------------------------------------
		public function getManager ():XTaskManager {
			return m_manager;
		}
				
//------------------------------------------------------------------------------------------
		public function setManager (__manager:XTaskManager):void {
			m_manager = __manager;
		}
		
//------------------------------------------------------------------------------------------
		public function addTask (
			__taskList:Array,
			__findLabelsFlag:Boolean = true
			):XTask {
				
			var __task:XTask = m_manager.addTask (__taskList, __findLabelsFlag);
			
			if (!(m_XTasks.exists (__task))) {
				m_XTasks.put (__task, 0);
			}
			
			return __task;
		}
		
//------------------------------------------------------------------------------------------
		public function addXTask (__task:XTask):XTask {
			var __task:XTask = m_manager.addXTask (__task);
			
			if (!m_XTasks.exists (__task)) {
				m_XTasks.put(__task, 0);
			}
			
			return __task;			
		}
		
//------------------------------------------------------------------------------------------
		public function changeTask (
			__oldTask:XTask,
			__taskList:Array,
			__findLabelsFlag:Boolean = true
			):XTask {
				
			if (!(__oldTask == null)) {
				removeTask (__oldTask);
			}
					
			return addTask (__taskList, __findLabelsFlag);
		}

//------------------------------------------------------------------------------------------
		public function changeXTask (
			__oldTask:XTask,
			__newTask:XTask
			):XTask {
				
			if (!(__oldTask == null)) {
				removeTask (__oldTask);
			}
					
			return addXTask (__newTask);
		}
		
//------------------------------------------------------------------------------------------
		public function isTask (__task:XTask):Boolean {
			return m_XTasks.exists (__task);
		}		

//------------------------------------------------------------------------------------------
		public function removeTask (__task:XTask):void {	
			if (m_XTasks.exists (__task)) {
				m_XTasks.remove (__task);
					
				m_manager.removeTask (__task);
			}
		}

//------------------------------------------------------------------------------------------
		public function removeAllTasks ():void {	
			m_XTasks.forEach (
				function (x:*):void {
					removeTask (x as XTask);
				}
			);
		}

//------------------------------------------------------------------------------------------
		public function addEmptyTask ():XTask {
			return addTask (getEmptyTask$ ());
		}

//------------------------------------------------------------------------------------------
		public function getEmptyTask$ ():Array {
			return [
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
				
					XTask.GOTO, "loop",
				
				XTask.RETN,
			];
		}	
			
//------------------------------------------------------------------------------------------
		public function gotoLogic (__logic:Function):void {
			removeAllTasks ();
			
			__logic ();
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
