//------------------------------------------------------------------------------------------
// <$begin$/>
// Copyright (C) 2014 Jimmy Huey
//
// Some Rights Reserved.
//
// The "X-Engine" is licensed under a Creative Commons
// Attribution-NonCommerical-ShareAlike 3.0 Unported License.
// (CC BY-NC-SA 3.0)
//
// You are free to:
//
//      SHARE - to copy, distribute, display and perform the work.
//      ADAPT - remix, transform build upon this material.
//
//      The licensor cannot revoke these freedoms as long as you follow the license terms.
//
// Under the following terms:
//
//      ATTRIBUTION -
//          You must give appropriate credit, provide a link to the license, and
//          indicate if changes were made.  You may do so in any reasonable manner,
//          but not in any way that suggests the licensor endorses you or your use.
//
//      SHAREALIKE -
//          If you remix, transform, or build upon the material, you must
//          distribute your contributions under the same license as the original.
//
//      NONCOMMERICIAL -
//          You may not use the material for commercial purposes.
//
// No additional restrictions - You may not apply legal terms or technological measures
// that legally restrict others from doing anything the license permits.
//
// The full summary can be located at:
// http://creativecommons.org/licenses/by-nc-sa/3.0/
//
// The human-readable summary of the Legal Code can be located at:
// http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode
//
// The "X-Engine" is free for non-commerical use.
// For commercial use, you will need to provide additional credits.
// Please contact me @ wuey99[dot]gmail[dot]com for more details.
// <$end$/>
//------------------------------------------------------------------------------------------
package X.World.Sprite {
	
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
			__fontName:String="Verdana",
			__fontSize:Number=12,
			__color:int=0x000000,
			__bold:Boolean=false
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
		public function set text (__text:String):void {
			if (CONFIG::starling) {
				m_text.text = __text;
			}
			else
			{
				m_text.htmlText = __text; __format ();
			}
		}

//------------------------------------------------------------------------------------------
		CONFIG::starling
		public function set filters (__value:Array):void {
			
		}
		
		CONFIG::flash
		public override function set filters (__value:Array):void {
			m_text.filters = __value;
		}
		
//------------------------------------------------------------------------------------------
		public function set color (__color:uint):void {
			if (CONFIG::starling) {
				m_text.color = __color;
			}
			else
			{
				m_text.textColor = __color; __format ();
			}
		}
		
//------------------------------------------------------------------------------------------
		public function set bold (__value:Boolean):void {
			if (CONFIG::starling) {
				m_text.bold = __value;
			}
			else
			{
				m_textFormat.bold = __value; __format ();
			}
		}
			
//------------------------------------------------------------------------------------------
		public function set font (__value:String):void {
			if (CONFIG::starling) {
				m_text.fontName = __value;
			}
			else
			{
				m_textFormat.font = __value; __format ();
			}
		}
		
//------------------------------------------------------------------------------------------
		public function set size (__value:Number):void {
			if (CONFIG::starling) {
				m_text.fontSize = __value;
			}
			else
			{
				m_textFormat.size = __value; __format ();
			}
		}

//------------------------------------------------------------------------------------------
		public function set align (__value:String):void {
			this.hAlign = __value;
		}
		
//------------------------------------------------------------------------------------------
		public function set hAlign (__value:String):void {
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
		}
		
//------------------------------------------------------------------------------------------
		public function set vAlign (__value:String):void {
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
		}
		
//------------------------------------------------------------------------------------------
		public override function get width ():Number {
			return m_text.width;
		}
		
		public override function set width (__value:Number):void {
			m_text.width = __value;
		}
		
//------------------------------------------------------------------------------------------
		public override function get height ():Number {
			return m_text.height;
		}
		
		public override function set height (__value:Number):void {
			m_text.height = __value;
		}

//------------------------------------------------------------------------------------------
		public function get textWidth ():Number {
			if (CONFIG::starling) {
				return m_text.textBounds.width;
			}
			else
			{
				return m_text.textWidth;
			}
		}
		
//------------------------------------------------------------------------------------------
		public function get textHeight ():Number {
			if (CONFIG::starling) {
				return m_text.textBounds.height;
			}
			else
			{
				return m_text.textHeight;
			}
		}
		
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
		public function set letterSpacing (__value:Number):void {
			if (CONFIG::starling) {
			}
			else
			{
				m_textFormat.letterSpacing = __value; __format ();
			}
		}
		
//------------------------------------------------------------------------------------------
		public function set leading (__value:Number):void {
			if (CONFIG::starling) {
			}
			else
			{
				m_textFormat.leading = __value; __format ();
			}
		}

//------------------------------------------------------------------------------------------
		public function set selectable (__value:Boolean):void {
			if (CONFIG::starling) {
			}
			else
			{
				m_text.selectable = __value;
			}
		}
		
//------------------------------------------------------------------------------------------
		public function set multiline (__value:Boolean):void {
			if (CONFIG::starling) {	
			}
			else
			{
				m_text.multiline = __value; __format ();
			}
		}
		
//------------------------------------------------------------------------------------------
		public function set wordWrap (__value:Boolean):void {
			if (CONFIG::starling) {
			}
			else
			{
				m_text.wordWrap = __value; __format ();
			}
		}

//------------------------------------------------------------------------------------------
		public function set italic (__value:Boolean):void {
		}
		
//------------------------------------------------------------------------------------------
		public function set kerning (__value:Boolean):void {	
		}
		
//------------------------------------------------------------------------------------------
		public function set underline (__value:Boolean):void {
		}
		
//------------------------------------------------------------------------------------------
		public function set embedFonts (__value:Boolean):void {
			if (CONFIG::starling) {
			}
			else
			{
				m_text.embedFonts = __value;
			}
		}
				
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