//------------------------------------------------------------------------------------------
// <$license$/>
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
	public class XSWFURLResource extends XSWFResource {
		
//------------------------------------------------------------------------------------------
		public function XSWFURLResource () {
		}

//------------------------------------------------------------------------------------------
		public override function setup (
			__resourcePath:String, __resourceXML:XML,
			__parent:Sprite,
			__resourceManager:XSubResourceManager
			):void {
				
			m_resourcePath = __resourcePath;
			m_resourceXML = __resourceXML;
			m_parent = __parent;
			m_loader = null;
			m_loadComplete = false;
			m_resourceManager = __resourceManager;
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
		}

//------------------------------------------------------------------------------------------
/*
		public override function loadAsync ():void {		
			m_loader = new Loader();

			var __loaderContext:LoaderContext = new LoaderContext ();
        	__loaderContext.applicationDomain = new ApplicationDomain (ApplicationDomain.currentDomain);
       
       		trace (":--------------------------------------------");
       		trace (": ", m_resourcePath);
       		trace (":============================================");
       		
			var __urlReq:URLRequest = new URLRequest (m_resourcePath);

			__configureListeners (m_loader.contentLoaderInfo);
			
			m_loader.load (__urlReq, __loaderContext);
						
			m_parent.addChild (m_loader);
			m_loader.visible = false;

	//------------------------------------------------------------------------------------------
			function __configureListeners(dispatcher:IEventDispatcher):void {
				dispatcher.addEventListener (Event.COMPLETE, __completeHandler);
				dispatcher.addEventListener (HTTPStatusEvent.HTTP_STATUS, __httpStatusHandler);
				dispatcher.addEventListener (Event.INIT, __initHandler);
				dispatcher.addEventListener (IOErrorEvent.IO_ERROR, __ioErrorHandler);
				dispatcher.addEventListener (Event.OPEN, __openHandler);
				dispatcher.addEventListener (ProgressEvent.PROGRESS, __progressHandler);
				dispatcher.addEventListener (Event.UNLOAD, __unLoadHandler);
			}
		
	//------------------------------------------------------------------------------------------											
     	   function __completeHandler(event:Event):void {
        	    trace("completeHandler: " + event);
            
				trace ("xxx url: ", m_loader.contentLoaderInfo.url);
				trace ("xxx actionScriptVersion: ", m_loader.contentLoaderInfo.actionScriptVersion);		
				
				m_loader.contentLoaderInfo.removeEventListener (Event.COMPLETE, __completeHandler);
				
				m_loadComplete = true;
        	}

	//------------------------------------------------------------------------------------------
        	function __httpStatusHandler(event:HTTPStatusEvent):void {
            	trace("httpStatusHandler: " + event);
        	}

	//------------------------------------------------------------------------------------------
        	function __initHandler(event:Event):void {
            	trace("initHandler: " + event);
        	}

	//------------------------------------------------------------------------------------------
        	function __ioErrorHandler(event:IOErrorEvent):void {
            	trace("ioErrorHandler: " + event);
        	}

	//------------------------------------------------------------------------------------------
        	function __openHandler(event:Event):void {
            	trace("openHandler: " + event);
        	}

	//------------------------------------------------------------------------------------------
        	function __progressHandler(event:ProgressEvent):void {
            	trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
        	}

	//------------------------------------------------------------------------------------------
        	function __unLoadHandler(event:Event):void {
            	trace("unLoadHandler: " + event);
        	}
        	
//------------------------------------------------------------------------------------------
// loadASync
//------------------------------------------------------------------------------------------
		}
*/

//------------------------------------------------------------------------------------------
		public override function loadResource ():void {		
			m_loader = new Loader();

			try {
				var __urlLoader:URLLoader = new URLLoader();
				var __urlReq:URLRequest = new URLRequest(m_resourcePath);
				__urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				__urlLoader.addEventListener(Event.COMPLETE, __onBytesLoaded);
				__urlLoader.addEventListener(IOErrorEvent.IO_ERROR, __onIOError);
				__urlLoader.load(__urlReq);
			}
			catch (error:Error) {
				throw (Error ("Load resource error: " + error));
			}			
			
			m_parent.addChild (m_loader);
			m_loader.visible = false;
		
	//------------------------------------------------------------------------------------------
			function __onIOError(event:Event):void {
				throw (Error ("I/O Error reading: " + m_resourcePath));
			}
			
	//------------------------------------------------------------------------------------------
			function __onBytesLoaded(event:Event):void {
 				try {
 					trace (":-----------------");
 					trace (": ", m_resourcePath);
 					
					__urlLoader.removeEventListener(Event.COMPLETE, __onBytesLoaded);		
					__configureListeners (m_loader.contentLoaderInfo);	

					var __loaderContext:LoaderContext;
					
					if (resourceManager ().loaderContextFactory () != null) {
						__loaderContext = resourceManager ().loaderContextFactory () ();
					}
					else
					{
						__loaderContext = new LoaderContext();
					}

					m_loader.loadBytes(__urlLoader.data, __loaderContext);
 				}
 				catch (error:Error) {
					throw (Error ("Load resource error: " + error));
 				}
			}
			
	//------------------------------------------------------------------------------------------
			function __configureListeners(dispatcher:IEventDispatcher):void {
				dispatcher.addEventListener (Event.COMPLETE, __completeHandler);
				dispatcher.addEventListener (HTTPStatusEvent.HTTP_STATUS, __httpStatusHandler);
				dispatcher.addEventListener (Event.INIT, __initHandler);
				dispatcher.addEventListener (IOErrorEvent.IO_ERROR, __ioErrorHandler);
				dispatcher.addEventListener (Event.OPEN, __openHandler);
				dispatcher.addEventListener (ProgressEvent.PROGRESS, __progressHandler);
				dispatcher.addEventListener (Event.UNLOAD, __unLoadHandler);
			}
			
	//------------------------------------------------------------------------------------------
			function __removeListeners(dispatcher:IEventDispatcher):void {
				dispatcher.removeEventListener (Event.COMPLETE, __completeHandler);
				dispatcher.removeEventListener (HTTPStatusEvent.HTTP_STATUS, __httpStatusHandler);
				dispatcher.removeEventListener (Event.INIT, __initHandler);
				dispatcher.removeEventListener (IOErrorEvent.IO_ERROR, __ioErrorHandler);
				dispatcher.removeEventListener (Event.OPEN, __openHandler);
				dispatcher.removeEventListener (ProgressEvent.PROGRESS, __progressHandler);
				dispatcher.removeEventListener (Event.UNLOAD, __unLoadHandler);
			}

	//------------------------------------------------------------------------------------------											
     	   function __completeHandler(event:Event):void {
        	    trace("completeHandler: " + event);
            
				trace ("xxx url: ", m_loader.contentLoaderInfo.url);
				trace ("xxx actionScriptVersion: ", m_loader.contentLoaderInfo.actionScriptVersion);		
						
				__removeListeners (m_loader.contentLoaderInfo);
				
				m_loadComplete = true;
        	}

	//------------------------------------------------------------------------------------------
        	function __httpStatusHandler(event:HTTPStatusEvent):void {
            	trace("httpStatusHandler: " + event);
        	}

	//------------------------------------------------------------------------------------------
        	function __initHandler(event:Event):void {
            	trace("initHandler: " + event);
        	}

	//------------------------------------------------------------------------------------------
        	function __ioErrorHandler(event:IOErrorEvent):void {
            	trace("ioErrorHandler: " + event);
        	}

	//------------------------------------------------------------------------------------------
        	function __openHandler(event:Event):void {
            	trace("openHandler: " + event);
        	}

	//------------------------------------------------------------------------------------------
        	function __progressHandler(event:ProgressEvent):void {
            	trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
        	}

	//------------------------------------------------------------------------------------------
        	function __unLoadHandler(event:Event):void {
            	trace("unLoadHandler: " + event);
        	}
        	
//------------------------------------------------------------------------------------------
// loadAsync2
//------------------------------------------------------------------------------------------	
		}
				
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}