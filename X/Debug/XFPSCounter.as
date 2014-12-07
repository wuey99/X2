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
package X.Debug  {
	
	import X.*;
	import X.Task.*;
	import X.Text.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	
//------------------------------------------------------------------------------------------
	public class XFPSCounter extends XTextLogicObject {

//------------------------------------------------------------------------------------------
		public function XFPSCounter () {
			super ();
		}
		
//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
		}
		
//------------------------------------------------------------------------------------------
		public override function setupX ():void {
			super.setupX ();
						
			oX = oY = 8;
			
			xxx.addTimer1000Listener (
				function ():void {
					setupText (
						// width
						700,
						// height
						32,
						// text
						"FPS: " + xxx.getFPS (),
						// font name
						"Aller",
						// font size
						16,
						// color
						0xe0e0e0,
						// bold
						true
					);
				}
			);
		}

//------------------------------------------------------------------------------------------
		protected override function __removeSprite (__sprite:XDepthSprite):void {
			removeSpriteFromHud (__sprite);
		}
		
//------------------------------------------------------------------------------------------
		protected override function __addSpriteAt (__sprite:XTextSprite, __dx:Number=0, __dy:Number=0):XDepthSprite {
			return addSpriteToHudAt (__sprite, __dx, __dy);	
		}
		
//------------------------------------------------------------------------------------------
		public override function Idle_Script ():void {
			
			script.gotoTask ([
				
				//------------------------------------------------------------------------------------------
				// control
				//------------------------------------------------------------------------------------------
				function ():void {
					script.addTask ([
						XTask.LABEL, "loop",
							XTask.WAIT, 0x1000,
							
							function ():void {
							},
							
							XTask.GOTO, "loop",
						
						XTask.RETN,
					]);
					
				},
				
				//------------------------------------------------------------------------------------------
				// animation
				//------------------------------------------------------------------------------------------	
				XTask.LABEL, "loop",	
					XTask.WAIT, 0x0100,	
					
					XTask.GOTO, "loop",
				
				XTask.RETN,
				
				//------------------------------------------------------------------------------------------			
			]);
			
		//------------------------------------------------------------------------------------------
		}
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}
