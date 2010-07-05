//------------------------------------------------------------------------------------------
package X.XMap {

// X classes		
	import X.MVC.*;
	
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------	
	public class XSubmapModel extends XModelBase {
		private var m_XMapLayer:XMapLayerModel;
			
		private var m_items:Dictionary;
		
//------------------------------------------------------------------------------------------	
		public function XSubmapModel (__XMapLayer:XMapLayerModel) {
			m_XMapLayer = __XMapLayer;
			
			m_items = new Dictionary ();
		}	

//------------------------------------------------------------------------------------------
		public function addItem (
			__item:XMapItemModel
			):XMapItemModel {
							
			if (!(__item in m_items)) {
				m_items[__item] = __item.id;
			}
					
			return __item;
		}

//------------------------------------------------------------------------------------------
		public function removeItem (
			__item:XMapItemModel
			):void {
			
			if (__item in m_items) {
				delete m_items[__item];
			}
		}
				
//------------------------------------------------------------------------------------------
		public function items ():Dictionary {
			return m_items;
		}

//------------------------------------------------------------------------------------------
		public function serializeRowCol (__row:Number, __col:Number):XML {	
			var xml:XML =
				<XSubmap
					row={__row}
					col={__col}	
				/>

			var x:*;
			var item:XMapItemModel;
				
			for (x in items ()) {	
				item = x as XMapItemModel;
					
				xml.appendChild (item.serialize ());
			}
			
			return xml;
	}

//------------------------------------------------------------------------------------------
		public function deserializeRowCol (__xml:XML):void {
			var __xmlList:XMLList = __xml.child ("XMapItem");
			
			var i:Number;
			
			for (i=0; i<__xmlList.length (); i++) {
				var __xml:XML = __xmlList[i];
				
				trace (": XMapItem: ", __xml);
				
				var __item:XMapItemModel = new XMapItemModel ();
		
				var __logicClassIndex:Number = __xml.@logicClassIndex;
				var __imageClassIndex:Number = __xml.@imageClassIndex;
				
				trace (": logicClassName: ", m_XMapLayer.getClassNameFromIndex (__logicClassIndex));
				trace (": imageClassName: ", m_XMapLayer.getClassNameFromIndex (__imageClassIndex));
				
				__item.init (
					m_XMapLayer,
// __logicClassName
					m_XMapLayer.getClassNameFromIndex (__logicClassIndex),
// __name, __id
					__xml.@name, __xml.@id,
// __imageClassName, __frame
					m_XMapLayer.getClassNameFromIndex (__imageClassIndex), __xml.@frame,
// __x, __y,
					__xml.@x, __xml.@y,
// __scale, __rotation, __depth
					__xml.@scale, __xml.@rotation, __xml.@depth,
// __collisionRect,
					new Rectangle (__xml.@cx, __xml.@cy, __xml.@cw, __xml.@ch),
// __boundingRect,
					new Rectangle (__xml.@cx, __xml.@cy, __xml.@bw, __xml.@bh),
// __params
					__xml.@params
					);
					
					addItem (__item);
			}
		}
				
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
