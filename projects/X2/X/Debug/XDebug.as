//------------------------------------------------------------------------------------------
// <$license$/>
//------------------------------------------------------------------------------------------
package X.Debug {
	
// X classes
	import X.XApp;
	
	import com.mattism.http.xmlrpc.*;
	import com.mattism.http.xmlrpc.util.*;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
//------------------------------------------------------------------------------------------
	public class XDebug extends Object {
		protected var m_XApp:XApp;
		protected var m_disabled:Boolean;
		protected var m_complete:Boolean;
		protected static var CHUNK_SIZE:Number = 128;
								
//------------------------------------------------------------------------------------------
		public function XDebug () {	
			super ();
			
			m_disabled = false;
			m_complete = false;
		}

//------------------------------------------------------------------------------------------
		public function setup (__XApp:XApp):void {
			m_XApp = __XApp;
		}

//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function disable (__flag:Boolean):void {
			m_disabled = __flag;
		}

//------------------------------------------------------------------------------------------
		public function print (...args):void {
			var __output:String;
			
			__output = "";
			
			for (i=0; i<args.length; i++) {
				__output += args[i] + " ";	
			}
			
			__output = "................................................................... " + __output;
			
			var __length:Number = Math.floor ((__output.length+CHUNK_SIZE)/CHUNK_SIZE);
			
			var i:Number;
			
			for (i=0; i<__length; i++) {	
				print2 (__output.substr (i*CHUNK_SIZE, Math.min (__output.length - i*CHUNK_SIZE, CHUNK_SIZE)));
			}
		}
			
//------------------------------------------------------------------------------------------
		public function print2 (__output:String):void {
			if (m_disabled) {
				return;
			}

			m_complete = false;
			
			var __connection:ConnectionImpl;
			
			try {
				__connection = new ConnectionImpl("http://localhost:8001/XDEBUG");
			}
			catch (e:Error) {
				return;
			}
			
			try {	
				__connection.removeParams ();
				__connection.addParam (__output, XMLRPCDataTypes.STRING);
				__connection.call ("debugOut");
				__connection.addEventListener (Event.COMPLETE, __onCompleteHandler);
				__connection.addEventListener (ErrorEvent.ERROR, __onErrorHandler);
			}
			catch (e:Error) {
				trace (": XDebug: ", e);
			}
			
			function __onCompleteHandler (e:Event):void {
				__removeEventListeners ();
				
				m_complete = true;
			}
			
			function __onErrorHandler (e:ErrorEvent):void {
				trace (": XDebug: ", e);
				
				__removeEventListeners ();
				
				m_complete = true;
			}
			
			function __removeEventListeners ():void {
				__connection.removeEventListener (Event.COMPLETE, __onCompleteHandler);
				__connection.removeEventListener (ErrorEvent.ERROR, __onErrorHandler);
			}
		}

//------------------------------------------------------------------------------------------		
	}
	
//------------------------------------------------------------------------------------------
}