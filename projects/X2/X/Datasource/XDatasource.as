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
// For commercial use, you will need to provide additional credits.
// Please contact me @ wuey99[dot]gmail[dot]com for more details.
// <$end$/>
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
//		public function setup ():void {
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