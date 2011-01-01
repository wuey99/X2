//------------------------------------------------------------------------------------------
package X.XMap {

// X classes
	import X.Geom.*;
	import X.Collections.*;
	import X.MVC.*;
	
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
				
				__item.setup (
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
					new XRect (__xml.@cx, __xml.@cy, __xml.@cw, __xml.@ch),
// __boundingRect,
					new XRect (__xml.@cx, __xml.@cy, __xml.@bw, __xml.@bh),
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
