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
package x.sound {
	
	import x.collections.*;
	import x.pool.*;
	import x.task.*;
	import x.type.*;
	import x.XApp;
	
	import flash.events.Event;
	import flash.media.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------	
	public class XSoundManager extends Object {
		public var m_XApp:XApp;
		public var m_soundChannels:XDict; // <Float, Array<Dynamic>>
		private static var g_GUID:int = 0;
		private var m_soundClassPoolManager:XClassPoolManager;
		private var m_SFXVolume:Number;
		
//------------------------------------------------------------------------------------------
		public function XSoundManager (__XApp:XApp) {
			m_XApp = __XApp;

			m_soundChannels = new XDict (); // <Float, Array<Dynamic>>
			m_soundClassPoolManager = new XClassPoolManager ();
			m_SFXVolume = 1;
		}
		
//------------------------------------------------------------------------------------------
		public function cleanup ():void {
			removeAllSounds ();
		}
		
//------------------------------------------------------------------------------------------
		private function __playSound (
			__class:Class /* <Dynamic> */,
			__sound:Sound,
			__type:Class /* <Dynamic> */,
			__loops:int = 0,
			__transform:SoundTransform = null,
			__successListener:Function = null,
			__completeListener:Function = null
			):int {
		
			if (__transform == null) {
				__transform = new SoundTransform (getSFXVolume (), 0);
			}
			var __mp3Sound:MP3Sound = XType.createInstance (__type);
			__mp3Sound.setup (__sound);
			__mp3Sound.play (0, __loops, __transform);
			
			var __guid:int = g_GUID++;
			m_soundChannels.set (__guid, [__mp3Sound, __completeListener, __class, __sound]);
			
			__successListener (__guid);
			
			__mp3Sound.addCompleteListener (
				function (e:Event):void {
					if (m_soundChannels.exists (__guid)) {
						var __completeListener:Function = m_soundChannels.get (__guid)[1];
						var __class:Class /* <Dynamic> */ = m_soundChannels.get (__guid)[2];
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
			__loops:int = 0,
			__transform:SoundTransform = null,
			__successListener:Function = null,
			__completeListener:Function = null
		):int {
			
			var __sound:Sound = m_soundClassPoolManager.borrowObject (__class) as Sound;
			
			return __playSound (
				__class,
				__sound,
				MP3Normal,
				__loops,
				__transform,
				__successListener,
				__completeListener
			);
		}
		
//------------------------------------------------------------------------------------------
		public function playSoundFromClassName (
			__className:String,
			__priority:Number,
			__loops:int = 0,
			__transform:SoundTransform = null,
			__successListener:Function = null,
			__completeListener:Function = null
			):int {
			
			var __class:Class = m_XApp.getClass (__className);
			var __sound:Sound = m_soundClassPoolManager.borrowObject (__class) as Sound;
			
			return __playSound (
				__class,
				__sound,
				MP3Normal,
				__loops,
				__transform,
				__successListener,
				__completeListener
			);
		}

		//------------------------------------------------------------------------------------------
		public function playPitchSoundFromClass (
			__class:Class /* <Dynamic> */,
			__priority:Number,
			__loops:int = 0,
			__transform:SoundTransform = null,
			__successListener:Function = null,
			__completeListener:Function = null
		):int {
			
			var __sound:Sound = m_soundClassPoolManager.borrowObject (__class) as Sound;
			
			return __playSound (
				__class,
				__sound,
				MP3Pitch,
				__loops,
				__transform,
				__successListener,
				__completeListener
			);
		}
		
		//------------------------------------------------------------------------------------------
		public function playPitchSoundFromClassName (
			__className:String,
			__priority:Number,
			__loops:int = 0,
			__transform:SoundTransform = null,
			__successListener:Function = null,
			__completeListener:Function = null
		):int {
			
			var __class:Class /* <Dynamic> */ = m_XApp.getClass (__className);
			var __sound:Sound = m_soundClassPoolManager.borrowObject (__class) as Sound;
			
			return __playSound (
				__class,
				__sound,
				MP3Pitch,
				__loops,
				__transform,
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
		public function stopSound (__guid:int):void {
			removeSound (__guid);
		}

//------------------------------------------------------------------------------------------
		public function removeSound (__guid:int):void {
			if (m_soundChannels.exists (__guid)) {
				var __mp3Sound:MP3Sound = m_soundChannels.get (__guid)[0];
				__mp3Sound.stop ();
				
				var __completeListener:Function = m_soundChannels.get (__guid)[1];
				
				if (__completeListener != null) {
					__completeListener (__guid);
				}

				var __class:Class /* <Dynamic> */ = m_soundChannels.get (__guid)[2];
				var __sound:Sound = m_soundChannels.get (__guid)[3];
				m_soundClassPoolManager.returnObject (__class, __sound);
				
				m_soundChannels.remove (__guid);
			}
		}

//------------------------------------------------------------------------------------------
		public function removeAllSounds ():void {	
			m_soundChannels.forEach (
				function (__guid:int):void {
					removeSound (__guid);
				}
			);
		}
		
//------------------------------------------------------------------------------------------
		public function getSoundChannel (__guid:int):MP3Sound {
			if (m_soundChannels.exists (__guid)) {
				return m_soundChannels.get (__guid)[0];
			}
			else
			{
				return null;
			}
		}	

//------------------------------------------------------------------------------------------
		public function pause ():void {
			m_soundChannels.forEach (
				function (__guid:int):void {
					var __soundChannel:MP3Sound = getSoundChannel (__guid);
					
					if (__soundChannel != null) {
						__soundChannel.pause ();
					}
				}
			);
		}
		
//------------------------------------------------------------------------------------------
		public function resume ():void {	
			m_soundChannels.forEach (
				function (__guid:int):void {
					var __soundChannel:MP3Sound = getSoundChannel (__guid);
					
					if (__soundChannel != null) {
						__soundChannel.resume ();
					}
				}
			);
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
