//------------------------------------------------------------------------------------------
package X.World.Logic {
	
	import X.XMap.XMapItemModel;
	
	import flash.events.*;
	
//------------------------------------------------------------------------------------------	
	public class XLogicObjectEvent extends Event {
		
		private var m_item:XMapItemModel;
		
//------------------------------------------------------------------------------------------		
		public override function XLogicObjectEvent (
			__type:String,
			__bubbles:Boolean = false,
			__cancelable:Boolean = false
			) {
				
			super (__type, __bubbles, __cancelable);
		}
		
//------------------------------------------------------------------------------------------
		public function set item (__item:XMapItemModel):void {
			m_item = __item;
		}

//------------------------------------------------------------------------------------------
		public function get item ():XMapItemModel {
			return m_item;
		}
		
//------------------------------------------------------------------------------------------
	}	

//------------------------------------------------------------------------------------------
}
