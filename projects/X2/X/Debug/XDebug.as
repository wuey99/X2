//------------------------------------------------------------------------------------------
// <$begin$/>
// Copyright (C) 2014 Jimmy Huey
//
// Some Rights Reserved.
//
// The "X-Engine" is licensed under a Creative Commons
// Attribution-NonCommerical-ShareAlike 3.0 Unported License.
// (CC BY-NC-SA 3.0)
//
// You are free to:
//
//      SHARE - to copy, distribute, display and perform the work.
//      ADAPT - remix, transform build upon this material.
//
//      The licensor cannot revoke these freedoms as long as you follow the license terms.
//
// Under the following terms:
//
//      ATTRIBUTION -
//          You must give appropriate credit, provide a link to the license, and
//          indicate if changes were made.  You may do so in any reasonable manner,
//          but not in any way that suggests the licensor endorses you or your use.
//
//      SHAREALIKE -
//          If you remix, transform, or build upon the material, you must
//          distribute your contributions under the same license as the original.
//
//      NONCOMMERICIAL -
//          You may not use the material for commercial purposes.
//
// No additional restrictions - You may not apply legal terms or technological measures
// that legally restrict others from doing anything the license permits.
//
// The full summary can be located at:
// http://creativecommons.org/licenses/by-nc-sa/3.0/
//
// The human-readable summary of the Legal Code can be located at:
// http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode
//
// The "X-Engine" is free for non-commerical use.
// For commercial use, you will need to provide proper credits.
// Please contact me @ wuey99[dot]gmail[dot]com for more details.
// <$end$/>
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