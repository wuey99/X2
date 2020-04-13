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
package kx.task {
	
	import flash.system.*;
	import flash.utils.*;
	
	import kx.*;
	import kx.collections.*;
	import kx.pool.*;
	import kx.type.*;
	
	//------------------------------------------------------------------------------------------
	// XTask provides a mechanism to control the execution of functions.
	// Functions can be queued up in an Array and executed at a later time.
	//
	// example of use:
	//
	// var taskList:Array /* <Dynamic> */= [
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
	// var taskList:Array /* <Dynamic> */ = [
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
		private var m_taskList:Array; // <Dynamic>
		private var m_taskIndex:int;
		private var m_labels:XDict; // <String, Int>
		private var m_ticks:Number;
		private var m_stack:Array; // <Int>
		private var m_loop:Array; // <Int>
		private var m_stackPtr:int;
		private var m_parent:*;
		private var m_flags:int;
		private var m_subTask:XTask;
		private var m_time:Number;
		private var m_WAIT1000:Boolean;
		public var m_isDead:Boolean;
		public var tag:String;
		public var m_id:int;
		public var self:XTask;
		public var m_pool:XObjectPoolManager;
		
		public static var g_id:int = 0;
		
		protected var m_manager:XTaskManager;
		
		public static var g_XApp:XApp;
		public var m_XApp:XApp;
		
// all op-codes
		public static const CALL:int = 0;
		public static const RETN:int = 1;
		public static const LOOP:int = 2;
		public static const NEXT:int = 3;
		public static const WAIT:int = 4;
		public static const LABEL:int = 5;
		public static const GOTO:int = 6;
		public static const BEQ:int = 7;
		public static const BNE:int = 8;
		public static const FLAGS:int = 9;
		public static const EXEC:int = 10;
		public static const FUNC:int = 11;
		public static const WAIT1000:int = 12; 
		public static const UNTIL:int = 13;
		public static const POP:int = 14;
		public static const WAITX:int = 15;
		
		public static const XTask_OPCODES:int = 16;
		
		public const _FLAGS_EQ:int = 1;
		
		protected var m_XTaskSubManager:XTaskSubManager;
		
		//------------------------------------------------------------------------------------------
		public function XTask () {
			super ();	
			
			self = this;
			
			m_XTaskSubManager = createXTaskSubManager ();
			
			m_stack = new Array (); // <Int>
			m_loop = new Array (); // <Int>
			m_labels = new XDict (); // <String, Int>
			
			for (var i:int = 0; i < 8; i++) {
				m_stack.push (0);
				m_loop.push (0);
			}
			
			m_isDead = true;
		}
		
		//------------------------------------------------------------------------------------------
		public function setup (__taskList:Array /* <Dynamic> */, __findLabelsFlag:Boolean = true):void {
			__reset (__taskList, __findLabelsFlag);
			
			m_id = ++g_id;
		}
		
		//------------------------------------------------------------------------------------------
		private function __reset (__taskList:Array /* <Dynamic> */, __findLabelsFlag:Boolean = true):void {
			m_taskList = __taskList;
			m_taskIndex = 0;
			m_labels.removeAllKeys ();
			for (var i:int = 0; i < 8; i++) {
				m_stack[i] = 0;
				m_loop[i] = 0;
			}
			m_stackPtr = 0;
			m_ticks = 0x0100 + 0x0080;
			m_flags = ~_FLAGS_EQ;
			m_subTask = null;
			m_isDead = false;
			m_parent = null;
			m_WAIT1000 = false;
			tag = "";
			
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
		public function setPool (__pool:XObjectPoolManager):void {
			m_pool = __pool;
		}
		
		//------------------------------------------------------------------------------------------
		public function getPool ():XObjectPoolManager {
			return m_pool;
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
		public static function setXApp (__XApp:XApp):void {
			g_XApp = __XApp;
		}
		
		//------------------------------------------------------------------------------------------
		public function getXApp ():XApp {
			return g_XApp;
		}
		
		//------------------------------------------------------------------------------------------
		public function kill ():void {
			removeAllTasks ();
			
			m_isDead = true;
		}	
		
		//------------------------------------------------------------------------------------------
		// execute the XTask, usually called by the XTaskManager.
		//------------------------------------------------------------------------------------------
		public function run ():void {
			function __retn ():Boolean {
				if (m_stackPtr < 0) {
					if (m_parent != null && m_parent != m_manager) {
						m_parent.removeTask (self);
					}
					else
					{
						m_manager.removeTask (self);
					}
					
					return true;
				}		
				else
				{
					return false;
				}
			}
			
			// done execution?
			if (m_isDead) {
				return;
			}

			if (__retn ()) {
				return;
			}
			
			// suspended?
			m_ticks -= 0x0100;
			
			if (m_ticks > 0x0080) {
				return;
			}
			
			// evaluate instructions
			var __cont:Boolean = true;
			
			while (__cont && !m_isDead) {
				__cont = __evalInstructions ();
			}
		}
		
		//------------------------------------------------------------------------------------------
		// locate all labels in an XTask
		//------------------------------------------------------------------------------------------
		private function __findLabels ():void {
			var i:int;
			var x:int;
			
			i = 0;
			
			while (i < m_taskList.length) {
				var value:* = m_taskList[i++];
				
				if (XType.isFunction (value)) {
				}
				else
				{
					x = value as int;
					
					switch (x) {
						case LABEL:
							var __label:String = m_taskList[i++] as String;	
							
//							trace (": new Label: ", __label);
							
							if (!(m_labels.exists (__label))) {
								m_labels.set (__label, i);
							}
							else
							{
								throw (XType.createError ("duplicate label: " + __label));
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
						
						case POP:
							i++;
							
							break;
						
						case WAITX:
							i++;
							
							break;
						
						default:
							i = findMoreLabels (i);
							
							break;
					}
				}
			}
		}

		//------------------------------------------------------------------------------------------
		// sub-classes of XTask override this to implement more op-codes
		//
		// find more labels 
		//------------------------------------------------------------------------------------------
		public function findMoreLabels (i:int):int {
			return i;
		}
		
		//------------------------------------------------------------------------------------------		
		// evaluate instructions
		//------------------------------------------------------------------------------------------	
		private function __evalInstructions ():Boolean {
			
			var value:* = m_taskList[m_taskIndex++];
			
			//------------------------------------------------------------------------------------------
			if (XType.isFunction (value)) {
				value ();
				
				return true;
			}
			
			//------------------------------------------------------------------------------------------
			switch (/* @:safe_cast */ value as int) {
				//------------------------------------------------------------------------------------------
				
				//------------------------------------------------------------------------------------------
				case LABEL:
				//------------------------------------------------------------------------------------------
					var __label:String = m_taskList[m_taskIndex++] as String;
					
					if (!(m_labels.exists (__label))) {
						m_labels.set (__label, m_taskIndex);
					}
					
					break;
				
				//------------------------------------------------------------------------------------------					
				case WAIT:
				//------------------------------------------------------------------------------------------
					var __ticks:Number = __evalNumber () * getXApp ().getFrameRateScale ();
					
					m_ticks += __ticks;
					
					if (m_ticks > 0x0080) {
						return false;
					}
					
					break;
				
				//------------------------------------------------------------------------------------------					
				case WAITX:
				//------------------------------------------------------------------------------------------
					var __ticksX:Number = __evalNumber ();
					
					m_ticks += __ticksX;
					
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
					var __loopCount:int = int (__evalNumber ());
					
					m_loop[m_stackPtr] = __loopCount;
					m_stack[m_stackPtr++] = m_taskIndex;
					
					break;
				
				//------------------------------------------------------------------------------------------
				case NEXT:
				//------------------------------------------------------------------------------------------
					//		trace (": ", m_loop[m_stackPtr-1]);
					
					m_loop[m_stackPtr-1]--;
					
					if (m_loop[m_stackPtr-1] > 0) {	
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
					var __funcUntil:Function =
						/* @:cast */ m_taskList[m_taskIndex++] as Function;
					
					__funcUntil (self);
					
					if ((m_flags & _FLAGS_EQ) == 0) {	
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
					
					if (!(m_labels.exists (__gotoLabel))) {
						throw (XType.createError ("goto: unable to find label: " + __gotoLabel));
					}
					
					m_taskIndex = m_labels.get(__gotoLabel);
					
					break;
				
				//------------------------------------------------------------------------------------------					
				case CALL:
				//------------------------------------------------------------------------------------------
					var __callLabel:String = m_taskList[m_taskIndex++] as String;
					
					m_stack[m_stackPtr++] = m_taskIndex;
					
					if (!(m_labels.exists(__callLabel))) {
						throw (XType.createError ("call: unable to find label: " + __callLabel));
					}
					
					m_taskIndex = m_labels.get(__callLabel);
					
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
				case POP:
				//------------------------------------------------------------------------------------------					
					m_stackPtr--;

					break;
				
				//------------------------------------------------------------------------------------------
				case BEQ:
				//------------------------------------------------------------------------------------------	
					var __beqLabel:String = m_taskList[m_taskIndex++] as String;
					
					if (!(m_labels.exists (__beqLabel))) {
						throw (XType.createError ("goto: unable to find label: " + __beqLabel));
					}
					
					if ((m_flags & _FLAGS_EQ) != 0) {
						m_taskIndex = m_labels.get(__beqLabel);
					}
					
					break;
				
				//------------------------------------------------------------------------------------------
				case BNE:
				//------------------------------------------------------------------------------------------
					var __bneLabel:String = m_taskList[m_taskIndex++] as String;
					
					if (!(m_labels.exists (__bneLabel))) {
						throw (XType.createError ("goto: unable to find label: " + __bneLabel));
					}
					
					if ((m_flags & _FLAGS_EQ) == 0) {
						m_taskIndex = m_labels.get (__bneLabel);
					}
					
					break;
				
				//------------------------------------------------------------------------------------------
				case FLAGS:
				//------------------------------------------------------------------------------------------
					var __funcFlags:Function = 
						/* @:cast */ m_taskList[m_taskIndex++] as Function;
					
					__funcFlags (self);
					
					break;
				
				//------------------------------------------------------------------------------------------
				case FUNC:
				//------------------------------------------------------------------------------------------
					var __funcTask:Function =
						/* @:cast */ m_taskList[m_taskIndex++] as Function;
					
					__funcTask (self);
					
					break;
				
				//------------------------------------------------------------------------------------------
				// launch a sub-task and wait for it to finish before proceeding
				//------------------------------------------------------------------------------------------
				case EXEC:
					if (m_subTask == null) {
						// get new XTask Array run it immediately
						m_subTask = m_XTaskSubManager.addTask ((/* @:safe_cast */ m_taskList[m_taskIndex] as Array /* <Dynamic> */), true);
						m_subTask.tag = tag;
						m_subTask.setManager (m_manager);
						m_subTask.setParent (self);
						m_subTask.run ();
						m_taskIndex--;
					}

					// if the sub-task is still active, wait another tick and check again
					else if (m_XTaskSubManager.isTask (m_subTask)) {
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
					
					break;
				
				//------------------------------------------------------------------------------------------
				// more op-codes
				//------------------------------------------------------------------------------------------
				default:
					if (!evalMoreInstructions (/* @:safe_cast */ value as int)) {
						return false;
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
		// sub-classes of XTask override this to implement more op-codes
		//
		// evaluate more op-codes	
		//------------------------------------------------------------------------------------------
		public function evalMoreInstructions (value:int):Boolean {
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
			m_flags |= _FLAGS_EQ;
		}
		
		//------------------------------------------------------------------------------------------
		public function setFlagsNE ():void {
			m_flags &= ~_FLAGS_EQ;
		}
		
		//------------------------------------------------------------------------------------------
		private function __evalNumber ():Number {
			var value:* = m_taskList[m_taskIndex++];
			
			if (value is Number) {
				return /* @:cast */ value as Number;
			}
			
			if (value is XNumber) {
				var __number:XNumber = value as XNumber;
				
				return __number.value;
			}
			
			return 0;
		}
		
		//------------------------------------------------------------------------------------------
		public function gotoTask (__taskList:Array /* <Dynamic> */, __findLabelsFlag:Boolean = false):void {
			kill ();
			
			__reset (__taskList, __findLabelsFlag);
			
			setManager (m_manager);
		}
		
		//------------------------------------------------------------------------------------------
		public function addTask (
			__taskList:Array /* <Dynamic> */,
			__findLabelsFlag:Boolean = true
		):XTask {
			
			return m_XTaskSubManager.addTask (__taskList, __findLabelsFlag);
		}
		
		//------------------------------------------------------------------------------------------
		public function changeTask (
			__task:XTask,
			__taskList:Array /* <Dynamic> */,
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
		public function getEmptyTaskX ():Array /* <Dynamic> */ {
			return m_XTaskSubManager.getEmptyTaskX ();
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