//------------------------------------------------------------------------------------------
package X.XMap {

	import X.Collections.*;
	import X.Geom.*;
	import X.Task.*;
	import X.World.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------
// represents the view for all Items in a XMap.
//
// using the layer's viewport, instantiates/spawns XMapItemModels as XLogicObjects
// that fall within the viewport's rect.
//
// the XLogicObject is responsible for culling.  This class monitor's the XLogicObject's
// life-cycle by listening to the XLogicObject's kill signal.  XMapItemModels are returned
// to the Submap on a cull/kill;  However, objects that have been nuked () are permanently
// removed from the XMapModel.
//------------------------------------------------------------------------------------------
	public class XMapLayerView extends XLogicObject {
		private var m_XMapItemToXLogicObject:XDict;
		private var m_XMapView:XMapView;
		private var m_XMapModel:XMapModel;
		private var m_currLayer:Number;
		
//------------------------------------------------------------------------------------------
		public function XMapLayerView () {
			super ();
		}
		
//------------------------------------------------------------------------------------------
		public override function setup (__xxx:XWorld, args:Array):void {
			super.setup (__xxx, args);
			
			m_XMapView = getArg (args, 0);
			m_XMapModel = getArg (args, 1);
			m_currLayer = getArg (args, 2);
			
			m_XMapItemToXLogicObject = new XDict ();
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
			var __view:XRect = xxx.getXWorldLayer (m_currLayer).viewPort (
				xxx.getViewRect ().width, xxx.getViewRect ().height
			);
						
			var __items:Array;
			
			__items = m_XMapModel.getItemsAt (
				m_currLayer,
				__view.left, __view.top,
				__view.right, __view.bottom
			);	
			
//------------------------------------------------------------------------------------------
			var __item:XMapItemModel;
			var i:Number;
									
			for (i=0; i<__items.length; i++) {
				__item = __items[i] as XMapItemModel;
						
				updateXMapItemModel (__item);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function updateXMapItemModel (__item:XMapItemModel):void {
			if (!__item.inuse) {
				addXMapItem (
					// item
					__item,
					// depth
					0
				);
			}
			else
			{
				if (m_XMapItemToXLogicObject.exists (__item)) {
					var logicObject:XLogicObject = m_XMapItemToXLogicObject.get (__item);
					
					var __point:XPoint = logicObject.getPos ();
					
					__point.x = __item.x;
					__point.y = __item.y;
				}
			}
		}	
		
//------------------------------------------------------------------------------------------
		public function addXMapItem (__item:XMapItemModel, __depth:Number):void {	
			var __logicObject:XLogicObject =
			  xxx.getXLogicManager ().createXLogicObjectFromClassName (
				// parent
					null,
				// logicClassName
					__item.logicClassName,
				// item, layer, depth
					__item, m_currLayer, __depth,
				// x, y, z
					__item.x, __item.y, 0,
				// scale, rotation
					__item.scale, __item.rotation,
				// imageClassName
					__item.imageClassName,
				// frame
					__item.frame
				);
			
			__item.inuse++;
				
			m_XMapItemToXLogicObject.put (__item, __logicObject);
			
			__logicObject.addKillListener (removeXMapItem);
			
			__logicObject.show ();
		}
		
			
//------------------------------------------------------------------------------------------
		public function removeXMapItem (...args):void {
			var item:XMapItemModel = args[0] as XMapItemModel;
			
			if (m_XMapItemToXLogicObject.exists (item)) {		
				m_XMapItemToXLogicObject.remove (item);
			}
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
