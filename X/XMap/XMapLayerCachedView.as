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
package X.XMap {

	import X.Collections.*;
	import X.Geom.*;
	import X.Task.*;
	import X.Pool.*;
	import X.World.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	
//	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------
	public class XMapLayerCachedView extends XLogicObject {
		private var m_XSubmapToXLogicObject:XDict;
		private var m_XMapView:XMapView;
		private var m_XMapModel:XMapModel;
		private var m_currLayer:Number;
		private var m_delay:Number;
				
//------------------------------------------------------------------------------------------
		public function XMapLayerCachedView () {
			super ();
		}
		
//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			m_XMapView = getArg (args, 0);
			m_XMapModel = getArg (args, 1);
			m_currLayer = getArg (args, 2);

			m_XSubmapToXLogicObject = new XDict ();
			
			m_delay = 1;
		}

//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
		}
		
//------------------------------------------------------------------------------------------
		public override function setupX ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function updateFromXMapModel ():void {
			if (!m_XMapView.areImageClassNamesCached ()) {
				return;
			}
			
			if (m_delay) {
				m_delay--;
				
				return;
			}
			
//------------------------------------------------------------------------------------------		
			var __view:XRect = xxx.getXWorldLayer (m_currLayer).viewPort (
				xxx.getViewRect ().width, xxx.getViewRect ().height
			);

//------------------------------------------------------------------------------------------						
			var __submaps:Array;
						
			__submaps = m_XMapModel.getSubmapsAt (
				m_currLayer,
				__view.left, __view.top,
				__view.right, __view.bottom
				);
			
//------------------------------------------------------------------------------------------
			var __submap:XSubmapModel;
			
			var i:Number;
									
			for (i=0; i<__submaps.length; i++) {
				__submap = __submaps[i] as XSubmapModel;
						
				updateXSubmapModel (__submap);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function updateXSubmapModel (__submap:XSubmapModel):void {
			if (!__submap.inuse) {
				addXSubmap (
					// submap
					__submap,
					// depth
					0
				);
			}
			else
			{
				if (m_XSubmapToXLogicObject.exists (__submap)) {
					var logicObject:XLogicObject = m_XSubmapToXLogicObject.get (__submap);
				}
			}
		}	
		
//------------------------------------------------------------------------------------------
		public function addXSubmap (__submap:XSubmapModel, __depth:Number):void {
//			trace (": addXSubmap: ", __submap.x, __submap.y);
			
			if (CONFIG::starling) {
				var __logicObject:XSubmapViewImageCache =
					xxx.getXLogicManager ().initXLogicObjectFromPool (
						// parent
						m_XMapView,
						// class
						XSubmapViewImageCache,
						// item, layer, depth
						null, m_currLayer, __depth,
						// x, y, z
						__submap.x, __submap.y, 0,
						// scale, rotation
						1.0, 0,
						// XMapView
						m_XMapView
					) as XSubmapViewImageCache;
			}
			else
			{
				var __logicObject:XSubmapViewBitmapCache =
					xxx.getXLogicManager ().initXLogicObjectFromPool (
						// parent
						m_XMapView,
						// class
						XSubmapViewBitmapCache,
						// item, layer, depth
						null, m_currLayer, __depth,
						// x, y, z
						__submap.x, __submap.y, 0,
						// scale, rotation
						1.0, 0,
						// XMapView
						m_XMapView
					) as XSubmapViewBitmapCache;
			}
			
			__submap.inuse++;
			
			m_XMapView.addXLogicObject (__logicObject);
			
			m_XSubmapToXLogicObject.put (__submap, __logicObject);
			
			__logicObject.setModel (__submap);
			
			__logicObject.addKillListener (removeXSubmap);
			
			__logicObject.show ();
		}
		
			
//------------------------------------------------------------------------------------------
		public function removeXSubmap (...args):void {
			var __submap:XSubmapModel = args[0] as XSubmapModel;
			
			if (m_XSubmapToXLogicObject.exists (__submap)) {		
				m_XSubmapToXLogicObject.remove (__submap);
			}
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
