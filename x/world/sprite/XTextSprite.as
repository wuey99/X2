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
package x.world.sprite {
	
	include "..\\..\\flash.h";
	include "..\\..\\text.h";

	import flash.filters.*;
	import flash.text.TextFormat;
	
	import starling.utils.*;
	
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
			__fontSize:Number=12,
			__color:int=0x000000,
			__bold:Boolean=false,
			__embedFonts:Boolean = true
		) {
			setup ();
			
			if (CONFIG::starling) {
				m_text = new TextField (__width, __height, __text, __fontName, __fontSize, __color, __bold);
			}
			else
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
			
			if (CONFIG::starling) {
				m_text.dispose ();
			}
		}
		
//------------------------------------------------------------------------------------------
		public function getTextField ():TextField {
			return m_text;
		}
		
//------------------------------------------------------------------------------------------
		/* @:get, set text String */
		
		public function set text (__text:String): /* @:set_type */ void {
			if (CONFIG::starling) {
				m_text.text = __text;
			}
			else
			{
				m_text.htmlText = __text; __format ();
			}
		}

//------------------------------------------------------------------------------------------
		if (CONFIG::starling) {
			/* @:get, set filters Array */
				
			public function get filters ():Array {
				null
			}
			
			public function set filters (__value:Array): /* @:set_type */ void {
				/* @:set_return null; */			
			}
			/* @:end */
		}
		
		if (CONFIG::flash) {
			/* @:override get, set filters Array<Dynamic> */
			
			public override function get filters ():Array /* <Dynamic> */ {
				return null;
			}
			
			public override function set filters (__value:Array /* <Dynamic> */): /* @:set_type */ void {
				m_text.filters = __value;
				
				/* @:set_return null; */			
			}
			/* @:end */
		}
		
//------------------------------------------------------------------------------------------
		/* @:get, set color Int */
		
		public function get color ():uint {
			return 0;
		}
		
		public function set color (__color:uint): /* @:set_type */ void {
			if (CONFIG::starling) {
				m_text.color = __color;
			}
			else
			{
				m_text.textColor = __color; __format ();
			}
			
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set bold Bool */
		
		public function get bold ():Boolean {
			return true;
		}
		
		public function set bold (__value:Boolean): /* @:set_type */ void {
			if (CONFIG::starling) {
				m_text.bold = __value;
			}
			else
			{
				m_textFormat.bold = __value; __format ();
			}
			
			/* @:set_return true; */			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		/* @:get, set font String */
		
		public function get font ():String {
			return "";
		}
		
		public function set font (__value:String): /* @:set_type */ void {
			if (CONFIG::starling) {
				m_text.fontName = __value;
			}
			else
			{
				m_textFormat.font = __value; __format ();
			}
			
			/* @:set_return ""; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set size Float */
		
		public function get size ():Number {
			return 0;
		}
		
		public function set size (__value:Number): /* @:set_type */ void {
			if (CONFIG::starling) {
				m_text.fontSize = __value;
			}
			else
			{
				m_textFormat.size = __value; __format ();
			}
			
			/* @:set_return 0; */			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		/* @:get, set aligh String */
		
		public function get align ():String {
			return "";
		}
		
		public function set align (__value:String): /* @:set_type */ void {
			this.hAlign = __value;
			
			/* @:set_return ""; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set hAlign String */
		
		public function get hAlign ():String {
			return "";
		}
		
		public function set hAlign (__value:String): /* @:set_type */ void {
			if (CONFIG::starling) {
				switch (__value) {
					case "left":
						m_text.hAlign = HAlign.CENTER;
						break;
					case "right":
						m_text.hAlign = HAlign.RIGHT;
						break;
					case "center":
						m_text.hAlign = HAlign.CENTER;
						break;
				}
			}
			else
			{
				switch (__value) {
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
		
		public function set vAlign (__value:String): /* @:set_type */ void {
			if (CONFIG::starling) {
				switch (__value) {
					case "top":
						m_text.vAlign = VAlign.TOP;
						break;
					case "bottom":
						m_text.vAlign = VAlign.BOTTOM;
						break;
					case "center":
						m_text.vAlign = VAlign.CENTER;
						break;
				}
			}
			else
			{
			}
			
			/* @:set_return ""; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:override get, set width Float */
		
		public override function get width ():Number {
			return m_text.width;
		}
		
		public override function set width (__value:Number): /* @:set_type */ void {
			m_text.width = __value;
			
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:override get, set height Float */
		
		public override function get height ():Number {
			return m_text.height;
		}
		
		public override function set height (__value:Number): /* @:set_type */ void {
			m_text.height = __value;
			
			/* @:set_return 0; */			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		/* @:get, set textWidth Float */
		
		public function get textWidth ():Number {
			if (CONFIG::starling) {
				return m_text.textBounds.width;
			}
			else
			{
				return m_text.textWidth;
			}
		}
		
		public function setTextWidth (__value:Number):/* @:set_type */ void {
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set textHeight Float */
		
		public function get textHeight ():Number {
			if (CONFIG::starling) {
				return m_text.textBounds.height;
			}
			else
			{
				return m_text.textHeight;
			}
		}
		
		public function setTextHeigt (__value:Number):/* @:set_type */ void {
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
		
		public function set letterSpacing (__value:Number): /* @:set_type */ void {
			if (CONFIG::starling) {
			}
			else
			{
				m_textFormat.letterSpacing = __value; __format ();
			}
			
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set leading Float */
		
		public function get leading ():Number {
			return 0;
		}
		
		public function set leading (__value:Number): /* @:set_type */ void {
			if (CONFIG::starling) {
			}
			else
			{
				m_textFormat.leading = __value; __format ();
			}
			
			/* @:set_return 0; */			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		/* @:get, set selectable Bool */
		
		public function get selectable ():Boolean {
			return true;
		}
		
		public function set selectable (__value:Boolean): /* @:set_type */ void {
			if (CONFIG::starling) {
			}
			else
			{
				m_text.selectable = __value;
			}
			
			/* @:set_return true; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set multiline Bool */
		
		public function get multiline ():Boolean {
			return true;
		}
		
		public function set multiline (__value:Boolean): /* @:set_type */ void {
			if (CONFIG::starling) {	
			}
			else
			{
				m_text.multiline = __value; __format ();
			}
			
			/* @:set_return true; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set wordwrap Bool */
		
		public function get wordwrap ():Boolean {
			return true;
		}
		
		public function set wordWrap (__value:Boolean): /* @:set_type */ void {
			if (CONFIG::starling) {
			}
			else
			{
				m_text.wordWrap = __value; __format ();
			}
			
			/* @:set_return true; */			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		/* @:get, set italic Bool */
		
		public function get italic ():Boolean {
			return true;
		}
		
		public function set italic (__value:Boolean): /* @:set_type */ void {
			/* @:set_return true; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set kerning Bool */
		
		public function get kerning ():Boolean {
			return true;
		}
		
		public function set kerning (__value:Boolean): /* @:set_type */ void {
			/* @:set_return true; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set underline Bool */
		
		public function get underline ():Boolean {
			return true;
		}
		
		public function set underline (__value:Boolean): /* @:set_type */ void {
			/* @:set_return true; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set embedFonts Bool */
		
		public function get embedFonts ():Boolean {
			return true;
		}
		
		public function set embedFonts (__value:Boolean): /* @:set_type */ void {
			if (CONFIG::starling) {
			}
			else
			{
				m_text.embedFonts = __value; __format ();
			}
			
			/* @:set_return true; */			
		}
		/* @:end */
				
//------------------------------------------------------------------------------------------
		private function __format ():void {
			if (CONFIG::flash) {
				m_text.setTextFormat (m_textFormat);
			}
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}