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

	import X.*;
	import X.Collections.*;
	import X.Task.*;
	
	import flash.media.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------	
	public class XSoundSubManager extends Object {
		public var m_soundManager:XSoundManager;
		public var m_soundChannels:XDict;
		public var m_maxChannels:Number;
		public var m_numChannels:Number;
		
//------------------------------------------------------------------------------------------
		public function XSoundSubManager (__soundManager:XSoundManager) {
			m_soundManager = __soundManager;

			m_soundChannels = new XDict ();
			
			m_maxChannels = 8;
			m_numChannels = 0;
		}

//------------------------------------------------------------------------------------------
		public function setup (__maxChannels:Number):void {
			m_maxChannels = __maxChannels;
			m_numChannels = 0;
		}
		
//------------------------------------------------------------------------------------------
		public function cleanup ():void {
			removeAllSounds ();
		}
		
//------------------------------------------------------------------------------------------
		public function setSoundManager (__soundManager:XSoundManager):void {
			m_soundManager = __soundManager;
		}

//------------------------------------------------------------------------------------------
		public function playSoundFromClass (
			__class:Class,
			__priority:Number = 1.0,
			__loops:Number = 0,
			__successListener:Function = null,
			__completeListener:Function = null
			):Number {
			
			if (!channelAvailable (__priority)) {
				return -1;
			}
				
			var __guid:Number = m_soundManager.playSoundFromClass (__class, __loops, __complete);
			
			m_soundChannels.put (__guid, __priority);
			m_numChannels++;
			
			if (__successListener != null) {
				__successListener (__guid);
			}
			
			function __complete ():void {
				if (__completeListener != null) {
					__completeListener (__guid);
				}
				
				m_soundChannels.remove (__guid);	
				m_numChannels--;
			}
			
			return __guid;
		}

//------------------------------------------------------------------------------------------
		public function playSoundFromClassName (
			__className:String,
			__priority:Number = 1.0,
			__loops:Number = 0,
			__successListener:Function = null,
			__completeListener:Function = null
			):Number {
			
			if (!channelAvailable (__priority)) {
				return -1;
			}
			
			var __guid:Number = m_soundManager.playSoundFromClassName (__className, __loops, __complete);
			
			m_soundChannels.put (__guid, __priority);
			m_numChannels++;
			
			if (__successListener != null) {
				__successListener (__guid);
			}
			
			function __complete ():void {
				if (__completeListener != null) {
					__completeListener (__guid);
				}
				
				m_soundChannels.remove (__guid);	
				m_numChannels--;
			}
			
			return __guid;
		}

//------------------------------------------------------------------------------------------
		private function channelAvailable (__priority:Number):Boolean {
			if (m_numChannels < m_maxChannels) {
				return true;
			}
			
			var __firstChoice:Number = -1
			var __secondChoice:Number = -1;
			
			m_soundChannels.forEach (
				function (__targetGuid:Number):void {
					var __targetPriority:Number = m_soundChannels.get (__targetGuid);
					
					if (__priority > __targetPriority) {
						__firstChoice = __targetGuid
					}
					
					if (__priority == __targetPriority) {
						__secondChoice = __targetGuid;
					}
				}
			);
			
			if (__firstChoice != -1) {
				removeSound (__firstChoice);
				
				return true;
			}
			
			if (__secondChoice != -1) {
				removeSound (__secondChoice);
			}
			
			return false;
		}
		
//------------------------------------------------------------------------------------------
		public function stopSound (__guid:Number):void {
			removeSound (__guid);
		}

//------------------------------------------------------------------------------------------
		public function removeSound (__guid:Number):void {
			if (m_soundChannels.exists (__guid)) {
				m_soundChannels.remove (__guid);
				m_numChannels--;
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
	}
	
//------------------------------------------------------------------------------------------
}
