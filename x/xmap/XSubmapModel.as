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
package x.xmap {

// X classes
	import x.collections.*;
	import x.geom.*;
	import x.mvc.*;
	import x.pool.XSubObjectPoolManager;
	import x.utils.XReferenceNameToIndex;
	import x.xml.*;
	
	import flash.events.*;
	
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
		
		private var m_boundingRect:XRect;
		
		private var m_src:XRect;
		private var m_dst:XRect;

		private var m_items:XDict; // <XMapItemModel, Float>
		private var m_arrayItems:Vector.<XMapItemModel>;
		private var m_arrayItemIndex:int;
		
		private var m_XMapItemModelPoolManager:XSubObjectPoolManager;
		private var m_XRectPoolManager:XSubObjectPoolManager;
		
// empty
		public static const CX_EMPTY:int = 0;
		
// solid solid
		public static const CX_SOLID:int = 1;
		
// soft
		public static const CX_SOFT:int = 2;	
		
// jump thru
		public static const CX_JUMP_THRU:int = 3;
		
// 45 degree diagonals
		public static const CX_UL45:int = 4;
		public static const CX_UR45:int = 5;
		public static const CX_LL45:int = 6;
		public static const CX_LR45:int = 7;
		
// 22.5 degree diagonals
		public static const CX_UL225A:int = 8;
		public static const CX_UL225B:int = 9;
		public static const CX_UR225A:int = 10;
		public static const CX_UR225B:int = 11;
		public static const CX_LL225A:int = 12;
		public static const CX_LL225B:int = 13;
		public static const CX_LR225A:int = 14;
		public static const CX_LR225B:int = 15;

// 67.5 degree diagonals
		public static const CX_UL675A:int = 16;
		public static const CX_UL675B:int = 17;
		public static const CX_UR675A:int = 18;
		public static const CX_UR675B:int = 19;
		public static const CX_LL675A:int = 20;
		public static const CX_LL675B:int = 21;
		public static const CX_LR675A:int = 22;
		public static const CX_LR675B:int = 23;
		
// soft tiles
		public static const CX_SOFTLF:int = 24;
		public static const CX_SOFTRT:int = 25;
		public static const CX_SOFTUP:int = 26;
		public static const CX_SOFTDN:int = 27;
		
		// special solids
		public static const CX_SOLIDX001:int = 28;
		
		// death
		public static const CX_DEATH:int = 29;
		
		// ice
		public static const CX_ICE:int = 30;
		
		// max
		public static const CX_MAX:int = 31;
		
// collision tile width, height
		public static const CX_TILE_WIDTH:int = 16;
		public static const CX_TILE_HEIGHT:int = 16;
		
		public static const CX_TILE_WIDTH_MASK:int = 15;
		public static const CX_TILE_HEIGHT_MASK:int = 15;
		
		public static const CX_TILE_WIDTH_UNMASK:int = 0xfffffff0;
		public static const CX_TILE_HEIGHT_UNMASK:int = 0xfffffff0;

// alternate tile width, height
		public static const TX_TILE_WIDTH:int = 64;
		public static const TX_TILE_HEIGHT:int = 64;
		
		public static const TX_TILE_WIDTH_MASK:int = 63;
		public static const TX_TILE_HEIGHT_MASK:int = 63;
		
		public static const TX_TILE_WIDTH_UNMASK:int = 0xffffffc0;
		public static const TX_TILE_HEIGHT_UNMASK:int = 0xffffffc0;

		private static var CXToChar:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
		
//------------------------------------------------------------------------------------------	
		public function XSubmapModel (
			__XMapLayer:XMapLayerModel,
			__col:int, __row:int,
			__width:Number, __height:Number
			) {
				
			super ();
			
			m_XMapLayer = __XMapLayer;
				
			m_submapWidth = __width;
			m_submapHeight = __height;
		
			m_col = __col;
			m_row = __row;
		
			m_cols = m_submapWidth/CX_TILE_WIDTH;
			m_rows = m_submapHeight/CX_TILE_HEIGHT;

			m_boundingRect = new XRect (0, 0, m_submapWidth, m_submapHeight);
			
			m_cmap = new Vector.<int> (m_cols * m_rows);
			
			m_inuse = 0;
			
			for (var i:int = 0; i< m_cmap.length; i++) {
				m_cmap[i] = CX_EMPTY;
			}

			m_items = new XDict (); // <XMapItemModel, Float>
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
	
		public function set useArrayItems (__value:Boolean): /* @:set_type */ void {
			/* @:set_return true; */			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		/* @:get, set cmap Array<Int> */
		
		public function get cmap ():Vector.<int> {
			return m_cmap;
		}
		
		public function set cmap (__value:Vector.<int>): /* @:set_type */ void {
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
			
			/* @:set_return 0; */			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		/* @:get, set cols Int */
		
		public function get cols ():int {
			return m_cols;
		}
		
		public function set cols (__value:int): /* @:set_type */ void {
			/* @:set_return 0; */			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		/* @:get, set rows Int */
		
		public function get rows ():int {
			return m_rows;
		}
		
		public function set rows (__value:int): /* @:set_type */ void {
			/* @:set_return 0; */			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		/* @:get, set boundingRect XRect */
		
		public function get boundingRect ():XRect {
			return m_boundingRect;
		}
		
		public function set boundingRect (__value:XRect): /* @:set_type */ void {
			m_boundingRect = __value;
			
			/* @:set_return null; */			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		/* @:get, set x Float */
		
		public function get x ():Number {
			return m_col * m_submapWidth;
		}		
		
		public function set x (__value:Number): /* @:set_type */ void {
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set y Float */
		
		public function get y ():Number {
			return m_row * m_submapHeight;
		}

		public function set y (__value:Number): /* @:set_type */ void {
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set width Float */
		
		public function get width ():Number {
			return m_submapWidth;
		}
		
		public function set width (__value:Number): /* @:set_type */ void {
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set height Float */
		
		public function get height ():Number {
			return  m_submapHeight;
		}
		
		public function set height (__value:Number): /* @:set_type */ void {
			/* @:set_return 0; */			
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
			
			var __removedItems:Array /* <XSimpleXMLNode> */ = new Array (); // <XSimpleXMLNode>
			
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
		public function items ():XDict /* <XMapItemModel, Float> */ {
			return m_items;
		}

//------------------------------------------------------------------------------------------
		public function arrayItems ():Vector.<XMapItemModel> {
			return m_arrayItems;
		}

//------------------------------------------------------------------------------------------
		public function iterateAllItems (__callback:Function):void {
			if (useArrayItems) {
				var __items:Vector.<XMapItemModel>;
				var __length:int;
				
				__items = arrayItems ();
				
				__length = __items.length;
				
				for (var i:int = 0; i<__length; i++) {
					__callback (__items[i]);
				}
			}
			else
			{
				items ().forEach (
					function (x:*):void {
						__callback (x);
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
			var i:int;

//------------------------------------------------------------------------------------------			
			__xmlList = __xml.child ("CX");
			
			if (__xmlList.length) {
				deserializeCXTiles (__xmlList[0]);
			}
			
//------------------------------------------------------------------------------------------
			__xmlList = __xml.child ("XMapItem");

			if (useArrayItems) {
				m_arrayItems = new Vector.<XMapItemModel> (__xmlList.length);
			}
			
			for (i=0; i<__xmlList.length; i++) {
				var __xml:XSimpleXMLNode = __xmlList[i];
				
//				trace (": deserializeRowCol: ", m_col, m_row);

				var __id:int = __xml.getAttribute ("id");
				var __item:XMapItemModel = m_XMapLayer.ids ().get (__id);
				
				if (__item != null) {
					trace (": **** existing item found ****: ", __item, __item.id);
				}
				else
				{
					__item = m_XMapItemModelPoolManager.borrowObject () as XMapItemModel;
				}

				var __classNameToIndex:XReferenceNameToIndex = m_XMapLayer.getClassNames ();
				
				var __logicClassIndex:int = __xml.getAttribute ("logicClassIndex");
				var __imageClassIndex:int = __xml.getAttribute ("imageClassIndex");
				
//				trace (": logicClassName: ", m_XMapLayer.getClassNameFromIndex (__logicClassIndex), __classNameToIndex.getReferenceNameCount (__logicClassIndex));
//				trace (": imageClassName: ", m_XMapLayer.getClassNameFromIndex (__imageClassIndex),  __classNameToIndex.getReferenceNameCount (__imageClassIndex));
								
				var __collisionRect:XRect = m_XRectPoolManager.borrowObject () as XRect;
				var __boundingRect:XRect = m_XRectPoolManager.borrowObject () as XRect;
				
				__collisionRect.setRect (__xml.getAttribute ("cx"), __xml.getAttribute ("cy"), __xml.getAttribute ("cw"), __xml.getAttribute ("ch"));
				__boundingRect.setRect (__xml.getAttribute ("bx"), __xml.getAttribute ("by"), __xml.getAttribute ("bw"), __xml.getAttribute ("bh"));
					
				__item.setup (
					m_XMapLayer,
// __logicClassName
					m_XMapLayer.getClassNameFromIndex (__logicClassIndex),
// __hasLogic
					__xml.hasAttribute ("hasLogic") && __xml.getAttribute ("hasLogic") == "true" ? true : false,
// __name, __id
					__xml.getAttribute ("name"), __id,
// __imageClassName, __frame
					m_XMapLayer.getClassNameFromIndex (__imageClassIndex), __xml.getAttribute ("frame"),
// XMapItem
					__xml.hasAttribute ("XMapItem") ? __xml.getAttribute ("XMapItem") : "",
// __x, __y,
					__xml.getAttribute ("x"), __xml.getAttribute ("y"),
// __scale, __rotation, __depth
					__xml.getAttribute ("scale"), __xml.getAttribute ("rotation"), __xml.getAttribute ("depth"),
// __collisionRect,
					__collisionRect,
// __boundingRect,
					__boundingRect,
// __params
					__xml.child ("params")[0].toXMLString ()
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
			
			for (__row=0; __row<__xmlList.length; __row++) {
				var __xml:XSimpleXMLNode = __xmlList[__row];
				var __rowString:String = __xml.getText ();
				
				for (__col=0; __col<__rowString.length; __col++) {
					m_cmap[__row * m_cols + __col] = CXToChar.indexOf (__rowString.charAt (__col));
				}
			}
		}
		
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
