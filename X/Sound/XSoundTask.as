//------------------------------------------------------------------------------------------
package X.Sound {
	
	import X.Task.*;
	
	import flash.media.*;
	import flash.system.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------
	public class XSoundTask extends XTask {
		protected var m_XSoundTaskManager:XSoundTaskManager;
		
//------------------------------------------------------------------------------------------
		public function XSoundTask (__taskList:Array, __findLabelsFlag:Boolean = true) {
			super (__taskList, __findLabelsFlag);
		}

//------------------------------------------------------------------------------------------
		public override function createXTaskSubManager ():XTaskSubManager {
			m_XSoundTaskManager = new XSoundTaskManager (m_manager, null);
			
			return m_XSoundTaskManager;
		}
		
//------------------------------------------------------------------------------------------
		public override function kill ():void {
			m_XSoundTaskManager.removeAllSounds ();
			
			removeAllTasks ();
		}	

//------------------------------------------------------------------------------------------
		public function playSound (
			__sound:Sound,
			__completeListener:Function = null
			):Number {
				
			return m_XSoundTaskManager.playSound (__sound, __completeListener);
		}

//------------------------------------------------------------------------------------------
		public function playSoundFromClassName (
			__className:String,
			__completeListener:Function = null
			):Number {
				
			return 0;
		}
		
//------------------------------------------------------------------------------------------
		public function stopSound (__guid:Number):void {
			m_XSoundTaskManager.stopSound (__guid);
		}

//------------------------------------------------------------------------------------------
		public function removeSound (__guid:Number):void {
			m_XSoundTaskManager.removeSound (__guid);
		}

//------------------------------------------------------------------------------------------
		public function removeAllSounds ():void {
			m_XSoundTaskManager.removeAllSounds ();
		}
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}