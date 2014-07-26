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
	import X.Pool.*;
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
		private var m_soundClassPoolManager:XClassPoolManager;
		private var m_SFXVolume:Number;
		
//------------------------------------------------------------------------------------------
		public function XSoundManager (__XApp:XApp) {
			m_XApp = __XApp;

			m_soundChannels = new XDict ();
			m_soundClassPoolManager = new XClassPoolManager ();
			m_SFXVolume = 1;
		}
		
//------------------------------------------------------------------------------------------
		public function cleanup ():void {
			removeAllSounds ();
		}
		
//------------------------------------------------------------------------------------------
		private function __playSound (
			__class:Class,
			__sound:Sound,
			__loops:Number = 0,
			__successListener:Function = null,
			__completeListener:Function = null
			):Number {
		
			var __soundChannel:SoundChannel = __sound.play (0, __loops, new SoundTransform (getSFXVolume (), 0));
			var __guid:Number = g_GUID++;
			m_soundChannels.put (__guid, [__soundChannel, __completeListener, __class, __sound]);
			
			__successListener (__guid);
			
			__soundChannel.addEventListener (
				Event.SOUND_COMPLETE,
						
				function (e:Event):void {
					if (m_soundChannels.exists (__guid)) {
						var __completeListener:Function = m_soundChannels.get (__guid)[1];
						var __class:Class = m_soundChannels.get (__guid)[2];
						var __sound:Sound = m_soundChannels.get (__guid)[3];
						
						if (__completeListener != null) {
							__completeListener (__guid);
						}
						
						m_soundClassPoolManager.returnObject (__class, __sound);
						
						m_soundChannels.remove (__guid);
					}
				}
			);
			
			return __guid;
		}

//------------------------------------------------------------------------------------------
		public function playSoundFromClass (
			__class:Class,
			__priority:Number,
			__loops:Number = 0,
			__successListener:Function = null,
			__completeListener:Function = null
		):Number {
			
			var __sound:Sound = m_soundClassPoolManager.borrowObject (__class) as Sound;
			
			return __playSound (
				__class,
				__sound,
				__loops,
				__successListener,
				__completeListener
			);
		}
		
//------------------------------------------------------------------------------------------
		public function playSoundFromClassName (
			__className:String,
			__priority:Number,
			__loops:Number = 0,
			__successListener:Function = null,
			__completeListener:Function = null
			):Number {
			
			var __class:Class = m_XApp.getClass (__className);
			var __sound:Sound = m_soundClassPoolManager.borrowObject (__class) as Sound;
			
			return __playSound (
				__class,
				__sound,
				__loops,
				__successListener,
				__completeListener
			);
		}

//------------------------------------------------------------------------------------------
		public function setSFXVolume (__state:Number):void {
			m_SFXVolume = __state;
		}
		
//------------------------------------------------------------------------------------------
		public function getSFXVolume ():Number {
			return m_SFXVolume;
		}
		
//------------------------------------------------------------------------------------------
		public function stopSound (__guid:Number):void {
			removeSound (__guid);
		}

//------------------------------------------------------------------------------------------
		public function removeSound (__guid:Number):void {
			if (m_soundChannels.exists (__guid)) {
				var __soundChannel:SoundChannel = m_soundChannels.get (__guid)[0];
				__soundChannel.stop ();
				
				var __completeListener:Function = m_soundChannels.get (__guid)[1];
				
				if (__completeListener != null) {
					__completeListener (__guid);
				}

				var __class:Class = m_soundChannels.get (__guid)[2];
				var __sound:Sound = m_soundChannels.get (__guid)[3];
				m_soundClassPoolManager.returnObject (__class, __sound);
				
				m_soundChannels.remove (__guid);
			}
		}

//------------------------------------------------------------------------------------------
		public function removeAllSounds ():void {	
			m_soundChannels.forEach (
				function (__guid:Number):void {
					removeSound (__guid);
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
