//------------------------------------------------------------------------------------------
// <$begin$/>
// <$end$/>
//------------------------------------------------------------------------------------------
package X.Resource.Types {

	import X.Resource.*;
	import X.Resource.Manager.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------		
	public class XSWFResource extends XResource {
		protected var m_loader:Loader = null;
		protected var m_loadComplete:Boolean;
		protected var m_parent:Sprite;
		protected var m_resourceManager:XSubResourceManager;
		
//------------------------------------------------------------------------------------------
		public function XSWFResource () {
			super ();
		}
	
//------------------------------------------------------------------------------------------	
		public function resourceManager ():XSubResourceManager {
			return m_resourceManager;
		}	
		
//------------------------------------------------------------------------------------------
		public override function kill ():void {
			trace (": XResource: kill: ");
			
			m_parent.removeChild (m_loader);
			m_loader.unloadAndStop ();
			m_loader = null;
			m_loadComplete = false;
		}

//------------------------------------------------------------------------------------------
		private function __getClassByName (__className:String, __resourceName:String=""):Class {
			var c:Class;
			
			try {
				c = m_loader.contentLoaderInfo.applicationDomain.getDefinition (__className) as Class;
				
//				trace (": oooooooo: ", getQualifiedClassName (c));
			}
			catch (e:Error) {
// how should we handle this error?
				throw (Error ("unable to resolve: " + __className + " in " + __resourceName + ", error: " + e));
			}	
			
			return c;
		}
		
//------------------------------------------------------------------------------------------
		public override function getClassByName (__fullName:String):Class {
			if (m_loader == null) {
				loadResource ();
			}
			
			if (!m_loadComplete) {
				return null;
			}
			
			var r:XResourceName = new XResourceName (__fullName);
			
			var __resourceName:String = r.resourceName;
			var __className:String = r.className;
			
			var c:Class = __getClassByName (__className, __resourceName);	
			
			return c;
		}
		
//------------------------------------------------------------------------------------------
		public override function getAllClasses ():Array {
			if (m_loader == null) {
				loadResource ();
			}
			
			if (!m_loadComplete) {
				return null;
			}
			
			var i:Number;
			var __classNames:Array = getAllClassNames ();
			var __classes:Array = new Array ();
			
			for (i=0; i<__classNames.length; i++) {
				var c:Class;
				
				c = __getClassByName (__classNames[i]);
				
				__classes.push (c);			
			}
			
			return __classes;
		}
				
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}