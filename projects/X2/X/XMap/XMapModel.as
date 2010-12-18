//------------------------------------------------------------------------------------------
package X.XMap {

// X classes	
	import X.MVC.*;
	
	import flash.events.*;
	import flash.geom.Rectangle;
				
//------------------------------------------------------------------------------------------
// XMapModel:
//      consists of 1-n layers (XMapLayerModel).  Each layer is sub-divided
//		into a grid of submaps (XSubmapModel) submapCols wide and submapRows high.
//		each submap is submapWidth pixels wide and submapHeight pixels high.
//------------------------------------------------------------------------------------------
	public class XMapModel extends XModelBase {
				
		private var m_numLayers:Number;
		private var m_layers:Array;
		protected var m_viewRect:Rectangle;
		private var m_allClassNames:Array;
		
//------------------------------------------------------------------------------------------	
		public function XMapModel () {
			m_allClassNames = new Array ();
		}	

//------------------------------------------------------------------------------------------
		public function setup (
			__layers:Array
			):void {
			
			m_numLayers = __layers.length;	
			m_layers = new Array (m_numLayers);
			
			var i:Number;
			
			for (i=0; i<m_numLayers; i++) {
				m_layers[i] = __layers[i]
			}
		}				

//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function getAllClassNames ():Array {
			var i:Number, j:Number;
			
			if (m_allClassNames.length == 0) {
				for (i=0; i<m_numLayers; i++) {
					var __classNames:Array = m_layers[i].getAllClassNames ();
				
					for (j=0; j<__classNames.length; j++) {
						m_allClassNames.push (__classNames[j]);
					}
				}
			}
			
			return m_allClassNames;
		}
		
//------------------------------------------------------------------------------------------
		public function getLayer (__layer:Number):XMapLayerModel {
			return m_layers[__layer];
		}		
		
//------------------------------------------------------------------------------------------
		public function addItem (__layer:Number, __item:XMapItemModel):void {
			m_layers[__layer].addItem (__item);
		}

//------------------------------------------------------------------------------------------
		public function removeItem (__layer:Number, __item:XMapItemModel):void {
			m_layers[__layer].removeItem (__item);
		}
		
//------------------------------------------------------------------------------------------
		public function getSubmapsAt (
			__layer:Number,
			__x1:Number, __y1:Number,
			__x2:Number, __y2:Number
			):Array {
				
			return m_layers[__layer].getSubmapsAt (__x1, __y1, __x2, __y2);
		}

//------------------------------------------------------------------------------------------
		public function getItemsAt (
			__layer:Number,
			__x1:Number, __y1:Number,
			__x2:Number, __y2:Number
			):Array {
				
			return m_layers[__layer].getItemsAt (__x1, __y1, __x2, __y2);
		}

//------------------------------------------------------------------------------------------
		public function getItemsAtCX (
			__layer:Number,
			__x1:Number, __y1:Number,
			__x2:Number, __y2:Number
			):Array {
				
			return m_layers[__layer].getItemsAtCX (__x1, __y1, __x2, __y2);
		}

//------------------------------------------------------------------------------------------
		public function setViewRect (
			__left:Number, __top:Number,
			__width:Number, __height:Number
			):void {
				
			m_viewRect = new Rectangle (__left, __top, __width, __height);
		}

//------------------------------------------------------------------------------------------	
		public function getViewRect ():Rectangle {
			return m_viewRect
		}

//------------------------------------------------------------------------------------------
		public override function serializeAll ():XML {
			return serialize ();
		}
		
//------------------------------------------------------------------------------------------
		public override function deserializeAll (__xml:XML):void {
			trace (": [XMap] deserializeAll: ");
			
			deserialize (__xml);
		}
		
//------------------------------------------------------------------------------------------
		public function serialize ():XML {
			var xml:XML =
				<XMap
				>
					{serializeLayers ()}
				</XMap>
							
			return xml;
		}

//------------------------------------------------------------------------------------------	
		private function serializeLayers ():XML {
			var xml:XML =
				<XLayers/>
				
			var i:Number;
			
			for (i=0; i<m_numLayers; i++) {
				xml.appendChild (m_layers[i].serialize ());
			}
			
			return xml;
		}

//------------------------------------------------------------------------------------------
		private function deserialize (__xml:XML):void {
			trace (": [XMap] deserialize: ");
			
			var __xmlList:XMLList = __xml.XLayers.child ("XLayer");
			
			m_numLayers = __xmlList.length ();
			m_layers = new Array (m_numLayers);
			
			var i:Number;
			
			for (i=0; i<__xmlList.length (); i++) {
				m_layers[i] = new XMapLayerModel ();
				
				m_layers[i].deserialize (__xmlList[i]);
			}
		}
		
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
