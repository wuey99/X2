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
// For commercial use, you will need to provide additional credits.
// Please contact me @ wuey99[dot]gmail[dot]com for more details.
// <$end$/>
//------------------------------------------------------------------------------------------
package X.Signals {

	import X.Collections.*;
	
//------------------------------------------------------------------------------------------
	public class XSignal extends Object {
		private var m_listeners:XDict;
		private var m_parent:*;
		
//------------------------------------------------------------------------------------------
		public function XSignal () {
			super();
			
			m_listeners = new XDict ();
		}

//------------------------------------------------------------------------------------------
		public function getParent ():* {
			return m_parent;
		}
		
//------------------------------------------------------------------------------------------
		public function setParent (__parent:*):void {
			m_parent = __parent;
		}
		
//------------------------------------------------------------------------------------------
		public function addListener (__listener:Function):void {
			m_listeners.put (__listener, 0);
		}

//------------------------------------------------------------------------------------------
		public function fireSignal (...args):void {	
			switch (args.length) {
				case 0:
					m_listeners.forEach (
						function (__listener:*):void {
							__listener ();
						}
					);
					
					break;
					
				case 1:
					m_listeners.forEach (
						function (__listener:*):void {
							__listener (args[0]);
						}
					);
					
					break;
					
				default:
					m_listeners.forEach (
						function (__listener:*):void {
							__listener.apply (null, args);
						}
					);
					
					break;
			}
		}
		
//------------------------------------------------------------------------------------------
		public function removeListener (__listener:Function):void {
			if (m_listeners.exists (__listener)) {
				m_listeners.remove (__listener);
			}
		}

//------------------------------------------------------------------------------------------
		public function removeAllListeners ():void {
			m_listeners.forEach (
				function (__listener:*):void {
					m_listeners.remove (__listener);
				}
			);
		}
				
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}