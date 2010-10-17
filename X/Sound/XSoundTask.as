//------------------------------------------------------------------------------------------
package X.Sound {
	
	import X.Task.*;
	
	import flash.media.*;
	import flash.system.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------
	public class XSoundTask extends XTask {
		public var m_manager:XTaskManager;
		
		protected var m_XSoundTaskManager:XSoundTaskManager;
		
//------------------------------------------------------------------------------------------
		public function XSoundTask (__manager:XTaskManager, __taskList:Array, __findLabelsFlag:Boolean = true) {
			m_manager = __taskManager;
			
			super (__taskList, __findLabelsFlag);
		}

//------------------------------------------------------------------------------------------
		public override function createXTaskSubManager ():void {
			m_XTaskSubManager = m_XSoundTaskManager = new XSoundTaskManager (m_manager, null);
		}
		
//------------------------------------------------------------------------------------------
		public override function kill ():void {
			m_XSoundTaskManager.removeAllSounds ();
			
			removeAllTasks ();
		}	

//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}