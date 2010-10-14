//------------------------------------------------------------------------------------------
package X.Sound {
	
	import X.Task.XTaskSubManager;
	
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------	
	public class XSoundManager extends Object {
		public var m_XTaskSubManager:XTaskSubManager;
		
//------------------------------------------------------------------------------------------
		public function XSoundManager (__manager:XTaskManager) {
			m_XTaskSubManager = new XTaskSubManager (__manager);
		}

//------------------------------------------------------------------------------------------
		public function addTask (
			__taskList:Array,
			__findLabelsFlag:Boolean = true
			):XTask {

			return m_XTaskSubManager.addTask (__taskList, __findLabelsFlag);
		}

//------------------------------------------------------------------------------------------
		public function changeTask (
			__task:XTask,
			__taskList:Array,
			__findLabelsFlag:Boolean = true
			):XTask {
				
			return m_XTaskSubManager.changeTask (__task, __taskList, __findLabelsFlag);
		}

//------------------------------------------------------------------------------------------
		public function isTask (__task:XTask):Boolean {
			return m_XTaskSubManager.isTask (__task);
		}		
		
//------------------------------------------------------------------------------------------
		public function removeTask (__task:XTask):void {
			m_XTaskSubManager.removeTask (__task);	
		}

//------------------------------------------------------------------------------------------
		public function removeAllTasks ():void {
			m_XTaskSubManager.removeAllTasks ();
		}

//------------------------------------------------------------------------------------------
		public function addEmptyTask ():XTask {
			return m_XTaskSubManager.addEmptyTask ();
		}

//------------------------------------------------------------------------------------------
		public function getEmptyTask$ ():Array {
			return m_XTaskSubManager.getEmptyTask$ ();
		}	
			
//------------------------------------------------------------------------------------------
		public function gotoLogic (__logic:Function):void {
			m_XTaskSubManager.gotoLogic (__logic);
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
