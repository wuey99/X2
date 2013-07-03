//------------------------------------------------------------------------------------------
package X.Debug  {
	
	import X.*;
	import X.Task.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	
	import flash.display.*;
	import flash.text.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------
	public class XDebugConsole extends XLogicObject {
		private var m_textFormat:TextFormat;
		private var m_textArea:XTextSprite;
		private var m_disableOutput:Number;
		private var m_fontClass:Class;
		
//------------------------------------------------------------------------------------------
		public function XDebugConsole () {
			m_disableOutput = 0;
		}

//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);

			m_fontClass = getArg (args, 0);
			
			createSprites ();
		}

//------------------------------------------------------------------------------------------
		public override function setupX ():void {
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
		}
		
//------------------------------------------------------------------------------------------
// create sprites
//------------------------------------------------------------------------------------------
		public override function createSprites ():void {
			var xsprite:XDepthSprite;
			
			m_textArea = new XTextSprite (32, 32, "");
			
			xsprite = addSpriteAt (m_textArea, 0, 0, true);
			xsprite.setDepth (999999);
			
			setTextProps ();
			
			addText ("starting ...");
			
			show ();
		}

//------------------------------------------------------------------------------------------
// set text field properties
//------------------------------------------------------------------------------------------
		public function setTextProps ():void {
			m_textArea.selectable = true;
			m_textArea.multiline = true;
			m_textArea.wordWrap = true;
			m_textArea.embedFonts = true;
		
			m_textArea.width = 320;
			m_textArea.height = 480;
			
//			var __font:Font = new __fontClass ();		
//			m_textArea.font = __font.fontName;
			
			m_textArea.bold = true;
			m_textArea.color = 0x404040;
			m_textArea.letterSpacing = 0.0;
		}

//------------------------------------------------------------------------------------------
		public function disableOutput (__flag:Boolean):void {
			if (__flag) {
				m_disableOutput++;
			}
			else
			{
				if (m_disableOutput) {
					m_disableOutput--;
				}
			}
		}
		
//------------------------------------------------------------------------------------------
		public function addText (__text:String):void {
// !STARLING!
			if (!m_disableOutput) {
				if (CONFIG::flash) {
//					m_textArea.v.appendText (__text + "\n");
//					m_textArea.v.setTextFormat (m_textFormat);
				}
			}
		}

//------------------------------------------------------------------------------------------
		public function clear ():void {
			m_textArea.text = "";
		}
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}