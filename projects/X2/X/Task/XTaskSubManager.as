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
package X.Task {

	import X.*;
	import X.Collections.*;
	import X.World.Logic.*;
	
//------------------------------------------------------------------------------------------	
	public class XTaskSubManager extends Object {
		public var m_manager:XTaskManager;
		
		private var m_XTasks:XDict;
		
//------------------------------------------------------------------------------------------
		public function XTaskSubManager (__manager:XTaskManager) {
			super ();
			
			m_manager = __manager;
			
			m_XTasks = new XDict ();
		}

//------------------------------------------------------------------------------------------
		public function setup ():void {
		}	
		
//------------------------------------------------------------------------------------------
		public function cleanup ():void {
			removeAllTasks ();
		}

//------------------------------------------------------------------------------------------
		public function getManager ():XTaskManager {
			return m_manager;
		}
				
//------------------------------------------------------------------------------------------
		public function setManager (__manager:XTaskManager):void {
			m_manager = __manager;
		}
		
//------------------------------------------------------------------------------------------
		public function addTask (
			__taskList:Array,
			__findLabelsFlag:Boolean = true
			):XTask {
				
			var __task:XTask = m_manager.addTask (__taskList, __findLabelsFlag);
			
			if (!(m_XTasks.exists (__task))) {
				m_XTasks.put (__task, 0);
			}
			
			return __task;
		}
		
//------------------------------------------------------------------------------------------
		public function addXTask (__task:XTask):XTask {
			var __task:XTask = m_manager.addXTask (__task);
			
			if (!m_XTasks.exists (__task)) {
				m_XTasks.put(__task, 0);
			}
			
			return __task;			
		}
		
//------------------------------------------------------------------------------------------
		public function changeTask (
			__oldTask:XTask,
			__taskList:Array,
			__findLabelsFlag:Boolean = true
			):XTask {
				
			if (!(__oldTask == null)) {
				removeTask (__oldTask);
			}
					
			return addTask (__taskList, __findLabelsFlag);
		}

//------------------------------------------------------------------------------------------
		public function changeXTask (
			__oldTask:XTask,
			__newTask:XTask
			):XTask {
				
			if (!(__oldTask == null)) {
				removeTask (__oldTask);
			}
					
			return addXTask (__newTask);
		}
		
//------------------------------------------------------------------------------------------
		public function isTask (__task:XTask):Boolean {
			return m_XTasks.exists (__task);
		}		

//------------------------------------------------------------------------------------------
		public function removeTask (__task:XTask):void {	
			if (m_XTasks.exists (__task)) {
				m_XTasks.remove (__task);
					
				m_manager.removeTask (__task);
			}
		}

//------------------------------------------------------------------------------------------
		public function removeAllTasks ():void {	
			m_XTasks.forEach (
				function (x:*):void {
					removeTask (x as XTask);
				}
			);
		}

//------------------------------------------------------------------------------------------
		public function addEmptyTask ():XTask {
			return addTask (getEmptyTask$ ());
		}

//------------------------------------------------------------------------------------------
		public function getEmptyTask$ ():Array {
			return [
				XTask.LABEL, "loop",
					XTask.WAIT, 0x0100,
				
					XTask.GOTO, "loop",
				
				XTask.RETN,
			];
		}	
			
//------------------------------------------------------------------------------------------
		public function gotoLogic (__logic:Function):void {
			removeAllTasks ();
			
			__logic ();
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
