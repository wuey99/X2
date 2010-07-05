//------------------------------------------------------------------------------------------
package X.Task {

	import X.*;
	import X.World.Logic.*;
	
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------	
	public class XTaskSubManager extends XTaskManager {
		private var m_XTaskManager:XTaskManager;
		
//------------------------------------------------------------------------------------------
		public function XTaskSubManager (__manager:XTaskManager) {
			super ();
			
			m_XTaskManager = __manager;
		}

//------------------------------------------------------------------------------------------
		public override function addTask (
			__taskList:Array,
			__findLabelsFlag:Boolean = true
			):XTask {
				
			var __task:XTask = m_XTaskManager.addTask (__taskList, __findLabelsFlag);
			
			if (!(__task in m_XTasks)) {
				m_XTasks[__task] = 0;
			}
			
			__task.setParent (this);
			
			return __task;
		}

//------------------------------------------------------------------------------------------
		public override function changeTask (
			__task:XTask,
			__taskList:Array,
			__findLabelsFlag:Boolean = true
			):XTask {
				
			if (!(__task == null)) {
				removeTask (__task);
			}
					
			__task = addTask (__taskList, __findLabelsFlag);
			
			return __task;
		}

//------------------------------------------------------------------------------------------
		public override function removeTask (__task:XTask):void {	
			if (__task in m_XTasks) {
				delete m_XTasks[__task];
					
				m_XTaskManager.removeTask (__task);
			}
		}

//------------------------------------------------------------------------------------------
		public override function removeAllTasks ():void {
			var x:*;
			
			for (x in m_XTasks) {
				removeTask (x as XTask);
			}
		}

//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
