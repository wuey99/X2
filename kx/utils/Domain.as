//------------------------------------------------------------------------------------------
package kx.utils {

	import flash.display.*;
	
	//------------------------------------------------------------------------------------------
	// returns the Domain from where this application was loaded
	//------------------------------------------------------------------------------------------
	public class Domain  {
	
		//------------------------------------------------------------------------------------------
		public function Domain () {
		}
		
		//------------------------------------------------------------------------------------------
		public static function getDomain (__root:Sprite):String {
			var __urlString:String = __root.loaderInfo.url;
			var __urlArray:Array /* <String> */ =
				__urlString.split("://");
			var __fullDomainString:String = __urlArray[1].split("/")[0];
			
			var __domainParts:Array /* <String> */ = __fullDomainString.split (".");
			
			if (__domainParts.length > 2) {
				return  __domainParts[1] + "." + __domainParts[2];
			}
			else
			{
				return __fullDomainString;
			}		
		}
		
	//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------
}