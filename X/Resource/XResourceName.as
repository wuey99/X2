//------------------------------------------------------------------------------------------	
package X.Resource {
	
//------------------------------------------------------------------------------------------	
	public class XResourceName extends Object {
		private var m_className:String;
		private var m_resourceName:String;
		private var m_manifestName:String
				
//------------------------------------------------------------------------------------------
// fullName examples:
//
// XLogicObject:XLogicObject  -  Resource Name, Class Name
// :XLogicObject:XLogicObject  -  Resource Name, Class Name
// Project:XLogicObject:XLogicObject  -   Manifest Name, Resource Name, Class Name
//------------------------------------------------------------------------------------------
		public function XResourceName (__fullName:String) {
			super ();
			
			var s:Array = __fullName.split (":");
			
			if (s.length != 2 && s.length != 3) {
				throw (Error ("className not valid: " + __fullName));
			}
			
			if (s.length == 2) {
				m_manifestName = "";
				m_resourceName = s[0];
				m_className = s[1];
			}
			else
			{
				m_manifestName = s[0];
				m_resourceName = s[1];
				m_className = s[2];
			}
		}
		
//------------------------------------------------------------------------------------------
		public function get manifestName ():String {
			return m_manifestName;
		}
		
//------------------------------------------------------------------------------------------
		public function get resourceName ():String {
			return m_resourceName;
		}
		
//------------------------------------------------------------------------------------------
		public function get className ():String {
			return m_className;
		}
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}