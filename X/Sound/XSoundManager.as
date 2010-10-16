//------------------------------------------------------------------------------------------
package X.Sound {
	
	import X.Task.*;
	import X.XApp;
	
	import flash.events.Event;
	import flash.media.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------	
	public class XSoundManager extends Object {
		public var m_XApp:XApp;
		public var m_XTaskSubManager:XTaskSubManager;
		public var m_soundChannels:Dictionary;
		private static var g_GUID:Number = 0;
		
//------------------------------------------------------------------------------------------
		public function XSoundManager (__XApp:XApp, __manager:XTaskManager) {
			m_XApp = __XApp;
			
			m_XTaskSubManager = new XTaskSubManager (__manager);
			
			m_soundChannels = new Dictionary ();
		}

//------------------------------------------------------------------------------------------
		public function playSound (__sound:Sound, __completeListener:Function = null):Number {
			var __soundChannel:SoundChannel = __sound.play ();
			var __guid:Number = g_GUID++;
			m_soundChannels[__guid] = __soundChannel;
			
			__soundChannel.addEventListener (
				Event.SOUND_COMPLETE,
						
				function (e:Event):void {
					if (__completeListener != null) {
						__completeListener ();
					}
					
					if (__guid in m_soundChannels) {
						delete m_soundChannels[__guid];
					}
				}
			);
			
			return __guid;
		}

//------------------------------------------------------------------------------------------
		public function playSoundFromClassName (__className:String):Number {
			return 0;
		}

//------------------------------------------------------------------------------------------
		public function stopSound (__guid:Number):void {
			removeSound (__guid);
		}

//------------------------------------------------------------------------------------------
		public function removeSound (__guid:Number):void {
			if (__guid in m_soundChannels) {
				var __soundChannel:SoundChannel = m_soundChannels[__guid];
				__soundChannel.stop ();
				
				delete m_soundChannels[__guid];
			}
		}

//------------------------------------------------------------------------------------------
		public function removeAllSounds ():void {
			var __guid:*;			
		
			for (__guid in m_soundChannels) {
				removeSound (__guid as Number);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function getSoundChannel (__guid:Number):SoundChannel {
			if (__guid in m_soundChannels) {
				return m_soundChannels[__guid];
			}
			else
			{
				return null;
			}
		}	
					
//------------------------------------------------------------------------------------------
		public function addTask (
			__taskList:Array,
			__findLabelsFlag:Boolean = true
			):XTask {

			return m_XTaskSubManager.addXTask (new XSoundTask (this, __taskList, __findLabelsFlag));
		}

//------------------------------------------------------------------------------------------
		public function changeTask (
			__task:XTask,
			__taskList:Array,
			__findLabelsFlag:Boolean = true
			):XTask {
				
			return m_XTaskSubManager.changeXTask (__task, new XSoundTask (this, __taskList, __findLabelsFlag));
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
