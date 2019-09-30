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
	import kx.type.*;
	import kx.utils.*;
	import kx.world.collision.*;
	import kx.xmap.*;
	import kx.xml.*;
			
//------------------------------------------------------------------------------------------	
	public class XMapLayerModel extends XModelBase {
		private var m_XMap:XMapModel;
		
		private var m_layer:int;
		
		private var m_XSubmaps:Vector.<Vector.<XSubmapModel>>;
		
		private var m_submapRows:int;
		private var m_submapCols:int;
		private var m_submapWidth:int;
		private var m_submapHeight:int;
		
		private var m_currID:int;

		private var m_items:XDict; // <XMapItemModel, Int>
		private var m_ids:XDict; // <Int, XMapItemModel>

		private var m_classNames:XReferenceNameToIndex;
		private var m_imageClassNames:XDict; // <String, Int>
		
		private var m_viewPort:XRect;
		private var m_startingViewPort:XRect;
		
		private var m_visible:Boolean;
		private var m_scale:Number;
		private var m_regX:Number;
		private var m_regY:Number;
		private var m_name:String;
		private var m_grid:Boolean;
		
		private var m_itemInuse:XDict; // <Int, Int>
		
		private var m_persistentStorage:XDict; // <Int, Dynamic>

		private var m_retrievedSubmaps:Array; // <XSubmapModel>
		private var m_retrievedItems:Array; // <XMapItemModel>
		
//------------------------------------------------------------------------------------------	
		public function XMapLayerModel () {
			super ();
		}	

//------------------------------------------------------------------------------------------
		public function setup (
			__layer:int,
			__submapCols:int, __submapRows:int,
			__submapWidth:int, __submapHeight:int
			):void {

			var i:int;
			
			var __row:int;
			var __col:int;

			m_submapRows = __submapRows;
			m_submapCols = __submapCols;
			m_submapWidth = __submapWidth;
			m_submapHeight = __submapHeight;

			m_currID = 0;
			m_items = new XDict ();  // <XMapItemModel, Int>
			m_ids = new XDict ();  // <Int, XMapItemModel>
			m_layer = __layer;
			m_XSubmaps = new Vector.<Vector.<XSubmapModel>> ();
			for (i = 0; i < __submapRows; i++) {
				m_XSubmaps.push (null);
			}
			m_visible = true;
			m_scale = 1.0;
			m_regX = 0.0;
			m_regY = 0.0;
			m_name = "layer" + __layer;
			m_grid = false;
			m_retrievedSubmaps = new Array (); // <XSubmapModel>
			m_retrievedItems = new Array (); // <XMapItemModel>
	
			for (__row=0; __row<__submapRows; __row++) {
				m_XSubmaps[__row] = new Vector.<XSubmapModel> ();
				for (i = 0; i < __submapCols; i++) {
					m_XSubmaps[__row].push (null);
				}
				
				for (__col=0; __col<__submapCols; __col++) {
					m_XSubmaps[__row][__col] = new XSubmapModel (this, __col, __row, m_submapWidth, m_submapHeight);
				}
			}
			
			m_persistentStorage = new XDict ();  // <Int, Dynamic>
			
			m_classNames = new XReferenceNameToIndex ();
			m_imageClassNames = new XDict ();  // <String, Int>
			
			m_itemInuse = new XDict ();  // <Int, Int>
			
			m_viewPort = new XRect ();
			m_startingViewPort = new XRect ();
		}

//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}

//------------------------------------------------------------------------------------------
		public function setParent (__XMap:XMapModel):void {
			m_XMap = __XMap;
		}

//------------------------------------------------------------------------------------------
		public function getXMapModel ():XMapModel {
			return m_XMap;
		}

//------------------------------------------------------------------------------------------
		/* @:get, set useArrayItems Bool */
		
		public function get useArrayItems ():Boolean {
			return m_XMap.useArrayItems;
		}
		
		public function set useArrayItems (__val:Boolean): /* @:set_type */ void {
			/* @:set_return true; */			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		public function setViewPort (__viewPort:XRect):void {
			m_viewPort = __viewPort;
		}
		
//------------------------------------------------------------------------------------------
		public function getStartingViewPort ():XRect {
			return m_startingViewPort;
		}
		
//------------------------------------------------------------------------------------------
		/* @:get, set viewPort XRect */
		
		public function get viewPort ():XRect {
			return m_viewPort;
		}
		
		public function set viewPort (__val:XRect): /* @:set_type */ void {
			m_viewPort = __val;
			
			/* @:set_return __val; */			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		/* @:get, set visible Bool */
		
		public function get visible ():Boolean {
			return m_visible;
		}

		public function set visible (__val:Boolean): /* @:set_type */ void {
			m_visible = __val;
			
			/* @:set_return __val; */			
		}
		/* @:end */
	
//------------------------------------------------------------------------------------------
		/* @:get, set scale Float */
		
		public function get scale ():Number {
			return m_scale;
		}
		
		public function set scale (__val:Number): /* @:set_type */ void {
			m_scale = __val;
			
			/* @:set_return __val; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set regX Float */
		
		public function get regX ():Number {
			return m_regX;
		}
		
		public function set regX (__val:Number): /* @:set_type */ void {
			m_regX = __val;
			
			/* @:set_return __val; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set regY Float */
		
		public function get regY ():Number {
			return m_regY;
		}
		
		public function set regY (__val:Number): /* @:set_type */ void {
			m_regY = __val;
			
			/* @:set_return __val; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set name String */
		
		public function get name ():String {
			return m_name;
		}

		public function set name (__val:String): /* @:set_type */ void {
			m_name = __val;
			
			/* @:set_return __val; */			
		}
		/* @:end */
	
//------------------------------------------------------------------------------------------
		/* @:get, set grid Bool */
		
		public function get grid ():Boolean {
			return m_grid;
		}

		public function set grid (__val:Boolean): /* @:set_type */ void {
			m_grid = __val;
			
			/* @:set_return __val; */			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		public function getPersistentStorage ():XDict /* <Int, Dynamic> */ {
			return m_persistentStorage;
		}
		
//------------------------------------------------------------------------------------------
		public function getSubmapRows ():int {
			return m_submapRows;
		}
		
//------------------------------------------------------------------------------------------
		public function getSubmapCols ():int {
			return m_submapCols;
		}
		
//------------------------------------------------------------------------------------------
		public function getSubmapWidth ():int {
			return m_submapWidth;
		}	
		
//------------------------------------------------------------------------------------------
		public function getSubmapHeight ():int {
			return m_submapHeight;
		}
	
//------------------------------------------------------------------------------------------
		public function getItemInuse (__id:int):int {
			/*
			if (m_itemInuse[__id] == null) {
				m_itemInuse[__id] = 0;
			}

			return m_itemInuse[__id];
			*/
			
			if (!m_itemInuse.exists (__id)) {
				m_itemInuse.set (__id, 0);
			}
			
			return m_itemInuse.get (__id);
		}
		
//------------------------------------------------------------------------------------------
		public function setItemInuse (__id:int, __inuse:int):void {
			/*
			if (m_itemInuse[__id] == null) {
				m_itemInuse[__id] = 0;
			}
			
			if (__inuse == 0) {
				delete m_itemInuse[__id];
			}
			else
			{
				m_itemInuse[__id] = __inuse;
			}
			*/
			
			if (!m_itemInuse.exists (__id)) {
				m_itemInuse.set (__id, 0);
			}
			
			if (__inuse == 0) {
				m_itemInuse.remove (__id);
			}
			else
			{
				m_itemInuse.set (__id, __inuse);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function addItem (__item:XMapItemModel):XMapItemModel {
			var __c1:int, __r1:int, __c2:int, __r2:int;
			
			var __id:int = __item.getID ();
			
			if (__id == -1) {
// obtain unique ID for this item			
				__id = generateID ();
				
				__item.setID (__id);
			}
			
			var r:XRect = __item.boundingRect.cloneX ();
			r.offset (__item.x, __item.y);
			
// determine submaps that the item straddles
			__c1 = int (r.left/m_submapWidth);
			__r1 = int (r.top/m_submapHeight);
			
			__c2 = int (r.right/m_submapWidth);
			__r2 = int (r.bottom/m_submapHeight);

			trace (": -----------------------: ");
			trace (": XXMapLayerModel: addItem: ", __id);
			trace (": x, y: ", __item.x, __item.y);
			trace (": ", r.left, r.top, r.right, r.bottom);
			trace (": ", __c1, __r1, __c2, __r2);
			
			__c1 = XType.max (__c1, 0);
			__c2 = XType.max (__c2, 0);
			__r1 = XType.max (__r1, 0);
			__r2 = XType.max (__r2, 0);
			
			__c1 = XType.min (__c1, m_submapCols-1);
			__c2 = XType.min (__c2, m_submapCols-1);
			__r1 = XType.min (__r1, m_submapRows-1);
			__r2 = XType.min (__r2, m_submapRows-1);
			
			/*
// ul
			m_XSubmaps[__r1][__c1].addItem (__item);
// ur
			m_XSubmaps[__r1][__c2].addItem (__item);
// ll
			m_XSubmaps[__r2][__c1].addItem (__item);
// lr
			m_XSubmaps[__r2][__c2].addItem (__item);
			*/
			
			var __r:int;
			var __c:int;
			
			for (__r = __r1; __r <= __r2; __r++) {
				for (__c = __c1; __c <= __c2; __c++) {
					m_XSubmaps[__r][__c].addItem (__item);
				}
			}
			
			trackItem (__item);
			
			return __item;
		}

//------------------------------------------------------------------------------------------
		public function replaceItems (__item:XMapItemModel):Array /* <XMapItemModel> */ {
			var __c1:int, __r1:int, __c2:int, __r2:int;
			
			var __id:int = __item.getID ();
			
			if (__id == -1) {
				// obtain unique ID for this item			
				__id = generateID ();
				
				__item.setID (__id);
			}
			
			var __removedItems:Array /* <XMapItemModel> */ = new Array (); // <XMapItemModel>
			
			var r:XRect = __item.boundingRect.cloneX ();
			r.offset (__item.x, __item.y);
			
			// determine submaps that the item straddles
			__c1 = int (r.left/m_submapWidth);
			__r1 = int (r.top/m_submapHeight);
			
			__c2 = int (r.right/m_submapWidth);
			__r2 = int (r.bottom/m_submapHeight);
			
			trace (": -----------------------: ");
			trace (": XXMapLayerModel: replaceItems: ", __id);
			trace (": x, y: ", __item.x, __item.y);
			trace (": ", r.left, r.top, r.right, r.bottom);
			trace (": ", __c1, __r1, __c2, __r2);
			
			__c1 = XType.max (__c1, 0);
			__c2 = XType.max (__c2, 0);
			__r1 = XType.max (__r1, 0);
			__r2 = XType.max (__r2, 0);
			
			__c1 = XType.min (__c1, m_submapCols-1);
			__c2 = XType.min (__c2, m_submapCols-1);
			__r1 = XType.min (__r1, m_submapRows-1);
			__r2 = XType.min (__r2, m_submapRows-1);
			
			function __extend (__items:Array /* <XMapItemModel> */):void {
				var __item:XMapItemModel;
				
				var i:int;
				
				//				for each (var __item:XMapItemModel in __items) {
				for (i=0; i<__items.length; i++) {
					__item = __items[i] as XMapItemModel;
					
					if (__removedItems.indexOf (__item) == -1) {
						__removedItems.push (__item);
					}
				}
			}
			
			// ul
			__extend (m_XSubmaps[__r1][__c1].replaceItems (__item));
			// ur
			__extend (m_XSubmaps[__r1][__c2].replaceItems (__item));
			// ll
			__extend (m_XSubmaps[__r2][__c1].replaceItems (__item));
			// lr
			__extend (m_XSubmaps[__r2][__c2].replaceItems (__item));
			
			trackItem (__item);
			
			return __removedItems;
		}
		
//------------------------------------------------------------------------------------------
		public function removeItem (__item:XMapItemModel):void {		
//			if (!m_items.exists (__item)) {
//				return;
//			}
			
			var __c1:int, __r1:int, __c2:int, __r2:int;
		
			var r:XRect = __item.boundingRect.cloneX ();
			r.offset (__item.x, __item.y);
			
// determine submaps that the item straddles
			__c1 = int (r.left/m_submapWidth);
			__r1 = int (r.top/m_submapHeight);
			
			__c2 = int (r.right/m_submapWidth);
			__r2 = int (r.bottom/m_submapHeight);

			__c1 = XType.max (__c1, 0);
			__c2 = XType.max (__c2, 0);
			__r1 = XType.max (__r1, 0);
			__r2 = XType.max (__r2, 0);
			
			__c1 = XType.min (__c1, m_submapCols-1);
			__c2 = XType.min (__c2, m_submapCols-1);
			__r1 = XType.min (__r1, m_submapRows-1);
			__r2 = XType.min (__r2, m_submapRows-1);
			
			/*
// ul
			m_XSubmaps[__r1][__c1].removeItem (__item);
// ur
			m_XSubmaps[__r1][__c2].removeItem (__item);
// ll
			m_XSubmaps[__r2][__c1].removeItem (__item);
// lr
			m_XSubmaps[__r2][__c2].removeItem (__item);
			*/
	
			var __r:int;
			var __c:int;
			
			for (__r = __r1; __r <= __r2; __r++) {
						for (__c = __c1; __c <= __c2; __c++) {
					m_XSubmaps[__r][__c].removeItem (__item);
				}
			}
			
			untrackItem (__item);
		}
				
//------------------------------------------------------------------------------------------
		public function addItemAsTile (__item:XMapItemModel):void {
			var __c:int = int (__item.x / m_submapWidth);
			var __r:int = int (__item.y / m_submapHeight);
			
			m_XSubmaps[__r][__c].addItemAsTile (__item);
		}
		
//------------------------------------------------------------------------------------------
		public function getSubmapsAt (
				__x1:Number, __y1:Number,
				__x2:Number, __y2:Number
				):Array /* <XSubmapModel> */ {
					
			var __c1:int, __r1:int, __c2:int, __r2:int;
	
// determine submaps that the rect straddles
			__c1 = int (__x1/m_submapWidth);
			__r1 = int (__y1/m_submapHeight);
			
			__c2 = int (__x2/m_submapWidth);
			__r2 = int (__y2/m_submapHeight);

			var __row:int, __col:int;
						
//			var __submaps:Array = new Array ();
//			m_retrievedSubmaps.length = 0;
			XType.clearArray (m_retrievedSubmaps);
			
			__c1 = XType.max (__c1, 0);
			__c2 = XType.min (__c2, m_submapCols-1);
			__r1 = XType.max (__r1, 0);
			__r2 = XType.min (__r2, m_submapRows-1);
									
			var push:int = 0;
			
			for (__row = __r1; __row <= __r2; __row++) {
				for (__col = __c1; __col <= __c2; __col++) {
					m_retrievedSubmaps[push++] = ( m_XSubmaps[__row][__col] );
				}
			}
												
			return m_retrievedSubmaps;
		}	
		
//------------------------------------------------------------------------------------------
		public function getItemsAt (
				__x1:Number, __y1:Number,
				__x2:Number, __y2:Number
				):Array /* <XMapItemModel> */ {
			
			if (useArrayItems) {
				return getArrayItemsAt (__x1, __y1, __x2, __y2);
			}
			
			var submaps:Array /* <XSubmapModel> */ = getSubmapsAt (__x1, __y1, __x2, __y2);
			
			var i:int;
			var src_items:XDict;  // <XMapItemModel, Int>
//			var dst_items:Array = new Array ();
//			m_retrievedItems.length = 0;
			XType.clearArray (m_retrievedItems);
			var x:*;
			var item:XMapItemModel;
			
			var __x:Number, __y:Number;
			var b:XRect;
						
			var push:int= 0;
			
			for (i=0; i<submaps.length; i++) {
				src_items = submaps[i].items ();
											
				src_items.forEach (
					function (x:*):void {
						item = x as XMapItemModel;
						
						b = item.boundingRect; __x = item.x; __y = item.y;
						
						if (
							!(__x2 < b.left + __x || __x1 > b.right + __x ||
							  __y2 < b.top + __y || __y1 > b.bottom + __y)
							) {
								
//							if (!(item in dst_items)) {
								m_retrievedItems[push++] = (item);
//							}
						}
					}
				);
			}
			
			return m_retrievedItems;		
		}

//------------------------------------------------------------------------------------------
		public function getArrayItemsAt (
			__x1:Number, __y1:Number,
			__x2:Number, __y2:Number
		):Array /* <XMapItemModel> */ {
			
			var submaps:Array /* <XSubmapModel> */ = getSubmapsAt (__x1, __y1, __x2, __y2);
			
			var i:int;
			var src_items:Vector.<XMapItemModel>;
//			var dst_items:Array = new Array ();
//			m_retrievedItems.length = 0;
			XType.clearArray (m_retrievedItems);
			var item:XMapItemModel;
			
			var __length:int;
			var __x:Number, __y:Number;
			var b:XRect;
			
			var push:int = 0;
			
			for (i=0; i<submaps.length; i++) {
				src_items = submaps[i].arrayItems ();
				
				__length = src_items.length;
				
				for (var x:int = 0; x<__length; x++) {
					item = src_items[x];
						
					b = item.boundingRect; __x = item.x; __y = item.y;
						
					if (
						!(__x2 < b.left + __x || __x1 > b.right + __x ||
						__y2 < b.top + __y || __y1 > b.bottom + __y)
					) {
							
//						if (!(item in dst_items)) {
							m_retrievedItems[push++] = (item);
//						}
					}
				}
			}
			
			return m_retrievedItems;		
		}
		
//------------------------------------------------------------------------------------------
		public function getItemsAtCX (
				__x1:Number, __y1:Number,
				__x2:Number, __y2:Number
				):Array /* <XMapItemModel> */ {
			
			if (useArrayItems) {
				return getArrayItemsAtCX (__x1, __y1, __x2, __y2);
			}
			
			__x2--; __y2--;
			
			var submaps:Array /* <XSubmapModel> */ = getSubmapsAt (__x1, __y1, __x2, __y2);
							
			var i:int;
			var src_items:XDict;  // <XMapItemModel, Int>
			var dst_items:Array /* <XMapItemModel> */ = new Array () /* <XMapItemModel> */ ;
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
							!(__x2 < cx.left || __x1 > cx.right - 1 ||
							  __y2 < cx.top || __y1 > cx.bottom - 1)
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
		public function getArrayItemsAtCX (
			__x1:Number, __y1:Number,
			__x2:Number, __y2:Number
		):Array /* <XMapItemModel> */ {
			
			__x2--; __y2--;
			
			var submaps:Array /* <XSubmapModel> */ = getSubmapsAt (__x1, __y1, __x2, __y2);
			
			var i:int;
			var src_items:Vector.<XMapItemModel>;
			var dst_items:Array /* <XMapItemModel> */ = new Array () /* <XMapItemModel> */;
			var item:XMapItemModel;

			var __length:int;
			
			trace (": ---------------------: ");	
			trace (": getItemsAt: submaps: ", submaps.length);
			trace (": ---------------------: ");
			
			for (i=0; i<submaps.length; i++) {
				src_items = submaps[i].arrayItems ();
				
				__length = src_items.length;
				
				for (var x:int = 0; x<__length; x++) {	
					item = src_items[x];
					
					var cx:XRect = item.collisionRect.cloneX ();
					cx.offset (item.x, item.y);
						
					if (
						!(__x2 < cx.left || __x1 > cx.right - 1 ||
						__y2 < cx.top || __y1 > cx.bottom - 1)
					) {
							
						if (dst_items.indexOf (item) == -1) {
							dst_items.push (item);
						}
					}
				}
			}
			
			return dst_items;		
		}
		
//------------------------------------------------------------------------------------------
		public function getTiles (
			c1:int, r1:int,
			c2:int, r2:int
		):Vector.<Array> {
			
			// tile array to return
			var tiles:Vector.<Array>;
			
			// col, row divisor
			var row8:int = int (m_submapHeight/XSubmapModel.TX_TILE_HEIGHT);
			var col8:int = int (m_submapWidth/XSubmapModel.TX_TILE_WIDTH);
			
			// col, row mask for the submap
			var rowMask:int = int (row8-1);
			var colMask:int = int (col8-1);
			
			// total columns wide, rows high
			var cols:int = c2-c1+1;
			var rows:int = r2-r1+1;
			
			tiles = new Vector.<Array> ();
			for (var i:int = 0; i < cols * rows; i++) {
				tiles.push ([-1, 0]);
			}
			
			for (var row:int=r1; row <= r2; row++) {
				var submapRow:int = int (row/row8);
				
				for (var col:int=c1; col <= c2; col++) {
					var dstCol:int = col-c1, dstRow:int = row-r1;
					
					var submapCol:int = int (col/col8);
					
					tiles[dstRow * cols + dstCol] =
						m_XSubmaps[submapRow][submapCol].getTile (col & colMask, row & rowMask);
				}
			}
			
			return tiles;
		}
		
//------------------------------------------------------------------------------------------
		public function setTiles (
			tiles:Vector.<Array>,
			c1:int, r1:int,
			c2:int, r2:int
		):void {
			// col, row divisor
			var row8:int = int (m_submapHeight/XSubmapModel.TX_TILE_HEIGHT);
			var col8:int = int (m_submapWidth/XSubmapModel.TX_TILE_WIDTH);
			
			// col, row mask for the submap
			var rowMask:int = int (row8-1);
			var colMask:int = int (col8-1);
			
			// total columns wide, rows high
			var cols:int = c2-c1+1;
			var rows:int = r2-r1+1;
			
			for (var row:int=r1; row <= r2; row++) {
				var submapRow:int = int (row/row8);
				
				for (var col:int=c1; col <= c2; col++) {
					var dstCol:int = col-c1, dstRow:int = row-r1;
					
					var submapCol:int = int (col/col8);
					
					m_XSubmaps[submapRow][submapCol].setTile (
						tiles[dstRow * cols + dstCol],
						col & colMask, row & rowMask
					);
				}
			}
		}
		
		//------------------------------------------------------------------------------------------
		public function eraseWithTiles (
			tiles:Vector.<Array>,
			c1:int, r1:int,
			c2:int, r2:int
		):void {
			// col, row divisor
			var row8:int = int (m_submapHeight/XSubmapModel.TX_TILE_HEIGHT);
			var col8:int = int (m_submapWidth/XSubmapModel.TX_TILE_WIDTH);
			
			// col, row mask for the submap
			var rowMask:int = int (row8-1);
			var colMask:int = int (col8-1);
			
			// total columns wide, rows high
			var cols:int = c2-c1+1;
			var rows:int = r2-r1+1;
			
			for (var row:int=r1; row <= r2; row++) {
				var submapRow:int = int (row/row8);
				
				for (var col:int=c1; col <= c2; col++) {
					var dstCol:int = col-c1, dstRow:int = row-r1;
					
					var submapCol:int = int (col/col8);
					
					m_XSubmaps[submapRow][submapCol].setTile (
						[-1, 0],
						col & colMask, row & rowMask
					);
				}
			}
		}
		
//------------------------------------------------------------------------------------------
		public function getCXTiles (
			c1:int, r1:int,
			c2:int, r2:int
		):Array /* <Int> */ {
			
// tile array to return
			var tiles:Array; // <Int>

// col, row divisor
			var row32:int = int (m_submapHeight/XSubmapModel.CX_TILE_HEIGHT);
			var col32:int = int (m_submapWidth/XSubmapModel.CX_TILE_WIDTH);

// col, row mask for the submap
			var rowMask:int = int (row32-1);
			var colMask:int = int (col32-1);
			
// total columns wide, rows high
			var cols:int = c2-c1+1;
			var rows:int = r2-r1+1;

			tiles = new Array (); // <Int>
			for (var i:int = 0; i < cols * rows; i++) {
				tiles.push (0);
			}
			
			for (var row:int=r1; row <= r2; row++) {
				var submapRow:int = int (row/row32);
				
				for (var col:int=c1; col <= c2; col++) {
					var dstCol:int = col-c1, dstRow:int = row-r1;
					
					var submapCol:int = int (col/col32);
				
					tiles[dstRow * cols + dstCol] =
						m_XSubmaps[submapRow][submapCol].getCXTile (col & colMask, row & rowMask);
				}
			}
			
			return tiles;
		}

//------------------------------------------------------------------------------------------
		public function setCXTiles (
			tiles:Array /* <Int> */,
			c1:int, r1:int,
			c2:int, r2:int
		):void {
// col, row divisor
			var row32:int = int (m_submapHeight/XSubmapModel.CX_TILE_HEIGHT);
			var col32:int = int (m_submapWidth/XSubmapModel.CX_TILE_WIDTH);

// col, row mask for the submap
			var rowMask:int = int (row32-1);
			var colMask:int = int (col32-1);
			
// total columns wide, rows high
			var cols:int = c2-c1+1;
			var rows:int = r2-r1+1;
	
			for (var row:int=r1; row <= r2; row++) {
				var submapRow:int = int (row/row32);
				
				for (var col:int=c1; col <= c2; col++) {
					var dstCol:int = col-c1, dstRow:int = row-r1;
					
					var submapCol:int = int (col/col32);
								
					m_XSubmaps[submapRow][submapCol].setCXTile (
						tiles[dstRow * cols + dstCol],
						col & colMask, row & rowMask
					);
				}
			}
		}
		
//------------------------------------------------------------------------------------------
		public function eraseWithCXTiles (
			tiles:Array /* <Int> */,
			c1:int, r1:int,
			c2:int, r2:int
		):void {
// col, row divisor
			var row32:int = int (m_submapHeight/XSubmapModel.CX_TILE_HEIGHT);
			var col32:int = int (m_submapWidth/XSubmapModel.CX_TILE_WIDTH);

// col, row mask for the submap
			var rowMask:int = int (row32-1);
			var colMask:int = int (col32-1);
					
// total columns wide, rows high
			var cols:int = c2-c1+1;
			var rows:int = r2-r1+1;
	
			for (var row:int=r1; row <= r2; row++) {
				var submapRow:int = int (row/row32);
				
				for (var col:int=c1; col <= c2; col++) {
					var dstCol:int = col-c1, dstRow:int = row-r1;
					
					var submapCol:int = int (col/col32);
								
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
		public function generateID ():int {
			m_currID += 1;
			
			return m_currID;
		}
				
//------------------------------------------------------------------------------------------
		public function items0 ():XDict /* <XMapItemModel, Int> */ {
			return m_items;
		}
		
//------------------------------------------------------------------------------------------
		public function ids ():XDict /* <Int, XMapItemModel> */ {
			return m_ids;
		}
		
//------------------------------------------------------------------------------------------
		public function submaps ():Vector.<Vector.<XSubmapModel>> {
			return m_XSubmaps;
		}
		
//------------------------------------------------------------------------------------------
		public function ___getItemId___ (__item:XMapItemModel):int {
			return m_items.get (__item);
		}	
		
//------------------------------------------------------------------------------------------
		public function ___getIdItem___ (__id:int):XMapItemModel {
			return m_ids.get (__id);
		}

//------------------------------------------------------------------------------------------
		public function trackItem (__item:XMapItemModel):void {
			m_items.set (__item, __item.id);
			m_ids.set (__item.id, __item);
		}
		
//------------------------------------------------------------------------------------------
		public function untrackItem (__item:XMapItemModel):void {
			m_items.remove (__item);
			m_ids.remove (__item.id);
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
		public function getAllClassNames ():Array /* <String> */ {
			return m_classNames.getAllReferenceNames ();
		}

//------------------------------------------------------------------------------------------
		public function getClassNames ():XReferenceNameToIndex {
			return m_classNames;
		}

//------------------------------------------------------------------------------------------
		public function getImageClassNames ():XDict /* <String, Int> */ {
			return m_imageClassNames;
		}

//------------------------------------------------------------------------------------------
		public function lookForItem (__itemName:String, __list:XDict=null):XDict /* <Int, XMapItemModel> */ {
			var __row:int, __col:int;
			
			if (__list == null) {
				__list = new XDict (); // <Int, XMapItemModel>
			}
		
			for (__row=0; __row<m_submapRows; __row++) {
				for (__col=0; __col<m_submapCols; __col++) {
					m_XSubmaps[__row][__col].iterateAllItems (
						function (x:*):void {
							var __item:XMapItemModel = x as XMapItemModel;
								
							if (__item.XMapItem == __itemName) {
								__list.set (__item.id, __item);
							}
						}
					);
				}
			}
			
			return __list;	
		}

//------------------------------------------------------------------------------------------
		public function iterateAllSubmaps (__iterationCallback:Function):void {
			var __row:int, __col:int;
			
			for (__row=0; __row<m_submapRows; __row++) {
				for (__col=0; __col<m_submapCols; __col++) {
					__iterationCallback (m_XSubmaps[__row][__col], __row, __col);
				}
			}				
		}
		
//------------------------------------------------------------------------------------------
		public function serialize (__xml:XSimpleXMLNode):XSimpleXMLNode {
			var __attribs:Array /* <Dynamic> */ = [
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
				"scale",		m_scale,
				"regX",			m_regX,
				"regY",			m_regY,
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
					
					var submaps:Array /* <XSubmapModel> */ = getSubmapsAt (__x1, __y1, __x2, __y2);
					
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
			var __imageClassNames:XDict /* <String, Int> */ = new XDict (); // <String, Int>
			
			var __row:Number, __col:Number;
			
			for (__row=0; __row<m_submapRows; __row++) {
				for (__col=0; __col<m_submapCols; __col++) {
					m_XSubmaps[__row][__col].items ().forEach (
						function (__item:XMapItemModel):void {
							__imageClassNames.set (__item.imageClassName, 0);
						}
					);
				}
			}
	
			var __xml:XSimpleXMLNode = new XSimpleXMLNode ();		
			__xml.setupWithParams ("imageClassNames", "", []);
					
			__imageClassNames.forEach (
				function (__imageClassName:*):void {
					var __attribs:Array /* <Dynamic> */ = [
						"name",	/* @:safe_cast */ __imageClassName as String,					
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
		public function deserialize (__xml:XSimpleXMLNode, __readOnly:Boolean=false):void {
			trace (": [XMapLayer]: deserialize: ");
			
			m_viewPort = m_startingViewPort = new XRect (
				__xml.getAttributeFloat ("vx"),
				__xml.getAttributeFloat ("vy"),
				__xml.getAttributeFloat ("vw"),
				__xml.getAttributeFloat ("vh")
			);
			
			m_layer = __xml.getAttributeInt ("layer");
			m_submapRows = __xml.getAttributeInt ("submapRows");
			m_submapCols = __xml.getAttributeInt ("submapCols");
			m_submapWidth = __xml.getAttributeInt ("submapWidth");
			m_submapHeight = __xml.getAttributeInt ("submapHeight");
			m_currID = __xml.getAttribute ("currID");
			if (__xml.hasAttribute ("visible")) {
				m_visible = __xml.getAttributeBoolean ("visible");
			}
			else
			{
				m_visible = true;
			}
			if (__xml.hasAttribute ("scale")) {
				m_scale = __xml.getAttributeFloat ("scale");
			}
			else
			{
				m_scale = 1.0;
			}
			if (__xml.hasAttribute ("regX")) {
				m_regX = __xml.getAttributeFloat ("regX");
			}
			else
			{
				m_regX = 0.0;
			}
			if (__xml.hasAttribute ("regY")) {
				m_regY = __xml.getAttributeFloat ("regY");
			}
			else
			{
				m_regY = 0.0;
			}
			if (__xml.hasAttribute ("name")) {
				m_name = __xml.getAttributeString ("name");
			}
			else
			{
				m_name = "";
			}
			if (__xml.hasAttribute ("grid")) {
				m_grid = __xml.getAttributeBoolean ("grid");
			}
			else
			{
				m_grid = false;
			}	
			
			m_persistentStorage = new XDict ();  // <Int, Dynamic>
			
			m_classNames = new XReferenceNameToIndex ();
			m_imageClassNames = new XDict (); // <String, Int>

			m_itemInuse = new XDict ();  // <Int, Int>
			
			m_items = new XDict (); // <XMapItemModel, Int>
			m_ids = new XDict (); // <Int, XMapItemModel>
			m_XSubmaps = new Vector.<Vector.<XSubmapModel>> ();
			for (var i:int = 0; i < m_submapRows; i++) {
				m_XSubmaps.push (null);
			}
			m_retrievedSubmaps = new Array (); // <XSubmapModel>
			m_retrievedItems = new Array (); // <XMapItemModel>
			
			deserializeImageClassNames (__xml);
			m_classNames.deserialize (__xml);
			deserializeItems (__xml);
			deserializeSubmaps (__xml, __readOnly);
		}
	
//------------------------------------------------------------------------------------------
		public function deserializeItems (__xml:XSimpleXMLNode):void {
		}
		
//------------------------------------------------------------------------------------------
		public function deserializeSubmaps (__xml:XSimpleXMLNode, __readOnly:Boolean):void {
			trace (": [XMapLayer]: deserializeSubmaps: ");
			
//------------------------------------------------------------------------------------------
			trace (": creating XSubmaps: ");
			
			var __row:int;
			var __col:int;
			
			if (__readOnly) {
				var __empty:XSubmapModel = new XSubmapModel (this, 0, 0, m_submapWidth, m_submapHeight);

				for (__row=0; __row < m_submapRows; __row++) {
					m_XSubmaps[__row] = new Vector.<XSubmapModel> ();
					
					for (__col=0; __col<m_submapCols; __col++) {
						m_XSubmaps[__row].push (__empty);
					}
				}
			}
			else
			{
				for (__row=0; __row < m_submapRows; __row++) {
					m_XSubmaps[__row] = new Vector.<XSubmapModel> ();
	
					for (__col=0; __col<m_submapCols; __col++) {
						m_XSubmaps[__row].push (new XSubmapModel (this, __col,__row, m_submapWidth, m_submapHeight));
					}
				}
			}
			
//------------------------------------------------------------------------------------------
			trace (": deserializing XSubmaps: ");
			
			var __xmlList:Array; // <XSimpleXMLNode>
			var i:Number;
			
			__xmlList = __xml.child ("XSubmaps")[0].child ("XSubmap");
				
			for (i=0; i<__xmlList.length; i++) {
				var __submapXML:XSimpleXMLNode = __xmlList[i];
				
				__row = __submapXML.getAttributeInt ("row");
				__col = __submapXML.getAttributeInt ("col");
					
				if (__readOnly) {
					m_XSubmaps[__row][__col] = new XSubmapModel (this, __col,__row, m_submapWidth, m_submapHeight);
				}
				
				m_XSubmaps[__row][__col].deserializeRowCol (__submapXML);
			}

//------------------------------------------------------------------------------------------
// we're going to assume that we won't need clean-up with using ArrayItems
//------------------------------------------------------------------------------------------
			if (useArrayItems) {
				return;
			}
			
//------------------------------------------------------------------------------------------	
// add items to the layer's dictionary
//------------------------------------------------------------------------------------------
			trace (": adding items: ");
			
			if (useArrayItems) {
				var src_items:Vector.<XMapItemModel>;
				var __length:int;
				
				for (__row=0; __row<m_submapRows; __row++) {
					for (__col=0; __col<m_submapCols; __col++) {
						src_items = m_XSubmaps[__row][__col].arrayItems ();
						
						__length = src_items.length;
						
						for (var x:int = 0; x<__length; x++) {
							trackItem (src_items[x]);
						}
					}
				}				
			}
			else
			{
				for (__row=0; __row<m_submapRows; __row++) {
					for (__col=0; __col<m_submapCols; __col++) {
						m_XSubmaps[__row][__col].items ().forEach (
							function (__item:*):void {
								trackItem (__item);
							}
						);
					}
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

			var __xmlList:Array /* <XSimpleXMLNode> */ = __xml.child ("imageClassNames")[0].child ("imageClassName");

			var __name:String;	
			var i:Number;
		
			for (i=0; i<__xmlList.length; i++) {
				__name = __xmlList[i].getAttributeString ("name");
				
				trace (": deserializeImageClassName: ", __name);
				
				m_imageClassNames.set (__name, 0);
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
						function (__item:XMapItemModel):void {			
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
