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
package X.Resource.Manager {
	
	import X.Collections.*;
	import X.Resource.*;
	import X.Task.*;
	import X.XApp;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.*;
	
//------------------------------------------------------------------------------------------
// XProjectManager
//
// manages the main project which can contain one more more sub-projects
//------------------------------------------------------------------------------------------	
	public class XProjectManager extends Object {
		private var m_XApp:XApp;
		private var m_parent:Sprite;
		private var m_rootPath:String;
		private var m_projectName:String;
		private var m_loadComplete:Boolean;
		private var m_projectXML:XML;
		private var m_loaderContextFactory:Function;
		private var m_subResourceManagers:Array; // <XSubResourceManager>
		private var m_callback:Function;
		private var m_embeddedResources:XDict; // <String, Class<Dynamic>>
				
//------------------------------------------------------------------------------------------		
		public function XProjectManager (__XApp:XApp) {
			super ();

			m_XApp = __XApp;
			m_loadComplete = true;
			m_projectXML = null;
			m_embeddedResources = new XDict (); // <String, Class<Dynamic>>
		}

//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function kill ():void {
			reset ();
		}
		
//------------------------------------------------------------------------------------------
		public function reset ():void {
			var i:int;
			
			for (i=0; i<m_subResourceManagers.length; i++) {
				m_subResourceManagers[i].kill ();
			}
			
			while (m_subResourceManagers.length) {
				m_subResourceManagers.pop ();
			}
		}
				
//------------------------------------------------------------------------------------------
		public function setupFromURL (
			__parent:Sprite,
			__rootPath:String,
			__projectName:String,
			__callback:Function,
			__loaderContextFactory:Function
			):void {
				
			m_parent = __parent;
			m_subResourceManagers = new Array (); // <XSubResourceManager>
			setBothPaths (__rootPath, __projectName);
			m_loaderContextFactory = __loaderContextFactory;
			loadProjectFromURL (__rootPath, __projectName, __callback);
		}

//------------------------------------------------------------------------------------------	
		public function setLoaderContextFactory (__loaderContextFactory:Function):void {
			m_loaderContextFactory = __loaderContextFactory;
		}

//------------------------------------------------------------------------------------------	
		public function loaderContextFactory ():Function {
			return m_loaderContextFactory;
		}
				
//------------------------------------------------------------------------------------------	
		public function loadProjectFromURL (
			__rootPath:String,
			__projectName:String,
			__callback:Function):Boolean {
				
			if (!m_loadComplete) {
				return false;
			}
			
			reset ();
			
			if (__projectName != null) {
				m_loadComplete = false;
			
				m_rootPath = __rootPath;
			
				var __loader:URLLoader = __loadProjectFromURL (m_rootPath + __projectName);
				__loader.addEventListener (Event.COMPLETE, __completeHandler);
			}
			
			m_callback = __callback;
				
			return true;
						
//------------------------------------------------------------------------------------------					
     	   function __completeHandler(event:Event):void {
				try {
	     	   		var __loader:URLLoader = event.target as URLLoader;
     	   		  
     	   		  	var xml:XML = new XML (__loader.data);
     	   		  	m_projectXML = xml;
     	   		  	
					__importManifests ();
     	   		}
     	   		catch (e:Error) {
     	   			throw (new Error ("Not a valid XML file"));
     	   		}
     	   		
				m_loadComplete = true;
			}
			
//------------------------------------------------------------------------------------------
			function __loadProjectFromURL (__url:String):URLLoader {
				var __loader:URLLoader = new URLLoader ();
				var __urlReq:URLRequest = new URLRequest (__url);
	
				__loader.load (__urlReq);
				
				return __loader;
			}
		}

//------------------------------------------------------------------------------------------	
		public function setBothPaths (__rootPath:String, __projectName:String):void {
			m_rootPath = __rootPath;
			m_projectName = __projectName;
		}
		
//------------------------------------------------------------------------------------------
		public function setRootPath (__rootPath:String):void {
			m_rootPath = __rootPath;
		}

//------------------------------------------------------------------------------------------
		public function getRootPath ():String {
			return m_rootPath;
		}
		
//------------------------------------------------------------------------------------------
		public function setupFromXML (
			__parent:Sprite,
			__rootPath:String,
			__xml:XML,
			__callback:Function,
			__loaderContextFactory:Function
			):void {
				
			m_parent = __parent;
			m_subResourceManagers = new Array (); // <XSubResourceManager>
			m_loaderContextFactory = __loaderContextFactory;
			loadProjectFromXML (__rootPath, __xml, __callback);
		}
		
//------------------------------------------------------------------------------------------
		public function loadProjectFromXML (
			__rootPath:String,
			__xml:XML,
			__callback:Function):Boolean {
				
			reset ();
			
			m_loadComplete = false;
			
			m_rootPath = __rootPath;	
			m_callback = __callback;
			m_projectXML = __xml;
			
			__importManifests ();
			
			m_loadComplete = true;
			
			return true;
		}
		
//------------------------------------------------------------------------------------------
		private function __importManifests ():void {	
			var __xmlList:XMLList = m_projectXML.child ("manifest");
			
			var i:Number;
				
			for (i=0; i<__xmlList.length (); i++) {
				var __subResourceManager:XSubResourceManager = new XSubResourceManager ();
				
				var __manifestList:XMLList = __xmlList[i].child ("*");
				var __manifest:XML = null;
				if (__manifestList.length ()) {
					__manifest = __manifestList[0];	
				}
	
				if (__manifest == null) {
					__subResourceManager.setupFromURL (
						this,
						m_parent,
						getRootPath (),
						__xmlList[i].attribute ("name"),
						null,
						loaderContextFactory ()
						);
				}
				else
				{
					__subResourceManager.setupFromXML (
						this,
						m_parent,
						getRootPath (),
						__manifest,
						null,
						loaderContextFactory ()
						);				
				}
					
				addSubResourceManager (__subResourceManager);
			}
			
			m_XApp.getXTaskManager ().addTask ([		
					XTask.LABEL, "__wait",		
						XTask.FLAGS, function (__XTask:XTask):void {
							__XTask.setFlagsBool (resourceManagerReady ());
						},
						
						XTask.WAIT, 0x0100,
						
						XTask.BNE, "__wait",
					
					function ():void {
						if (m_callback != null) {
							m_callback ();
						}
					},
					
				XTask.RETN,
			]);
		}
		
//------------------------------------------------------------------------------------------
		public function addSubResourceManager (__subResourceManager:XSubResourceManager):void {
			m_subResourceManagers.push (__subResourceManager);
		}

//------------------------------------------------------------------------------------------
		public function addEmbeddedResource (__resourcePath:String, __swfBytes:Class /* <Dynamic> */):void {
			m_embeddedResources.set (__resourcePath, __swfBytes);
		}

//------------------------------------------------------------------------------------------
		public function findEmbeddedResource (__resourcePath:String):Class /* <Dynamic> */ {
			return /* @:cast */ m_embeddedResources.get (__resourcePath) as Class /* <Dynamic> */;
		}
					
//------------------------------------------------------------------------------------------
		public function getProject ():XML {
			return m_projectXML;
		}
		
//------------------------------------------------------------------------------------------
		public function resourceManagerReady ():Boolean {
			if (!m_loadComplete) {
				return false;
			}
			
			var i:Number;
			var r:XSubResourceManager;
			var c:Class; // <Dynamic>
			
			for (i=0; i<m_subResourceManagers.length; i++) {
				r = m_subResourceManagers[i];
				
				if (!r.resourceManagerReady ()) {
					return false;
				}
			}
			
			return true;
		}

//------------------------------------------------------------------------------------------
		public function deleteManifest (__xml:XML):void {
// <HAXE>
/* --
			not implemented in HaXe
-- */
// </HAXE>
// <AS3>
			delete __xml.parent ().(@name == __xml.@name)[0];
// </AS3>
		}		
		
//------------------------------------------------------------------------------------------
		public function insertManifest (__xmlItem:XML, __xmlToInsert:XML):void {			
			if (__xmlItem == null) {
				return;
			}
				
			if (__xmlItem.localName () == "resource") {
				__xmlItem.insertChildAfter (__xmlItem, __xmlToInsert);
			}
		}

//------------------------------------------------------------------------------------------
		public function resourceManagers ():Array /* <XSubResourceManager */ {
			return m_subResourceManagers;
		}

//------------------------------------------------------------------------------------------
		public function getResourceManagerByName (__name:String):XSubResourceManager {
			for (var i:int = 0; i < m_subResourceManagers[i].length; i++) {
				if (m_subResourceManagers[i].getName () == __name) {
					return m_subResourceManagers[i] as XSubResourceManager;
				}
			}

			return null;
		}
	
//------------------------------------------------------------------------------------------
// looks up Class based on the full class name
//------------------------------------------------------------------------------------------
		public function getClassByName (__className:String):Class /* <Dynamic> */ {
			if (!resourceManagerReady ()) {
				return null;
			}
			
			if (__className == "XLogicObjectXMap:XLogicObjectXMap") {
				import X.XMap.*;
				
				return XLogicObjectXMap;
			}
			
			var i:Number;
			var r:XSubResourceManager;
			var c:Class; // <Dynamic>
			
			for (i=0; i<m_subResourceManagers.length; i++) {
				r = m_subResourceManagers[i];
				
				try {
					c = r.getClassByName (__className);
				}
				catch (e:Error) {
					var error:String = "className not found in manifest";
					
					if (e.message.substring (0, error.length) == error) {
						continue;
					}
					else
					{
						throw (e);
					}
				}
				
				return c;
			}
			
			throw (Error ("className not found in any manifest: " + __className));
		}	

//------------------------------------------------------------------------------------------
// unloads a Class based on the full class name
//------------------------------------------------------------------------------------------
		public function unloadClassByName (__className:String):Boolean {
			if (!resourceManagerReady ()) {
				return false;
			}
			
			var i:Number;
			var r:XSubResourceManager;
			var results:Boolean;
			
			for (i=0; i<m_subResourceManagers.length; i++) {
				r = m_subResourceManagers[i];
				
				try {
					results = r.unloadClassByName (__className);
				}
				catch (e:Error) {
					var error:String = "className not found in manifest";
					
					if (e.message.substring (0, error.length) == error) {
						continue;
					}
					else
					{
						throw (e);
					}
				}
				
				return results;
			}
			
			throw (Error ("className not found in any manifest: " + __className));
		}
		
//------------------------------------------------------------------------------------------
		public function	cacheClassNames ():Boolean {
			if (!resourceManagerReady ()) {
				return false;
			}
			
			var i:Number;
			var r:XSubResourceManager;
			
			for (i=0; i<m_subResourceManagers.length; i++) {
				r = m_subResourceManagers[i];
				
				trace (": resourceManager: ", r);
				
				r.cacheClassNames (r.getManifest ().child ("folder")[0].child ("*"));
			}
			
			return true;
		}	
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}