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
// For commercial use, you will need to provide proper credits.
// Please contact me @ wuey99[dot]gmail[dot]com for more details.
// <$end$/>
//------------------------------------------------------------------------------------------
package X.Sound {
	
	import X.Task.*;
	
	import flash.media.*;
	import flash.system.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------
	public class XSoundTask extends XTask {
		protected var m_XSoundTaskManager:XSoundTaskManager;
		
//------------------------------------------------------------------------------------------
		public function XSoundTask () {
			super ();
		}

//------------------------------------------------------------------------------------------
		public override function setup (__taskList:Array, __findLabelsFlag:Boolean = true):void {
			super.setup (__taskList, __findLabelsFlag);
		}
		
//------------------------------------------------------------------------------------------
		public override function createXTaskSubManager ():XTaskSubManager {
			m_XSoundTaskManager = new XSoundTaskManager (null, null);
			
			return m_XSoundTaskManager;
		}
		
//------------------------------------------------------------------------------------------
		public function setSoundManager (__soundManager:XSoundManager):void {
			m_XSoundTaskManager.setSoundManager (__soundManager);
		}
		
//------------------------------------------------------------------------------------------
		public override function kill ():void {
			m_XSoundTaskManager.removeAllSounds ();
			
			removeAllTasks ();
		}	

//------------------------------------------------------------------------------------------
		public function playSoundFromClass (
			__class:Class,
			__completeListener:Function = null
			):Number {
				
			return m_XSoundTaskManager.playSoundFromClass (__class, __completeListener);
		}
		
//------------------------------------------------------------------------------------------
		public function playSoundFromClassName (
			__className:String,
			__completeListener:Function = null
			):Number {
				
			return m_XSoundTaskManager.playSoundFromClassName (__className, __completeListener);
		}
		
//------------------------------------------------------------------------------------------
		public function stopSound (__guid:Number):void {
			m_XSoundTaskManager.stopSound (__guid);
		}

//------------------------------------------------------------------------------------------
		public function removeSound (__guid:Number):void {
			m_XSoundTaskManager.removeSound (__guid);
		}

//------------------------------------------------------------------------------------------
		public function removeAllSounds ():void {
			m_XSoundTaskManager.removeAllSounds ();
		}
		
//------------------------------------------------------------------------------------------
	}

//------------------------------------------------------------------------------------------
}