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
package kx.world.ui {
	
	// X classes
	import kx.*;
	import kx.signals.*;
	import kx.task.*;
	import kx.world.*;
	import kx.world.collision.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.world.ui.*;
	import kx.geom.*;
	
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------
	public class XWorldButton extends XButton {
		public var m_width:Number;
		public var m_height:Number;
		
		//------------------------------------------------------------------------------------------
		public function XWorldButton () {
			super ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array /* <Dynamic> */):void {
			super.setup (__xxx, args);
			
			m_width = getArg (args, 1);
			m_height = getArg (args, 2);
		}
		
		//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
		}

		//------------------------------------------------------------------------------------------
		public override function __onMouseOver ():void {	
			if (isMouseInRange ()) {
				super.__onMouseOver ();
			}
			else
			{
				super.__onMouseOut ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function __onMouseDown ():void {
			if (isMouseInRange ()) {
				super.__onMouseDown ();
			}
			else
			{
				super.__onMouseOut ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function __onMouseUp ():void {
			if (isMouseInRange ()) {
				super.__onMouseUp ();
			}
			else
			{
				super.__onMouseOut ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function __onMouseMove ():void {
			if (m_currState == XButton.DOWN_STATE) {
				return;
			}
			
			if (isMouseInRange ()) {
				super.__onMouseOver ();
			}
			else
			{
				super.__onMouseOut ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		public override function __onMouseOut ():void {
			super.__onMouseOut ();
		}
		
		//------------------------------------------------------------------------------------------
		public override function setupListeners ():void {	
			xxx.getXTaskManager ().addTask ([
				function ():void {
					/*
//					xxx.getParent ().stage.addEventListener (xxx.MOUSE_OVER, onMouseOver);
					xxx.getParent ().stage.addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown);
					xxx.getParent ().stage.addEventListener (MouseEvent.MOUSE_MOVE, onMouseMove);
					xxx.getParent ().stage.addEventListener (MouseEvent.MOUSE_UP, onMouseUp);
					xxx.getParent ().stage.addEventListener (MouseEvent.MOUSE_OUT, onMouseOut);
					*/
					
					xxx.addMouseDownListener (onMouseDown);
					xxx.addPolledMouseMoveListener (onPolledMouseMove);
					xxx.addMouseUpListener (onMouseUp);
					xxx.addMouseOutListener (onMouseOut);
					xxx.getFlashStage ().addEventListener (KeyboardEvent.KEY_DOWN, onKeyboardDown);	
				},
				
				XTask.RETN,
			]);
		}

		//------------------------------------------------------------------------------------------
		public override function cleanupListeners ():void {
			xxx.removeMouseDownListener (onMouseDown);
			xxx.removeMouseMoveListener (onMouseMove);
			xxx.removeMouseUpListener (onMouseUp);
			xxx.removeMouseOutListener (onMouseOut);
			xxx.getFlashStage ().removeEventListener (KeyboardEvent.KEY_DOWN, onKeyboardDown);	
		}
		
		//------------------------------------------------------------------------------------------
		public function onPolledMouseMove (__point:XPoint):void {
			__onMouseMove ();
		}
		
		//------------------------------------------------------------------------------------------
		protected function getWorldCoordinates ():XPoint {
			var __logicObject:XLogicObject = this.getParent ();
			
			var __x:Number = oX, __y:Number = oY;
			
			while (__logicObject != null) {
				__x += __logicObject.oX;
				__y += __logicObject.oY;
				
				__logicObject = __logicObject.getParent ();
			}
			
			return new XPoint (__x, __y);
		}
		
		//------------------------------------------------------------------------------------------
		protected function isMouseInRange ():Boolean {
			var __button:XPoint = getWorldCoordinates ();
			
			var __mouse:XPoint = xxx.getXWorldLayer (getLayer ()).globalToLocalXPoint (new XPoint (xxx.mouseX, xxx.mouseY));
			
			var __dx:Number = __mouse.x - __button.x;
			var __dy:Number = __mouse.y - __button.y;
	
//			trace (": XWorldButton (mouseX, mouseY): ", xxx.mouseX, xxx.mouseY, __mouse.x, __mouse.y, __button.x, __button.y);
			
			if (__dx < 0 || __dx > m_width) {
				return false;
			}
			
			if (__dy < 0 || __dy > m_height) {
				return false;
			}
			
			return true;
		}
		
		//------------------------------------------------------------------------------------------
		// create sprites
		//------------------------------------------------------------------------------------------
		public override function createSprites ():void {			
			m_sprite = createXMovieClip (m_buttonClassName);
			x_sprite = addSpriteAt (m_sprite, 0, 0);
			x_sprite.setDepth (getDepth ());
		
			gotoState (XButton.NORMAL_STATE);
			
			m_currState = getNormalState ();
			
			show ();
		}

	//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
