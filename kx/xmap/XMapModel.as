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

// X classes	
	import flash.events.*;
	
	import kx.XApp;
	import kx.geom.*;
	import kx.mvc.*;
	import kx.pool.*;
	import kx.xml.*;
				
//------------------------------------------------------------------------------------------
// XMapModel:
//      consists of 1-n layers (XMapLayerModel).  Each layer is sub-divided
//		into a grid of submaps (XSubmapModel) submapCols wide and submapRows high.
//		each submap is submapWidth pixels wide and submapHeight pixels high.
//------------------------------------------------------------------------------------------
	public class XMapModel extends XModelBase {
		private var m_numLayers:int;
		private var m_layers:Array; // <XMapLayerModel>
		private var m_allClassNames:Array; // <String>
		private var m_currLayer:int;
		private var m_useArrayItems:Boolean;
		private var m_XSubXMapItemModelPoolManager:XSubObjectPoolManager;
		private var m_XSubXRectPoolManager:XSubObjectPoolManager;
		private var m_XApp:XApp;
		public static var g_XApp:XApp;
		
//------------------------------------------------------------------------------------------	
		public function XMapModel () {
			super ();
			
			m_allClassNames = new Array (); // <String>
			m_useArrayItems = false;
			
			m_XApp = g_XApp;
		}	

//------------------------------------------------------------------------------------------
		public function setup (
			__layers:Array /* <XMapLayerModel> */ = null,
			__useArrayItems:Boolean = false
			):void {
				
			if (__layers == null) {
				return;
			}
			
			m_numLayers = __layers.length;	
			m_layers = new Array (); // <XMapLayerModel>
			for (var i:int = 0; i< m_numLayers; i++) {
				m_layers.push (null);
			}
			m_currLayer = 0;
			m_useArrayItems = __useArrayItems;
			m_XSubXMapItemModelPoolManager = new XSubObjectPoolManager (m_XApp.getXMapItemModelPoolManager ());
			m_XSubXRectPoolManager = new XSubObjectPoolManager (m_XApp.getXRectPoolManager ());
			
			var i:int;
			
			for (i=0; i<m_numLayers; i++) {
				m_layers[i] = __layers[i];
				m_layers[i].setParent (this);
			}
		}				

//------------------------------------------------------------------------------------------
		public function cleanup ():void {
			var i:int;
			
			for (i=0; i<m_numLayers; i++) {
				m_layers[i].cleanup ();
				
				m_layers[i] = null;
			}
			
			m_XSubXMapItemModelPoolManager.returnAllObjects ();
			m_XSubXRectPoolManager.returnAllObjects ();
		}
		
//------------------------------------------------------------------------------------------
		public static function setXApp (__XApp:XApp):void {
			g_XApp = __XApp;
		}

//------------------------------------------------------------------------------------------
		public function getXMapItemModelPoolManager ():XSubObjectPoolManager {
			return m_XSubXMapItemModelPoolManager;
		}
		
//------------------------------------------------------------------------------------------
		public function getXRectPoolManager ():XSubObjectPoolManager {
			return m_XSubXRectPoolManager;
		}
		
//------------------------------------------------------------------------------------------
		/* @:get, set useArrayItems Bool */
		
		public function get useArrayItems ():Boolean {
			return m_useArrayItems;
		}
		
		public function set useArrayItems (__val:Boolean): /* @:set_type */ void {
			/* @:set_return true; */			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		public function getNumLayers ():int {
			return m_numLayers;
		}
		
//------------------------------------------------------------------------------------------
		public function setCurrLayer (__layer:int):void {
			m_currLayer = __layer;
		}
		
//------------------------------------------------------------------------------------------
		public function getCurrLayer ():int {
			return m_currLayer;
		}
		
//------------------------------------------------------------------------------------------
		public function getAllClassNames ():Array /* <String> */ {
			var i:int, j:int;
			
			if (m_allClassNames.length == 0) {
				for (i=0; i<m_numLayers; i++) {
					var __classNames:Array /* <String> */ = m_layers[i].getAllClassNames ();
				
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
		public function getLayers ():Array /* <XMapLayerModel> */ {
			return m_layers;
		}	
				
//------------------------------------------------------------------------------------------
		public function getLayer (__layer:int):XMapLayerModel {
			return m_layers[__layer];
		}		
		
//------------------------------------------------------------------------------------------
		public function addItem (__layer:int, __item:XMapItemModel):void {
			m_layers[__layer].addItem (__item);
		}

//------------------------------------------------------------------------------------------
		public function replaceItems (__layer:int, __item:XMapItemModel):Array /* <XMapItemModel> */ {
			return m_layers[__layer].replaceItems (__item);
		}
		
//------------------------------------------------------------------------------------------
		public function removeItem (__layer:int, __item:XMapItemModel):void {
			m_layers[__layer].removeItem (__item);
		}
		
//------------------------------------------------------------------------------------------
		public function addItemAsTile (__layer:int, __item:XMapItemModel):void {
			m_layers[__layer].addItemAsTile (__item);
		}
		
//------------------------------------------------------------------------------------------
		public function getSubmapsAt (
			__layer:int,
			__x1:Number, __y1:Number,
			__x2:Number, __y2:Number
			):Array /* <XSubmapModel> */ {
				
			return m_layers[__layer].getSubmapsAt (__x1, __y1, __x2, __y2);
		}

//------------------------------------------------------------------------------------------
		public function getItemsAt (
			__layer:int,
			__x1:Number, __y1:Number,
			__x2:Number, __y2:Number
			):Array /* <XMapItemModel> */ {
				
			return m_layers[__layer].getItemsAt (__x1, __y1, __x2, __y2);
		}

//------------------------------------------------------------------------------------------
		public function getArrayItemsAt (
			__layer:int,
			__x1:Number, __y1:Number,
			__x2:Number, __y2:Number
		):Array /* <XMapItemModel> */ {
			
			return m_layers[__layer].getArrayItemsAt (__x1, __y1, __x2, __y2);
		}
		
//------------------------------------------------------------------------------------------
		public function getItemsAtCX (
			__layer:int,
			__x1:Number, __y1:Number,
			__x2:Number, __y2:Number
			):Array /* <XMapItemModel> */ {
				
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
	
			var i:int;
			
			for (i=0; i<m_numLayers; i++) {
				m_layers[i].serialize (xml);
			}
			
			return xml;
		}

//------------------------------------------------------------------------------------------
		private function deserialize (__xml:XSimpleXMLNode, __readOnly:Boolean=false, __useArrayItems:Boolean=false):void {
			trace (": [XMap] deserialize: ");
			
			var i:int;
			
			var __xmlList:Array /* <XSimpleXMLNode> */ = __xml.child ("XLayers")[0].child ("XLayer");
			
			m_numLayers = __xmlList.length;
			m_layers = new Array (); // <XMapLayerModel>
			for (i = 0; i< m_numLayers; i++) {
				m_layers.push (null);
			}
			m_useArrayItems = __useArrayItems;
			m_XSubXMapItemModelPoolManager = new XSubObjectPoolManager (m_XApp.getXMapItemModelPoolManager ());
			m_XSubXRectPoolManager = new XSubObjectPoolManager (m_XApp.getXRectPoolManager ());
				
			for (i=0; i<__xmlList.length; i++) {
				m_layers[i] = createXMapLayerModel ();
				m_layers[i].setParent (this);
				m_layers[i].deserialize (__xmlList[i], __readOnly);
			}
		}
		
		
//------------------------------------------------------------------------------------------
		public function createXMapLayerModel ():XMapLayerModel {
			return new XMapLayerModel ();	
		}
		
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
