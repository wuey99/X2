//------------------------------------------------------------------------------------------
package X.Datasource {
	
// flash classes
	import flash.utils.ByteArray;

//------------------------------------------------------------------------------------------
	public class XDatasource extends Object {
						
//------------------------------------------------------------------------------------------
		public function XDatasource () {	
			super ();
		}

//------------------------------------------------------------------------------------------
//		public function init ():void {
//		}
		
//------------------------------------------------------------------------------------------
//		public function open ():void {
//		}
		
//------------------------------------------------------------------------------------------
		public function close ():void {
		}

//------------------------------------------------------------------------------------------
		public function set position (__position:Number):void {
		}
	
//------------------------------------------------------------------------------------------	
		public function get position ():Number {
			return 0;
		}
		
//------------------------------------------------------------------------------------------	
		public function readByte ():int {
			return 0;
		}
		
//------------------------------------------------------------------------------------------	
		public function readBytes (__offset:Number, __length:Number):ByteArray {
			return null;
		}
		
//------------------------------------------------------------------------------------------	
		public function writeByte (__value:int):void {
		}
		
//------------------------------------------------------------------------------------------	
		public function writeBytes (__bytes:ByteArray, __offset:Number, __length:Number):void {
		}

//------------------------------------------------------------------------------------------
		public function readUTFBytes (__length:Number):String {
			return null;
		}

//------------------------------------------------------------------------------------------	
		public function writeUTFBytes (__value:String):void {
		}		
		
//------------------------------------------------------------------------------------------		
	}
	
//------------------------------------------------------------------------------------------
}