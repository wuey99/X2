//------------------------------------------------------------------------------------------
package X.Sound {
	
	import X.Task.*;
	
	import flash.media.*;
	import flash.system.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------
	public class XSoundTask extends XTask {
		public var m_XSoundManager:XSoundManager;
		public var m_soundChannels:Dictionary;
		
//------------------------------------------------------------------------------------------
		public function XSoundTask (
			__XSoundManager:XSoundManager,
			__taskList:Array, __findLabelsFlag:Boolean = true
			) {
				
			m_XSoundManager = __XSoundManager;
			
			m_soundChannels = new Dictionary ();
			
			super (__taskList, __findLabelsFlag);
		}

//------------------------------------------------------------------------------------------
		public override function kill ():void {
			removeAllSounds ();
			
			removeAllTasks ();
		}	

//------------------------------------------------------------------------------------------
		public function playSound (__sound:Sound, __completeListener:Function = null):Number {
			var __guid:Number = m_XSoundManager.playSound (__sound, __complete);
			
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
				delete m_soundChannels[__guid];
			}
			
			m_XSoundManager.removeSound (__guid);
		}

//------------------------------------------------------------------------------------------
		public function removeAllSounds ():void {
			var __guid:*;
			
			for (__guid in m_soundChannels) {
				removeSound (__guid as Number);
			}	
		}
			
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}