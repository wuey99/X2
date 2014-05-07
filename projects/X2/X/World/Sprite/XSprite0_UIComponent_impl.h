//------------------------------------------------------------------------------------------
// <$begin$/>
// <$end$/>
//------------------------------------------------------------------------------------------
package X.World.Sprite {

	import X.World.*;
	
	import flash.display.Sprite;
	
	import mx.containers.*;
	import mx.core.Container;
	import mx.core.IChildList;

//------------------------------------------------------------------------------------------
	public class XSprite0 extends Container {
		public var m_xxx:XWorld;
					
//------------------------------------------------------------------------------------------
		public function XSprite0 () {
			super ();
			
			clipContent = false;
			width = 64;
			height = 64;
			setStyle ("borderStyle", "none");
		}

//------------------------------------------------------------------------------------------
		public function get xxx ():XWorld {
			return m_xxx;
		}
		
		public function set xxx (__XWorld:XWorld):void {
			m_xxx = __XWorld;
		}
		
//------------------------------------------------------------------------------------------
		public function get childList ():IChildList {
			return rawChildren;
		}
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}
