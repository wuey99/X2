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
			
			m_textArea = new XTextSprite ();
			
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
			m_textArea.v.selectable = true;
			m_textArea.v.multiline = true;
			m_textArea.v.wordWrap = true;
			m_textArea.v.embedFonts = true;
			m_textArea.v.width = 320;
			m_textArea.v.height = 480;
            m_textFormat = __TextFormat (m_fontClass);
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
			if (!m_disableOutput) {
				m_textArea.v.appendText (__text + "\n");
				m_textArea.v.setTextFormat (m_textFormat);
			}
		}

//------------------------------------------------------------------------------------------
		public function clear ():void {
			m_textArea.v.text = "";
		}
		
//------------------------------------------------------------------------------------------
		public function __TextFormat (__fontClass:Class):TextFormat {
			var __font:Font = new __fontClass ();
			
            var __format:TextFormat = new TextFormat();
            __format.font = __font.fontName;
            
            __format.bold = true;
            __format.color = 0x404040;
            __format.letterSpacing = 0.0;
            
            return __format;
  		}
            
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}
