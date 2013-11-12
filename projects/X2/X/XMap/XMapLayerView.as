//------------------------------------------------------------------------------------------
package X.XMap {

	import X.Collections.*;
	import X.Geom.*;
	import X.Task.*;
	import X.World.*;
	import X.World.Logic.*;
	import X.World.Sprite.*;
	
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
		private var m_XMapLayerModel:XMapLayerModel;
		private var m_currLayer:Number;
		private var m_logicClassNameToClass:Function;
		
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
			m_logicClassNameToClass = getArg (args, 3);
			
			m_XMapLayerModel = m_XMapModel.getLayer (m_currLayer);
			
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
			if (!m_XMapView.areImageClassNamesCached ()) {
				return;
			}
			
//------------------------------------------------------------------------------------------
			var __view:XRect = xxx.getXWorldLayer (m_currLayer).viewPort (
				xxx.getViewRect ().width, xxx.getViewRect ().height
			);
						
			var __items:Array;
			
			if (m_XMapModel.useArrayItems) {
				__items = m_XMapModel.getArrayItemsAt (
					m_currLayer,
					__view.left, __view.top,
					__view.right, __view.bottom
				);
			}
			else
			{
				__items = m_XMapModel.getItemsAt (
					m_currLayer,
					__view.left, __view.top,
					__view.right, __view.bottom
				);				
			}
			
//------------------------------------------------------------------------------------------
			var __item:XMapItemModel;
			var i:int, __length:int = __items.length;
									
			for (i=0; i<__length; i++) {
				__item = __items[i] as XMapItemModel;
						
				updateXMapItemModel (__item);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function updateXMapItemModel (__item:XMapItemModel):void {
			if (__item.inuse == 0) {
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
					
//					__point.x = __item.x;
//					__point.y = __item.y;
				}
			}
		}	
		
//------------------------------------------------------------------------------------------
		public function addXMapItem (__item:XMapItemModel, __depth:Number):XLogicObject {
			var __logicObject:XLogicObjectCX;
			
			var __object:* = m_logicClassNameToClass (__item.logicClassName);
				
			if (__object is Function) {
				__logicObject = (__object as Function) ();
			}
			else if (__item.logicClassName.charAt (0) == "$") {
				if (__object == null) {
					trace (": (error) logicClassName: ", __item.logicClassName);
					
					__logicObject = null;
				}
				else {
					__logicObject = xxx.getXLogicManager ().initXLogicObjectFromPool (
						// parent
						m_XMapView,
						// class
						__object as Class,
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
					) as XLogicObjectCX;
				}
			}
			else
			{
				if (__item.logicClassName == "XLogicObjectXMap:XLogicObjectXMap") {
					__logicObject = null;
				}
				else
				{
					__logicObject = xxx.getXLogicManager ().createXLogicObjectFromClassName (
						// parent
							m_XMapView,
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
						) as XLogicObjectCX;
				}
			}

			__item.inuse++;

			if (__logicObject == null) {
				return null;
			}
			
			m_XMapView.addXLogicObject (__logicObject);
			
			m_XMapItemToXLogicObject.put (__item, __logicObject);

			__logicObject.setXMapModel (m_currLayer + 1, m_XMapModel, m_XMapView);
			
			__logicObject.addKillListener (removeXMapItem);

			__logicObject.show ();
			
			return __logicObject;
		}

//------------------------------------------------------------------------------------------
		public function getXLogicObject (__item:XMapItemModel):XLogicObject {
			return m_XMapItemToXLogicObject.get (__item);
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
