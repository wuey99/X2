//------------------------------------------------------------------------------------------
package kx.sound {
	
	import kx.*;
	import kx.collections.*;
	import kx.pool.*;
	import kx.task.*;
	import kx.sound.*;
	import kx.world.logic.*;
	import kx.type.*;
	
	//------------------------------------------------------------------------------------------	
	public class XSoundTaskManager extends XTaskManager {
		
	//------------------------------------------------------------------------------------------
		public function XSoundTaskManager (__XApp:XApp) {
			super (__XApp);	
		}
		
	//------------------------------------------------------------------------------------------	
		public override function createPoolManager ():XObjectPoolManager {
			return new XObjectPoolManager (
				function ():* {
					return new XSoundTask ();
				},
				
				function (__src:*, __dst:*):* {
					return null;
				},
				
				1024, 256,
				
				function (x:*):void {
				}
			);
		}
	
	//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}