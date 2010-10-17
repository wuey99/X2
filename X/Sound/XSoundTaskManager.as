//------------------------------------------------------------------------------------------
package X.Task {

	import X.*;
	import X.Sound.*;
	
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------	
	public class XSoundTaskManager extends XTaskSubManager {
		public m_soundManager:XSoundManager;
		
//------------------------------------------------------------------------------------------
		public function XSoundTaskManager (__manager:XTaskManager, __soundManager:XSoundManager) {
			m_soundManager = __soundManager;
			
			super (__manager);
		}
		
//------------------------------------------------------------------------------------------
		public function addTask (
			__taskList:Array,
			__findLabelsFlag:Boolean = true
			):XTask {

			return addXTask (new XSoundTask (m_soundManager, __taskList, __findLabelsFlag));
		}

//------------------------------------------------------------------------------------------
		public function changeTask (
			__task:XTask,
			__taskList:Array,
			__findLabelsFlag:Boolean = true
			):XTask {
				
			return changeXTask (__task, new XSoundTask (m_soundManager, __taskList, __findLabelsFlag));
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
