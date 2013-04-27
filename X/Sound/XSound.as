//------------------------------------------------------------------------------------------
package X.Sound {
	
	import X.*;
	
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	/**
	 * @author Andre Michelle (andre.michelle@gmail.com)
	 * @author Stefan van Dinther (stefan@eiland.cc)
	 */
	
	//------------------------------------------------------------------------------------------
	public class XSound extends EventDispatcher {
		
		//---------------------------------------------------------------------
		//  Members
		//---------------------------------------------------------------------
		
		private const BLOCK_SIZE: int = 3072;
		
		private var _loop: Boolean;
		
		private var _mp3: Sound;
		private var _sound: Sound;
		
		private var _target: ByteArray;
		
		private var _position: Number;
		private var _rate: Number;
		private var _volume: Number;
		
		private var _length: Number;
		private var _isPlaying: Boolean;
		
		//---------------------------------------------------------------------
		//  Constructor
		//---------------------------------------------------------------------
		/**
		 * Constructor
		 *
		 * @param url The url of the mp3-file to load.
		 * @param loop If true, the sound loops when playing.
		 */
		public function XSound(xApp:XApp, resourceName: String , loop:Boolean = true) {
			_loop = loop;
			_isPlaying = false;
			
			_mp3 = new (xApp.getClass (resourceName)) ();
			initSoundCompleteListeners();
			
			_target = new ByteArray();
			_position = 0.0;
			_rate = 1.0;
			_volume = 1.0;
		}
		
		//---------------------------------------------------------------------
		//  Events
		//---------------------------------------------------------------------
		
		/**
		 * Init sound load event listeners.
		 * @private
		 */
		private function initSoundCompleteListeners():void {
			_mp3.addEventListener( Event.COMPLETE, soundCompleteHandler );
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
			_mp3.removeEventListener( Event.COMPLETE, soundCompleteHandler );
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
		 * Handels a sound complete event.
		 * @private
		 */
		private function soundCompleteHandler( event: Event ): void
		{
			exitSoundCompleteListeners();
			_length = _mp3.length * 44.1;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * Handels a sampleData event.
		 * @private
		 */
		private function sampleDataHandler( event: SampleDataEvent ): void
		{
			//-- REUSE INSTEAD OF RECREATION
			_target.position = 0;
			
			//-- SHORTCUT
			var data: ByteArray = event.data;
			
			var scaledBlockSize: Number = BLOCK_SIZE * _rate;
			var positionInt: int = _position;
			var alpha: Number = _position - positionInt;
			
			var positionTargetNum: Number = alpha;
			
			//-- COMPUTE NUMBER OF SAMPLES NEED TO PROCESS BLOCK (+2 FOR INTERPOLATION)
			var need: int = Math.ceil( scaledBlockSize ) + 2;
			
			//-- EXTRACT SAMPLES
			var read: int = _mp3.extract( _target, need, positionInt );
			
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
		
		private function writeData(data, alpha, n:uint, positionTargetNum:Number): void {
			var positionTargetInt: int = -1;
			
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
		//  Getters && Setters
		//---------------------------------------------------------------------
		
		public function get rate(): Number {
			return _rate;
		}
		
		public function set rate( value: Number ): void {
			if( value < 0.1 ) {
				value = 0.1;
			}
			
			_rate = value;
		}
		
		public function get volume(): Number {
			return _volume;
		}
		
		public function set volume( value: Number ): void {
			if( value < 0.0 ) {
				value = 0;
			}
			
			_volume = value;
		}
		
		public function get position(): Number {
			return _position;
		}
		
		public function get length(): Number {
			return _length;
		}
		
		//---------------------------------------------------------------------
		//  Public methods
		//---------------------------------------------------------------------
		
		/**
		 * Plays the sound
		 */
		public function play(): void {
			if  (!_isPlaying) {
				_sound = new Sound();
				initSampleDataEventListeners();
				_sound.play();
				_isPlaying = true;
			}
		}
		
		/**
		 * Stops the sound
		 */
		public function stop(): void {
			if  (_isPlaying) {
				exitSampleDataEventListeners();
				_isPlaying = false;
				_sound = null;
			}
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------	
}
