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
package kx.world.sprite {
	
	include "..\\..\\flash.h";
	include "..\\..\\text.h";

	import flash.filters.*;
	import flash.text.TextFormat;
	
//------------------------------------------------------------------------------------------
	public class XTextSprite extends XSprite {
		private var m_text:TextField;
		private var m_textFormat:TextFormat;

//------------------------------------------------------------------------------------------
		public function XTextSprite (
			__width:Number=32,
			__height:Number=32,
			__text:String="",
			__fontName:String="Aller",
			__fontSize:int=12,
			__color:int=0x000000,
			__bold:Boolean=false,
			__embedFonts:Boolean = true
		) {
			super ();
			
			setup ();
			
			{
				m_text = new TextField ();		
				m_textFormat = new TextFormat ();
				
				this.width = __width;
				this.height = __height;
				this.text = __text;
				this.font = __fontName;
				this.size = __fontSize;
				this.color = __color;
				this.bold = __bold;
				this.embedFonts = __embedFonts;
			}
			
			addChild (m_text);
		}

//------------------------------------------------------------------------------------------
		public override function setup ():void {
			super.setup ();
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
		}
		
//------------------------------------------------------------------------------------------
		public function getTextField ():TextField {
			return m_text;
		}
		
//------------------------------------------------------------------------------------------
		/* @:get, set text String */
		
		public function get text ():String {
			return "";
		}
		
		public function set text (__text:String): /* @:set_type */ void {
			{
				m_text.htmlText = __text; __format ();
			}
			
			/* @:set_return __text; */
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
			/* @:override get, set filters Array<BitmapFilter> */
			
			public override function get filters ():Array /* <BitmapFilter> */ {
				return null;
			}
			
			public override function set filters (__val:Array /* <BitmapFilter> */): /* @:set_type */ void {
				m_text.filters = __val;
				
				/* @:set_return __val; */			
			}
			/* @:end */

//------------------------------------------------------------------------------------------
		/* @:get, set color Int */
		
		public function get color ():uint {
			return 0;
		}
		
		public function set color (__color:uint): /* @:set_type */ void {
			{
				m_text.textColor = __color; __format ();
			}
			
			/* @:set_return __color; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set bold Bool */
		
		public function get bold ():Boolean {
			return true;
		}
		
		public function set bold (__val:Boolean): /* @:set_type */ void {
			{
				m_textFormat.bold = __val; __format ();
			}
			
			/* @:set_return __val; */			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		/* @:get, set font String */
		
		public function get font ():String {
			return "";
		}
		
		public function set font (__val:String): /* @:set_type */ void {
			{
				m_textFormat.font = __val; __format ();
			}
			
			/* @:set_return __val; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set size Int */
		
		public function get size ():int {
			return 0;
		}
		
		public function set size (__val:int): /* @:set_type */ void {
			{
				m_textFormat.size = __val; __format ();
			}
			
			/* @:set_return __val; */			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		/* @:get, set align String */
		
		public function get align ():String {
			return "";
		}
		
		public function set align (__val:String): /* @:set_type */ void {
			this.hAlign = __val;
			
			/* @:set_return ""; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set hAlign String */
		
		public function get hAlign ():String {
			return "";
		}
		
		public function set hAlign (__val:String): /* @:set_type */ void {
			{
				switch (__val) {
					case "left":
						m_textFormat.align = TextFormatAlign.LEFT;
						break;
					case "right":
						m_textFormat.align = TextFormatAlign.RIGHT;
						break;
					case "center":
						m_textFormat.align = TextFormatAlign.CENTER;
						break;
				}
				
				__format ();
			}
			
			/* @:set_return ""; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set vAlign String */
		
		public function get vAlign ():String {
			return "";
		}
		
		public function set vAlign (__val:String): /* @:set_type */ void {

			
			/* @:set_return ""; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:override get, set width Float */
		
		public override function get width ():Number {
			return m_text.width;
		}
		
		public override function set width (__val:Number): /* @:set_type */ void {
			m_text.width = __val;
			
			/* @:set_return __val; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:override get, set height Float */
		
		public override function get height ():Number {
			return m_text.height;
		}
		
		public override function set height (__val:Number): /* @:set_type */ void {
			m_text.height = __val;
			
			/* @:set_return __val; */			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		/* @:get, set textWidth Float */
		
		public function get textWidth ():Number {
			{
				return m_text.textWidth;
			}
		}
		
		public function set_textWidth (__val:Number):/* @:set_type */ void {
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set textHeight Float */
		
		public function get textHeight ():Number {
			{
				return m_text.textHeight;
			}
		}
		
		public function set_textHeight (__val:Number):/* @:set_type */ void {
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function autoCalcSize ():void {
			width =	textWidth + 8;
			height = textHeight + 8;
		}
		
//------------------------------------------------------------------------------------------
		public function autoCalcWidth ():void {
			width =	textWidth + 8;
		}
	
//------------------------------------------------------------------------------------------
		public function autoCalcHeight ():void {
			height = textHeight + 8;
		}
		
//------------------------------------------------------------------------------------------
		/* @:get, set letterSpacing Float */
		
		public function get letterSpacing ():Number {
			return 0;
		}
		
		public function set letterSpacing (__val:Number): /* @:set_type */ void {
			{
				m_textFormat.letterSpacing = __val; __format ();
			}
			
			/* @:set_return __val; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set leading Int */
		
		public function get leading ():int {
			return 0;
		}
		
		public function set leading (__val:int): /* @:set_type */ void {
			{
				m_textFormat.leading = __val; __format ();
			}
			
			/* @:set_return __val; */			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		/* @:get, set selectable Bool */
		
		public function get selectable ():Boolean {
			return true;
		}
		
		public function set selectable (__val:Boolean): /* @:set_type */ void {
			{
				m_text.selectable = __val;
			}
			
			/* @:set_return __val; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set multiline Bool */
		
		public function get multiline ():Boolean {
			return true;
		}
		
		public function set multiline (__val:Boolean): /* @:set_type */ void {
			{
				m_text.multiline = __val; __format ();
			}
			
			/* @:set_return __val; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set wordWrap Bool */
		
		public function get wordWrap ():Boolean {
			return true;
		}
		
		public function set wordWrap (__val:Boolean): /* @:set_type */ void {
			{
				m_text.wordWrap = __val; __format ();
			}
			
			/* @:set_return __val; */			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		/* @:get, set italic Bool */
		
		public function get italic ():Boolean {
			return true;
		}
		
		public function set italic (__val:Boolean): /* @:set_type */ void {
			/* @:set_return true; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set kerning Bool */
		
		public function get kerning ():Boolean {
			return true;
		}
		
		public function set kerning (__val:Boolean): /* @:set_type */ void {
			/* @:set_return true; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set underline Bool */
		
		public function get underline ():Boolean {
			return true;
		}
		
		public function set underline (__val:Boolean): /* @:set_type */ void {
			/* @:set_return true; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set embedFonts Bool */
		
		public function get embedFonts ():Boolean {
			return true;
		}
		
		public function set embedFonts (__val:Boolean): /* @:set_type */ void {
			{
				m_text.embedFonts = __val; __format ();
			}
			
			/* @:set_return __val; */			
		}
		/* @:end */
				
//------------------------------------------------------------------------------------------
		private function __format ():void {
			m_text.setTextFormat (m_textFormat);
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}