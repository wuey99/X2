//------------------------------------------------------------------------------------------
package X.XMap {

// X classes
	import X.Collections.*;
	import X.Geom.*;
	import X.MVC.*;
	import X.XML.*;
	
	import flash.events.*;
	
//------------------------------------------------------------------------------------------	
	public class XSubmapModel extends XModelBase {
		private var m_XMapLayer:XMapLayerModel;
			
		private var m_submapWidth:Number;
		private var m_cols:Number;
		
		private var m_submapHeight:int;
		private var m_rows:int;
		
		private var m_col:int;
		private var m_row:int;
		
		private var m_tiles:Array;
		private var m_inuse:Number;
		
		private var m_boundingRect:XRect;
		
// empty
		public static var CX_EMPTY:Number = 0;
		
// solid solid
		public static var CX_SOLID:Number = 1;
		
// soft
		public static var CX_SOFT:Number = 2;	
		
// jump thru
		public static var CX_JUMP_THRU:Number = 3;
		
// 45 degree diagonals
		public static var CX_UL45:Number = 4;
		public static var CX_UR45:Number = 5;
		public static var CX_LL45:Number = 6;
		public static var CX_LR45:Number = 7;
		
// 22.5 degree diagonals
		public static var CX_UL225A:Number = 8;
		public static var CX_UL225B:Number = 9;
		public static var CX_UR225A:Number = 10;
		public static var CX_UR225B:Number = 11;
		public static var CX_LL225A:Number = 12;
		public static var CX_LL225B:Number = 13;
		public static var CX_LR225A:Number = 14;
		public static var CX_LR225B:Number = 15;

// tile width, height
		public static var CX_TILE_WIDTH:Number = 16;
		public static var CX_TILE_HEIGHT:Number = 16;
		
		public static var CX_TILE_WIDTH_MASK:Number = 15;
		public static var CX_TILE_HEIGHT_MASK:Number = 15;
		
		public static var CX_TILE_WIDTH_UNMASK:Number = 0xfffffff0;
		public static var CX_TILE_HEIGHT_UNMASK:Number = 0xfffffff0;
		
		private var m_items:XDict;
		
//------------------------------------------------------------------------------------------	
		public function XSubmapModel (
			__XMapLayer:XMapLayerModel,
			__col:Number, __row:Number,
			__width:Number, __height:Number
			) {
				
			m_XMapLayer = __XMapLayer;
				
			m_submapWidth = __width;
			m_submapHeight = __height;
		
			m_col = __col;
			m_row = __row;
		
			m_cols = m_submapWidth/CX_TILE_WIDTH;
			m_rows = m_submapHeight/CX_TILE_HEIGHT;

			m_boundingRect = new XRect (0, 0, m_submapWidth, m_submapHeight);
			
			m_tiles = new Array (m_cols * m_rows);
			
			m_inuse = 0;
			
			for (var i:int = 0; i< m_tiles.length; i++) {
				m_tiles[i] = CX_EMPTY;
			}
			
			m_items = new XDict ();
		}	

//------------------------------------------------------------------------------------------
		public function setCXTile (__type:Number, __col:Number, __row:Number):void {
		}
		
//------------------------------------------------------------------------------------------
		public function getCXTile (__col:Number, __row:Number):Number {
			return m_tiles[__row * m_cols + __col];
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
							
			if (!m_items.exists (__item)) {
				m_items.put (__item, __item.id);
			}
					
			return __item;
		}

//------------------------------------------------------------------------------------------
		public function removeItem (
			__item:XMapItemModel
			):void {
			
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
		public function deserializeRowCol (__xml:XSimpleXMLNode):void {
			var __xmlList:Array = __xml.child ("XMapItem");
			
			var i:Number;
			
			for (i=0; i<__xmlList.length; i++) {
				var __xml:XSimpleXMLNode = __xmlList[i];
				
				trace (": XMapItem: ", __xml);
				
				var __item:XMapItemModel = new XMapItemModel ();
		
				var __logicClassIndex:Number = __xml.getAttribute ("logicClassIndex");
				var __imageClassIndex:Number = __xml.getAttribute ("imageClassIndex");
				
				trace (": logicClassName: ", m_XMapLayer.getClassNameFromIndex (__logicClassIndex));
				trace (": imageClassName: ", m_XMapLayer.getClassNameFromIndex (__imageClassIndex));
				
				__item.setup (
					m_XMapLayer,
// __logicClassName
					m_XMapLayer.getClassNameFromIndex (__logicClassIndex),
// __name, __id
					__xml.getAttribute ("name"), __xml.getAttribute ("id"),
// __imageClassName, __frame
					m_XMapLayer.getClassNameFromIndex (__imageClassIndex), __xml.getAttribute ("frame"),
// __x, __y,
					__xml.getAttribute ("x"), __xml.getAttribute ("y"),
// __scale, __rotation, __depth
					__xml.getAttribute ("scale"), __xml.getAttribute ("rotation"), __xml.getAttribute ("depth"),
// __collisionRect,
					new XRect (__xml.getAttribute ("cx"), __xml.getAttribute ("cy"), __xml.getAttribute ("cw"), __xml.getAttribute ("ch")),
// __boundingRect,
					new XRect (__xml.getAttribute ("cx"), __xml.getAttribute ("cy"), __xml.getAttribute ("bw"), __xml.getAttribute ("bh")),
// __params
					__xml.child ("params")[0].toXMLString ()
					);
					
					addItem (__item);
			}
		}
				
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
