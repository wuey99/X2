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
	import X.Resource.Types.*;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.*;
	
	//------------------------------------------------------------------------------------------
	// XSubResourceManager
	//
	// A resource manager for external swf's.  On initialization, the resource manager is
	// provided with a Manifest, which is an XML file which maps a human-readable resource name
	// with a URL.  It's possible than in the future the resource look-up could be done server-side.
	//
	// Given a "resource name", the resource manager will attempt to locate the resource in memory
	// if it's not found in memory, it'll attempt to load it.  Currently, there's no provision
	// to unload resources.  In the future, we'll attempt to implement a system to better manage
	// in-memory resources. Some things under consideration:  An LRU system will discard selodmly
	// used assets.
	//------------------------------------------------------------------------------------------	
	public class XSubResourceManager extends IResourceManager {
		private var m_manifestXML:XML;
		private var m_projectManager:XProjectManager;
		private var m_resourceMap:XDict; // <String, XResource>
		private var m_classMap:XDict; // <String, XClass>
		private var m_parent:Sprite;
		private var m_rootPath:String;
		private var m_manifestName:String;
		private var m_loadComplete:Boolean;
		private var m_loaderContextFactory:Function;
		private var m_cachedClassName:XDict; // <String, XML>
		
		public static var CLASS_TYPE:String = "classX";
		public static var RESOURCE_TYPE:String = "resource";
		public static var FOLDER_TYPE:String = "folder";
		
		//------------------------------------------------------------------------------------------		
		public function XSubResourceManager () {
			super ();
			
			m_resourceMap = new XDict (); // <String, XResource>
			m_classMap = new XDict (); // <String, XClass>
			m_cachedClassName = new XDict (); // <String, XML>
			
			m_loaderContextFactory = null;
			
			m_loadComplete = true;
			m_manifestXML = null;
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
			
			// unload .swf's here?
			m_resourceMap = new XDict (); //  <String, XResource>
			m_classMap = new XDict (); //  <String, XClass>
		}
		
		//------------------------------------------------------------------------------------------
		public function setupFromURL (
			__projectManager:XProjectManager,
			__parent:Sprite,
			__rootPath:String,
			__manifestName:String,
			__callback:Function,
			__loaderContextFactory:Function
		):void {
			
			m_projectManager = __projectManager;
			m_parent = __parent;
			setBothPaths (__rootPath, __manifestName);
			m_loaderContextFactory = __loaderContextFactory;
			
			loadManifestFromURL (__rootPath, __manifestName, __callback);
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
		public function loadManifestFromURL (
			__rootPath:String,
			__manifestName:String,
			__callback:Function):Boolean {
			
			if (!m_loadComplete) {
				return false;
			}
			
			if (__manifestName != null) {
				m_loadComplete = false;
				
				m_rootPath = __rootPath;
				
				var __loader:URLLoader = __loadManifestFromURL (m_rootPath + __manifestName);
				__loader.addEventListener (Event.COMPLETE, __completeHandler);
			}
			
			if (__callback != null) {
				__loader.addEventListener (Event.COMPLETE, __callback);
			}
			
			return true;
			
			//------------------------------------------------------------------------------------------					
			function __completeHandler(event:Event):void {
				try {
					var __loader:URLLoader = event.target as URLLoader;
					
					var __xml:XML = new XML (__loader.data);
					
					setManifest (__xml);
				}
				catch (e:Error) {
					throw (new Error ("Not a valid XML file"));
				}
				
				m_loadComplete = true;
			}
			
			//------------------------------------------------------------------------------------------
			function __loadManifestFromURL (__url:String):URLLoader {
				var __loader:URLLoader = new URLLoader ();
				var __urlReq:URLRequest = new URLRequest (__url);
				
				__loader.load (__urlReq);
				
				return __loader;
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function setupFromXML (
			__projectManager:XProjectManager,
			__parent:Sprite,
			__rootPath:String,
			__xml:XML,
			__callback:Function,
			__loaderContextFactory:Function
		):void {
			
			m_projectManager = __projectManager;
			m_parent = __parent;
			setBothPaths (__rootPath, "");
			m_loaderContextFactory = __loaderContextFactory;
			
			loadManifestFromXML (__rootPath, __xml, __callback);
		}
		
		//------------------------------------------------------------------------------------------
		public function loadManifestFromXML (
			__rootPath:String,
			__xml:XML,
			__callback:Function):Boolean {
			
			m_loadComplete = false;
			
			m_rootPath = __rootPath;
			
			setManifest (__xml);
			
			if (__callback != null) {
				__callback ();
			}
			
			m_loadComplete = true;
			
			return true;		
		}
		
		//------------------------------------------------------------------------------------------
		public function findEmbeddedResource (__resourcePath:String):Class /* <Dynamic> */ {
			return m_projectManager.findEmbeddedResource (__resourcePath);
		}
		
		//------------------------------------------------------------------------------------------
		public function setManifest (__xml:XML):void {
			m_manifestXML = __xml;
		}
		
		//------------------------------------------------------------------------------------------	
		public function setBothPaths (__rootPath:String, __manifestName:String):void {	
			m_rootPath = __rootPath;
			m_manifestName = __manifestName;
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
		public function getManifestName ():String {
			return m_manifestName;
		}
		
		//------------------------------------------------------------------------------------------
		public function getName ():String {
			return getManifestName ().substr(0, getManifestName ().lastIndexOf('.'))
		}
		
		//------------------------------------------------------------------------------------------
		public function getManifest ():XML {
			return m_manifestXML;
		}
		
		//------------------------------------------------------------------------------------------
		public function resourceManagerReady ():Boolean {
			return m_loadComplete;
		}
		
		//------------------------------------------------------------------------------------------
		public override function deleteResourceXML (__xml:XML):void {
			//			delete __xml.parent ().resource.(@name == __xml.@name)[0];
			
			// let it match any node name
			delete __xml.parent ().*.(@name == __xml.@name)[0];
		}		
		
		//------------------------------------------------------------------------------------------
		public override function insertResourceXML (__xmlItem:XML, __xmlToInsert:XML):void {			
			if (__xmlItem == null) {
				return;
			}
			
			if (__xmlItem.localName () == XSubResourceManager.CLASS_TYPE) {
				__xmlItem.parent ().insertChildAfter (__xmlItem.parent (), __xmlToInsert);
			}
			
			if (__xmlItem.localName () == XSubResourceManager.RESOURCE_TYPE) {
				__xmlItem.parent ().insertChildAfter (__xmlItem, __xmlToInsert);
			}
			
			if (__xmlItem.localName () == XSubResourceManager.FOLDER_TYPE) {
				__xmlItem.appendChild (__xmlToInsert);
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function findResourceXMLFromName (__resourceName:String):XML {	
			return findNodeFromResourceName (
				null,
				__resourceName,
				m_manifestXML.folder.child ("*")
			);
		}
		
		//------------------------------------------------------------------------------------------
		public function findResourceFromName (__resourceName:String):XResource {
			var __resourceXML:XML = findResourceXMLFromName (__resourceName);
			
			return __getXResourceFromPath (
				__resourceXML.@path + "\\" +__resourceXML.@dst,
				__resourceXML
			);
		}
		
		//------------------------------------------------------------------------------------------
		// looks up Class based on the full class name
		//------------------------------------------------------------------------------------------
		public override function getClassByName (__className:String):Class /* <Dynamic> */ {
			if (!m_loadComplete) {
				return null;
			}
			
			trace (": XResourceManager:getClass (): ", __className);
			
			var __XClass:XClass = __resolveXClass (__className);
			
			var __class:Class /* <Dynamic> */ = __XClass.getClass ();
			
			if (__class == null) {
				__class = __resolveClass (__XClass);
			}
			
			if (__class != null) {
				__XClass.count++;
				
				var __r:XResource = m_resourceMap.get (__XClass.getResourcePath ()) as XResource;
				__r.count++;
				
				trace (": getClassByName: loaded: ", __XClass.count, __r.count, __class);
			}
			
			return __class;
		}
		
		//------------------------------------------------------------------------------------------
		// unloads a class by name.  returns false if the resource hasn't been loaded yet. 
		// returns true if when the resource is successfully unloaded.
		//------------------------------------------------------------------------------------------
		public function unloadClassByName (__className:String):Boolean {
			return false;
			
			if (!m_loadComplete) {
				return false;
			}
			
			var __XClass:XClass = __resolveXClass (__className);
			
			var __class:Class /* <Dynamic> */ = __XClass.getClass ();
			
			if (__class == null) {
				__class = __resolveClass (__XClass);
				
				if (__class == null) {
					return false;
				}
			}
			
			__XClass.count--;
			
			var __r:XResource = m_resourceMap.get (__XClass.getResourcePath ()) as XResource;
			__r.count--;
			
			trace (": unloadClassName: ", __className, __XClass.count, __r.count);
			
			if (__XClass.count == 0) {
				m_classMap.remove (__className);
			}
			
			if (__r.count == 0) {
				__r.kill ();
				
				m_resourceMap.remove (__XClass.getResourcePath ());
			}
			
			return true;
		}
		
		//------------------------------------------------------------------------------------------
		// eventually replace:
		//
		// findNodeFromSrcName
		// findNodeFromResourceName
		// findNodeFromClassName
		//------------------------------------------------------------------------------------------
		public function iterateAllNodes (
			__match:XML,
			__xmlList:XMLList,
			__callback:Function
		):XML {
			
			var i:int;
			
			for (i = 0; i<__xmlList.length (); i++) {
				if (__xmlList[i].localName () == "folder") {
					var nuMatch:XML = iterateAllNodes (
						__match,
						__xmlList[i].child ("*"),
						__callback
					);
					
					if (nuMatch != null) {
						__match = nuMatch;
					}
				}
				else
				{	
					var __results:Array /* XMLList */ = __callback (__xmlList[i]);
					
					if (__results[0]) {
						__match = __results[1];
					}
				}
			}
			
			return __match;			
		}
		
		//------------------------------------------------------------------------------------------
		public function findNodeFromSrcName (
			__match:XML,
			__srcName:String,
			__xmlList:XMLList
		):XML {
			
			var i:int, j:int;
			
			for (i = 0; i<__xmlList.length (); i++) {
				if (__xmlList[i].localName () == "folder") {
					var nuMatch:XML = findNodeFromSrcName (
						__match,
						__srcName,
						__xmlList[i].child ("*")
					);
					
					if (nuMatch != null) {
						__match = nuMatch;
					}
				}
				else
				{				
					if (__srcName == __xmlList[i].@src) {	
						__match = __xmlList[i];
					}
				}
			}
			
			return __match;
		}
		
		//------------------------------------------------------------------------------------------
		public function findNodeFromResourceName (
			__match:XML,
			__resourceName:String,
			__xmlList:XMLList
		):XML {
			
			var i:int, j:int;
			
			for (i = 0; i<__xmlList.length (); i++) {
				if (__xmlList[i].localName () == "folder") {
					var nuMatch:XML = findNodeFromResourceName (
						__match,
						__resourceName,
						__xmlList[i].child ("*")
					);
					
					if (nuMatch != null) {
						__match = nuMatch;
					}
				}
				else
				{
					if (__resourceName == __xmlList[i].@name) {
						__match = __xmlList[i];
					}
				}
			}
			
			return __match;
		}
		
		//------------------------------------------------------------------------------------------
		public function findNodeFromXML (
			__match:XML,
			__xml:XML,
			__xmlList:XMLList
		):XML {
			
			var i:int, j:int;
			
			for (i = 0; i<__xmlList.length (); i++) {
				if (__xml == __xmlList[i]) {
					__match = __xmlList[i];
				}
				else if (__xmlList[i].localName () == "folder") {
					var nuMatch:XML = findNodeFromXML (
						__match,
						__xml,
						__xmlList[i].child ("*")
					);
					
					if (nuMatch != null) {
						__match = nuMatch;
					}
				}
			}
			
			return __match;
		}
		
		//------------------------------------------------------------------------------------------
		// look for an e4x-centric way of finding a "classX" name
		// my intuition tells me that this method can be achieved via e4x
		//------------------------------------------------------------------------------------------
		public function findNodeFromClassName (
			__match:XML,
			__resourceName:String,
			__className:String,
			__xmlList:XMLList
		):XML {
			
			if (m_cachedClassName.exists (__className)) {			
				return m_cachedClassName.get (__className) as XML;
			}
			
			var i:int, j:int;
			
			for (i = 0; i<__xmlList.length (); i++) {
				if (__xmlList[i].localName () == "folder") {
					var nuMatch:XML = findNodeFromClassName (
						__match,
						__resourceName,
						__className,
						__xmlList[i].child ("*")
					);
					
					if (nuMatch != null) {
						__match = nuMatch;
					}
				}
				else
				{
					if (__resourceName == __xmlList[i].@name) {
						for (j=0; j<__xmlList[i].classX.@name.length (); j++) {		
							if (!m_cachedClassName.exists (__xmlList[i].classX.@name[j])) {
								m_cachedClassName.set (__xmlList[i].classX.@name[j], __xmlList[i]);
							}
							
							if (__xmlList[i].classX.@name[j] == __className) {
								__match = __xmlList[i];
							}
						}	
					}
				}
			}
			
			return __match;
		}
		
		//------------------------------------------------------------------------------------------
		public function cacheClassNames (__xmlList:XMLList):void {
			var i:int, j:int;
			
			for (i = 0; i<__xmlList.length (); i++) {
				//				trace (": caching: ", __xmlList[i].localName ());
				
				if (__xmlList[i].localName () == "folder") {
					cacheClassNames (__xmlList[i].child ("*"));
				}
				else
				{
					for (j=0; j<__xmlList[i].classX.@name.length (); j++) {						
						m_cachedClassName.set (__xmlList[i].classX.@name[j], __xmlList[i]);
					}	
				}
			}
		}
		
		//------------------------------------------------------------------------------------------
		private function __lookUpResourcePathByClassName (__fullName:String):Array /* <Dynamic> */ {
			if (m_manifestXML == null) {
				throw (Error ("manifest hasn't been loaded yet"));
			}
			
			var r:XResourceName = new XResourceName (__fullName);
			
			var __manifestName:String = r.manifestName;
			var __resourceName:String = r.resourceName;
			var __className:String = r.className;
			
			if (__manifestName != "") {
				throw (Error ("classname: " + __fullName + " is not valid"));
			}
			
			var match:XML =
				findNodeFromClassName (
					null,
					__resourceName,
					__className,
					m_manifestXML.folder.child ("*")
				);
			
			if (match == null) {
				throw (Error ("className not found in manifest: " + __fullName));
			}
			
			return [match, match.@path + "\\" + match.@dst];
		}
		
		//------------------------------------------------------------------------------------------
		// Given a class name, this function determines if an existing
		// XClass has been cached.  if not, it creates a new XClass
		//------------------------------------------------------------------------------------------
		private function __resolveXClass (__className:String):XClass {
			var	__XClass:XClass;
			
//			trace (": XResourceManager:__resolveXClass (): ", __className);
			
			if (!m_classMap.exists (__className)) {
				var __match:Array /* <String> */ = __lookUpResourcePathByClassName (__className);
				
				var __resourceXML:XML = __match[0];
				var __resourcePath:String = __match[1];
				
//				trace ("$ __resolveXClass: ", __className, __resourcePath);
				
				__XClass = new XClass (__className, __resourcePath, __resourceXML);
				__XClass.setClass (null);
				m_classMap.set (__className, __XClass);				
			}
			else
			{
				__XClass = m_classMap.get (__className) as XClass;
			}
			
			return __XClass;
		}
		
		//------------------------------------------------------------------------------------------
		// Given a XClass (Class wrapper), initialize its class definition from its resource.
		// if the resource is not already cached, it creates a new XResource (Resource wrapper)
		// note that XResource loads the resource asynchronously.  until the resource is completely
		// loaded, this function will return null.
		//------------------------------------------------------------------------------------------
		private function __resolveClass (__XClass:XClass):Class /* <Dynamic> */ {
			var	__resourcePath:String = __XClass.getResourcePath ();
			var __resourceXML:XML = __XClass.getResourceXML ();
			
			var __r:XResource = __getXResourceFromPath (__resourcePath, __resourceXML);
			
			if (__XClass.getClass () == null) {
				__XClass.setClass (__r.getClassByName (__XClass.getClassName ()));
			}
			
			return __XClass.getClass ();
		}		
		
		//------------------------------------------------------------------------------------------
		private function __getXResourceFromPath (__resourcePath:String, __resourceXML:XML):XResource {
			var __r:XResource = m_resourceMap.get (__resourcePath) as XResource;
			
			if (__r == null) {
				var	__XResource:XResource;
				
				if (m_projectManager.findEmbeddedResource (__resourcePath) == null) {
					__XResource = new XSWFURLResource ();
					__XResource.setup (m_rootPath + "\\" + __resourcePath, __resourceXML, m_parent, this);
				}
				else
				{
					__XResource = new XSWFEmbeddedResource ();
					__XResource.setup (__resourcePath, __resourceXML, m_parent, this);					
				}
				
				__XResource.loadResource ();
				
				m_resourceMap.set (__resourcePath, __XResource);
				
				__r = __XResource;
			}
			
			return __r
		}
		
		//------------------------------------------------------------------------------------------
	}
	
	//------------------------------------------------------------------------------------------
}