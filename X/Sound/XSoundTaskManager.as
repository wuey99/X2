//------------------------------------------------------------------------------------------
// <$license$/>
//------------------------------------------------------------------------------------------
package X.Sound {

	import X.*;
	import X.Collections.*;
	import X.Task.*;
	
	import flash.media.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------	
	public class XSoundTaskManager extends XTaskSubManager {
		public var m_soundManager:XSoundManager;
		public var m_soundChannels:XDict;
		
//------------------------------------------------------------------------------------------
		public function XSoundTaskManager (__manager:XTaskManager, __soundManager:XSoundManager) {
			m_soundManager = __soundManager;
			
			super (__manager);
			
			m_soundChannels = new XDict ();
		}
			
//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
			
			removeAllSounds ();
		}
		
//------------------------------------------------------------------------------------------
		public function setSoundManager (__soundManager:XSoundManager):void {
			m_soundManager = __soundManager;
		}

//------------------------------------------------------------------------------------------
		public function replaceSound (
			__sound:Sound,
			__completeListener:Function = null
			):Number {
				
			removeAllSounds ();
			
			return playSound (__sound, __completeListener);
		}
		
//------------------------------------------------------------------------------------------
		public function playSound (
			__sound:Sound,
			__completeListener:Function = null
			):Number {
				
			var __guid:Number = m_soundManager.playSound (__sound, __complete);
			
			m_soundChannels.put (__guid, 0);
			
			function __complete ():void {
				if (__completeListener != null) {
					__completeListener ();
				}
				
				m_soundChannels.remove (__guid);
			}
			
			return __guid;
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
			removeSound (__guid);
		}

//------------------------------------------------------------------------------------------
		public function removeSound (__guid:Number):void {
			if (m_soundChannels.exists (__guid)) {
				m_soundChannels.remove (__guid);
			}
			
			m_soundManager.removeSound (__guid);
		}

//------------------------------------------------------------------------------------------
		public function removeAllSounds ():void {
			m_soundChannels.forEach (
				function (__guid:*):void {
					removeSound (__guid as Number);
				}
			);
		}
		
//------------------------------------------------------------------------------------------
		public override function addTask (
			__taskList:Array,
			__findLabelsFlag:Boolean = true
			):XTask {

			var __task0:XSoundTask = new XSoundTask ();
			__task0.setup (__taskList, __findLabelsFlag);
			
			var __task:XSoundTask = addXTask (__task0) as XSoundTask;
			
			__task.setSoundManager (m_soundManager);
			
			return __task;
		}

//------------------------------------------------------------------------------------------
		public function replaceAllSoundTasks (
			__taskList:Array,
			__findLabelsFlag:Boolean = true
			):XTask {
				
			removeAllTasks ();
			
			return addSoundTask (__taskList, __findLabelsFlag);
		}
		
//------------------------------------------------------------------------------------------
		public function addSoundTask (
			__taskList:Array,
			__findLabelsFlag:Boolean = true
			):XTask {
				
			var __task0:XSoundTask = new XSoundTask ();
			__task0.setup (__taskList, __findLabelsFlag);
			
			var __task:XSoundTask = addXTask (__task0) as XSoundTask;
			
			__task.setSoundManager (m_soundManager);
			
			return __task;
		}
		
//------------------------------------------------------------------------------------------
		public override function changeTask (
			__oldTask:XTask,
			__taskList:Array,
			__findLabelsFlag:Boolean = true
			):XTask {
				
			var __task0:XSoundTask = new XSoundTask ();
			__task0.setup (__taskList, __findLabelsFlag);
			
			var __task:XSoundTask = changeXTask (__oldTask, __task0) as XSoundTask;
			
			return __task;
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
