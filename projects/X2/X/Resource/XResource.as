//------------------------------------------------------------------------------------------
package X.Resource {

	import X.Resource.Manager.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.system.*;
	
//------------------------------------------------------------------------------------------	
	public class XResource extends Object {
		
//------------------------------------------------------------------------------------------
		public function XResource () {
		}
		
//------------------------------------------------------------------------------------------
		public function setup (
			__resourcePath:String,
			__parent:Sprite,
			__resourceManager:XSubResourceManager
			):void {
		}
			
//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}
		
//------------------------------------------------------------------------------------------		
		public function loadResource ():void {		
		}
		
//------------------------------------------------------------------------------------------
		public function kill ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function getResourcePath ():String {
			return "";
		}

//------------------------------------------------------------------------------------------
		public function getClassByName (__className:String):Class {
			return null;
		}

//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}