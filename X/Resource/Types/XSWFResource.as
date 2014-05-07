//------------------------------------------------------------------------------------------
// Copyright (C) 2014 Jimmy Huey
//
// Some Rights Reserved.
//
// The "X-Engine" is licensed under a Creative Commons
// Attribution-Share Alike 3.0 United States License.
// (CC BY-SA 3.0)
//
// You are free to:
//
//      SHARE - to copy, distribute, display and perform the work.
//      ADAPT - remix, transform build upon this material, even for commercial works.
//
//      The licensor cannot revoke these freedoms as long as you follow the license terms.
//
// Under the following terms:
//
//      ATTRIBUTION — 
//      You must give appropriate credit, provide a link to the license, and
//      indicate if changes were made.  You may do so in any reasonable manner,
//      but not in any way that suggests the licensor endorses you or your use.
//
//      SHARE-ALIKE -
//      If you remix, transform, or build upon the material, you must
//      distribute your contributions under the same license as the original.
//
// No additional restrictions — You may not apply legal terms or technological measures
// that legally restrict others from doing anything the license permits. 
//
// The full summary can be located at:
// http://creativecommons.org/licenses/by-sa/3.0/us/ 
//
// The human-readable summary of the Legal Code can be located at:
// http://creativecommons.org/licenses/by-sa/3.0/us/legalcode
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