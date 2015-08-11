package x.utils {
	
// see: http://www.rgbeffects.com/blog/actionscript/actionscript-3-guid-%E2%80%93-generating-unique-ids-for-users-in-as3/

	import flash.display.Sprite;
	import flash.system.Capabilities;
	
	import x.type.*;
	
	public class GUID extends Sprite {

		private static var counter:int = 0;
		
		function GUID(){
			super();
		}
		
		public static function create():String {
			var dt:Date = XType.getNowDate();
			var id1:Number = dt.getTime();
			var id2:Number = Math.random()*XType.Number_MAX_VALUE();
			var id3:String = Capabilities.serverString;
			var rawID:String = calculate(id1+id3+id2+counter++).toUpperCase();
			var finalString:String = rawID.substring(0, 8) + "-" + rawID.substring(8, 12) + "-" + rawID.substring(12, 16) + "-" + rawID.substring(16, 20) + "-" + rawID.substring(20, 32);
			return finalString;
		}
	
		private static function calculate(src:String):String {
				return hex_sha1(src);
		}
	
		private static function hex_sha1(src:String):String {
				return binb2hex(core_sha1(str2binb(src), src.length*8));
		}
			
		private static function core_sha1(
			x:Array /* <Int> */,
			len:int
		):Array /* <Int> */ {
			x[len >> 5] |= 0x80 << (24-len%32);
			x[((len+64 >> 9) << 4)+15] = len;
			var w:Array /* <Int> */
				= new Array (/* 80 */); // <Int>
			for (var z:int = 0; z < 80; z++) {
				w.push (0);
			}
			var a:int = 1732584193;
			var b:int = -271733879;
			var c:int = -1732584194;
			var d:int = 271733878;
			var e:int = -1009589776;
			var i:int = 0;
//			for (var i:Number = 0; i<x.length; i += 16) {
			while (i<x.length) {
				var olda:int = a, oldb:int = b;
				var oldc:int = c, oldd:int = d, olde:int = e;
				for (var j:int = 0; j<80; j++) {
					if (j<16) w[j] = x[i+j];
					else w[j] = rol(w[j-3] ^ w[j-8] ^ w[j-14] ^ w[j-16], 1);
					var t:int = safe_add(safe_add(rol(a, 5), sha1_ft(j, b, c, d)), safe_add(safe_add(e, w[j]), sha1_kt(j)));
					e = d; d = c;
					c = rol(b, 30);
					b = a; a = t;
				}
				a = safe_add(a, olda);
				b = safe_add(b, oldb);
				c = safe_add(c, oldc);
				d = safe_add(d, oldd);
				e = safe_add(e, olde);
				i += 16;
			}
			// <HAXE>
			/* --
				return [a, b, c, c, e];
				
			-- */
			// </HAXE>
			// <AS3>
				return new Array(a, b, c, d, e); // <Int>
			// </AS3>
		}
	
		private static function sha1_ft(t:int, b:int, c:int, d:int):int {
			if (t<20) return (b & c) | ((~b) & d);
			if (t<40) return b ^ c ^ d;
			if (t<60) return (b & c) | (b & d) | (c & d);
			return b ^ c ^ d;
		}
	
		private static function sha1_kt(t:int):int {
			return (t<20) ? 1518500249 : (t<40) ? 1859775393 : (t<60) ? -1894007588 : -899497514;
		}
	
		private static function safe_add(x:int, y:int):int {
			var lsw:int = (x & 0xFFFF)+(y & 0xFFFF);
			var msw:int = (x >> 16)+(y >> 16)+(lsw >> 16);
			return (msw << 16) | (lsw & 0xFFFF);
		}
	
		private static function rol(num:int, cnt:int):int {
			return (num << cnt) | (num >>> (32-cnt));
		}
	
		private static function str2binb(str:String):Array /* <Int> */ {
			var bin:Array /* <Int> */ = new Array (); // <Int>
			var mask:int = (1 << 8)-1;
			var i:int = 0;
//			for (var i:Number = 0; i<str.length*8; i += 8) {
			while (i<str.length*8) {
				var index8:int = int(i/8);
				bin[i >> 5] |= (str.charCodeAt(index8) & mask) << (24-i%32);
				i += 8;
			}
			return bin;
		}
	
		private static function binb2hex(binarray:Array /* <Int> */):String {
			var str:String = new String("");
			var tab:String = new String("0123456789abcdef");
			for (var i:int = 0; i<binarray.length*4; i++) {
				str += tab.charAt((binarray[i >> 2] >> ((3-i%4)*8+4)) & 0xF) + tab.charAt((binarray[i >> 2] >> ((3-i%4)*8)) & 0xF);
			}
			return str;
		}
	}
}