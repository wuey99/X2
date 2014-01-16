//------------------------------------------------------------------------------------------
package X.World.UI {
	
	// X classes
	import X.*;
	import X.Signals.*;
	import X.Task.*;
	import X.World.*;
	import X.World.Collision.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	import X.World.UI.*;
	import X.Geom.*;
	
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	
	//------------------------------------------------------------------------------------------
	public class XWorldButton extends XButton {
		public var m_width:Number;
		public var m_height:Number;
		
		//------------------------------------------------------------------------------------------
		public function XWorldButton () {
		}
		
		//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
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
			if (m_currState == DOWN_STATE) {
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
//					xxx.getParent ().stage.addEventListener (xxx.MOUSE_OVER, onMouseOver);
					xxx.getParent ().stage.addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown);
					xxx.getParent ().stage.addEventListener (MouseEvent.MOUSE_MOVE, onMouseMove);
					xxx.getParent ().stage.addEventListener (MouseEvent.MOUSE_UP, onMouseUp);
					xxx.getParent ().stage.addEventListener (MouseEvent.MOUSE_OUT, onMouseOut);
				},
				
				XTask.RETN,
			]);
		}
		
		//------------------------------------------------------------------------------------------
		private function getWorldCoordinates ():XPoint {
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
	
			trace (": XWorldButton (mouseX, mouseY): ", xxx.mouseX, xxx.mouseY, __mouse.x, __mouse.y, __button.x, __button.y);
			
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
		
			gotoState (NORMAL_STATE);
			
			m_currState = getNormalState ();
			
			show ();
		}

	//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
