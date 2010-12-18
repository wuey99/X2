//------------------------------------------------------------------------------------------
package X {

// Box2D classes
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import X.Debug.XDebug;
	import X.MVC.*;
	import X.Resource.*;
	import X.Signals.*;
	import X.Sound.*;
	import X.Task.*;
	import X.World.*;
	import X.XMap.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.system.*;
	import flash.utils.Timer;
	
//------------------------------------------------------------------------------------------
	public class XApp extends Object {
		private var m_parent:Sprite;
		private var m_XTaskManager:XTaskManager;
		private var m_timer:Timer;
		private var m_inuse_TIMER_FRAME:Number;
		private var m_XDebug:XDebug;
		private var m_projectManager:XProjectManager;
		private var m_XSignalManager:XSignalManager;
		private var m_XSoundManager:XSoundManager;

//------------------------------------------------------------------------------------------
		public function XApp () {
			m_XTaskManager = new XTaskManager ();
			m_XSignalManager = new XSignalManager ();
			m_XSoundManager = new XSoundManager (this);
			
			m_XDebug = new XDebug ();
			m_XDebug.setup (this);
			
			m_timer = new Timer (16, 0);
			m_timer.start ();
			m_timer.addEventListener (TimerEvent.TIMER, updateTimer);
			m_inuse_TIMER_FRAME = 0;
		}

//------------------------------------------------------------------------------------------
		public function setup ():void {
		}

//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function updateTimer (e:Event):void {
			if (m_inuse_TIMER_FRAME) {
				trace (": overflow: TIMER_FRAME: ");
				
				return;
			}
			
			m_inuse_TIMER_FRAME++;
			
			getXTaskManager ().updateTasks ();
			
			m_inuse_TIMER_FRAME--;
		}
		
//------------------------------------------------------------------------------------------
		public function getXTaskManager ():XTaskManager {
			return m_XTaskManager;
		}

//------------------------------------------------------------------------------------------
		public function createXSignal ():XSignal {
			return m_XSignalManager.createXSignal ();
		}
		
//------------------------------------------------------------------------------------------
		public function getXSignalManager ():XSignalManager {
			return m_XSignalManager;
		}

//------------------------------------------------------------------------------------------
		public function getXSoundManager ():XSoundManager {
			return m_XSoundManager;
		}
				
//------------------------------------------------------------------------------------------
		public function setProjectManager (__projectManager:XProjectManager):void {
			m_projectManager = __projectManager;
		}

//------------------------------------------------------------------------------------------
		public function getProjectManager ():XProjectManager {
			return m_projectManager;
		}

//------------------------------------------------------------------------------------------
		public function getResourceManagerByName (__name:String):XSubResourceManager {
			return getProjectManager ().getResourceManagerByName (__name);
		}

//------------------------------------------------------------------------------------------
		public function getClass (__className:String):Class {
			return getProjectManager ().getClassByName (__className);
		}
		
//------------------------------------------------------------------------------------------
		public function getClassByName (__className:String):Class {
			return getProjectManager ().getClassByName (__className);
		}

//------------------------------------------------------------------------------------------
		public function disableDebug ():void {
			m_XDebug.disable (true);
		}
		
//------------------------------------------------------------------------------------------
		public function print (...args):void {
			m_XDebug.print (args);
		}
	
//------------------------------------------------------------------------------------------
		public function getCommonClasses ():Boolean {
			trace (": -------------------------: ");
			trace (": getting common classes: ");
			
			getClass ("XLogicObjectXMap:XLogicObjectXMap");
			getClass ("ErrorImages:undefinedClass");
				
			return (
				getClass ("XLogicObjectXMap:XLogicObjectXMap") == null ||
				getClass ("ErrorImages:undefinedClass") == null
				)
		}

//------------------------------------------------------------------------------------------
// report memory leaks
//------------------------------------------------------------------------------------------
		public function reportMemoryLeaks (m_XApp:XApp, xxx:XWorld):void {
			var i:Number;
			var x:*;

			m_XApp.print ("------------------------------");
			m_XApp.print ("active XSignals xxx");
			
			i = 0;
			
			for (x in xxx.getXSignalManager ().getXSignals ()) {
				m_XApp.print (": signal: " + i + ": " + x + ", parent: " + x.getParent ());
			}
			
			m_XApp.print ("------------------------------");
			m_XApp.print ("active XSignals XApp");
			
			i = 0;
			
			for (x in m_XApp.getXSignalManager ().getXSignals ()) {
				m_XApp.print (": signal: " + i + ": " + x + ", parent: " + x.getParent ());
			}
									
			m_XApp.print ("------------------------------");
			m_XApp.print ("active XLogicObjects");

			i = 0;
				
			for (x in xxx.getXLogicManager ().getXLogicObjects()) {
				m_XApp.print (": XLogicObject: " + i + ": " + x);
					
				i++;
			}
							
			m_XApp.print ("------------------------------");
			m_XApp.print ("active tasks xxx: ");
				
			i = 0;
				
			for (x in xxx.getXTaskManager ().getTasks ()) {
				m_XApp.print (": task: " + i + ": " + x + ", parent: " + x.getParent ());
					
				i++;
			}

			m_XApp.print ("------------------------------");
			m_XApp.print ("active tasks XApp: ");
												
			for (x in m_XApp.getXTaskManager ().getTasks ()) {
				m_XApp.print (": task: " + i + ": " + x + ", parent: " + x.getParent ());
			}
		}
			
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}	