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
// For commercial use, you will need to provide proper credits.
// Please contact me @ wuey99[dot]gmail[dot]com for more details.
// <$end$/>
//------------------------------------------------------------------------------------------
package X.XMap {

// X classes
	import X.Collections.*;
	import X.Geom.*;
	import X.MVC.*;
	import X.Utils.XReferenceNameToIndex;
	import X.XML.*;
	
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
		private var m_inuse:Number;
		
		private var m_boundingRect:XRect;
		
		private var m_src:XRect;
		private var m_dst:XRect;

		private var m_items:XDict;
		private var m_arrayItems:Vector.<XMapItemModel>;
		
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
		
		public static const CX_MAX:int = 30;
		
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
			__col:Number, __row:Number,
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
			
			m_items = new XDict ();
			m_arrayItems = new Vector.<XMapItemModel> ();

			m_src = new XRect ();
			m_dst = new XRect ();
		}	

//------------------------------------------------------------------------------------------
		public function get useArrayItems ():Boolean {
			return m_XMapLayer.getXMapModel ().useArrayItems;
		}
		
//------------------------------------------------------------------------------------------
		public function get cmap ():Vector.<int> {
			return m_cmap;
		}
		
//------------------------------------------------------------------------------------------
		public function setCXTile (__type:Number, __col:Number, __row:Number):void {
			m_cmap[__row * m_cols + __col] = __type;
		}
		
//------------------------------------------------------------------------------------------
		public function getCXTile (__col:Number, __row:Number):Number {
			return m_cmap[__row * m_cols + __col];
		}

//------------------------------------------------------------------------------------------
		public function hasCXTiles ():Boolean {
			var __row:Number, __col:Number;
			
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
		public function get inuse ():Number {
			return m_inuse;
		}
		
		public function set inuse (__inuse:Number):void {
			m_inuse = __inuse;
		}

//------------------------------------------------------------------------------------------
		public function get cols ():Number {
			return m_cols;
		}
		
//------------------------------------------------------------------------------------------
		public function get rows ():Number {
			return m_rows;
		}
		
//------------------------------------------------------------------------------------------
		public function get boundingRect ():XRect {
			return m_boundingRect;
		}
		
//------------------------------------------------------------------------------------------
		public function get x ():Number {
			return m_col * m_submapWidth;
		}		
		
//------------------------------------------------------------------------------------------
		public function get y ():Number {
			return m_row * m_submapHeight;
		}

//------------------------------------------------------------------------------------------
		public function get width ():Number {
			return m_submapWidth;
		}
		
//------------------------------------------------------------------------------------------
		public function get height ():Number {
			return  m_submapHeight;
		}
		
//------------------------------------------------------------------------------------------
		public function addItem (
			__item:XMapItemModel
			):XMapItemModel {
							
			trace (": XSubmapModel: additem: ",  m_col, m_row, __item.getID (), m_items.exists (__item));
			
			if (!m_items.exists (__item)) {
				m_items.put (__item, __item.id);
			}
					
			return __item;
		}
		
//------------------------------------------------------------------------------------------
		public function addArrayItem (
			__item:XMapItemModel
		):XMapItemModel {
			
			trace (": XSubmapModel: additemarray: ",  m_col, m_row, __item.getID (), m_items.exists (__item));
			
			if (!(__item in m_arrayItems)) {
				m_arrayItems.push (__item);
			}
			
			return __item;
		}		

//------------------------------------------------------------------------------------------
		public function replaceItems (
			__item:XMapItemModel
			):Array {
	
			trace (": XSubmapModel: replaceitem: ",  m_col, m_row, __item.getID (), m_items.exists (__item));
			
			var __removedItems:Array = new Array ();
			
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
		public function items ():XDict {
			return m_items;
		}

//------------------------------------------------------------------------------------------
		public function arrayItems ():Vector.<XMapItemModel> {
			return m_arrayItems;
		}
		
//------------------------------------------------------------------------------------------
		public function serializeRowCol (__row:Number, __col:Number):XSimpleXMLNode {	
			var xml:XSimpleXMLNode = new XSimpleXMLNode ();
			
			var __attribs:Array = [
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
			
			var __row:Number, __col:Number;
				
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
			var __xmlList:Array;
			var i:Number;

//------------------------------------------------------------------------------------------			
			__xmlList = __xml.child ("CX");
			
			if (__xmlList.length) {
				deserializeCXTiles (__xmlList[0]);
			}
			
//------------------------------------------------------------------------------------------
			__xmlList = __xml.child ("XMapItem");
						
			for (i=0; i<__xmlList.length; i++) {
				var __xml:XSimpleXMLNode = __xmlList[i];
				
				trace (": deserializeRowCol: ", m_col, m_row);

				var __id:Number = __xml.getAttribute ("id");
				var __item:XMapItemModel = m_XMapLayer.ids ().get (__id);
				
				if (__item != null) {
					trace (": **** existing item found ****: ", __item, __item.id);
				}
				else
				{
					__item = new XMapItemModel ();
				}

				var __classNameToIndex:XReferenceNameToIndex = m_XMapLayer.getClassNames ();
				
				var __logicClassIndex:Number = __xml.getAttribute ("logicClassIndex");
				var __imageClassIndex:Number = __xml.getAttribute ("imageClassIndex");
				
				trace (": logicClassName: ", m_XMapLayer.getClassNameFromIndex (__logicClassIndex), __classNameToIndex.getReferenceNameCount (__logicClassIndex));
				trace (": imageClassName: ", m_XMapLayer.getClassNameFromIndex (__imageClassIndex),  __classNameToIndex.getReferenceNameCount (__imageClassIndex));
								
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
					new XRect (__xml.getAttribute ("cx"), __xml.getAttribute ("cy"), __xml.getAttribute ("cw"), __xml.getAttribute ("ch")),
// __boundingRect,
					new XRect (__xml.getAttribute ("bx"), __xml.getAttribute ("by"), __xml.getAttribute ("bw"), __xml.getAttribute ("bh")),
// __params
					__xml.child ("params")[0].toXMLString ()
					);
	
//					addItem (__item);
					
					if (useArrayItems) {
						addArrayItem (__item);
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
			var __xmlList:Array = __cx.child ("row");
			var __row:Number, __col:Number;
			
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
