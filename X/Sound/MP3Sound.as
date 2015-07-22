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
	public class MP3Sound extends EventDispatcher  {
		public var m_mp3:Sound;
		
//------------------------------------------------------------------------------------------
		public function MP3Sound () {
			super ();
		}

//------------------------------------------------------------------------------------------
		public function setup (__mp3:Sound):void {
			m_mp3 = __mp3;
		}
		
//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}
		
//------------------------------------------------------------------------------------------
		/* @:get, set rate Float */

		public function get rate():Number {
			return 0;
		}
		
		public function set rate( value:Number ): /* @:set_type */ void {
			/* @:set_return 0; */
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set volume Float */
		
		public function get volume():Number {
			return 0;
		}
		
		public function set volume( value:Number ): /* @:set_type */ void {
			/* @:set_return 0; */
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set position Float */
		
		public function get position():Number {
			return 0;
		}

		public function set position(value:Number): /* @:set_type */ void {
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set length Float */
		
		public function get length():Number {
			return 0;
		}
		
		public function set length(value:Number): /* @:set_type */ void {
			/* @:set_return 0; */
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function play (__startTime:Number, __loops:int, __soundTransform:SoundTransform):void {
		}

//------------------------------------------------------------------------------------------
		public function stop ():void {
		}

//------------------------------------------------------------------------------------------
		public function pause ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function resume ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function addCompleteListener (__function:Function):void {	
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
