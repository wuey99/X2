//------------------------------------------------------------------------------------------
package X.Task {
	
	import flash.system.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------
// XTask provides a mechanism to control the execution of functions.
// Functions can be queued up in an Array and executed at a later time.
//
// example of use:
//
// var taskList:Array = [
//	__moveUp,
//  __moveDn,
// ];
//
// xxx.getXTaskManager ().addTask (taskList);
//
// function __moveUp ():void;
// function __moveDn ():void;
//
// The execution of the queued functions can be manipulated several ways
// via the use of a rudimentary Scripting system.
//
// DELAYED EXECUTION:
// 	XTask.WAIT, <ticks>
//
// var taskList:Array = [
//  __moveUp,
//  XTask.WAIT, 0x0400,
//  __moveDn,
// ];
//
// LOOPING:
// XTask.LOOP, <count>
//	<function>
// XTask.NEXT
// 
// CALL/RETURN
// 	XTask.CALL, <label>
//  XTask.LABEL, "label"
//  XTASK.RETN
//
// GOTO:
//  XTask.GOTO, <label>
//
// some possible uses/applications of XTask:
// 
// 1) sequencing animation
// 2) synchronizing the execution of code
// 3) efficiently organizing operations that have to be executed in a particular order
//------------------------------------------------------------------------------------------
	public class XTask extends Object {
		private var m_taskList:Array;
		private var m_taskIndex:Number;
		private var m_labels:Object;
		private var m_ticks:int;
		private var m_stack:Array;
		private var m_loop:Array;
		private var m_stackPtr:Number;
		private var m_parent:*;
		private var m_flags:Number;
		private var m_subTask:XTask;
		private var m_time:Number;
		private var m_WAIT1000:Boolean;

		protected var m_manager:XTaskManager;
		
		public static var CALL:Number = 0;
		public static var RETN:Number = 1;
		public static var LOOP:Number = 2;
		public static var NEXT:Number = 3;
		public static var WAIT:Number = 4;
		public static var LABEL:Number = 5;
		public static var GOTO:Number = 6;
		public static var BEQ:Number = 7;
		public static var BNE:Number = 8;
		public static var FLAGS:Number = 9;
		public static var EXEC:Number = 10;
		public static var FUNC:Number = 11;
		public static var WAIT1000:Number = 12; 
		public static var UNTIL:Number = 13;
		
		public static var FLAGS_EQ:Number = 1;
		
		protected var m_XTaskSubManager:XTaskSubManager;
				
//------------------------------------------------------------------------------------------
		public function XTask (__taskList:Array, __findLabelsFlag:Boolean = true) {
			super ();
			
			__reset (__taskList, __findLabelsFlag);
			
			m_parent = null;
			
			m_WAIT1000 = false;
		}
		
//------------------------------------------------------------------------------------------
		private function __reset (__taskList:Array, __findLabelsFlag:Boolean = true):void {
			m_taskList = __taskList;
			m_taskIndex = 0;
			m_labels = new Object ();
			m_stack = new Array (8);
			m_loop = new Array (8);
			m_stackPtr = 0;
			m_ticks = 0x0100 + 0x0080;
			m_flags = ~FLAGS_EQ;
			m_subTask = null;

			m_XTaskSubManager = createXTaskSubManager ();
			
// locate forward referenced labels.  this is usually done by default, but
// __findLabelsFlag can be set to false if it's known ahead of time that
// there aren't any forward referenced labels
			if (__findLabelsFlag) {
				__findLabels ();
			}
		}

//------------------------------------------------------------------------------------------
		public function createXTaskSubManager ():XTaskSubManager {
			return new XTaskSubManager (null);
		}
		
//------------------------------------------------------------------------------------------
		public function getParent ():* {
			return m_parent;
		}
		
//------------------------------------------------------------------------------------------
		public function setParent (__parent:*):void {
			m_parent = __parent;
		}

//------------------------------------------------------------------------------------------
		public function getManager ():XTaskManager {
			return m_manager;
		}
		
//------------------------------------------------------------------------------------------
		public function setManager (__manager:XTaskManager):void {
			m_manager = __manager;
			
			m_XTaskSubManager.setManager (__manager);
		}
		
//------------------------------------------------------------------------------------------
		public function kill ():void {
			removeAllTasks ();
		}	
			
//------------------------------------------------------------------------------------------
// execute the XTask, usually called by the XTaskManager.
//------------------------------------------------------------------------------------------
		public function run ():void {
// done execution?
			if (m_stackPtr < 0) {
				m_manager.removeTask (this);

				kill ();
				
				return;
			}
// suspended?
			m_ticks -= 0x0100;
				
			if (m_ticks > 0x0080) {
				return;
			}
// evaluate instructions
			var __cont:Boolean = true;
		
			while (__cont) {
				__cont = __evalInstructions ();
			}
		}

//------------------------------------------------------------------------------------------
// locate all labels in an XTask
//------------------------------------------------------------------------------------------
	private function __findLabels ():void {
		var i:Number;
		var x:Number;
		
		i = 0;
		
		while (i < m_taskList.length) {
			var value:* = m_taskList[i++];
			
			if (value is Function) {
			}
			else
			{
				x = value as Number;
				
				switch (x) {
					case LABEL:
						var __label:String = m_taskList[i++] as String;	
						
//						trace (": new Label: ", __label);
						
						if (!(__label in m_labels)) {
							m_labels[__label] = i;
						}
						else
						{
							throw (Error ("duplicate label: " + __label));
						}
						
						break;	
						
					case CALL:
						i++;
						
						break;
						
					case RETN:
						break;
						
					case LOOP:
						i++;
						
						break;
						
					case NEXT:
						break;

					case UNTIL:
						i++;
						
						break;
												
					case WAIT:
						i++;
						
						break;
						
					case WAIT1000:
						i++;
						
						break;
						
					case GOTO:
						i++;
						
						break;
						
					case BEQ:
						i++;
						
						break;
						
					case BNE:
						i++;
						
						break;
						
					case FLAGS:
						i++;
						
						break;
						
					case EXEC:
						i++;
						
						break;
						
					case FUNC:
						i++;
						
						break;
				}
			}
		}
	}
	
//------------------------------------------------------------------------------------------		
// evaluate instructions
//------------------------------------------------------------------------------------------	
	private function __evalInstructions ():Boolean {
		
		var value:* = m_taskList[m_taskIndex++];
				
//------------------------------------------------------------------------------------------
		if (value is Function) {
			value ();
			
			return true;
		}
	
//------------------------------------------------------------------------------------------
		switch (value as Number) {
//------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------
	case LABEL:
//------------------------------------------------------------------------------------------
		var __label:String = m_taskList[m_taskIndex++] as String;
							
		if (!(__label in m_labels)) {
			m_labels[__label] = m_taskIndex;
		}
							
		break;
	
//------------------------------------------------------------------------------------------					
	case WAIT:
//------------------------------------------------------------------------------------------
		var __ticks:Number = __evalNumber ();
					
		m_ticks += __ticks;
							
		if (m_ticks > 0x0080) {
			return false;
		}
							
		break;

//------------------------------------------------------------------------------------------
	case WAIT1000:
//------------------------------------------------------------------------------------------
		if (!m_WAIT1000) {
			m_time = m_XTaskSubManager.getManager ().getXApp ().getTime ();
			
			m_ticks += 0x0100;
			m_taskIndex--;
			
			m_WAIT1000 = true;
		}
		else
		{
			var __time:Number = __evalNumber ();
			
			if (m_XTaskSubManager.getManager ().getXApp ().getTime () < m_time + __time) {
				m_ticks += 0x0100;
				m_taskIndex -= 2;
			}
			else
			{
				m_WAIT1000 = false;
				
				return true;
			}		
		}
		
		return false;
				
//------------------------------------------------------------------------------------------					
	case LOOP:
//------------------------------------------------------------------------------------------
		var __loopCount:Number = __evalNumber ();
		
		m_loop[m_stackPtr] = __loopCount;
		m_stack[m_stackPtr++] = m_taskIndex;
		
		break;

//------------------------------------------------------------------------------------------
	case NEXT:
//------------------------------------------------------------------------------------------
//		trace (": ", m_loop[m_stackPtr-1]);
		
		m_loop[m_stackPtr-1]--;
		
		if (m_loop[m_stackPtr-1]) {	
			m_taskIndex = m_stack[m_stackPtr-1];
		}
		else
		{
			m_stackPtr--;
		}
			
		break;

//------------------------------------------------------------------------------------------
	case UNTIL:
//------------------------------------------------------------------------------------------
		var __funcUntil:Function = m_taskList[m_taskIndex++] as Function;
		
		__funcUntil (this);
		
		if (!(m_flags & FLAGS_EQ)) {	
			m_taskIndex = m_stack[m_stackPtr-1];
		}
		else
		{
			m_stackPtr--;
		}
			
		break;
					
//------------------------------------------------------------------------------------------					
	case GOTO:
//------------------------------------------------------------------------------------------
		var __gotoLabel:String = m_taskList[m_taskIndex] as String;

		if (!(__gotoLabel in m_labels)) {
			throw (Error ("goto: unable to find label: " + __gotoLabel));
		}
		
		m_taskIndex = m_labels[__gotoLabel]
							
		break;
	
//------------------------------------------------------------------------------------------					
	case CALL:
//------------------------------------------------------------------------------------------
		var __callLabel:String = m_taskList[m_taskIndex++] as String;
		
		m_stack[m_stackPtr++] = m_taskIndex;

		if (!(__callLabel in m_labels)) {
			throw (Error ("call: unable to find label: " + __callLabel));
		}
		
		m_taskIndex = m_labels[__callLabel];
		
		break;
	
//------------------------------------------------------------------------------------------					
	case RETN:
//------------------------------------------------------------------------------------------					
		m_stackPtr--;
							
		if (m_stackPtr < 0) {
			return false;
		}
		
		m_taskIndex = m_stack[m_stackPtr];
							
		break;

//------------------------------------------------------------------------------------------
	case BEQ:
		var __beqLabel:String = m_taskList[m_taskIndex++] as String;

		if (!(__beqLabel in m_labels)) {
			throw (Error ("goto: unable to find label: " + __beqLabel));
		}
		
		if (m_flags & FLAGS_EQ) {
			m_taskIndex = m_labels[__beqLabel]
		}
								
		break;
		
//------------------------------------------------------------------------------------------
	case BNE:
		var __bneLabel:String = m_taskList[m_taskIndex++] as String;

		if (!(__bneLabel in m_labels)) {
			throw (Error ("goto: unable to find label: " + __bneLabel));
		}
		
		if (!(m_flags & FLAGS_EQ)) {
			m_taskIndex = m_labels[__bneLabel]
		}
								
		break;
						
//------------------------------------------------------------------------------------------
	case FLAGS:
		var __funcFlags:Function = m_taskList[m_taskIndex++] as Function;
		
		__funcFlags (this);
		
		break;

//------------------------------------------------------------------------------------------
	case FUNC:
		var __funcTask:Function = m_taskList[m_taskIndex++] as Function;
		
		__funcTask (this);
		
		break;
		
//------------------------------------------------------------------------------------------
// launch a sub-task and wait for it to finish before proceeding
//------------------------------------------------------------------------------------------
	case EXEC:
		if (m_subTask == null) {
// get new XTask Array run it immediately
			m_subTask = m_manager.addTask ((m_taskList[m_taskIndex] as Array), true);
			m_subTask.setParent (m_parent);
			m_subTask.run ();
			
// return back to the EXEC command and wait
			m_taskIndex--;
		}
		else
		{
// if the sub-task is still active, wait another tick and check again
			if (m_manager.isTask (m_subTask)) {
				m_ticks += 0x0100;
				m_taskIndex--;
				return false;
			}
// move along
			else
			{
				m_subTask = null;
				m_taskIndex++;
			}
		}
		
		break;
						
//------------------------------------------------------------------------------------------
// end switch
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
// end evalInstructions
//------------------------------------------------------------------------------------------
		return true;
	}

//------------------------------------------------------------------------------------------
		public function setFlagsBool (__bool:Boolean):void {
			if (__bool) {
				setFlagsEQ ();
			}
			else
			{
				setFlagsNE ();
			}
		}
		
//------------------------------------------------------------------------------------------
		public function ifTrue (__bool:Boolean):void {
			if (__bool) {
				setFlagsEQ ();
			}
			else
			{
				setFlagsNE ();
			}
		}
		
//------------------------------------------------------------------------------------------
		public function setFlagsEQ ():void {
			m_flags |= FLAGS_EQ;
		}
		
//------------------------------------------------------------------------------------------
		public function setFlagsNE ():void {
			m_flags &= ~FLAGS_EQ;
		}

//------------------------------------------------------------------------------------------
		private function __evalNumber ():Number {
			var x:* = m_taskList[m_taskIndex++];
			
			if (x is Number) {
				return x as Number;
			}

			if (x is XNumber) {
				return XNumber (x).value;
			}
			
			return 0;
		}

//------------------------------------------------------------------------------------------
		public function gotoTask (__taskList:Array, __findLabelsFlag:Boolean = false):void {
			kill ();
			
			__reset (__taskList, __findLabelsFlag);
			
			setManager (m_manager);
		}

//------------------------------------------------------------------------------------------
		public function addTask (
			__taskList:Array,
			__findLabelsFlag:Boolean = true
			):XTask {

			return m_XTaskSubManager.addTask (__taskList, __findLabelsFlag);
		}

//------------------------------------------------------------------------------------------
		public function changeTask (
			__task:XTask,
			__taskList:Array,
			__findLabelsFlag:Boolean = true
			):XTask {
				
			return m_XTaskSubManager.changeTask (__task, __taskList, __findLabelsFlag);
		}

//------------------------------------------------------------------------------------------
		public function isTask (__task:XTask):Boolean {
			return m_XTaskSubManager.isTask (__task);
		}		
		
//------------------------------------------------------------------------------------------
		public function removeTask (__task:XTask):void {
			m_XTaskSubManager.removeTask (__task);	
		}

//------------------------------------------------------------------------------------------
		public function removeAllTasks ():void {
			m_XTaskSubManager.removeAllTasks ();
		}

//------------------------------------------------------------------------------------------
		public function addEmptyTask ():XTask {
			return m_XTaskSubManager.addEmptyTask ();
		}

//------------------------------------------------------------------------------------------
		public function getEmptyTask$ ():Array {
			return m_XTaskSubManager.getEmptyTask$ ();
		}	
			
//------------------------------------------------------------------------------------------
		public function gotoLogic (__logic:Function):void {
			m_XTaskSubManager.gotoLogic (__logic);
		}
				
//------------------------------------------------------------------------------------------
// end class		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
// end package
//------------------------------------------------------------------------------------------
}