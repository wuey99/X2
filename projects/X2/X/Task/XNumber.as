//------------------------------------------------------------------------------------------
package X.Task {
	
//------------------------------------------------------------------------------------------
	public class XNumber extends Object {
		private var m_number:Number
		
//------------------------------------------------------------------------------------------
		public function XNumber (__value:Number) {
			m_number = __value;
		}

//------------------------------------------------------------------------------------------
		public function get value ():Number {
			return  m_number;
		}
		
//------------------------------------------------------------------------------------------
		public function set value (__value:Number):void {
			m_number = __value;
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}