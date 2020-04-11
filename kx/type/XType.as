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
package kx.type {
	import kx.collections.XDict;

	// <HAXE>
	/* --
	-- */
	// </HAXE>
	// <AS3>
	import mx.utils.*;
	// </AS3>
	
	//------------------------------------------------------------------------------------------	
	public class XType extends Object {

		//------------------------------------------------------------------------------------------
		public function XType () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public function setup ():void {		
		}
		
		//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}

		//------------------------------------------------------------------------------------------
		public static function createInstance (__class:Class /* <Dynamic> */):* {
			// <HAXE>
			/* --
				return Type.createInstance (__class, []);
			-- */
			// </HAXE>
			// <AS3>
				return new (__class) ();
			// </AS3>
		}
		
		//------------------------------------------------------------------------------------------
		// <HAXE>
		/* --
		public static function createError (__message:String):String {
			return __message;
		}
		-- */
		// </HAXE>
		// <AS3>
		public static function createError (__message:String):Error {
			return Error (__message);
		}
		// </AS3>
		
		//------------------------------------------------------------------------------------------
		public static function min (__value1:int, __value2:int):int {
			if (__value1 < __value2) {
				return __value1;
			}
			else
			{
				return __value2;
			}
		}
		
		//------------------------------------------------------------------------------------------
		public static function max (__value1:int, __value2:int):int {
			if (__value1 > __value2) {
				return __value1;
			}
			else
			{
				return __value2;
			}
		}
		
		//------------------------------------------------------------------------------------------
		public static function clearArray (__array:Array /* <Dynamic> */):void {
			// <HAXE>
			/* --
			#if (cpp||php)
				__array.splice( 0, __array.length);           
			#else
				untyped __array.length = 0;
			#end
			-- */
			// </HAXE>
			// <AS3>
				__array.length = 0;
			// </AS3>
		}
		
		//------------------------------------------------------------------------------------------
		public static function initArray (__array:Array /* <Dynamic> */, __length:int, __val:*):void {
			var i:int;
			
			for (i=0; i < __length; i++) {
				__array.push (__val);
			}
		}
		
		//------------------------------------------------------------------------------------------
			// <HAXE>
			/* --
		public static function copyArray (__array:Array<Dynamic>):Array<Dynamic> {
			return __array.copy();
			-- */
			// </HAXE>
			// <AS3>
		public static function copyArray (__array:Array):Array {
			return [].concat(__array);
			// </AS3>		
		}
		
		//------------------------------------------------------------------------------------------
		public static function getNowDate ():Date {
			// <HAXE>
			/* --
				return Date.now ();
			-- */
			// </HAXE>
			// <AS3>
				return new Date ();
			// </AS3>			
		}
		
		//------------------------------------------------------------------------------------------
		public static function Number_MAX_VALUE ():Number {
			// <HAXE>
			/* --
				return 179 * Math.pow(10, 306);
			-- */
			// </HAXE>
			// <AS3>
				return Number.MAX_VALUE;
			// </AS3>				
		}
		
		//------------------------------------------------------------------------------------------
		public static function int_MAX_VALUE ():int {
			// <HAXE>
			/* --
			return 2147483647;
			-- */
			// </HAXE>
			// <AS3>
			return int.MAX_VALUE;
			// </AS3>				
		}
		
		//------------------------------------------------------------------------------------------
		public static function isFunction (__val:*):Boolean {
			// <HAXE>
			/* --
			return Reflect.isFunction (__val);
			-- */
			// </HAXE>
			// <AS3>
			return __val is Function;
			// </AS3>				
		}

		//------------------------------------------------------------------------------------------
		public static function isType (__val:*, __type:*):Boolean {
			// <HAXE>
			/* --
			return Std.is (__val, __type);
			-- */
			// </HAXE>
			// <AS3>
			return __val is __type;
			// </AS3>
		}
		
		//------------------------------------------------------------------------------------------
		public static function parseInt (__val:String):int {
			// <HAXE>
			/* --
			return Std.parseInt (__val);
			-- */
			// </HAXE>
			// <AS3>
			return int (__val);
			// </AS3>;
		}
		
		//------------------------------------------------------------------------------------------
		public static function parseFloat_ (__val:String):Number {
			// <HAXE>
			/* --
			return Std.parseFloat (__val);
			-- */
			// </HAXE>
			// <AS3>
			return parseFloat (__val);
			// </AS3>;
		}
		
		//------------------------------------------------------------------------------------------
		public static function hasField (__map:*, __key:String):Boolean {
			// <HAXE>
			/* --
			return Reflect.hasField (__map, __key);
			-- */
			// </HAXE>
			// <AS3>
			return __key in __map;
			// </AS3>
		}
		
		//------------------------------------------------------------------------------------------
		public static function replace (__string:String, __from:String, __to:String):String {
			// <HAXE>
			/* --
			return StringTools.replace (__string, __from, __to);
			-- */
			// </HAXE>
			// <AS3>
			return __string.replace (__from, __to);
			// </AS3>			
		}
		
		//------------------------------------------------------------------------------------------
		public static function array2XDict (__array:Array /* <Dynamic> */):XDict /* <String, Dynamic> */ {
			var __dict:XDict = new XDict (); // <String, Dynamic>
			
			var i:int = 0;
			
			while (i < __array.length) {
				__dict.set (__array[i+0], __array[i+1]);
				
				i += 2;
			}		
			
			return __dict;
		}
		
		//------------------------------------------------------------------------------------------
		public static function trim (__string:String):String {
				// <HAXE>
				/* --
				return StringTools.trim (__string);
				-- */
				// </HAXE>
				// <AS3>
				return StringUtil.trim (__string);
				// </AS3>						
		}
		
		//------------------------------------------------------------------------------------------
		// <HAXE>
		/* --
		public static function errorMessage (e:Dynamic):String {
		-- */
		// </HAXE>
		// <AS3>
		public static function errorMessage (e:Error):String {
		// </AS3>
			// <HAXE>
			/* --
			return e;
			-- */
			// </HAXE>
			// <AS3>
			return e.message;
			// </AS3>						
		}
		
		//------------------------------------------------------------------------------------------
		// <HAXE>
		/* --
		public static function forEach (__map:Map<Dynamic, Dynamic>, __callback:Dynamic):Void {
			for (__key in __map.keys ()) {
				__callback (__key);
			}
		}
		-- */
		// </HAXE>
		// <AS3>
		// </AS3>
		
		//------------------------------------------------------------------------------------------
		// <HAXE>
		/* --
		public static function doWhile (__map:Map<Dynamic, Dynamic>, __callback:Dynamic):Void {
			for (__key in __map.keys ()) {
				if (!__callback (__key)) {
					return;
				}
			}
		}
		-- */
		// </HAXE>
		// <AS3>
		// </AS3>
	}
	
	//------------------------------------------------------------------------------------------
}