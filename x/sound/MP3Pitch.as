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
	import x.XApp;
	
	import flash.events.*;
	import flash.media.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------	
	public class MP3Pitch extends MP3Sound  {
		private const BLOCK_SIZE:int = 3072;
		
		private var _loop: Boolean;
		
//		private var m_mp3: Sound;
		private var _sound: Sound;
		
		private var _target: ByteArray;
		
		private var _position:Number;
		private var _rate:Number;
		private var _volume:Number;
		
		private var _length:int;
		private var _isPlaying: Boolean;
		
		private var m_function:Function;
		
//------------------------------------------------------------------------------------------
		public function MP3Pitch () {
			super ();
		}

//------------------------------------------------------------------------------------------
		public override function setup (__mp3:Sound):void {
			super.setup (__mp3);
			
			_isPlaying = false;
			
			initSoundCompleteListeners();
			
			_target = new ByteArray();
			_position = 0.0;
			_rate = 1.0;
			_volume = 1.0;
		}
		
//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
		}
		
		
		//---------------------------------------------------------------------
		//  Events
		//---------------------------------------------------------------------
		
		/**
		 * Init sound load event listeners.
		 * @private
		 */
		private function initSoundCompleteListeners():void {
			m_mp3.addEventListener( Event.COMPLETE, soundCompleteHandler );
		}
		
		/**
		 * Init a SampleData listener.
		 * @private
		 */
		private function initSampleDataEventListeners():void {
			_sound.addEventListener( SampleDataEvent.SAMPLE_DATA, sampleDataHandler );
		}
		
		/**
		 * Exit sound load event listeners.
		 * @private
		 */
		private function exitSoundCompleteListeners():void {
			m_mp3.removeEventListener( Event.COMPLETE, soundCompleteHandler );
		}
		
		/**
		 * Exit a SampleData listener.
		 * @private
		 */
		private function exitSampleDataEventListeners():void {
			_sound.removeEventListener( SampleDataEvent.SAMPLE_DATA, sampleDataHandler );
		}
		
		//---------------------------------------------------------------------
		//  Event handlers
		//---------------------------------------------------------------------
		
		/**
		 * Handles a sound complete event.
		 * @private
		 */
		private function soundCompleteHandler( event: Event ):void
		{
			exitSoundCompleteListeners();
			_length = m_mp3.length * 44.1;
			dispatchEvent(new Event(Event.COMPLETE));
			if (m_function != null) {
				m_function ();
			}
		}
		
		/**
		 * Handles a sampleData event.
		 * @private
		 */
		private function sampleDataHandler( event: SampleDataEvent ):void
		{
			//-- REUSE INSTEAD OF RECREATION
			_target.position = 0;
			
			//-- SHORTCUT
			var data: ByteArray = event.data;
			
			var scaledBlockSize:Number = BLOCK_SIZE * _rate;
			var positionInt:int = _position;
			var alpha:Number = _position - positionInt;
			
			var positionTargetNum:Number = alpha;
			
			//-- COMPUTE NUMBER OF SAMPLES NEED TO PROCESS BLOCK (+2 FOR INTERPOLATION)
			var need:int = Math.ceil( scaledBlockSize ) + 2;
			
			//-- EXTRACT SAMPLES
			var read:int = m_mp3.extract( _target, need, positionInt );
			
			var n:uint;
			
			if (read == need) {
				n = BLOCK_SIZE;
			}
			else {
				n = read / _rate;
			}
			
			writeData(data, alpha, n, positionTargetNum);
			
			if( n < BLOCK_SIZE )
			{
				if (_loop) {
					positionTargetNum = 0;
					_position = 0;
					n = BLOCK_SIZE - n;
					
					writeData(data, alpha, n, positionTargetNum);
					
					_position = n;
				}
				else {
					//-- SET AT START OF SOUND FOR REPLAY
					_position = 0;
					stop();
				}
			}
			else {
				//-- INCREASE SOUND POSITION
				_position += scaledBlockSize;
			}
		}
		
		private function writeData(data, alpha, n:uint, positionTargetNum:Number):void {
			var positionTargetInt:int = -1;
			
			var l0:Number;
			var r0:Number;
			var l1:Number;
			var r1:Number;
			
			for (var i:int = 0; i < n; ++i )
			{
				//-- AVOID READING EQUAL SAMPLES, IF RATE < 1.0
				if( int( positionTargetNum ) != positionTargetInt )
				{
					positionTargetInt = positionTargetNum;
					
					//-- SET TARGET READ POSITION
					_target.position = positionTargetInt << 3;
					
					//-- READ TWO STEREO SAMPLES FOR LINEAR INTERPOLATION
					try {
						l0 = _target.readFloat();
						r0 = _target.readFloat();
						
						l1 = _target.readFloat();
						r1 = _target.readFloat();
					} catch (errObject:Error) {
						// IF WE ENTER AN END_OF_FILE FILL REST OF STREAM WITH ZEROs
						l0 = 0;
						r0 = 0;
						
						l1 = 0;
						l1 = 0;
					}
				}
				
				//-- WRITE INTERPOLATED AMPLITUDES INTO STREAM
				data.writeFloat( (l0 + alpha * ( l1 - l0 )) * _volume );
				data.writeFloat(( r0 + alpha * ( r1 - r0 )) * _volume );
				
				//-- INCREASE TARGET POSITION
				positionTargetNum += _rate;
				
				//-- INCREASE FRACTION AND CLAMP BETWEEN 0 AND 1
				alpha += _rate;
				while( alpha >= 1.0 ) --alpha;
			}
		}
		
		//---------------------------------------------------------------------
		//  Getters & Setters
		//---------------------------------------------------------------------
		
		/* @:override get, set rate Float */
		
		public override function get rate():Number {
			return _rate;
		}
		
		public override function set rate( value:Number ): /* @:set_type */ void {
			if( value < 0.1 ) {
				value = 0.1;
			}
			
			_rate = value;
			
			/* @:set_return 0; */
		}
		/* @:end */
		
		/* @:override get, set volume Float */
		
		public override function get volume():Number {
			return _volume;
		}
		
		public override function set volume( value:Number ): /* @:set_type */ void {
			if( value < 0.0 ) {
				value = 0;
			}
			
			_volume = value;
			
			/* @:set_return 0; */
		}
		/* @:end */
		
		/* @:override get, set position Float */
		
		public override function get position():Number {
			return _position;
		}
		/* @:end */
		
		/* @:override get, set length Float */
		
		public override function get length():Number {
			return _length;
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public override function play (__startTime:Number, __loops:int, __soundTransform:SoundTransform):void {
			_loop = (__loops > 1);
			
			if  (!_isPlaying) {
				_sound = new Sound();
				initSampleDataEventListeners();
				_sound.play();
				_isPlaying = true;
			}
		}

//------------------------------------------------------------------------------------------
		public override function stop ():void {
			if  (_isPlaying) {
				exitSampleDataEventListeners();
				_isPlaying = false;
				_sound = null;
			}
		}
		
//------------------------------------------------------------------------------------------
		public override function addCompleteListener (__function:Function):void {	
			m_function = __function;
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
