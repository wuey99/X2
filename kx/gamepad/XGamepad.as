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
package kx.gamepad {
	
	import kx.collections.*;
	import kx.signals.*;

	// <HAXE>
	/* --
	import lime.ui.*;
	-- */
	// </HAXE>
	// <AS3>
	// </AS3>
	
	import flash.ui.*;
	import flash.events.*;
	
	//------------------------------------------------------------------------------------------	
	public class XGamepad extends Object {
		private var m_axisMoveSignals:XDict; // <String, XSignal>
		private var m_buttonUpSignals:XDict; // <String, XSignal>
		private var m_buttonDownSignals:XDict; // <String, XSignal>
		
		private var m_disconnectSignal:XSignal;
	
		private var m_mapIDs:XDict; // <String, String>
		
		//------------------------------------------------------------------------------------------
		// controls
		//------------------------------------------------------------------------------------------
		public static const AXIS_LEFT_X:String = "AXIS_LEFT_X";
		public static const AXIS_LEFT_Y:String = "AXIS_LEFT_Y";
		public static const AXIS_RIGHT_X:String = "AXIS_RIGHT_X";
		public static const AXIS_RIGHT_Y:String = "AXIS_RIGHT_Y";
		public static const AXIS_TRIGGER_LEFT:String = "AXIS_TRIGGER_LEFT";
		public static const AXIS_TRIGGER_RIGHT:String = "AXIS_TRIGGER_RIGHT";
		public static const BUTTON_A:String = "BUTTON_A";
		public static const BUTTON_B:String = "BUTTON_B";
		public static const BUTTON_BACK:String = "BUTTON_BACK";
		public static const BUTTON_DPAD_DOWN:String = "BUTTON_DPAD_DOWN";
		public static const BUTTON_DPAD_LEFT:String = "BUTTON_DPAD_LEFT";
		public static const BUTTON_DPAD_RIGHT:String = "BUTTON_DPAD_RIGHT";
		public static const BUTTON_DPAD_UP:String = "BUTTON_DPAD_UP";
		public static const BUTTON_GUIDE:String = "BUTTON_GUIDE";
		public static const BUTTON_LEFT_SHOULDER:String = "BUTTON_LEFT_SHOULDER";
		public static const BUTTON_LEFT_STICK:String = "BUTTON_LEFT_STICK";
		public static const BUTTON_RIGHT_SHOULDER:String = "BUTTON_RIGHT_SHOULDER";
		public static const BUTTON_RIGHT_STICK:String = "BUTTON_RIGHT_STICK";
		public static const BUTTON_START:String = "BUTTON_START";
		public static const BUTTON_X:String = "BUTTON_X";
		public static const BUTTON_Y:String = "BUTTON_Y";

		//------------------------------------------------------------------------------------------
		public function XGamepad () {
		}

		//------------------------------------------------------------------------------------------
		public function setup ():void {	
			m_axisMoveSignals = new XDict (); // <String, XSignal>
			m_buttonUpSignals = new XDict (); // <String, XSignal>
			m_buttonDownSignals = new XDict (); // <String, XSignal>
			
			m_disconnectSignal = new XSignal ();
			
			m_mapIDs = new XDict (); // <String, String>
						
			// <HAXE>
			/* --
			#if windows
			m_mapIDs.set ("LEFT_X", XGamepad.AXIS_LEFT_X);
			m_mapIDs.set ("LEFT_Y", XGamepad.AXIS_LEFT_Y);				
			m_mapIDs.set ("RIGHT_X", XGamepad.AXIS_RIGHT_X);			
			m_mapIDs.set ("RIGHT_Y", XGamepad.AXIS_RIGHT_Y);			
			m_mapIDs.set ("TRIGGER_LEFT", XGamepad.AXIS_TRIGGER_LEFT);		
			m_mapIDs.set ("TRIGGER_RIGHT", XGamepad.AXIS_TRIGGER_RIGHT);		
			m_mapIDs.set ("A", XGamepad.BUTTON_A);
			m_mapIDs.set ("B", XGamepad.BUTTON_B);
			m_mapIDs.set ("BACK", XGamepad.BUTTON_BACK);
			m_mapIDs.set ("DPAD_DOWN", XGamepad.BUTTON_DPAD_DOWN);
			m_mapIDs.set ("DPAD_LEFT", XGamepad.BUTTON_DPAD_LEFT);
			m_mapIDs.set ("DPAD_RIGHT", XGamepad.BUTTON_DPAD_RIGHT);
			m_mapIDs.set ("DPAD_UP", XGamepad.BUTTON_DPAD_UP);
			m_mapIDs.set ("GUIDE", XGamepad.BUTTON_GUIDE);
			m_mapIDs.set ("LEFT_SHOULDER", XGamepad.BUTTON_LEFT_SHOULDER);
			m_mapIDs.set ("LEFT_STICK", XGamepad.BUTTON_LEFT_STICK);
			m_mapIDs.set ("RIGHT_SHOULDER", XGamepad.BUTTON_RIGHT_SHOULDER);
			m_mapIDs.set ("RIGHT_STICK", XGamepad.BUTTON_RIGHT_STICK);
			m_mapIDs.set ("START", XGamepad.BUTTON_START);
			m_mapIDs.set ("X", XGamepad.BUTTON_X);
			m_mapIDs.set ("Y", XGamepad.BUTTON_Y);
			
			Gamepad.onConnect.add (function (__gamepad:Gamepad):Void {
				trace ("Connected Gamepad: " + __gamepad.name);
				
				__gamepad.onAxisMove.add (function (__axis:GamepadAxis, __val:Float):Void {
					var __id:String = m_mapIDs.get (__axis.toString ());
			
					trace ("Moved Axis " + __id + ": " + __val);
			
					getAxisSignal (__id).fireSignal (__val);
				});
				
				__gamepad.onButtonDown.add (function (__button:GamepadButton):Void {
					var __id:String = m_mapIDs.get (__button.toString ());
			
					trace ("Pressed Button: " + __id);
			
					getButtonUpSignal (__id).fireSignal ();
				});
				
				__gamepad.onButtonUp.add (function (__button:GamepadButton):Void {
					var __id:String = m_mapIDs.get (__button.toString ());
			
					trace ("Released Button: " + __id);
			
					getButtonDownSignal (__id).fireSignal ();
				});
				
				__gamepad.onDisconnect.add (function ():Void {
					trace ("Disconnected Gamepad");
			
					m_disconnectSignal.fireSignal ();
				});
			});
			#else
			m_mapIDs.set ("AXIS_0", XGamepad.AXIS_LEFT_X);
			m_mapIDs.set ("AXIS_1", XGamepad.AXIS_LEFT_Y);				
			m_mapIDs.set ("AXIS_2", XGamepad.AXIS_RIGHT_X);			
			m_mapIDs.set ("AXIS_3", XGamepad.AXIS_RIGHT_Y);			
			m_mapIDs.set ("AXIS_4", XGamepad.AXIS_TRIGGER_LEFT);		
			m_mapIDs.set ("AXIS_5", XGamepad.AXIS_TRIGGER_RIGHT);		
			m_mapIDs.set ("BUTTON_0", XGamepad.BUTTON_A);
			m_mapIDs.set ("BUTTON_1", XGamepad.BUTTON_B);
			m_mapIDs.set ("BUTTON_4", XGamepad.BUTTON_BACK);
			m_mapIDs.set ("BUTTON_12", XGamepad.BUTTON_DPAD_DOWN);
			m_mapIDs.set ("BUTTON_13", XGamepad.BUTTON_DPAD_LEFT);
			m_mapIDs.set ("BUTTON_14", XGamepad.BUTTON_DPAD_RIGHT);
			m_mapIDs.set ("BUTTON_11", XGamepad.BUTTON_DPAD_UP);
			m_mapIDs.set ("BUTTON_5", XGamepad.BUTTON_GUIDE);
			m_mapIDs.set ("BUTTON_9", XGamepad.BUTTON_LEFT_SHOULDER);
			m_mapIDs.set ("BUTTON_7", XGamepad.BUTTON_LEFT_STICK);
			m_mapIDs.set ("BUTTON_10", XGamepad.BUTTON_RIGHT_SHOULDER);
			m_mapIDs.set ("BUTTON_8", XGamepad.BUTTON_RIGHT_STICK);
			m_mapIDs.set ("BUTTON_6", XGamepad.BUTTON_START);
			m_mapIDs.set ("BUTTON_2", XGamepad.BUTTON_X);
			m_mapIDs.set ("BUTTON_3", XGamepad.BUTTON_Y);
			
			new GameInput ().addEventListener (GameInputEvent.DEVICE_ADDED, function (event):Void {
				trace ("Connected Device: " + event.device.name);
				
				for (i in 0...event.device.numControls) {
					var control = event.device.getControlAt (i);
					
					control.addEventListener (Event.CHANGE, function (event):Void {			
						var __id:String = m_mapIDs.get (control.id);
			
						if (control.id.substr (0, 4) == "AXIS") {
							trace ("Moved Axis " + __id + ": " + control.value);
			
							getAxisSignal (__id).fireSignal (control.value);
						}
			
						if (control.id.substr (0, 6) == "BUTTON") {
							if (control.value == "0") {
								trace ("Released Button: " + __id);
			
								getButtonUpSignal (__id).fireSignal ();
							}
							else
							{
								trace ("Pressed Button: " + __id);
			
								getButtonDownSignal (__id).fireSignal ();
							}
						}
					});
				}
				
				event.device.enabled = true;
			});
			#end
			-- */
			// </HAXE>
			// <AS3>
			// </AS3>
		}
		
		//------------------------------------------------------------------------------------------
		public function cleanup ():void {	
			removeAllListeners ();
		}

		//------------------------------------------------------------------------------------------
		public function removeAllListeners ():void {
			m_axisMoveSignals.forEach (
				function (__controlName:String):void {
					m_axisMoveSignals.get (__controlName).removeAllListeners ();
				}
			);
			
			m_buttonUpSignals.forEach (
				function (__controlName:String):void {
					m_buttonUpSignals.get (__controlName).removeAllListeners ();
				}
			);
			
			m_buttonDownSignals.forEach (
				function (__controlName:String):void {
					m_buttonDownSignals.get (__controlName).removeAllListeners ();
				}
			);

			m_disconnectSignal.removeAllListeners ();
		}
		
		//------------------------------------------------------------------------------------------
		// AXIS
		//------------------------------------------------------------------------------------------
		
		//------------------------------------------------------------------------------------------
		public function getAxisSignal (__axis:String):XSignal {
			if (!m_axisMoveSignals.exists (__axis)) {
				m_axisMoveSignals.set (__axis, new XSignal ());
			}
			
			return /* @:cast */ m_axisMoveSignals.get (__axis);
		}

		//------------------------------------------------------------------------------------------
		public function addAxisMoveListener (__axis:String, __listener:Function):void {
			 getAxisSignal (__axis).addListener (__listener);
		}

		//------------------------------------------------------------------------------------------
		public function removeAxisMoveListener (__axis:String, __id:int):void {	
			getAxisSignal (__axis).removeListener (__id);
		}
		
		//------------------------------------------------------------------------------------------
		// BUTTON UP
		//------------------------------------------------------------------------------------------
		
		//------------------------------------------------------------------------------------------
		public function getButtonUpSignal (__button:String):XSignal {
			if (!m_buttonUpSignals.exists (__button)) {
				m_buttonUpSignals.set (__button, new XSignal ());
			}
			
			return /* @:cast */ m_buttonUpSignals.get (__button);			
		}
		
		//------------------------------------------------------------------------------------------
		public function addButtonUpListener (__button:String, __listener:Function):void {
			getButtonUpSignal (__button).addListener (__listener);
		}
	
		//------------------------------------------------------------------------------------------
		public function removeButtonUpListener (__button:String, __id:int):void {	
			getButtonDownSignal (__button).removeListener (__id);
		}
		
		//------------------------------------------------------------------------------------------
		// BUTTON DOWN
		//------------------------------------------------------------------------------------------
		
		//------------------------------------------------------------------------------------------
		public function getButtonDownSignal (__button:String):XSignal {
			if (!m_buttonDownSignals.exists (__button)) {
				m_buttonDownSignals.set (__button, new XSignal ());
			}
			
			return /* @:cast */  m_buttonDownSignals.get (__button);				
		}
				
		//------------------------------------------------------------------------------------------
		public function addButtonDownListener (__button:String, __listener:Function):void {
			getButtonDownSignal (__button).addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeButtonDownListener (__button:String, __id:int):void {
			getButtonDownSignal (__button).removeListener (__id);
		}
		
		//------------------------------------------------------------------------------------------
		// DISCONNECT
		//------------------------------------------------------------------------------------------
		
		//------------------------------------------------------------------------------------------
		public function addDisconnectListener (__listener:Function):void {
			m_disconnectSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeDisconnectListener (__id:int):void {
			m_disconnectSignal.removeListener (__id);
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
