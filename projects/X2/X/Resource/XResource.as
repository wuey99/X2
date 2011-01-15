//------------------------------------------------------------------------------------------
package X.Resource {

	import X.Resource.Manager.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.system.*;
	
//------------------------------------------------------------------------------------------	
	public class XResource extends Object {
		protected var m_resourcePath:String;
		protected var m_resourceXML:XML;

//------------------------------------------------------------------------------------------
		public function XResource () {
		}
		
//------------------------------------------------------------------------------------------
		public function setup (
			__resourcePath:String, __resourceXML:XML,
			__parent:Sprite,
			__resourceManager:XSubResourceManager
			):void {
				
			m_resourcePath = "";
			m_resourceXML = null;
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
			return m_resourcePath;
		}

//------------------------------------------------------------------------------------------
		public function getResourceXML ():XML {
			return m_resourceXML;
		}

//------------------------------------------------------------------------------------------
		public function getAllClassNames ():Array {
			var __xmlList:XMLList = m_resourceXML.child ("*");
			var i:Number;
			var __classes:Array = new Array ();
						
			for (i=0; i<__xmlList.length (); i++) {
				__classes.push (__xmlList[i].@name);	
			}
			
			return __classes;
		}
				
//------------------------------------------------------------------------------------------
		public function getClassByName (__className:String):Class {
			return null;
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}