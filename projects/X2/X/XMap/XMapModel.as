//------------------------------------------------------------------------------------------
// Copyright (C) 2014 Jimmy Huey
//
// Some Rights Reserved.
//
// The "X-Engine" is licensed under a Creative Commons
// Attribution-Share Alike 3.0 United States License.
// (CC BY-SA 3.0)
//
// You are free to:
//
//      SHARE - to copy, distribute, display and perform the work.
//      ADAPT - remix, transform build upon this material, even for commercial works.
//
//      The licensor cannot revoke these freedoms as long as you follow the license terms.
//
// Under the following terms:
//
//      ATTRIBUTION — 
//      You must give appropriate credit, provide a link to the license, and
//      indicate if changes were made.  You may do so in any reasonable manner,
//      but not in any way that suggests the licensor endorses you or your use.
//
//      SHARE-ALIKE -
//      If you remix, transform, or build upon the material, you must
//      distribute your contributions under the same license as the original.
//
// No additional restrictions — You may not apply legal terms or technological measures
// that legally restrict others from doing anything the license permits. 
//
// The full summary can be located at:
// http://creativecommons.org/licenses/by-sa/3.0/us/ 
//
// The human-readable summary of the Legal Code can be located at:
// http://creativecommons.org/licenses/by-sa/3.0/us/legalcode
//------------------------------------------------------------------------------------------
package X.XMap {

// X classes	
	import X.Geom.*;
	import X.MVC.*;
	import X.XApp;
	import X.XML.*;
	
	import flash.events.*;
				
//------------------------------------------------------------------------------------------
// XMapModel:
//      consists of 1-n layers (XMapLayerModel).  Each layer is sub-divided
//		into a grid of submaps (XSubmapModel) submapCols wide and submapRows high.
//		each submap is submapWidth pixels wide and submapHeight pixels high.
//------------------------------------------------------------------------------------------
	public class XMapModel extends XModelBase {
		private var m_numLayers:Number;
		private var m_layers:Array;
		private var m_allClassNames:Array;
		private var m_currLayer:Number;
		private var m_useArrayItems:Boolean;
		
//------------------------------------------------------------------------------------------	
		public function XMapModel () {
			super ();
			
			m_allClassNames = new Array ();
			m_useArrayItems = false;
		}	

//------------------------------------------------------------------------------------------
		public function setup (
			__layers:Array = null,
			__useArrayItems:Boolean = false
			):void {
				
			if (!__layers) {
				return;
			}
			
			m_numLayers = __layers.length;	
			m_layers = new Array (m_numLayers);
			m_currLayer = 0;
			m_useArrayItems = __useArrayItems;
			
			var i:Number;
			
			for (i=0; i<m_numLayers; i++) {
				m_layers[i] = __layers[i]
			}
		}				

//------------------------------------------------------------------------------------------
		public function cleanup ():void {
			var i:Number;
			
			for (i=0; i<m_numLayers; i++) {
				m_layers[i].cleanup ();
			}
		}

//------------------------------------------------------------------------------------------
		public function get useArrayItems ():Boolean {
			return m_useArrayItems;
		}
		
//------------------------------------------------------------------------------------------
		public function getNumLayers ():Number {
			return m_numLayers;
		}
		
//------------------------------------------------------------------------------------------
		public function setCurrLayer (__layer:Number):void {
			m_currLayer = __layer;
		}
		
//------------------------------------------------------------------------------------------
		public function getCurrLayer ():Number {
			return m_currLayer;
		}
		
//------------------------------------------------------------------------------------------
		public function getAllClassNames ():Array {
			var i:Number, j:Number;
			
			if (m_allClassNames.length == 0) {
				for (i=0; i<m_numLayers; i++) {
					var __classNames:Array = m_layers[i].getAllClassNames ();
				
					for (j=0; j<__classNames.length; j++) {
						if (__classNames[j] != null && m_allClassNames.indexOf (__classNames[j]) == -1) {
							m_allClassNames.push (__classNames[j]);
						}
					}
				}
			}
			
			return m_allClassNames;
		}

//------------------------------------------------------------------------------------------
		public function getLayers ():Array {
			return m_layers;
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
		public function replaceItems (__layer:Number, __item:XMapItemModel):Array {
			return m_layers[__layer].replaceItems (__item);
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
		public function getArrayItemsAt (
			__layer:Number,
			__x1:Number, __y1:Number,
			__x2:Number, __y2:Number
		):Array {
			
			return m_layers[__layer].getArrayItemsAt (__x1, __y1, __x2, __y2);
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
		public override function serializeAll ():XSimpleXMLNode {
			return serialize ();
		}
		
//------------------------------------------------------------------------------------------
		public override function deserializeAll (__xml:XSimpleXMLNode):void {
			trace (": [XMap] deserializeAll: ");
			
			deserialize (__xml, false);
		}
		
//------------------------------------------------------------------------------------------
		public function deserializeAllNormal (__xml:XSimpleXMLNode, __useArrayItems:Boolean=false):void {
			trace (": [XMap] deserializeAll: ");
			
			deserialize (__xml, false, __useArrayItems);
		}
		
//------------------------------------------------------------------------------------------
		public function deserializeAllReadOnly (__xml:XSimpleXMLNode, __useArrayItems:Boolean=false):void {
			trace (": [XMap] deserializeAll: ");
			
			deserialize (__xml, true, __useArrayItems);
		}
		
//------------------------------------------------------------------------------------------
		public function serialize ():XSimpleXMLNode {
			var xml:XSimpleXMLNode = new XSimpleXMLNode ();
			
			xml.setupWithParams ("XMap", "", []);
			
			xml.addChildWithXMLNode (serializeLayers ());
							
			return xml;
		}

//------------------------------------------------------------------------------------------	
		private function serializeLayers ():XSimpleXMLNode {
			var xml:XSimpleXMLNode = new XSimpleXMLNode ();
			
			xml.setupWithParams ("XLayers", "", []);
	
			var i:Number;
			
			for (i=0; i<m_numLayers; i++) {
				m_layers[i].serialize (xml);
			}
			
			return xml;
		}

//------------------------------------------------------------------------------------------
		private function deserialize (__xml:XSimpleXMLNode, __readonly:Boolean=false, __useArrayItems:Boolean=false):void {
			trace (": [XMap] deserialize: ");
			
			var __xmlList:Array = __xml.child ("XLayers")[0].child ("XLayer");
			
			m_numLayers = __xmlList.length;
			m_layers = new Array (m_numLayers);
			m_useArrayItems = __useArrayItems;
			
			var i:Number;
			
			for (i=0; i<__xmlList.length; i++) {
				m_layers[i] = new XMapLayerModel ();
				m_layers[i].setParent (this);
				m_layers[i].deserialize (__xmlList[i], __readonly);
			}
		}
		
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
