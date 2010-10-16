//------------------------------------------------------------------------------------------
package X.Task {

	import X.*;
	import X.World.Logic.*;
	
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------	
	public class XTaskSubManager extends Object {
		private var m_manager:XTaskManager;
		
		private var m_XTasks:Dictionary;
		
//------------------------------------------------------------------------------------------
		public function XTaskSubManager (__manager:XTaskManager) {
			super ();
			
			m_manager = __manager;
			
			m_XTasks = new Dictionary ();
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
			
			if (!(__task in m_XTasks)) {
				m_XTasks[__task] = 0;
			}
			
			return __task;
		}
//------------------------------------------------------------------------------------------
		public function addXTask (__task:XTask):XTask {
			var __task:XTask = m_manager.addXTask (__task);
			
			if (!(__task in m_XTasks)) {
				m_XTasks[__task] = 0;
			}
			
			return __task;			
		}
		
//------------------------------------------------------------------------------------------
		public function changeTask (
			__task:XTask,
			__taskList:Array,
			__findLabelsFlag:Boolean = true
			):XTask {
				
			if (!(__task == null)) {
				removeTask (__task);
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
			return __task in m_XTasks;
		}		

//------------------------------------------------------------------------------------------
		public function removeTask (__task:XTask):void {	
			if (__task in m_XTasks) {
				delete m_XTasks[__task];
					
				m_manager.removeTask (__task);
			}
		}

//------------------------------------------------------------------------------------------
		public function removeAllTasks ():void {
			var x:*;
			
			for (x in m_XTasks) {
				removeTask (x as XTask);
			}
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
