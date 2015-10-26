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
package kx.resource.types {

	import flash.display.*;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.*;
	import flash.utils.*;
	
	import kx.resource.*;
	import kx.resource.manager.*;
	import kx.type.*;
	import kx.xml.*;
	
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
		public function getDefinition (__className:String):Class /* <Dynamic> */ {
			return null;
		}
		
//------------------------------------------------------------------------------------------
		private function __getClassByName (__className:String, __resourceName:String=""):Class /* <Dynamic> */ {
			var c:Class; // <Dynamic>
			
			try {
				c = /* @:cast */ getDefinition (__className);
				
//				trace (": oooooooo: ", getQualifiedClassName (c));
			}
			catch (e:Error) {
// how should we handle this error?
				throw (XType.createError ("unable to resolve: " + __className + " in " + __resourceName + ", error: " + e));
			}	
			
			return c;
		}
		
//------------------------------------------------------------------------------------------
		public override function getClassByName (__fullName:String):Class /* <Dynamic> */ {
			if (m_loader == null) {
				loadResource ();
			}
			
			if (!m_loadComplete) {
				return null;
			}
			
			var r:XResourceName = new XResourceName (__fullName);
			
			var __resourceName:String = r.resourceName;
			var __className:String = r.className;
			
			var c:Class /* <Dynamic> */ = __getClassByName (__className, __resourceName);	
			
			return c;
		}
		
//------------------------------------------------------------------------------------------
		public override function getAllClasses ():Array /* <Class<Dynamic>> */ {
			if (m_loader == null) {
				loadResource ();
			}
			
			if (!m_loadComplete) {
				return null;
			}
			
			var i:int;
			var __classNames:Array /* <String> */ = getAllClassNames ();
			var __classes:Array /* <Class<Dynamic>> */ = new Array (); // <Class<Dynamic>> 
			
			for (i=0; i<__classNames.length; i++) {
				var c:Class; // <Dynamic>
				
				c = __getClassByName (__classNames[i]);
				
				__classes.push (c);			
			}
			
			return __classes;
		}
				
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}