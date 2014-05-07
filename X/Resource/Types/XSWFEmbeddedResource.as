//------------------------------------------------------------------------------------------
// <$license$/>
//------------------------------------------------------------------------------------------
package X.Resource.Types {

	import X.Resource.*;
	import X.Resource.Manager.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.system.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------		
	public class XSWFEmbeddedResource extends XSWFResource {

//------------------------------------------------------------------------------------------
		public function XSWFEmbeddedResource () {
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
		public override function loadResource ():void {		
			m_loader = new Loader();	
			
			__onBytesLoaded ();
			
			m_parent.addChild (m_loader);
			m_loader.visible = false;
		
	//------------------------------------------------------------------------------------------
			function __onBytesLoaded():void {
 				try {
 					trace (":-----------------");
 					trace (": ", m_resourcePath);
 						
					__configureListeners (m_loader.contentLoaderInfo);	

					var __loaderContext:LoaderContext;
					
					if (resourceManager ().loaderContextFactory () != null) {
						__loaderContext = resourceManager ().loaderContextFactory () ();
					}
					else
					{
						__loaderContext = new LoaderContext();
					}

					__loaderContext.allowCodeImport = true;
					
					m_loader.loadBytes (new (m_resourceManager.findEmbeddedResource (m_resourcePath)) (), __loaderContext);
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