//------------------------------------------------------------------------------------------
package X.Sound {
	
	import X.XApp;
	
	import flash.events.Event;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	//------------------------------------------------------------------------------------------
	/**
	 * Sound wrapper which allows you to dynamically modify the rate of play.
	 *
	 * As the name suggests this file only operates on mp3 encoded tracks.
	 *
	 * @author Andre Michelle (andre.michelle@gmail.com)
	 * @author Alexander Schearer <aschearer@gmail.com>
	 */
	//------------------------------------------------------------------------------------------
	public class XSound
	{
		private const BLOCK_SIZE: int = 2048;
		
		private var _sound: Sound;
		
		private var _target: ByteArray;
		
		private var _playing:Boolean;
		private var _looping:Boolean;
		private var _channel:SoundChannel;
		private var _position: Number;
		private var _rate: Number;
		
		private var _mp3:Sound;
		
		private var m_XApp:XApp;
		
		//------------------------------------------------------------------------------------------
		public function XSound(__XApp:XApp):void
		{
			m_XApp = __XApp;
		}
		
		//------------------------------------------------------------------------------------------
		public function setupFromClassName (__className:String):void {	
			setupFromClass (m_XApp.getClass (__className));
		}
		
		//------------------------------------------------------------------------------------------
		public function setupFromClass (__class:Class):void {
			_target = new ByteArray();
			
			_position = 0.0;
			_rate = 1.0;
			
			_mp3 = new (__class) ();
			_sound = new Sound();
			_sound.addEventListener( SampleDataEvent.SAMPLE_DATA, sampleData );	
		}
		
		//------------------------------------------------------------------------------------------
		/**
		 * @return Boolean Whether the sound is currently playing
		 */
		//------------------------------------------------------------------------------------------
		public function get playing():Boolean
		{
			return _playing;
		}
		
		//------------------------------------------------------------------------------------------
		public function play(start:Number = 0, loops:int = 0, transform:SoundTransform = null):SoundChannel
		{
			if (_channel)
				return _channel;
			
			_channel = _sound.play();
			_channel.addEventListener(Event.SOUND_COMPLETE, soundComplete);
			_playing = true;
			
			return _channel;
		}
		
		//------------------------------------------------------------------------------------------
		/**
		 * Loops the sound after it finishes playing indefinitely.
		 */
		//------------------------------------------------------------------------------------------
		public function loop():SoundChannel
		{
			_looping = true;
			return play();
		}
		
		//------------------------------------------------------------------------------------------
		public function set paused(value:Boolean):void
		{
			if (value)
				pause();
			else
				resume();
		}
		
		//------------------------------------------------------------------------------------------
		/**
		 * Stops the music keeping track of its current position. Use resume
		 * to play the music from where it was left off.
		 */
		//------------------------------------------------------------------------------------------
		private function pause():void
		{
			if (!_channel)
				return;
			
			// bug position will not be set unless it's read once
			var p:uint = _channel.position; 
			_playing = false;
			_channel.stop();
		}
		
		//------------------------------------------------------------------------------------------
		/**
		 * Plays the music from wherever it was left off when paused. This
		 * can't be called unless the music has been paused.
		 */
		//------------------------------------------------------------------------------------------
		private function resume():SoundChannel
		{
			if (!_channel || _playing)
				return _channel;
			
			var p:Number = _channel.position;
			_playing = true;
			_channel = null;
			_channel = play(p);
			return _channel;
		}
		
		//------------------------------------------------------------------------------------------
		/**
		 * Stops the music disposing of its sound channel. Use play to restart
		 * the track.
		 */
		//------------------------------------------------------------------------------------------
		public function stop():void
		{
			if (!_channel)
				return;
			
			_rate = 1.0;
			_position = 0;
			_playing = false;
			_looping = false;
			_channel.stop();
			_channel = null;
		}
		
		//------------------------------------------------------------------------------------------
		private function soundComplete(e:Event):void
		{
			_playing = false;
			_position = 0;
			var transform:SoundTransform = _channel.soundTransform;
			_channel = null;
			if (_looping)
				play(0, 0, transform);
		}
		
		//------------------------------------------------------------------------------------------
		public function get rate(): Number
		{
			return _rate;
		}
		
		//------------------------------------------------------------------------------------------
		public function set rate( value: Number ): void
		{
			if( value < 0.0 )
				value = 0;
			_rate = value;
		}
		
		//------------------------------------------------------------------------------------------
		private function sampleData( event: SampleDataEvent ): void
		{
			//-- REUSE INSTEAD OF RECREATION
			_target.position = 0;
			
			//-- SHORTCUT
			var data: ByteArray = event.data;
			
			var scaledBlockSize: Number = BLOCK_SIZE * _rate;
			var positionInt: int = _position;
			var alpha: Number = _position - positionInt;
			
			var positionTargetNum: Number = alpha;
			var positionTargetInt: int = -1;
			
			//-- COMPUTE NUMBER OF SAMPLES NEED TO PROCESS BLOCK (+2 FOR INTERPOLATION)
			var need: int = Math.ceil( scaledBlockSize ) + 2;
			
			//-- EXTRACT SAMPLES
			var read: int = _mp3.extract( _target, need, positionInt );
			
			if (_target.bytesAvailable == 0) {
				return;
			}
			
			var n: int = read == need ? BLOCK_SIZE : read / _rate;
			
			var l0: Number;
			var r0: Number;
			var l1: Number;
			var r1: Number;
			
			for( var i: int = 0 ; i < n ; ++i )
			{
				//-- AVOID READING EQUAL SAMPLES, IF RATE < 1.0
				if( int( positionTargetNum ) != positionTargetInt )
				{
					positionTargetInt = positionTargetNum;
					
					//-- SET TARGET READ POSITION
					_target.position = positionTargetInt << 3;
					
					//-- READ TWO STEREO SAMPLES FOR LINEAR INTERPOLATION
					l0 = _target.readFloat();
					r0 = _target.readFloat();
					
					l1 = _target.readFloat();
					r1 = _target.readFloat();
				}
				
				//-- WRITE INTERPOLATED AMPLITUDES INTO STREAM
				data.writeFloat( l0 + alpha * ( l1 - l0 ) );
				data.writeFloat( r0 + alpha * ( r1 - r0 ) );
				
				//-- INCREASE TARGET POSITION
				positionTargetNum += _rate;
				
				//-- INCREASE FRACTION AND CLAMP BETWEEN 0 AND 1
				alpha += _rate;
				while( alpha >= 1.0 ) --alpha;
			}
			
			//-- INCREASE SOUND POSITION
			_position += scaledBlockSize;
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
