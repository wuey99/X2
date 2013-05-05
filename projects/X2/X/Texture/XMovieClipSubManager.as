//------------------------------------------------------------------------------------------
package X.Texture {
	
	// X classes
	import X.Collections.*;
	import X.Task.*;
	import X.World.Sprite.*;
	import X.XApp;
	
	import flash.display.BitmapData;
	
	import starling.display.*;
	import starling.textures.*;
	
	//------------------------------------------------------------------------------------------
	// this class takes one or more flash.display.MovieClip's and dynamically creates texture/atlases
	//------------------------------------------------------------------------------------------
	public class XMovieClipSubManager extends Object {
		private var m_XApp:XApp;
		
		private var m_manager:XMovieClipManager;
		
		//------------------------------------------------------------------------------------------
		public function XMovieClipSubManager (__XApp:XApp) {
			m_manager = new XMovieClipManager ();
		}

		//------------------------------------------------------------------------------------------
		public function add (__name):void {
			m_manager.add (__name);
		}
		
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
