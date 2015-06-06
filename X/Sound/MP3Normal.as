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
	
	import X.Collections.*;
	import X.Pool.*;
	import X.Task.*;
	import X.XApp;
	
	import flash.events.*;
	import flash.media.*;
	import flash.utils.*;;
	
//------------------------------------------------------------------------------------------	
	public class MP3Normal extends MP3Sound  {
		public var m_soundChannel:SoundChannel;
		public var m_function:Function;
		public var m_loops:Number;
		public var m_soundTransform:SoundTransform;
		public var m_position:int;
		
//------------------------------------------------------------------------------------------
		public function MP3Normal () {
			super ();
		}
		
//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
		}
		
//------------------------------------------------------------------------------------------
		public override function play (__startTime:Number, __loops:Number, __soundTransform:SoundTransform):void {
			m_loops = __loops;
			m_soundTransform = __soundTransform;
			
			m_soundChannel = m_mp3.play (__startTime, __loops, __soundTransform);
		}

//------------------------------------------------------------------------------------------
		public override function stop ():void {
			m_soundChannel.stop ();
			
			m_soundChannel.removeEventListener(Event.SOUND_COMPLETE, m_function);
		}
		
//------------------------------------------------------------------------------------------
		public override function pause ():void {
			m_position = m_soundChannel.position;
			
			m_soundChannel.stop ();
		}
		
//------------------------------------------------------------------------------------------
		public override function resume ():void {
			m_soundChannel = m_mp3.play (m_position, m_loops, m_soundTransform);
		}
		
//------------------------------------------------------------------------------------------
		public override function addCompleteListener (__function:Function):void {
			m_function = __function;
			
			m_soundChannel.addEventListener (Event.SOUND_COMPLETE, m_function);
		}

//------------------------------------------------------------------------------------------
		public function getSoundTransform ():SoundTransform {
			return m_soundChannel.soundTransform;		
		}
		
//------------------------------------------------------------------------------------------
		public function setSoundTransform (__transform:SoundTransform):void {
			m_soundChannel.soundTransform = __transform;
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
