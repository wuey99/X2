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
	
	import kx.collections.*;
	import kx.geom.*;
	import kx.mvc.*;
	import kx.pool.XSubObjectPoolManager;
	import kx.type.*;
	import kx.utils.XReferenceNameToIndex;
	import kx.xml.*;

//------------------------------------------------------------------------------------------	
	public class XSubmapModel extends XModelBase {
		private var m_XMapLayer:XMapLayerModel;
			
		private var m_submapWidth:int;
		private var m_cols:int;
		
		private var m_submapHeight:int;
		private var m_rows:int;
		
		private var m_col:int;
		private var m_row:int;
		
		private var m_cmap:Vector.<int>;
		private var m_inuse:int;
		
		private var m_tileCols:int;
		private var m_tileRows:int;
		
		private var m_submapWidthMask:int;
		private var m_submapHeightMask:int;
		
		private var m_tmap:Vector.<Array>;
		
		private var m_boundingRect:XRect;
		
		private var m_src:XRect;
		private var m_dst:XRect;

		private var m_items:XDict; // <XMapItemModel, Int>
		private var m_arrayItems:Vector.<XMapItemModel>;
		private var m_arrayItemIndex:int;
		
		private var m_XMapItemModelPoolManager:XSubObjectPoolManager;
		private var m_XRectPoolManager:XSubObjectPoolManager;
		
		include "..\\World\\Collision\\cx.h";
		
		private static var CXToChar:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
		
//------------------------------------------------------------------------------------------	
		public function XSubmapModel (
			__XMapLayer:XMapLayerModel,
			__col:int, __row:int,
			__width:int, __height:int
			) {
				
			super ();
			
			var i:int;
			
			m_XMapLayer = __XMapLayer;
				
			m_submapWidth = __width;
			m_submapHeight = __height;
		
			m_submapWidthMask = m_submapWidth - 1;
			m_submapHeightMask = m_submapHeight - 1;
			
			m_col = __col;
			m_row = __row;
		
			m_cols = int (m_submapWidth/CX_TILE_WIDTH);
			m_rows = int (m_submapHeight/CX_TILE_HEIGHT);

			m_boundingRect = new XRect (0, 0, m_submapWidth, m_submapHeight);
			
			m_cmap = new Vector.<int> ();
			for (i = 0; i < m_cols * m_rows; i++) {
				m_cmap.push (0);
			}
			
			for (i = 0; i < m_cmap.length; i++) {
				m_cmap[i] = CX_EMPTY;
			}
		
			m_tileCols = int (m_submapWidth/TX_TILE_WIDTH);
			m_tileRows = int (m_submapHeight/TX_TILE_HEIGHT);
			
			m_tmap = new Vector.<Array> (); 
			
			for (i = 0; i < m_tileCols * m_tileRows; i++) {
				m_tmap.push([-1, 0]);
			}
			
			m_inuse = 0;

			m_items = new XDict (); // <XMapItemModel, Int>
			m_arrayItems = new Vector.<XMapItemModel> ();
			m_arrayItemIndex = 0;

			m_src = new XRect ();
			m_dst = new XRect ();
			
			m_XMapItemModelPoolManager = m_XMapLayer.getXMapModel ().getXMapItemModelPoolManager ();
			m_XRectPoolManager = m_XMapLayer.getXMapModel ().getXRectPoolManager ();
		}	

//------------------------------------------------------------------------------------------
		/* @:get, set useArrayItems Bool */
		
		public function get useArrayItems ():Boolean {
			return m_XMapLayer.getXMapModel ().useArrayItems;
		}
	
		public function set useArrayItems (__val:Boolean): /* @:set_type */ void {
			/* @:set_return true; */			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		/* @:get, set cmap Array<Int> */
		
		public function get cmap ():Vector.<int> {
			return m_cmap;
		}
		
		public function set cmap (__val:Vector.<int>): /* @:set_type */ void {
			/* @:set_return null; */			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		/* @:get, set tmap Array<Array<Dynamic>> */
		
		public function get tmap ():Vector.<Array> {
			return m_tmap;
		}
		
		public function set tmap (__val:Vector.<Array>): /* @:set_type */ void {
			/* @:set_return null; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function setCXTile (__type:int, __col:int, __row:int):void {
			m_cmap[__row * m_cols + __col] = __type;
		}
		
//------------------------------------------------------------------------------------------
		public function getCXTile (__col:int, __row:int):int {
			return m_cmap[__row * m_cols + __col];
		}

//------------------------------------------------------------------------------------------
		public function hasCXTiles ():Boolean {
			var __row:int, __col:int;
			
			for (__row = 0; __row < m_rows; __row++) {
				for (__col = 0; __col < m_cols; __col++) {
					if (m_cmap[__row * m_cols + __col] != CX_EMPTY) {
						return true;
					}
				}
			}
			
			return false;
		}	
		
//------------------------------------------------------------------------------------------
		/* @:get, set inuse Int */
		
		public function get inuse ():int {
			return m_inuse;
		}
		
		public function set inuse (__inuse:int): /* @:set_type */ void {
			m_inuse = __inuse;
			
			/* @:set_return __inuse; */			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		/* @:get, set cols Int */
		
		public function get cols ():int {
			return m_cols;
		}
		
		public function set cols (__val:int): /* @:set_type */ void {
			/* @:set_return 0; */			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		/* @:get, set rows Int */
		
		public function get rows ():int {
			return m_rows;
		}
		
		public function set rows (__val:int): /* @:set_type */ void {
			/* @:set_return 0; */			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		/* @:get, set tileCols Int */
		
		public function get tileCols ():int {
			return m_tileCols;
		}
		
		public function set tileCols (__val:int): /* @:set_type */ void {
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set tileRows Int */
		
		public function get tileRows ():int {
			return m_tileRows;
		}
		
		public function set tileRows (__val:int): /* @:set_type */ void {
			/* @:set_return 0; */			
		}
		/* @:end */
				
//------------------------------------------------------------------------------------------
		/* @:get, set boundingRect XRect */
		
		public function get boundingRect ():XRect {
			return m_boundingRect;
		}
		
		public function set boundingRect (__val:XRect): /* @:set_type */ void {
			m_boundingRect = __val;
			
			/* @:set_return __val; */			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		/* @:get, set x Float */
		
		public function get x ():Number {
			return m_col * m_submapWidth;
		}		
		
		public function set x (__val:Number): /* @:set_type */ void {
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set y Float */
		
		public function get y ():Number {
			return m_row * m_submapHeight;
		}

		public function set y (__val:Number): /* @:set_type */ void {
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set width Int */
		
		public function get width ():int {
			return m_submapWidth;
		}
		
		public function set width (__val:int): /* @:set_type */ void {
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set height Int */
		
		public function get height ():int {
			return  m_submapHeight;
		}
		
		public function set height (__val:int): /* @:set_type */ void {
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set XMapLayer XMapLayerModel */
		
		public function get XMapLayer ():XMapLayerModel {
			return  m_XMapLayer;
		}
		
		public function set XMapLayer (__val:XMapLayerModel): /* @:set_type */ void {
			m_XMapLayer = __val;
			
			/* @:set_return XMapLayer; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		public function addItem (
			__item:XMapItemModel
			):XMapItemModel {
							
			trace (": XSubmapModel: additem: ",  m_col, m_row, __item.getID (), m_items.exists (__item));
			
			if (!m_items.exists (__item)) {
				m_items.set (__item, __item.id);
			}
					
			return __item;
		}
		
//------------------------------------------------------------------------------------------
		public function addArrayItem (
			__item:XMapItemModel
		):XMapItemModel {
			
//			trace (": XSubmapModel: additemarray: ",  m_col, m_row, __item.getID (), m_items.exists (__item));
			
//			if (!(__item in m_arrayItems)) {
				m_arrayItems[m_arrayItemIndex++] = __item;
//			}
			
			return __item;
		}		

//------------------------------------------------------------------------------------------
		public function replaceItems (
			__item:XMapItemModel
			):Array /* <XMapItemModel> */ {
	
			trace (": XSubmapModel: replaceitem: ",  m_col, m_row, __item.getID (), m_items.exists (__item));
			
			var __removedItems:Array /* <XMapItemModel> */ = new Array (); // <XMapItemModel>
			
			__item.boundingRect.copy2 (m_src);
			m_src.offset (__item.x, __item.y);
			
			m_items.forEach (
				function (x:*):void {
					var __dstItem:XMapItemModel = x as XMapItemModel;
					
					__dstItem.boundingRect.copy2 (m_dst);
					m_dst.offset (__dstItem.x, __dstItem.y);
					
					if (m_src.intersects (m_dst)) {
						removeItem (__dstItem);
						
						__removedItems.push (__dstItem);
					}
				}
			);
			
			addItem (__item);
			
			trace (": XSubmapModel: replaceItems: ", __removedItems);
			
			return __removedItems;
		}
		
//------------------------------------------------------------------------------------------
		public function removeItem (
			__item:XMapItemModel
			):void {

			trace (": XSubmapModel: removeItem: ",  m_col, m_row, __item.getID (), m_items.exists (__item));
						
			if (m_items.exists (__item)) {
				m_items.remove (__item);
			}
		}
				
//------------------------------------------------------------------------------------------
		public function items ():XDict /* <XMapItemModel, Int> */ {
			return m_items;
		}

//------------------------------------------------------------------------------------------
		public function arrayItems ():Vector.<XMapItemModel> {
			return m_arrayItems;
		}

//------------------------------------------------------------------------------------------
		public function iterateAllItems (__iterationCallback:Function):void {
			if (useArrayItems) {
				var __items:Vector.<XMapItemModel>;
				var __length:int;
				
				__items = arrayItems ();
				
				__length = __items.length;
				
				for (var i:int = 0; i<__length; i++) {
					__iterationCallback (__items[i]);
				}
			}
			else
			{
				items ().forEach (
					function (x:*):void {
						__iterationCallback (x);
					}
				);		
			}
		}

//------------------------------------------------------------------------------------------
		public function serializeRowCol (__row:int, __col:int):XSimpleXMLNode {	
			var xml:XSimpleXMLNode = new XSimpleXMLNode ();
			
			var __attribs:Array /* <Dynamic> */ = [
				"row",	__row,
				"col",	__col
			];
			
			xml.setupWithParams ("XSubmap", "", __attribs);
			
			if (hasCXTiles ()) {
				xml.addChildWithXMLNode (serializeCXTiles ());
			}
			
			if (m_XMapLayer.grid) {
				xml = serializeRowCol_TileArray (xml);
			} else {				
				xml = serializeRowCol_XMapItem (xml);
			}
			
			return xml;
		}
		
//------------------------------------------------------------------------------------------
		public function serializeRowCol_XMapItem (xml:XSimpleXMLNode):XSimpleXMLNode {						
			var item:XMapItemModel;
	
			items ().forEach (
				function (x:*):void {
					item = x as XMapItemModel;
					
					xml.addChildWithXMLNode (item.serialize ());
				}
			);
			
			return xml;
		}

		//------------------------------------------------------------------------------------------
		public function serializeRowCol_TileArray (xml:XSimpleXMLNode):XSimpleXMLNode {	
			var __item:XMapItemModel;
			
			var __submapX:int = int (x);
			var __submapY:int = int (y);
			var __tileCol:int, __tileRow:int;
						
			var __tmap:Vector.<Array> = new Vector.<Array> (); 
			
			for (var i:int = 0; i < m_tileCols * m_tileRows; i++) {
				__tmap.push([0, 0]);
			}
			
			items ().forEach (
				function (x:*):void {
					__item = x as XMapItemModel;
					
					__tileCol = int ((int (__item.x) - __submapX) / TX_TILE_WIDTH);
					__tileRow = int ((int (__item.y) - __submapY) / TX_TILE_HEIGHT);
				
					trace(": imageClassIndex, frame: ", formatImageClassIndex (__item.imageClassIndex) + formatFrame (__item.frame));
					
					__tmap[__tileRow * m_tileCols + __tileCol] = [__item.imageClassIndex, __item.frame];
				}
			);
			
			var __tmapString:String = "";
			
			for (var __row:int = 0; __row < m_tileRows; __row++) {
				for (var __col:int = 0; __col < m_tileCols; __col++) {
					var __tile:* = __tmap[__row * m_tileCols + __col];
					
					if (__tile[0] == 0 && __tile[1] == 0) {
						__tmapString += "XXXX";	
					} else {
						__tmapString += formatImageClassIndex (__tile[0]) + formatFrame (__tile[1]);			
					}
				}
			}

			var __xmlTiles:XSimpleXMLNode = new XSimpleXMLNode ();			
			__xmlTiles.setupWithParams ("Tiles", __tmapString, []);
			
			xml.addChildWithXMLNode (__xmlTiles);
			
			return xml;
		}

//------------------------------------------------------------------------------------------
		private function formatImageClassIndex(__imageClassIndex:int):String {
			return CXToChar.charAt(__imageClassIndex);
		}
		
//------------------------------------------------------------------------------------------
		private function formatFrame(__frame:int):String {
			var digit100:int = int ((__frame%1000) / 100);
			var digit10:int = int ((__frame%100) / 10);
			var digit1:int = int ((__frame%10) / 1);
			
			return "" + digit100 + digit10 + digit1;
		}
		
//------------------------------------------------------------------------------------------
		public function serializeCXTiles ():XSimpleXMLNode {
			var __xmlCX:XSimpleXMLNode = new XSimpleXMLNode ();			
			__xmlCX.setupWithParams ("CX", "", []);
			
			var __row:int, __col:int;
				
			for (__row = 0; __row < m_rows; __row++) {
				var __xmlRow:XSimpleXMLNode = new XSimpleXMLNode ();
		
				var __rowString:String = "";
				
				for (__col = 0; __col < m_cols; __col++) {
					__rowString += CXToChar.charAt (m_cmap[__row * m_cols + __col]);
				}
				
				__xmlRow.setupWithParams ("row", __rowString, []);
				
				__xmlCX.addChildWithXMLNode (__xmlRow);
			}

			return __xmlCX;
		}
	
//------------------------------------------------------------------------------------------
		public function deserializeRowCol (__xml:XSimpleXMLNode):void {
			var __xmlList:Array; // <XSimpleXMLNode>
			__xmlList = __xml.child ("CX");
			
			if (__xmlList.length > 0) {
				deserializeCXTiles (__xmlList[0]);
			}
			
			//------------------------------------------------------------------------------------------
			var __xmlList:Array; // <XSimpleXMLNode>
			__xmlList = __xml.child ("Tiles");
			
			var __hasTiles:Boolean = __xmlList.length > 0;
			
			//------------------------------------------------------------------------------------------
			trace ("//------------------------------------------------------------------------------------------");
			trace (": deserializeRowCol: ", m_XMapLayer.grid);
			
			//------------------------------------------------------------------------------------------
			// even layers numbers are always encoded as XMapItems and decoded as XMapItems
			//------------------------------------------------------------------------------------------
			if (!m_XMapLayer.grid) {
				trace (": 0: ");
				deserializeRowCol_XMapItemXML_To_Items (__xml);
			}
			
			//------------------------------------------------------------------------------------------
			// encoded as XMapItemXML
			//------------------------------------------------------------------------------------------
			else if (!__hasTiles) {
				if (useArrayItems == false) { // TikiEdit
					trace(": 1: ");
					deserializeRowCol_XMapItemXML_To_Items (__xml); 				
				} else {
					trace(": 2: ");
					deserializeRowCol_XMapItemXML_To_TileArray (__xml);
				}
			}
			
			//------------------------------------------------------------------------------------------
			// encoded as TilesXML
			//------------------------------------------------------------------------------------------
			else {
				if (useArrayItems == false) { // TikiEdit
					trace(": 3: ");
					deserializeRowCol_TilesXML_To_Items (__xml);
				} else {
					trace(": 4: ");
					deserializeRowCol_TilesXML_To_TileArray (__xml);
				}
			}
		}
	
//------------------------------------------------------------------------------------------
		public function deserializeRowCol_TilesXML_To_TileArray (__xml:XSimpleXMLNode):void {
			trace (": TilesXML to TileArray: ");
			
			var __xmlList:Array; // <XSimpleXMLNode>
			__xmlList = __xml.child ("Tiles");
			
			if (__xmlList.length > 0) {
				var __xml:XSimpleXMLNode = __xmlList[0];
			
				var __tilesString:String = __xml.getTextTrim();
				var __imageClassIndex:int;
				var	__frame:int;
				
				trace (": <Tiles/>: ", __tilesString, __tilesString.length);
			
				var i:int;
				
				for (var __row:int = 0; __row < m_tileRows; __row++) {
					for (var __col:int = 0; __col < m_tileCols; __col++) {
						i = __row * m_tileCols + __col;
						
						if (__tilesString.substr (i * 4, 4) != "XXXX") {
							__imageClassIndex = CXToChar.indexOf (__tilesString.charAt (i * 4));
							__frame = XType.parseInt (__tilesString.substr (i * 4 + 1, 3));
	
							m_tmap[__row * m_tileCols + __col] = [__imageClassIndex, __frame];
						} else {
							m_tmap[__row * m_tileCols + __col] = [-1, 0];
						}
					}
				}
			}
		}
	
//------------------------------------------------------------------------------------------
		public function deserializeRowCol_TilesXML_To_Items (__xml:XSimpleXMLNode):void {
			trace (": TilesXML to Items: ");
			
			var __xmlList:Array; // <XSimpleXMLNode>
			__xmlList = __xml.child ("Tiles");
			
			if (__xmlList.length > 0) {
				var __xml:XSimpleXMLNode = __xmlList[0];
				
				var __tilesString:String = __xml.getTextTrim();
				var __imageClassIndex:int;
				var	__frame:int;
				
				trace (": <Tiles/>: ", __tilesString, __tilesString.length);
				
				var __item:XMapItemModel;
				
				var i:int;
				
				if (useArrayItems) {
					m_arrayItems = new Vector.<XMapItemModel> (/* __xmlList.length */);	
					for (i = 0; i < __xmlList.length; i++) {
						m_arrayItems.push (null);
					}
				}
				
				var __collisionRect:XRect = m_XRectPoolManager.borrowObject () as XRect;
				var __boundingRect:XRect = m_XRectPoolManager.borrowObject () as XRect;
				
				__collisionRect.setRect (
					0,
					0,
					TX_TILE_WIDTH,
					TX_TILE_HEIGHT
				);
				
				__boundingRect.setRect (
					0,
					0,
					TX_TILE_WIDTH,
					TX_TILE_HEIGHT
				);
				
				var __x:Number = m_col * m_submapWidth;
				var __y:Number = m_row * m_submapHeight;
				
				for (var __row:int = 0; __row < m_tileRows; __row++) {
					for (var __col:int = 0; __col < m_tileCols; __col++) {
						i = __row * m_tileCols + __col;
						
						if (__tilesString.substr (i * 4, 4) != "XXXX") {
							__imageClassIndex = CXToChar.indexOf (__tilesString.charAt (i * 4));
							__frame = XType.parseInt (__tilesString.substr (i * 4 + 1, 3));
							
							/*
							__layerModel:XMapLayerModel,
							__logicClassName:String,
							__hasLogic:Boolean,
							__name:String, __id:int,
							__imageClassName:String, __frame:int,
							__XMapItem:String,
							__x:Number, __y:Number,
							__scale:Number, __rotation:Number, __depth:Number,
							__collisionRect:XRect,
							__boundingRect:XRect,
							__params:String,
							...args
							*/
						
							__item = m_XMapItemModelPoolManager.borrowObject () as XMapItemModel;
						
							var __id:int = m_XMapLayer.generateID ();
								
							trace (":      --->: ", __tilesString.substr (i*4, 4), __imageClassIndex, m_XMapLayer.getClassNameFromIndex (__imageClassIndex));
							
							__item.setup (
								m_XMapLayer,
								// __logicClassName
								"XLogicObjectXMap:XLogicObjectXMap",
								// m_XMapLayer.getClassNameFromIndex (__logicClassIndex),
								// __hasLogic
								false,
								// __xml.hasAttribute ("hasLogic") && __xml.getAttribute ("hasLogic") == "true" ? true : false,
								// __name, __id
								"", __id,
								// __xml.getAttributeString ("name"), __id,
								m_XMapLayer.getClassNameFromIndex (__imageClassIndex), __frame,
								// m_XMapLayer.getClassNameFromIndex (__imageClassIndex), __xml.getAttributeInt ("frame"),
								// XMapItem
								"",
								// __xml.hasAttribute ("XMapItem") ? __xml.getAttribute ("XMapItem") : "",
								__x + __col * TX_TILE_WIDTH, __y + __row * TX_TILE_HEIGHT,
								// __xml.getAttributeFloat ("x"), __xml.getAttributeFloat ("y"),
								// __scale, __rotation, __depth
								1.0, 0.0, 0.0,
								// __xml.getAttributeFloat ("scale"), __xml.getAttributeFloat ("rotation"), __xml.getAttributeFloat ("depth"),
								// __collisionRect,
								__collisionRect,
								// __boundingRect,
								__boundingRect,
								// __params
								"<params/>",
								// __xml.child ("params")[0].toXMLString (),
								// args
								[]
							);
							
							if (useArrayItems) {
								m_arrayItems[m_arrayItemIndex++] = __item;
							}
							else
							{
								addItem (__item);
							}
							
							m_XMapLayer.trackItem (__item);
						}
					}
				}
			}
		}

//------------------------------------------------------------------------------------------
		public function deserializeRowCol_XMapItemXML_To_TileArray (__xml:XSimpleXMLNode):void {
			trace (": XMapItemXML to TileArray: ");
			
			var __xmlList:Array; // <XSimpleXMLNode>
			__xmlList = __xml.child ("XMapItem");
			
			var i:int;
			
			for (i=0; i<__xmlList.length; i++) {
				var __xml:XSimpleXMLNode = __xmlList[i];
				
				var __imageClassIndex:int = __xml.getAttributeInt ("imageClassIndex");
				var __imageClassName:String = m_XMapLayer.getClassNameFromIndex (__imageClassIndex);
				var __frame:int = __xml.getAttributeInt ("frame");
				var __x:int = int (__xml.getAttributeFloat ("x"));
				var __y:int = int (__xml.getAttributeFloat ("y"));
				
				if (__y >= m_row * m_submapHeight && __y < m_row * m_submapHeight + 512) {
					var __col:int = int ((__x & m_submapWidthMask) / TX_TILE_WIDTH);
					var __row:int = int ((__y & m_submapHeightMask) / TX_TILE_HEIGHT);
					
					m_tmap[__row * m_tileCols + __col] = [__imageClassIndex, __frame];
				}
			}			
		}
		
//------------------------------------------------------------------------------------------
		public function deserializeRowCol_XMapItemXML_To_Items (__xml:XSimpleXMLNode):void {
			var __xmlList:Array; // <XSimpleXMLNode>
			__xmlList = __xml.child ("XMapItem");

			var i:int;
			
			if (useArrayItems) {
				m_arrayItems = new Vector.<XMapItemModel> (/* __xmlList.length */);	
				for (i = 0; i < __xmlList.length; i++) {
					m_arrayItems.push (null);
				}
			}
			
			for (i=0; i<__xmlList.length; i++) {
				var __xml:XSimpleXMLNode = __xmlList[i];
				
//				trace (": deserializeRowCol: ", m_col, m_row);

				var __id:int = __xml.getAttributeInt ("id");
				var __item:XMapItemModel = m_XMapLayer.ids ().get (__id);
				
				if (__item != null) {
					trace (": **** existing item found ****: ", __item, __item.id);
				}
				else
				{
					__item = m_XMapItemModelPoolManager.borrowObject () as XMapItemModel;
				}

				var __classNameToIndex:XReferenceNameToIndex = m_XMapLayer.getClassNames ();
				
				var __logicClassIndex:int = __xml.getAttributeInt ("logicClassIndex");
				var __imageClassIndex:int = __xml.getAttributeInt ("imageClassIndex");
				
//				trace (": logicClassName: ", m_XMapLayer.getClassNameFromIndex (__logicClassIndex), __classNameToIndex.getReferenceNameCount (__logicClassIndex));
//				trace (": imageClassName: ", m_XMapLayer.getClassNameFromIndex (__imageClassIndex),  __classNameToIndex.getReferenceNameCount (__imageClassIndex));
								
				var __collisionRect:XRect = m_XRectPoolManager.borrowObject () as XRect;
				var __boundingRect:XRect = m_XRectPoolManager.borrowObject () as XRect;
				
				__collisionRect.setRect (
					__xml.getAttributeFloat ("cx"),
					__xml.getAttributeFloat ("cy"),
					__xml.getAttributeFloat ("cw"),
					__xml.getAttributeFloat ("ch")
				);
				
				__boundingRect.setRect (
					__xml.getAttributeFloat ("bx"),
					__xml.getAttributeFloat ("by"),
					__xml.getAttributeFloat ("bw"),
					__xml.getAttributeFloat ("bh")
				);
					
				__item.setup (
					m_XMapLayer,
// __logicClassName
					m_XMapLayer.getClassNameFromIndex (__logicClassIndex),
// __hasLogic
					__xml.hasAttribute ("hasLogic") && __xml.getAttribute ("hasLogic") == "true" ? true : false,
// __name, __id
					__xml.getAttributeString ("name"), __id,
// __imageClassName, __frame
					m_XMapLayer.getClassNameFromIndex (__imageClassIndex), __xml.getAttributeInt ("frame"),
// XMapItem
					__xml.hasAttribute ("XMapItem") ? __xml.getAttribute ("XMapItem") : "",
// __x, __y,
					__xml.getAttributeFloat ("x"), __xml.getAttributeFloat ("y"),
// __scale, __rotation, __depth
					__xml.getAttributeFloat ("scale"), __xml.getAttributeFloat ("rotation"), __xml.getAttributeFloat ("depth"),
// __collisionRect,
					__collisionRect,
// __boundingRect,
					__boundingRect,
// __params
					__xml.child ("params")[0].toXMLString (),
// args
					[]
					);

					if (useArrayItems) {
						m_arrayItems[m_arrayItemIndex++] = __item;
					}
					else
					{
						addItem (__item);
					}
	
					m_XMapLayer.trackItem (__item);
			}
		}
		
//----------------------------------------------------------------------------------------
		public function deserializeCXTiles (__cx:XSimpleXMLNode):void {
			var __xmlList:Array /* <XSimpleXMLNode> */ = __cx.child ("row");
			var __row:int, __col:int;
			var __xml:XSimpleXMLNode;
			var __rowString:String;
			
			for (__row=0; __row<__xmlList.length; __row++) {
				__xml = __xmlList[__row];
				__rowString = XType.trim (__xml.getText ());
				
				for (__col=0; __col<__rowString.length; __col++) {
					m_cmap[__row * m_cols + __col] = CXToChar.indexOf (__rowString.charAt (__col));
				}
			}
		}
		
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
