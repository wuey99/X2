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
		public function setup ():void {
		}

//------------------------------------------------------------------------------------------
		public function cleanup ():void {
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
		public override function set width (__value:Number):void {
			m_text.width = __value;
		}
		
//------------------------------------------------------------------------------------------
		public override function set height (__value:Number):void {
			m_text.height = __value;
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
				m_text.multiline = __value
			}
		}
		
//------------------------------------------------------------------------------------------
		public function set wordWrap (__value:Boolean):void {
			if (CONFIG::starling) {
			}
			else
			{
				m_text.wordWrap = __value;
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