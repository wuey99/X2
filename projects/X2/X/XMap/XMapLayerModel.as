//------------------------------------------------------------------------------------------
package X.XMap {

// X classes
	import X.Collections.*;
	import X.Geom.*;
	import X.MVC.*;
	import X.Utils.*;
	import X.XML.*;
	
	import flash.events.*;
			
//------------------------------------------------------------------------------------------	
	public class XMapLayerModel extends XModelBase {
		private var m_XMap:XMapModel;
		
		private var m_layer:Number;
		
		private var m_XSubmaps:Array;
		
		private var m_submapRows:Number;
		private var m_submapCols:Number;
		private var m_submapWidth:Number;
		private var m_submapHeight:Number;
		
		private var m_currID:Number;

		private var m_items:XDict;

		private var m_classNames:XReferenceNameToIndex;
		private var m_imageClassNames:XDict;
		
		private var m_viewPort:XRect;
		
		private var m_visible:Boolean;
		private var m_name:String;
		private var m_grid:Boolean
		
//------------------------------------------------------------------------------------------	
		public function XMapLayerModel () {
			super ();
		}	

//------------------------------------------------------------------------------------------
		public function setup (
			__layer:Number,
			__submapCols:Number, __submapRows:Number,
			__submapWidth:Number, __submapHeight:Number
			):void {

			var __row:Number;
			var __col:Number;

			m_submapRows = __submapRows;
			m_submapCols = __submapCols;
			m_submapWidth = __submapWidth;
			m_submapHeight = __submapHeight;

			m_currID = 0;
			m_items = new XDict ();
			m_layer = __layer;
			m_XSubmaps = new Array (__submapRows);
			m_visible = true;
			m_name = "layer" + __layer;
			m_grid = false;

			for (__row=0; __row<__submapRows; __row++) {
				m_XSubmaps[__row] = new Array (__submapCols);

				for (__col=0; __col<__submapCols; __col++) {
					m_XSubmaps[__row][__col] = new XSubmapModel (this, __col, __row, m_submapWidth, m_submapHeight);
				}
			}
			
			m_classNames = new XReferenceNameToIndex ();
			m_imageClassNames = new XDict ();
			
			m_viewPort = new XRect ();
		}

//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function setParent (__XMap:XMapModel):void {
			m_XMap = __XMap;
		}

//------------------------------------------------------------------------------------------
		public function setViewPort (__viewPort:XRect):void {
			m_viewPort = __viewPort;
		}
		
//------------------------------------------------------------------------------------------
		public function get viewPort ():XRect {
			return m_viewPort;
		}

//------------------------------------------------------------------------------------------
		public function get visible ():Boolean {
			return m_visible;
		}

//------------------------------------------------------------------------------------------
		public function set visible (__value:Boolean):void {
			m_visible = __value;
		}
	
//------------------------------------------------------------------------------------------
		public function get name ():String {
			return m_name;
		}

//------------------------------------------------------------------------------------------
		public function set name (__value:String):void {
			m_name = __value;
		}
	
//------------------------------------------------------------------------------------------
		public function get grid ():Boolean {
			return m_grid;
		}

//------------------------------------------------------------------------------------------
		public function set grid (__value:Boolean):void {
			m_grid = __value;
		}
					
//------------------------------------------------------------------------------------------
		public function getSubmapRows ():Number {
			return m_submapRows;
		}
		
//------------------------------------------------------------------------------------------
		public function getSubmapCols ():Number {
			return m_submapCols;
		}
		
//------------------------------------------------------------------------------------------
		public function getSubmapWidth ():Number {
			return m_submapWidth;
		}	
		
//------------------------------------------------------------------------------------------
		public function getSubmapHeight ():Number {
			return m_submapHeight;
		}
		
//------------------------------------------------------------------------------------------
		public function addItem (__item:XMapItemModel):XMapItemModel {
			var __c1:int, __r1:int, __c2:int, __r2:int;
			
			var __id:Number = __item.getID ();
			
			if (__id == -1) {
// obtain unique ID for this item			
				__id = generateID ();
				
				__item.setID (__id);
			}
			
			var r:XRect = __item.boundingRect.cloneX ();
			r.offset (__item.x, __item.y);
			
// determine submaps that the item straddles
			__c1 = r.left/m_submapWidth;
			__r1 = r.top/m_submapHeight;
			
			__c2 = r.right/m_submapWidth;
			__r2 = r.bottom/m_submapHeight;

			trace (": -----------------------: ");
			trace (": XXMapLayerModel: addItem: ", __id);
			trace (": x, y: ", __item.x, __item.y);
			trace (": ", r.left, r.top, r.right, r.bottom);
			trace (": ", __c1, __r1, __c2, __r2);
			
			__c1 = Math.max (__c1, 0);
			__c2 = Math.max (__c2, 0);
			__r1 = Math.max (__r1, 0);
			__r2 = Math.max (__r2, 0);
			
			__c1 = Math.min (__c1, m_submapCols-1);
			__c2 = Math.min (__c2, m_submapCols-1);
			__r1 = Math.min (__r1, m_submapRows-1);
			__r2 = Math.min (__r2, m_submapRows-1);
// ul
			m_XSubmaps[__r1][__c1].addItem (__item);
// ur
			m_XSubmaps[__r1][__c2].addItem (__item);
// ll
			m_XSubmaps[__r2][__c1].addItem (__item);
// lr
			m_XSubmaps[__r2][__c2].addItem (__item);

			m_items.put (__item, __item.id);
			
			return __item;
		}

//------------------------------------------------------------------------------------------
		public function removeItem (__item:XMapItemModel):void {		
			if (!m_items.exists (__item)) {
				return;
			}
			
			var __c1:int, __r1:int, __c2:int, __r2:int;
		
			var r:XRect = __item.boundingRect.cloneX ();
			r.offset (__item.x, __item.y);
			
// determine submaps that the item straddles
			__c1 = r.left/m_submapWidth;
			__r1 = r.top/m_submapHeight;
			
			__c2 = r.right/m_submapWidth;
			__r2 = r.bottom/m_submapHeight;

			__c1 = Math.max (__c1, 0);
			__c2 = Math.max (__c2, 0);
			__r1 = Math.max (__r1, 0);
			__r2 = Math.max (__r2, 0);
			
			__c1 = Math.min (__c1, m_submapCols-1);
			__c2 = Math.min (__c2, m_submapCols-1);
			__r1 = Math.min (__r1, m_submapRows-1);
			__r2 = Math.min (__r2, m_submapRows-1);
// ul
			m_XSubmaps[__r1][__c1].removeItem (__item);
// ur
			m_XSubmaps[__r1][__c2].removeItem (__item);
// ll
			m_XSubmaps[__r2][__c1].removeItem (__item);
// lr
			m_XSubmaps[__r2][__c2].removeItem (__item);
				
			m_items.remove (__item);
		}
				
//------------------------------------------------------------------------------------------
		public function getSubmapsAt (
				__x1:Number, __y1:Number,
				__x2:Number, __y2:Number
				):Array {
					
			var __c1:int, __r1:int, __c2:int, __r2:int;
	
// determine submaps that the rect straddles
			__c1 = __x1/m_submapWidth;
			__r1 = __y1/m_submapHeight;
			
			__c2 = __x2/m_submapWidth;
			__r2 = __y2/m_submapHeight;

			var __row:int, __col:int;
						
			var __submaps:Array = new Array ();
			
			__c1 = Math.max (__c1, 0);
			__c2 = Math.min (__c2, m_submapCols-1);
			__r1 = Math.max (__r1, 0);
			__r2 = Math.min (__r2, m_submapRows-1);
									
			for (__row = __r1; __row <= __r2; __row++) {
				for (__col = __c1; __col <= __c2; __col++) {
					__submaps.push ( m_XSubmaps[__row][__col] );
				}
			}
												
			return __submaps;
		}	
		
//------------------------------------------------------------------------------------------
		public function getItemsAt (
				__x1:Number, __y1:Number,
				__x2:Number, __y2:Number
				):Array {
			
			var submaps:Array = getSubmapsAt (__x1, __y1, __x2, __y2);
			
			var i:Number;
			var src_items:XDict;
			var dst_items:Array = new Array ();
			var x:*;
			var item:XMapItemModel;
			
//			trace (": ---------------------: ");	
//			trace (": getItemsAt: ");
//			trace (": ---------------------: ");
						
			for (i=0; i<submaps.length; i++) {
				src_items = submaps[i].items ();
							
				src_items.forEach (
					function (x:*):void {
						item = x as XMapItemModel;
						
						var b:XRect = item.boundingRect.cloneX ();
						b.offset (item.x, item.y);
						
						if (
							!(__x2 < b.left || __x1 > b.right ||
							  __y2 < b.top || __y1 > b.bottom)
							) {
								
							if (!(item in dst_items)) {
	//							trace (": item: ", item);
								
								dst_items.push (item);
							}
						}
					}
				);
			}
			
			return dst_items;		
		}

//------------------------------------------------------------------------------------------
		public function getItemsAtCX (
				__x1:Number, __y1:Number,
				__x2:Number, __y2:Number
				):Array {
			
			var submaps:Array = getSubmapsAt (__x1, __y1, __x2, __y2);
							
			var i:Number;
			var src_items:XDict;
			var dst_items:Array = new Array ();
			var x:*;
			var item:XMapItemModel;

			trace (": ---------------------: ");	
			trace (": getItemsAt: submaps: ", submaps.length);
			trace (": ---------------------: ");
				
			for (i=0; i<submaps.length; i++) {
				src_items = submaps[i].items ();
								
				src_items.forEach (
					function (x:*):void {
						item = x as XMapItemModel;
				
						var cx:XRect = item.collisionRect.cloneX ();
						cx.offset (item.x, item.y);
						
						if (
							!(__x2 < cx.left || __x1 > cx.right ||
							  __y2 < cx.top || __y1 > cx.bottom)
							) {
								
							if (dst_items.indexOf (item) == -1) {
								dst_items.push (item);
							}
						}
					}
				);
			}
			
			return dst_items;		
		}

//------------------------------------------------------------------------------------------
		public function getCXTiles (
			c1:Number, r1:Number,
			c2:Number, r2:Number
		):Array {
			
// tile array to return
			var tiles:Array;

// col, row divisor
			var row32:int = m_submapHeight/XSubmapModel.CX_TILE_HEIGHT;
			var col32:int = m_submapWidth/XSubmapModel.CX_TILE_WIDTH;

// col, row mask for the submap
			var rowMask:int = row32-1;
			var colMask:int = col32-1;
			
// total columns wide, rows high
			var cols:int = c2-c1+1;
			var rows:int = r2-r1+1;

			tiles = new Array (cols * rows);
			
			for (var row:int=r1; row <= r2; row++) {
				var submapRow:int = row/row32;
				
				for (var col:int=c1; col <= c2; col++) {
					var dstCol:int = col-c1, dstRow:int = row-r1;
					
					var submapCol:int = col/col32;
				
					tiles[dstRow * cols + dstCol] =
						m_XSubmaps[submapRow][submapCol].getCXTile (col & colMask, row & rowMask);
				}
			}
			
			return tiles;
		}

//------------------------------------------------------------------------------------------
		public function setCXTiles (
			tiles:Array,
			c1:Number, r1:Number,
			c2:Number, r2:Number
		):void {
// col, row divisor
			var row32:int = m_submapHeight/XSubmapModel.CX_TILE_HEIGHT;
			var col32:int = m_submapWidth/XSubmapModel.CX_TILE_WIDTH;

// col, row mask for the submap
			var rowMask:int = row32-1;
			var colMask:int = col32-1;
			
// total columns wide, rows high
			var cols:int = c2-c1+1;
			var rows:int = r2-r1+1;
	
			for (var row:int=r1; row <= r2; row++) {
				var submapRow:int = row/row32;
				
				for (var col:int=c1; col <= c2; col++) {
					var dstCol:int = col-c1, dstRow:int = row-r1;
					
					var submapCol:int = col/col32;
								
					m_XSubmaps[submapRow][submapCol].setCXTile (
						tiles[dstRow * cols + dstCol],
						col & colMask, row & rowMask
					);
				}
			}
		}
		
//------------------------------------------------------------------------------------------
		public function eraseWithCXTiles (
			tiles:Array,
			c1:Number, r1:Number,
			c2:Number, r2:Number
		):void {
// col, row divisor
			var row32:int = m_submapHeight/XSubmapModel.CX_TILE_HEIGHT;
			var col32:int = m_submapWidth/XSubmapModel.CX_TILE_WIDTH;

// col, row mask for the submap
			var rowMask:int = row32-1;
			var colMask:int = col32-1;
					
// total columns wide, rows high
			var cols:int = c2-c1+1;
			var rows:int = r2-r1+1;
	
			for (var row:int=r1; row <= r2; row++) {
				var submapRow:int = row/row32;
				
				for (var col:int=c1; col <= c2; col++) {
					var dstCol:int = col-c1, dstRow:int = row-r1;
					
					var submapCol:int = col/col32;
								
					m_XSubmaps[submapRow][submapCol].setCXTile (
						XSubmapModel.CX_EMPTY,
						col & colMask, row & rowMask
					);
				}
			}
		}
		
//------------------------------------------------------------------------------------------
		public function updateItem (__item:XMapItemModel):void {
		}
		
//------------------------------------------------------------------------------------------
		public function generateID ():Number {
			m_currID += 1;
			
			return m_currID;
		}
				
//------------------------------------------------------------------------------------------
		public function items ():XDict {
			return m_items;
		}

//------------------------------------------------------------------------------------------
		public function submaps ():Array {
			return m_XSubmaps;
		}
		
//------------------------------------------------------------------------------------------
		public function getItemId (__item:XMapItemModel):Number {
			return m_items.get (__item);
		}		

//------------------------------------------------------------------------------------------
		public function getClassNameFromIndex (__index:int):String {
			return m_classNames.getReferenceNameFromIndex (__index);
		}

//------------------------------------------------------------------------------------------
		public function getIndexFromClassName (__className:String):int {
			return m_classNames.getIndexFromReferenceName (__className);
		}

//------------------------------------------------------------------------------------------
		public function removeIndexFromClassNames (__index:int):void {
			m_classNames.removeIndexFromReferenceNames (__index);
		}

//------------------------------------------------------------------------------------------
		public function getAllClassNames ():Array {
			return m_classNames.getAllReferenceNames ();
		}

//------------------------------------------------------------------------------------------
		public function getClassNames ():XReferenceNameToIndex {
			return m_classNames;
		}

//------------------------------------------------------------------------------------------
		public function getImageClassNames ():XDict {
			return m_imageClassNames;
		}

//------------------------------------------------------------------------------------------
		public function lookForItem (__itemName:String):Array {
			var __row:Number, __col:Number;
			var __list:Array = new Array ();
			
			for (__row=0; __row<m_submapRows; __row++) {
				for (__col=0; __col<m_submapCols; __col++) {
					m_XSubmaps[__row][__col].items ().forEach (
						function (x:*):void {
							var __item:XMapItemModel = x as XMapItemModel;
							
							if (__item.XMapItem == __itemName) {
								__list.push (__item);
							}
						}
					);
				}
			}
			
			return __list;	
		}
		
//------------------------------------------------------------------------------------------
		public function serialize (__xml:XSimpleXMLNode):XSimpleXMLNode {
			var __attribs:Array = [
				"vx",			viewPort.x,
				"vy",			viewPort.y,
				"vw",			viewPort.width,
				"vh",			viewPort.height,
				"layer",		m_layer,
				"submapRows",	m_submapRows,
				"submapCols",	m_submapCols,
				"submapWidth",	m_submapWidth,
				"submapHeight",	m_submapHeight,
				"currID",		m_currID,
				"visible", 		m_visible,
				"name",			m_name,
				"grid", 		m_grid,
			];

			__xml = __xml.addChildWithParams ("XLayer", "", __attribs);
	
			__xml.addChildWithXMLNode (serializeImageClassNames ());
			__xml.addChildWithXMLNode (m_classNames.serialize ());
			__xml.addChildWithXMLNode (serializeItems ());
			__xml.addChildWithXMLNode (serializeSubmaps ());

			return __xml;
		}

//------------------------------------------------------------------------------------------
		public function serializeItems ():XSimpleXMLNode {
			var xml:XSimpleXMLNode = new XSimpleXMLNode ();
			
			xml.setupWithParams ("items", "", []);
		
			return xml;
		}
		
//------------------------------------------------------------------------------------------
		public function serializeSubmaps ():XSimpleXMLNode {
			var xml:XSimpleXMLNode = new XSimpleXMLNode ();
			
			xml.setupWithParams ("XSubmaps", "", []);
			
			var __row:Number, __col:Number;
			var __x1:Number, __y1:Number, __x2:Number, __y2:Number;
			
			cullUnneededItems ();
			
			for (__row=0; __row<m_submapRows; __row++) {
				__y1 = __row * m_submapHeight;
				__y2 = __y1 + m_submapHeight-1;
				
				for (__col=0; __col<m_submapCols; __col++) {
					__x1 = __col * m_submapWidth;
					__x2 = __x1 + m_submapWidth-1;
					
					var submaps:Array = getSubmapsAt (__x1, __y1, __x2, __y2);
					
					if (submaps.length == 1) {
						var submap:XSubmapModel = submaps[0] as XSubmapModel;
						
						if (submapIsNotEmpty (submap)) {
							xml.addChildWithXMLNode (submap.serializeRowCol (__row, __col));
						}
					}
				}
			}
			
			return xml;
		}

//------------------------------------------------------------------------------------------
		public function serializeImageClassNames ():XSimpleXMLNode {
			var __imageClassNames:XDict = new XDict ();
			
			var __row:Number, __col:Number;
			
			for (__row=0; __row<m_submapRows; __row++) {
				for (__col=0; __col<m_submapCols; __col++) {
					m_XSubmaps[__row][__col].items ().forEach (
						function (__item:*):void {
							__imageClassNames.put (__item.imageClassName, 0);
						}
					);
				}
			}
	
			var __xml:XSimpleXMLNode = new XSimpleXMLNode ();		
			__xml.setupWithParams ("imageClassNames", "", []);
					
			__imageClassNames.forEach (
				function (__imageClassName:*):void {
					var __attribs:Array = [
						"name",	__imageClassName as String,					
					];
					
					var __className:XSimpleXMLNode = new XSimpleXMLNode ();				
					__className.setupWithParams ("imageClassName", "", __attribs);
					__xml.addChildWithXMLNode (__className);
				}
			);
			
			return __xml;
		}
		
//------------------------------------------------------------------------------------------
		public function submapIsNotEmpty (submap:XSubmapModel):Boolean {
			var count:Number = 0;
					
			submap.items ().forEach (
				function (x:*):void {	
					count++;
				}
			);
			
			return count > 0 || submap.hasCXTiles ();
		}

//------------------------------------------------------------------------------------------
		public function deserialize (__xml:XSimpleXMLNode):void {
			trace (": [XMapLayer]: deserialize: ");
			
			m_viewPort = new XRect (
				__xml.getAttribute ("vx"),
				__xml.getAttribute ("vy"),
				__xml.getAttribute ("vw"),
				__xml.getAttribute ("vh")
			);
			
			m_layer = __xml.getAttribute ("layer");
			m_submapRows = __xml.getAttribute ("submapRows");
			m_submapCols = __xml.getAttribute ("submapCols");
			m_submapWidth = __xml.getAttribute ("submapWidth");
			m_submapHeight = __xml.getAttribute ("submapHeight");
			m_currID = __xml.getAttribute ("currID");
			if (__xml.hasAttribute ("visible")) {
				m_visible = __xml.getAttribute ("visible");
			}
			else
			{
				m_visible = true;
			}
			if (__xml.hasAttribute ("name")) {
				m_name = __xml.getAttribute ("name");
			}
			else
			{
				m_name = "";
			}
			if (__xml.hasAttribute ("grid")) {
				m_grid = __xml.getAttribute ("grid");
			}
			else
			{
				m_grid = false;
			}	
			m_classNames = new XReferenceNameToIndex ();
			m_imageClassNames = new XDict ();			

			m_items = new XDict ();
			m_XSubmaps = new Array (m_submapRows);
			
			deserializeImageClassNames (__xml);
			m_classNames.deserialize (__xml);
			deserializeItems (__xml);
			deserializeSubmaps (__xml);
		}
	
//------------------------------------------------------------------------------------------
		public function deserializeItems (__xml:XSimpleXMLNode):void {
		}
		
//------------------------------------------------------------------------------------------
		public function deserializeSubmaps (__xml:XSimpleXMLNode):void {
			trace (": [XMapLayer]: deserializeSubmaps: ");
			
//------------------------------------------------------------------------------------------	
			var __row:Number;
			var __col:Number;
			
			for (__row=0; __row<m_submapRows; __row++) {
				m_XSubmaps[__row] = new Array (m_submapCols);

				for (__col=0; __col<m_submapCols; __col++) {
					m_XSubmaps[__row][__col] = new XSubmapModel (this, __col,__row, m_submapWidth, m_submapHeight);
				}
			}
		
//------------------------------------------------------------------------------------------	
			var __xmlList:Array;
			var i:Number;
			
			__xmlList = __xml.child ("XSubmaps")[0].child ("XSubmap");
				
			for (i=0; i<__xmlList.length; i++) {
				var __submapXML:XSimpleXMLNode = __xmlList[i];
				
				__row = __submapXML.getAttribute ("row");
				__col = __submapXML.getAttribute ("col");
					
				m_XSubmaps[__row][__col].deserializeRowCol (__submapXML);
			}
	
//------------------------------------------------------------------------------------------	
// add items to the layer's dictionary
//------------------------------------------------------------------------------------------
			for (__row=0; __row<m_submapRows; __row++) {
				for (__col=0; __col<m_submapCols; __col++) {
					m_XSubmaps[__row][__col].items ().forEach (
						function (__item:*):void {
							m_items.put (__item, __item.id);
						}
					);
				}
			}

//------------------------------------------------------------------------------------------
			cullUnneededItems ();
		}

//------------------------------------------------------------------------------------------
		public function deserializeImageClassNames (__xml:XSimpleXMLNode):void {
			if (__xml.child ("imageClassNames").length == 0) {
				return;
			}

			var __xmlList:Array = __xml.child ("imageClassNames")[0].child ("imageClassName");

			var __name:String;	
			var i:Number;
		
			for (i=0; i<__xmlList.length; i++) {
				__name = __xmlList[i].getAttribute ("name");
				
				trace (": deserializeImageClassName: ", __name);
				
				m_imageClassNames.put (__name, 0);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function cullUnneededItems ():void {
			var __row:Number;
			var __col:Number;
			var __submapRect:XRect; 
										
			for (__row=0; __row<m_submapRows; __row++) {
				for (__col=0; __col<m_submapCols; __col++) {
					__submapRect = new XRect (
						__col * m_submapWidth, __row * m_submapHeight,
						m_submapWidth, m_submapHeight
					);
							
					m_XSubmaps[__row][__col].items ().forEach (
						function (__item:*):void {			
							var __itemRect:XRect = __item.boundingRect.cloneX ();
							__itemRect.offset (__item.x, __item.y);
							
							trace (": submapRect, itemRect: ", __item.id, __submapRect, __itemRect, __submapRect.intersects (__itemRect));
							
							if (!__submapRect.intersects (__itemRect)) {
								m_XSubmaps[__row][__col].removeItem (__item);
							}
						}
					);
				}
			}		
		}
			
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
