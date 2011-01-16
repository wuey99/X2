//------------------------------------------------------------------------------------------	
package X.Resource.Manager {
	
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
		private var m_resourceMap:Object;
		private var m_classMap:Object;
		private var m_parent:Sprite;
		private var m_rootPath:String;
		private var m_urlName:String;
		private var m_loadComplete:Boolean;
		private var m_rootDirectory:String;
		private var m_loaderContextFactory:Function;
		private var m_cachedClassName:Object;
		
//------------------------------------------------------------------------------------------		
		public function XSubResourceManager () {
			super ();
			
			m_resourceMap = new Object ();
			m_classMap = new Object ();
			m_cachedClassName = new Object ();
			
			m_loaderContextFactory = null;
			
			m_loadComplete = true;
			m_manifestXML =  null;
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
			m_resourceMap = new Object ();
			m_classMap = new Object ();
		}
				
//------------------------------------------------------------------------------------------
		public function setupFromURL (
			__projectManager:XProjectManager,
			__parent:Sprite,
			__rootPath:String,
			__urlName:String,
			__callback:Function,
			__loaderContextFactory:Function
			):void {
				
			m_projectManager = __projectManager;
			m_parent = __parent;
			setBothPaths (__rootPath, __urlName);
			m_loaderContextFactory = __loaderContextFactory;

			loadManifestFromURL (__rootPath, __urlName, __callback);
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
			__urlName:String,
			__callback:Function):Boolean {
				
			if (!m_loadComplete) {
				return false;
			}
					
			if (__urlName != null) {
				m_loadComplete = false;
			
				m_rootDirectory = __rootPath;
			
				var __loader:URLLoader = __loadManifestFromURL (m_rootDirectory + __urlName);
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
			function __loadManifestFromURL (__urlName:String):URLLoader {
				var __loader:URLLoader = new URLLoader ();
				var __urlReq:URLRequest = new URLRequest (__urlName);
	
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
			
			m_rootDirectory = __rootPath;
				
			setManifest (__xml);
			
			if (__callback != null) {
				__callback ();
			}
			
			m_loadComplete = true;
						
			return true;		
		}

//------------------------------------------------------------------------------------------
		public function findEmbeddedResource (__resourcePath:String):Class {
			return m_projectManager.findEmbeddedResource (__resourcePath);
		}
		
//------------------------------------------------------------------------------------------
		public function setManifest (__xml:XML):void {
			m_manifestXML = __xml;
		}

//------------------------------------------------------------------------------------------	
		public function setBothPaths (__rootPath:String, __urlName:String):void {
			m_rootPath = __rootPath;
			m_urlName = __urlName;
		}
		
//------------------------------------------------------------------------------------------
		public function setRootPath (__rootPath:String):void {
			m_rootDirectory = __rootPath;
		}

//------------------------------------------------------------------------------------------
		public function getRootPath ():String {
			return m_rootDirectory;
		}

//------------------------------------------------------------------------------------------
		public function getUrlName ():String {
			return m_urlName;
		}

//------------------------------------------------------------------------------------------
		public function getName ():String {
			return getUrlName ().substr(0, getUrlName ().lastIndexOf('.'))
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
			delete __xml.parent ().resource.(@name == __xml.@name)[0];
		}		
	
//------------------------------------------------------------------------------------------
		public override function insertResourceXML (__xmlItem:XML, __xmlToInsert:XML):void {			
			if (__xmlItem == null) {
				return;
			}
		
			if (__xmlItem.localName () == "classX") {
				__xmlItem.parent ().insertChildAfter (__xmlItem.parent (), __xmlToInsert);
			}
				
			if (__xmlItem.localName () == "resource") {
				__xmlItem.parent ().insertChildAfter (__xmlItem, __xmlToInsert);
			}
				
			if (__xmlItem.localName () == "folder") {
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
// looks up Class based on the full class name
//------------------------------------------------------------------------------------------
		public override function getClassByName (__className:String):Class {
			if (!m_loadComplete) {
				return null;
			}
			
//			trace (": XResourceManager:getClass (): ", __className);
							
			var __XClass:XClass = __resolveXClass (__className);
			
			var __class:Class = __XClass.getClass ();
			
			if (__class == null) {
				__class = __resolveClass (__XClass);
			}
			
			return __class;
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
// look for an e4x-centric way of finding a "classX" name
// my intuition tells me that this method can be achieved via e4x
//------------------------------------------------------------------------------------------
		public function findNodeFromClassName (
			__match:XML,
			__resourceName:String,
			__className:String,
			__xmlList:XMLList
			):XML {
						
			if (m_cachedClassName[__className] != undefined) {			
				return m_cachedClassName[__className];
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
							if (m_cachedClassName[__xmlList[i].classX.@name[j]] == undefined) {
								m_cachedClassName[__xmlList[i].classX.@name[j]] = __xmlList[i];
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
				trace (": caching: ", __xmlList[i].localName ());
				
				if (__xmlList[i].localName () == "folder") {
					cacheClassNames (__xmlList[i].child ("*"));
				}
				else
				{
					for (j=0; j<__xmlList[i].classX.@name.length (); j++) {						
						m_cachedClassName[__xmlList[i].classX.@name[j]] = __xmlList[i];
					}	
				}
			}
		}
	
//------------------------------------------------------------------------------------------
		private function __lookUpResourcePathByClassName (__fullName:String):Array {
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
// Given a class name, this function determins if an existing
// XClass has been cached.  if not, it creates a new XClass
//------------------------------------------------------------------------------------------
		private function __resolveXClass (__className:String):XClass {
			var	__XClass:XClass;
			
			var __c:* = m_classMap[__className];
			
			trace (": XResourceManager:__resolveXClass (): ", __className);
			
			if (__c == undefined) {
				var __match:Array = __lookUpResourcePathByClassName (__className);
				
				var __resourceXML:XML = __match[0];
				var __resourcePath:String = __match[1];
				
//				trace ("$ __resolveXClass: ", __className, __resourcePath);
				
				__XClass = new XClass (__className, __resourcePath, __resourceXML);
				__XClass.setClass (null);
				m_classMap[__className] = __XClass;				
			}
			else
			{
				__XClass = __c as XClass;
			}
			
			return __XClass;
		}

//------------------------------------------------------------------------------------------
// Given a XClass (Class wrapper), initialize its class definition from its resource.
// if the resource is not already cached, it creates a new XResource (Resource wrapper)
// note that XResource loads the resource asynchronously.  until the resource is completely
// loaded, this function will return null.
//------------------------------------------------------------------------------------------
		private function __resolveClass (__XClass:XClass):Class {
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
			var __r:XResource = m_resourceMap[__resourcePath] as XResource;
						
			if (__r == null) {
				var	__XResource:XResource;
				
				if (m_projectManager.findEmbeddedResource (__resourcePath) == null) {
					__XResource = new XSWFURLResource ();
					__XResource.setup (m_rootDirectory + __resourcePath, __resourceXML, m_parent, this);
				}
				else
				{
					__XResource = new XSWFEmbeddedResource ();
					__XResource.setup (__resourcePath, __resourceXML, m_parent, this);					
				}
						
				__XResource.loadResource ();
				
				m_resourceMap[__resourcePath] = __XResource;
				
				__r = __XResource;
			}
			
			return __r
		}
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}