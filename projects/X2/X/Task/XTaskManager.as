//------------------------------------------------------------------------------------------
package X.Task {

	import X.*;
	import X.World.Logic.*;
	
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------	
	public class XTaskManager extends Object {
		protected var m_XTasks:Dictionary;
		protected var m_paused:Number;
		
//------------------------------------------------------------------------------------------
		public function XTaskManager () {
			m_XTasks = new Dictionary ();
			
			m_paused = 0;
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
			return __task in m_XTasks;
		}	

//------------------------------------------------------------------------------------------
		public function getTasks ():Dictionary {
			return m_XTasks;
		}

//------------------------------------------------------------------------------------------
		public function removeAllTasks ():void {
			var __task:*;
			
			for (__task in m_XTasks) {
				delete m_XTasks[__task as XTask];
			}
		}		
		
//------------------------------------------------------------------------------------------
		public function addTask (__taskList:Array, __findLabelsFlag:Boolean = true):XTask {
			var __task:XTask = new XTask (__taskList, __findLabelsFlag);
			
			__task.setManager (this);
			__task.setParent (this);
			
			m_XTasks[__task] = 0;
			
			return __task;
		}

//------------------------------------------------------------------------------------------
		public function addXTask (__task:XTask):XTask {
			__task.setManager (this);
			__task.setParent (this);
			
			m_XTasks[__task] = 0;
			
			return __task;
		}
		
//------------------------------------------------------------------------------------------
		public function removeTask (__task:XTask):void {
			if (__task in m_XTasks) {
				__task.kill ();
				
				delete m_XTasks[__task];
			}
		}
		
//------------------------------------------------------------------------------------------
		public function updateTasks ():void {
			var x:*;
			
			if (m_paused) {
				return;
			}
			
			for (x in m_XTasks) {
				x.run ();
			}
		}

//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
