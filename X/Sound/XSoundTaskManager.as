//------------------------------------------------------------------------------------------
package X.Sound {

	import X.*;
	import X.Task.*;
	import X.Sound.*;
	
	import flash.utils.*;
	import flash.media.*;
	
//------------------------------------------------------------------------------------------	
	public class XSoundTaskManager extends XTaskSubManager {
		public var m_soundManager:XSoundManager;
		public var m_soundChannels:Dictionary;
		
//------------------------------------------------------------------------------------------
		public function XSoundTaskManager (__manager:XTaskManager, __soundManager:XSoundManager) {
			m_soundManager = __soundManager;
			
			super (__manager);
		}
		
//------------------------------------------------------------------------------------------
		public function playSound (
			__sound:Sound,
			__completeListener:Function = null
			):Number {
				
			var __guid:Number = m_soundManager.playSound (__sound, __complete);
			
			m_soundChannels[__guid] = 0;
			
			function __complete ():void {
				if (__completeListener != null) {
					__completeListener ();
				}
				
				delete m_soundChannels[__guid];
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
			if (__guid in m_soundChannels) {
				delete m_soundChannels[__guid];
			}
			
			m_soundManager.removeSound (__guid);
		}

//------------------------------------------------------------------------------------------
		public function removeAllSounds ():void {
			var __guid:*;
			
			for (__guid in m_soundChannels) {
				removeSound (__guid as Number);
			}	
		}
		
//------------------------------------------------------------------------------------------
		public override function addTask (
			__taskList:Array,
			__findLabelsFlag:Boolean = true
			):XTask {

			return addXTask (new XSoundTask (__taskList, __findLabelsFlag));
		}

//------------------------------------------------------------------------------------------
		public function addSoundTask (
			__taskList:Array,
			__findLabelsFlag:Boolean = true
			):XTask {

			return addXTask (new XSoundTask (__taskList, __findLabelsFlag));
		}
		
//------------------------------------------------------------------------------------------
		public override function changeTask (
			__task:XTask,
			__taskList:Array,
			__findLabelsFlag:Boolean = true
			):XTask {
				
			return changeXTask (__task, new XSoundTask (__taskList, __findLabelsFlag));
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
