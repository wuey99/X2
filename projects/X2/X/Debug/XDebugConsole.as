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
			
			m_textArea = createXTextSprite (32, 32, "");
			
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
