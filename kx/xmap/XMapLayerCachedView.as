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
package kx.xmap {

	import kx.collections.*;
	import kx.geom.*;
	import kx.task.*;
	import kx.pool.*;
	import kx.world.*;
	import kx.world.logic.*;
	import kx.world.sprite.*;
	import kx.xmap.*;
	
//	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;

//------------------------------------------------------------------------------------------
	public class XMapLayerCachedView extends XMapLayerView {
//		private var m_XMapView:XMapView;
//		private var m_XMapModel:XMapModel;
//		private var m_currLayer:int;
		
		private var m_XSubmapToXLogicObject:XDict; // <XSubmapModel, XLogicObject>
		private var m_delay:int;
				
//------------------------------------------------------------------------------------------
		public function XMapLayerCachedView () {
			super ();
		}
		
//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array /* <Dynamic> */):void {
			super.setup (__xxx, args);
			
			m_XMapView = getArg (args, 0);
			m_XMapModel = getArg (args, 1);
			m_currLayer = getArg (args, 2);

			m_XSubmapToXLogicObject = new XDict (); // <XSubmapModel, XLogicObject>
			
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
		public override function updateFromXMapModel ():void {		
			var __view:XRect = xxx.getXWorldLayer (m_currLayer).viewPort (
				xxx.getViewRect ().width, xxx.getViewRect ().height
			);

			updateFromXMapModelAtRect (__view);
		}
		
//------------------------------------------------------------------------------------------
		public override function updateFromXMapModelAtRect (__view:XRect):void {
			if (!m_XMapView.areImageClassNamesCached ()) {
				return;
			}
			
			if (m_delay > 0) {
				m_delay--;
				
				return;
			}

//------------------------------------------------------------------------------------------						
			var __submaps:Array; // <XSubmapModel>
			
			__submaps = m_XMapModel.getSubmapsAt (
				m_currLayer,
				__view.left, __view.top,
				__view.right, __view.bottom
			);
			
//------------------------------------------------------------------------------------------
			var __submap:XSubmapModel;
			
			var i:int;
			
			for (i=0; i<__submaps.length; i++) {
				__submap = __submaps[i] as XSubmapModel;
				
				updateXSubmapModel (__submap);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function updateXSubmapModel (__submap:XSubmapModel):void {
			if (__submap.inuse == 0) {
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
			
			// <HAXE>
			/* --
			-- */
			// </HAXE>
			// <AS3>
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
						[
							m_XMapView
						]
					) as XSubmapViewImageCache;
			}
			else
			{
			// </AS3>
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
						[
							// XMapView
							m_XMapView
						]
					) as XSubmapViewBitmapCache;
			// <HAXE>
			/* --
			-- */
			// </HAXE>
			// <AS3>				
			}
			// </AS3>
			
			__submap.inuse++;
			
			m_XMapView.addXLogicObject (__logicObject);
			
			m_XSubmapToXLogicObject.set (__submap, __logicObject);
			
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
