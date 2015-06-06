//------------------------------------------------------------------------------------------
// <$begin$/>
// The MIT License (MIT)
//
// The "X-Engine"
//
// Copyright (c) 2014 Jimmy Huey (wuey99@gmail.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
			__transform:SoundTransform = null,
			__successListener:Function = null,
			__completeListener:Function = null
			):Number {
			
			if (!channelAvailable (__priority)) {
				return -1;
			}
				
			return m_soundManager.playSoundFromClass (
				__class,
				__priority,
				__loops,
				__transform,
				
				function (__guid:Number):void {
					m_soundChannels.put (__guid, __priority);
					m_numChannels++;
					
					if (__successListener != null) {
						__successListener (__guid);
					}					
				},
				
				function (__guid:Number):void {
					if (__completeListener != null) {
						__completeListener (__guid);
					}
					
					if (m_soundChannels.exists (__guid)) {
						m_soundChannels.remove (__guid);	
						m_numChannels--;
					}
				}
			);
		}

//------------------------------------------------------------------------------------------
		public function playSoundFromClassName (
			__className:String,
			__priority:Number = 1.0,
			__loops:Number = 0,
			__transform:SoundTransform = null,
			__successListener:Function = null,
			__completeListener:Function = null
			):Number {
			
			if (!channelAvailable (__priority)) {
				return -1;
			}
			
			return m_soundManager.playSoundFromClassName (
				__className,
				__priority,
				__loops,
				__transform,
				
				function (__guid:Number):void {					
					m_soundChannels.put (__guid, __priority);
					m_numChannels++;

					if (__successListener != null) {
						__successListener (__guid);
					}					
				},
				
				function (__guid:Number):void {
					if (__completeListener != null) {
						__completeListener (__guid);
					}
					
					if (m_soundChannels.exists (__guid)) {
						m_soundChannels.remove (__guid);	
						m_numChannels--;
					}
				}
			);
		}
		
		//------------------------------------------------------------------------------------------
		public function playPitchSoundFromClass (
			__class:Class,
			__priority:Number = 1.0,
			__loops:Number = 0,
			__transform:SoundTransform = null,
			__successListener:Function = null,
			__completeListener:Function = null
		):Number {
			
			if (!channelAvailable (__priority)) {
				return -1;
			}
			
			return m_soundManager.playPitchSoundFromClass (
				__class,
				__priority,
				__loops,
				__transform,
				
				function (__guid:Number):void {
					m_soundChannels.put (__guid, __priority);
					m_numChannels++;
					
					if (__successListener != null) {
						__successListener (__guid);
					}					
				},
				
				function (__guid:Number):void {
					if (__completeListener != null) {
						__completeListener (__guid);
					}
					
					if (m_soundChannels.exists (__guid)) {
						m_soundChannels.remove (__guid);	
						m_numChannels--;
					}
				}
			);
		}
		
		//------------------------------------------------------------------------------------------
		public function playPitchSoundFromClassName (
			__className:String,
			__priority:Number = 1.0,
			__loops:Number = 0,
			__transform:SoundTransform = null,
			__successListener:Function = null,
			__completeListener:Function = null
		):Number {
			
			if (!channelAvailable (__priority)) {
				return -1;
			}
			
			return m_soundManager.playPitchSoundFromClassName (
				__className,
				__priority,
				__loops,
				__transform,
				
				function (__guid:Number):void {					
					m_soundChannels.put (__guid, __priority);
					m_numChannels++;
					
					if (__successListener != null) {
						__successListener (__guid);
					}					
				},
				
				function (__guid:Number):void {
					if (__completeListener != null) {
						__completeListener (__guid);
					}
					
					if (m_soundChannels.exists (__guid)) {
						m_soundChannels.remove (__guid);	
						m_numChannels--;
					}
				}
			);
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
				
				return true;
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
				m_soundManager.removeSound (__guid);
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
		public function getSoundChannel (__guid:Number):MP3Sound {
			return m_soundManager.getSoundChannel (__guid);
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
