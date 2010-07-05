//------------------------------------------------------------------------------------------
package X.XMap {

// X classes	
	import X.MVC.*;
	import X.Utils.*;
	
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.utils.*;
			
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

		private var m_items:Dictionary;

		private var m_classNames:XClassNameToIndex;
		
		private var m_viewPort:Rectangle;
		
//------------------------------------------------------------------------------------------	
		public function XMapLayerModel () {
		}	

//------------------------------------------------------------------------------------------
		public function init (
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
			m_items = new Dictionary ();
			m_layer = __layer;
			m_XSubmaps = new Array (__submapRows);

			for (__row=0; __row<__submapRows; __row++) {
				m_XSubmaps[__row] = new Array (__submapCols);

				for (__col=0; __col<__submapCols; __col++) {
					m_XSubmaps[__row][__col] = new XSubmapModel (this);
				}
			}
			
			m_classNames = new XClassNameToIndex ();
			
			m_viewPort = new Rectangle ();
		}

//------------------------------------------------------------------------------------------
		public function setParent (__XMap:XMapModel):void {
			m_XMap = __XMap;
		}

//------------------------------------------------------------------------------------------
		public function setViewPort (__viewPort:Rectangle):void {
			m_viewPort = __viewPort;
		}
		
//------------------------------------------------------------------------------------------
		public function get viewPort ():Rectangle {
			return m_viewPort;
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
			
			var r:Rectangle = __item.boundingRect.clone ();
			r.offset (__item.x, __item.y);
			
// determine submaps that the item straddles
			__c1 = r.left/m_submapWidth;
			__r1 = r.top/m_submapHeight;
			
			__c2 = r.right/m_submapWidth;
			__r2 = r.bottom/m_submapHeight;

			trace (": -----------------------: ");
			trace (": addItem: ");
			trace (": ", r.left, r.top, r.right, r.bottom);
			trace (": ", __c1, __r1, __c2, __r2);
// ul
			m_XSubmaps[__r1][__c1].addItem (__item);
// ur
			m_XSubmaps[__r1][__c2].addItem (__item);
// ll
			m_XSubmaps[__r2][__c1].addItem (__item);
// lr
			m_XSubmaps[__r2][__c2].addItem (__item);

			m_items[__item] = __item.id;
			
			return __item;
		}

//------------------------------------------------------------------------------------------
		public function removeItem (__item:XMapItemModel):void {		
			if (!(__item in m_items)) {
				return;
			}
			
			var __c1:int, __r1:int, __c2:int, __r2:int;
		
			var r:Rectangle = __item.boundingRect.clone ();
			r.offset (__item.x, __item.y);
			
// determine submaps that the item straddles
			__c1 = r.left/m_submapWidth;
			__r1 = r.top/m_submapHeight;
			
			__c2 = r.right/m_submapWidth;
			__r2 = r.bottom/m_submapHeight;

// ul
			m_XSubmaps[__r1][__c1].removeItem (__item);
// ur
			m_XSubmaps[__r1][__c2].removeItem (__item);
// ll
			m_XSubmaps[__r2][__c1].removeItem (__item);
// lr
			m_XSubmaps[__r2][__c2].removeItem (__item);
				
			delete m_items[__item];
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
			var src_items:Dictionary;
			var dst_items:Array = new Array ();
			var x:*;
			var item:XMapItemModel;
			
//			trace (": ---------------------: ");	
//			trace (": getItemsAt: ");
//			trace (": ---------------------: ");
						
			for (i=0; i<submaps.length; i++) {
				src_items = submaps[i].items ();
							
				for (x in src_items) {
					item = x as XMapItemModel;
					
					var b:Rectangle = item.boundingRect.clone ();
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
			var src_items:Dictionary;
			var dst_items:Array = new Array ();
			var x:*;
			var item:XMapItemModel;

			trace (": ---------------------: ");	
			trace (": getItemsAt: submaps: ", submaps.length);
			trace (": ---------------------: ");
				
			for (i=0; i<submaps.length; i++) {
				src_items = submaps[i].items ();
								
				for (x in src_items) {
					item = x as XMapItemModel;
			
					var cx:Rectangle = item.collisionRect.clone ();
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
			}
			
			return dst_items;		
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
		public function items ():Dictionary {
			return m_items;
		}
			
//------------------------------------------------------------------------------------------
		public function getItemId (__item:XMapItemModel):Number {
			return m_items[__item];
		}		

//------------------------------------------------------------------------------------------
		public function getClassNameFromIndex (__index:int):String {
			return m_classNames.getClassNameFromIndex (__index);
		}

//------------------------------------------------------------------------------------------
		public function getIndexFromClassName (__className:String):int {
			return m_classNames.getIndexFromClassName (__className);
		}

//------------------------------------------------------------------------------------------
		public function removeIndexFromClassNames (__index:int):void {
			m_classNames.removeIndexFromClassNames (__index);
		}

//------------------------------------------------------------------------------------------
		public function getAllClassNames ():Array {
			return m_classNames.getAllClassNames ();
		}
		
//------------------------------------------------------------------------------------------
		public function serialize ():XML {
			var __xml:XML = 
				<XLayer
					vx={viewPort.x}
					vy={viewPort.y}
					vw={viewPort.width}
					vh={viewPort.height}
					layer={m_layer}
					submapRows={m_submapRows}
					submapCols={m_submapCols}
					submapWidth={m_submapWidth}
					submapHeight={m_submapHeight}
					currID={m_currID}
				>
					{m_classNames.serialize ()}
					{serializeItems ()}
					{serializeSubmaps ()}
					
				</XLayer>
				
			return __xml;
		}

//------------------------------------------------------------------------------------------
		public function serializeItems ():XML {
			var xml:XML =
				<items/>
				
			return xml;
		}
		
//------------------------------------------------------------------------------------------
		public function serializeSubmaps ():XML {
			var xml:XML =
				<XSubmaps/>
				
			var __row:Number, __col:Number;
			var __x1:Number, __y1:Number, __x2:Number, __y2:Number;
			
			for (__row=0; __row<m_submapRows; __row++) {
				__y1 = __row * m_submapHeight;
				__y2 = __y1 + m_submapHeight-1;
				
				for (__col=0; __col<m_submapCols; __col++) {
					__x1 = __col * m_submapWidth;
					__x2 = __x1 + m_submapWidth-1;
					
					var submaps:Array = getSubmapsAt (__x1, __y1, __x2, __y2);
					
					if (submaps.length == 1) {
						var submap:XSubmapModel = submaps[0] as XSubmapModel;
						
						if (submapHasItems (submap)) {
							xml.appendChild (submap.serializeRowCol (__row, __col));
						}
					}
				}
			}
			
			return xml;
		}

//------------------------------------------------------------------------------------------
		public function submapHasItems (submap:XSubmapModel):Number {
			var x:*;
			var count:Number = 0;
					
			for (x in submap.items ()) {	
				count++;
			}
			
			return count;
		}

//------------------------------------------------------------------------------------------
		public function deserialize (__xml:XML):void {
			trace (": [XMapLayer]: deserialize: ");
			
			m_viewPort = new Rectangle (__xml.@vx, __xml.@vy, __xml.@vw, __xml.@vh);
			m_layer = __xml.@layer;
			m_submapRows = __xml.@submapRows;
			m_submapCols = __xml.@submapCols;
			m_submapWidth = __xml.@submapWidth;
			m_submapHeight = __xml.@submapHeight;
			m_currID = __xml.@currID;
			
			m_classNames = new XClassNameToIndex ();
			
			m_items = new Dictionary ();
			m_XSubmaps = new Array (m_submapRows);
			
			m_classNames.deserialize (__xml);
			deserializeItems (__xml);
			deserializeSubmaps (__xml);
		}
	
//------------------------------------------------------------------------------------------
		public function deserializeItems (__xml:XML):void {
		}
		
//------------------------------------------------------------------------------------------
		public function deserializeSubmaps (__xml:XML):void {
			trace (": [XMapLayer]: deserializeSubmaps: ");
			
			trace (": xml: ", __xml);
			
			var __row:Number;
			var __col:Number;
			
			for (__row=0; __row<m_submapRows; __row++) {
				m_XSubmaps[__row] = new Array (m_submapCols);

				for (__col=0; __col<m_submapCols; __col++) {
					m_XSubmaps[__row][__col] = new XSubmapModel (this);
				}
			}
			
			var __xmlList:XMLList = __xml.XSubmaps.child ("XSubmap");
			
			trace (": __xmlList.length (): ", __xmlList.length ());
			
			var i:Number;
			
			for (i=0; i<__xmlList.length (); i++) {
				var __submapXML:XML = __xmlList[i];
				
				__row = __submapXML.@row;
				__col = __submapXML.@col;
				
				trace (": __submapXML: ", __submapXML);
				
				m_XSubmaps[__row][__col].deserializeRowCol (__submapXML);
			}
			
			for (__row=0; __row<m_submapRows; __row++) {
				for (__col=0; __col<m_submapCols; __col++) {
					for (var __item:* in m_XSubmaps[__row][__col].items ()) {
						addItem (__item);
					}
				}
			}
		}
		
//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
