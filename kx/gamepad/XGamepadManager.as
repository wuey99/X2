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
	
	import flash.events.*;
	import flash.ui.*;
	
	// <HAXE>
	/* --
	import lime.ui.*;
	-- */
	// </HAXE>
	// <AS3>
	// </AS3>
	
	import kx.collections.*;
	import kx.signals.*;
	
	//------------------------------------------------------------------------------------------	
	public class XGamepadManager extends Object {
		private var m_analogChangedSignals:XDict; // <String, XSignal>
		private var m_buttonUpSignals:XDict; // <String, XSignal>
		private var m_buttonDownSignals:XDict; // <String, XSignal>
		
		private var m_connected:Boolean;
		private var m_disconnectSignal:XSignal;
	
		private var m_mapIDs:XDict; // <String, String>
		
		//------------------------------------------------------------------------------------------
		public function XGamepadManager () {
		}

		//------------------------------------------------------------------------------------------
		public function setup ():void {	
			m_analogChangedSignals = new XDict (); // <String, XSignal>
			m_buttonUpSignals = new XDict (); // <String, XSignal>
			m_buttonDownSignals = new XDict (); // <String, XSignal>
			
			m_connected = false;
			m_disconnectSignal = new XSignal ();
			
			m_mapIDs = new XDict (); // <String, String>
						
			// <HAXE>
			/* --
			#if (windows || html5 || android)
			m_mapIDs.set ("LEFT_X", XGamepad.ANALOG_LEFT_X);
			m_mapIDs.set ("LEFT_Y", XGamepad.ANALOG_LEFT_Y);				
			m_mapIDs.set ("RIGHT_X", XGamepad.ANALOG_RIGHT_X);			
			m_mapIDs.set ("RIGHT_Y", XGamepad.ANALOG_RIGHT_Y);			
			m_mapIDs.set ("TRIGGER_LEFT", XGamepad.ANALOG_TRIGGER_LEFT);		
			m_mapIDs.set ("TRIGGER_RIGHT", XGamepad.ANALOG_TRIGGER_RIGHT);		
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
				
				m_connected = true;
			
				__gamepad.onAxisMove.add (function (__analog:GamepadAxis, __val:Float):Void {
					var __id:String = m_mapIDs.get (__analog.toString ());
			
					// trace ("Moved Axis " + __id + ": " + __val);
			
					getAnalogChangedSignal (__id).fireSignal (__val);
				});
				
				__gamepad.onButtonDown.add (function (__button:GamepadButton):Void {
					var __id:String = m_mapIDs.get (__button.toString ());
			
					// trace ("Pressed Button: " + __id);
			
					getButtonDownSignal (__id).fireSignal ();
				});
				
				__gamepad.onButtonUp.add (function (__button:GamepadButton):Void {
					var __id:String = m_mapIDs.get (__button.toString ());
			
					// trace ("Released Button: " + __id);
			
					getButtonUpSignal (__id).fireSignal ();
				});
				
				__gamepad.onDisconnect.add (function ():Void {
					// trace ("Disconnected Gamepad");
			
					m_connected = false;
			
					m_disconnectSignal.fireSignal ();
				});
			});
			#else
			
			return;
			
			m_mapIDs.set ("AXIS_0", XGamepad.ANALOG_LEFT_X);
			m_mapIDs.set ("AXIS_1", XGamepad.ANALOG_LEFT_Y);				
			m_mapIDs.set ("AXIS_2", XGamepad.ANALOG_RIGHT_X);			
			m_mapIDs.set ("AXIS_3", XGamepad.ANALOG_RIGHT_Y);			
			m_mapIDs.set ("AXIS_4", XGamepad.ANALOG_TRIGGER_LEFT);		
			m_mapIDs.set ("AXIS_5", XGamepad.ANALOG_TRIGGER_RIGHT);		
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
			
				m_connected = true;
			
				for (i in 0...event.device.numControls) {
					var control = event.device.getControlAt (i);
					
					control.addEventListener (Event.CHANGE, function (event):Void {			
						var __id:String = m_mapIDs.get (control.id);
			
						if (control.id.substr (0, 4) == "AXIS") {
							// trace ("Moved Axis " + __id + ": " + control.value);
			
							getAnalogChangedSignal (__id).fireSignal (control.value);
						}
			
						if (control.id.substr (0, 6) == "BUTTON") {
							if (control.value == "0") {
								// trace ("Released Button: " + __id);
			
								getButtonUpSignal (__id).fireSignal ();
							}
							else
							{
								// trace ("Pressed Button: " + __id);
			
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
			m_analogChangedSignals.forEach (
				function (__controlName:String):void {
					m_analogChangedSignals.get (__controlName).removeAllListeners ();
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
		public function connected ():Boolean {
			return m_connected;
		}
		
		//------------------------------------------------------------------------------------------
		// ANALOG
		//------------------------------------------------------------------------------------------
		
		//------------------------------------------------------------------------------------------
		public function getAnalogChangedSignal (__analog:String):XSignal {
			if (!m_analogChangedSignals.exists (__analog)) {
				m_analogChangedSignals.set (__analog, new XSignal ());
			}
			
			return /* @:cast */ m_analogChangedSignals.get (__analog);
		}

		//------------------------------------------------------------------------------------------
		public function addAnalogChangedListener (__analog:String, __listener:Function):int {
			 return getAnalogChangedSignal (__analog).addListener (__listener);
		}

		//------------------------------------------------------------------------------------------
		public function removeAnalogChangedListener (__analog:String, __id:int):void {	
			getAnalogChangedSignal (__analog).removeListener (__id);
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
		public function addButtonUpListener (__button:String, __listener:Function):int {
			return getButtonUpSignal (__button).addListener (__listener);
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
		public function addButtonDownListener (__button:String, __listener:Function):int {
			return getButtonDownSignal (__button).addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeButtonDownListener (__button:String, __id:int):void {
			getButtonDownSignal (__button).removeListener (__id);
		}
		
		//------------------------------------------------------------------------------------------
		// DISCONNECT
		//------------------------------------------------------------------------------------------
		
		//------------------------------------------------------------------------------------------
		public function addDisconnectListener (__listener:Function):int {
			return m_disconnectSignal.addListener (__listener);
		}
		
		//------------------------------------------------------------------------------------------
		public function removeDisconnectListener (__id:int):void {
			m_disconnectSignal.removeListener (__id);
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
