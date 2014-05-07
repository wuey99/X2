//------------------------------------------------------------------------------------------
// <$begin$/>
// Copyright (C) 2014 Jimmy Huey
//
// Some Rights Reserved.
//
// The "X-Engine" is licensed under a Creative Commons
// Attribution-NonCommerical-ShareAlike 3.0 Unported License.
// (CC BY-NC-SA 3.0)
//
// You are free to:
//
//      SHARE - to copy, distribute, display and perform the work.
//      ADAPT - remix, transform build upon this material.
//
//      The licensor cannot revoke these freedoms as long as you follow the license terms.
//
// Under the following terms:
//
//      ATTRIBUTION -
//          You must give appropriate credit, provide a link to the license, and
//          indicate if changes were made.  You may do so in any reasonable manner,
//          but not in any way that suggests the licensor endorses you or your use.
//
//      SHAREALIKE -
//          If you remix, transform, or build upon the material, you must
//          distribute your contributions under the same license as the original.
//
//      NONCOMMERICIAL -
//          You may not use the material for commercial purposes.
//
// No additional restrictions - You may not apply legal terms or technological measures
// that legally restrict others from doing anything the license permits.
//
// The full summary can be located at:
// http://creativecommons.org/licenses/by-nc-sa/3.0/
//
// The human-readable summary of the Legal Code can be located at:
// http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode
//
// The "X-Engine" is free for non-commerical use.
// For commercial use, you will need to provide proper credits.
// Please contact me @ wuey99[dot]gmail[dot]com for more details.
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
