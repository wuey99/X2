//------------------------------------------------------------------------------------------
// <$begin$/>
// <$end$/>
//------------------------------------------------------------------------------------------
package X.Sound {
	
	import X.Collections.*;
	import X.Task.*;
	import X.XApp;
	
	import flash.events.Event;
	import flash.media.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------	
	public class XSoundManager extends Object {
		public var m_XApp:XApp;
		public var m_soundChannels:XDict;
		private static var g_GUID:Number = 0;
		
//------------------------------------------------------------------------------------------
		public function XSoundManager (__XApp:XApp) {
			m_XApp = __XApp;

			m_soundChannels = new XDict ();
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
				
			var __soundChannel:SoundChannel = __sound.play ();
			var __guid:Number = g_GUID++;
			m_soundChannels.put (__guid, __soundChannel);
			
			__soundChannel.addEventListener (
				Event.SOUND_COMPLETE,
						
				function (e:Event):void {
					if (__completeListener != null) {
						__completeListener ();
					}
					
					if (m_soundChannels.exists (__guid)) {
						m_soundChannels.remove (__guid);
					}
				}
			);
			
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
				var __soundChannel:SoundChannel = m_soundChannels.get (__guid);
				__soundChannel.stop ();
				
				m_soundChannels.remove (__guid);
			}
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
		public function getSoundChannel (__guid:Number):SoundChannel {
			if (m_soundChannels.exists (__guid)) {
				return m_soundChannels.get (__guid);
			}
			else
			{
				return null;
			}
		}	

//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
