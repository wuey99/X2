//------------------------------------------------------------------------------------------
package X.Keyboard {
	
	import X.World.Logic.XLogicObject;
	import X.World.XWorld;
	
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------	
	public class XKeyboardManager extends Object {
		public var xxx:XWorld;
		public var m_keyboardObject:XKeyboardLogicObject;
		
//------------------------------------------------------------------------------------------
		public function XKeyboardManager (__xxx:XWorld) {
			xxx = __xxx;
			
			m_keyboardObject = xxx.getXLogicManager ().initXLogicObject (
				// parent
					null,
				// logicObject
					new XKeyboardLogicObject () as XLogicObject,
				// item, layer, depth
					null, 0, 1000,
				// x, y, z
					128, 128, 0,
				// scale, rotation
					1.0, 0
				) as XKeyboardLogicObject;
		}

//------------------------------------------------------------------------------------------
		public function grabFocus ():void {
			m_keyboardObject.grabFocus ();
		}
		
//------------------------------------------------------------------------------------------
		public function releaseFocus ():void {
			m_keyboardObject.releaseFocus ();
		}

//------------------------------------------------------------------------------------------
		public function getKeyCode (__c:uint):Boolean {
			return m_keyboardObject.getKeyCode (__c);
		}		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
