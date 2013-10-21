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
		
		private var m_cmap:Array;
		private var m_inuse:Number;
		
		private var m_boundingRect:XRect;
		
		private var m_src:XRect;
		private var m_dst:XRect;
		
// empty
		public static const CX_EMPTY:Number = 0;
		
// solid solid
		public static const CX_SOLID:Number = 1;
		
// soft
		public static const CX_SOFT:Number = 2;	
		
// jump thru
		public static const CX_JUMP_THRU:Number = 3;
		
// 45 degree diagonals
		public static const CX_UL45:Number = 4;
		public static const CX_UR45:Number = 5;
		public static const CX_LL45:Number = 6;
		public static const CX_LR45:Number = 7;
		
// 22.5 degree diagonals
		public static const CX_UL225A:Number = 8;
		public static const CX_UL225B:Number = 9;
		public static const CX_UR225A:Number = 10;
		public static const CX_UR225B:Number = 11;
		public static const CX_LL225A:Number = 12;
		public static const CX_LL225B:Number = 13;
		public static const CX_LR225A:Number = 14;
		public static const CX_LR225B:Number = 15;

// 67.5 degree diagonals
		public static const CX_UL675A:Number = 16;
		public static const CX_UL675B:Number = 17;
		public static const CX_UR675A:Number = 18;
		public static const CX_UR675B:Number = 19;
		public static const CX_LL675A:Number = 20;
		public static const CX_LL675B:Number = 21;
		public static const CX_LR675A:Number = 22;
		public static const CX_LR675B:Number = 23;
		
// soft tiles
		public static const CX_SOFTLF:Number = 24;
		public static const CX_SOFTRT:Number = 25;
		public static const CX_SOFTUP:Number = 26;
		public static const CX_SOFTDN:Number = 27;
		
		public static const CX_MAX:Number = 28;
		
// collision tile width, height
		public static const CX_TILE_WIDTH:Number = 16;
		public static const CX_TILE_HEIGHT:Number = 16;
		
		public static const CX_TILE_WIDTH_MASK:Number = 15;
		public static const CX_TILE_HEIGHT_MASK:Number = 15;
		
		public static const CX_TILE_WIDTH_UNMASK:Number = 0xfffffff0;
		public static const CX_TILE_HEIGHT_UNMASK:Number = 0xfffffff0;

// alternate tile width, height
		public static const TX_TILE_WIDTH:Number = 64;
		public static const TX_TILE_HEIGHT:Number = 64;
		
		public static const TX_TILE_WIDTH_MASK:Number = 63;
		public static const TX_TILE_HEIGHT_MASK:Number = 63;
		
		public static const TX_TILE_WIDTH_UNMASK:Number = 0xffffffc0;
		public static const TX_TILE_HEIGHT_UNMASK:Number = 0xffffffc0;
		
		private var m_items:XDict;
		
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
			
			m_cmap = new Array (m_cols * m_rows);
			
			m_inuse = 0;
			
			for (var i:int = 0; i< m_cmap.length; i++) {
				m_cmap[i] = CX_EMPTY;
			}
			
			m_items = new XDict ();

			m_src = new XRect ();
			m_dst = new XRect ();
		}	

//------------------------------------------------------------------------------------------
		public function get cmap ():Array {
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
		public function replaceItems (
			__item:XMapItemModel
			):Array {
	
			trace (": XSubmapModel: replaceitem: ",  m_col, m_row, __item.getID (), m_items.exists (__item));
			
			var __removedItems:Array = new Array ();
			
			__item.boundingRect.copy2 (m_src);
			m_src.offset (__item.x, __item.y);
			
			m_items.forEach (
				function (x:*) {
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
					
					addItem (__item);
					
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
