//------------------------------------------------------------------------------------------
package X.XMap {

// X classes
	import X.Geom.*;
	import X.MVC.*;
	import X.XML.*;
	
	import flash.events.*;
	import flash.utils.*;

//------------------------------------------------------------------------------------------		
	public class XMapItemModel extends XModelBase {
		
		private var m_layerModel:XMapLayerModel;
		private var m_logicClassIndex:int;
		private var m_hasLogic:Boolean;
		private var m_name:String;
		private var m_id:Number;
		private var m_imageClassIndex:int;
		private var m_frame:Number;
		private var m_XMapItem:String;
		private var m_x:Number, m_y:Number;
		private var m_rotation:Number, m_scale:Number, m_depth:Number;
		private var m_collisionRect:XRect;
		private var m_boundingRect:XRect;
		private var m_params:String;

//------------------------------------------------------------------------------------------	
		public function XMapItemModel () {
			super ();
			
			m_id = -1;
		}	

//------------------------------------------------------------------------------------------	
		public function setup (
			__layerModel:XMapLayerModel,
			__logicClassName:String,
			__hasLogic:Boolean,
			__name:String, __id:Number,
			__imageClassName:String, __frame:Number,
			__XMapItem:String,
			__x:Number, __y:Number,
			__scale:Number, __rotation:Number, __depth:Number,
			__collisionRect:XRect,
			__boundingRect:XRect,
			__params:String,
			...args
			):void {
				
				m_layerModel = __layerModel;
				m_logicClassIndex = m_layerModel.getIndexFromClassName (__logicClassName);
				m_hasLogic = __hasLogic;
				m_name = __name;
				m_id = __id;
				m_imageClassIndex = m_layerModel.getIndexFromClassName (__imageClassName);
				m_frame = __frame;
				m_XMapItem = __XMapItem;
				m_x = __x;
				m_y = __y;
				m_scale = __scale;
				m_rotation = __rotation;
				m_depth = __depth;
				m_collisionRect = __collisionRect;
				m_boundingRect = __boundingRect;
				m_params = __params;
		}

//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function kill ():void {
			m_layerModel.removeIndexFromClassNames (logicClassIndex);
			m_layerModel.removeIndexFromClassNames (imageClassIndex);
		}
		
//------------------------------------------------------------------------------------------
		public function clone (__newLayerModel:XMapLayerModel = null):XMapItemModel {
			var __item:XMapItemModel = new XMapItemModel ();

			__item.setup (
				__newLayerModel != null ? __newLayerModel : this.layerModel,
// __logicClassName
				this.layerModel.getClassNameFromIndex (m_logicClassIndex),
// __hasLogic
				this.hasLogic,
// __name, __id
				"", -1,
// __imageClassName, __frame
				this.layerModel.getClassNameFromIndex (m_imageClassIndex), this.frame,
// XMapItem
				this.XMapItem,
// __x, __y,
				this.x, this.y,
// __scale, __rotation, __depth
				this.scale, this.rotation, this.depth,
// __collisionRect,
				this.collisionRect.cloneX (),
// __boundingRect,
				this.boundingRect.cloneX (),
// __params
				this.params
				);
			
			return __item;
		}
	
//------------------------------------------------------------------------------------------
		public function getID ():Number {
			return m_id;
		}
		
//------------------------------------------------------------------------------------------
		public function setID (__id:Number):void {
			m_id = __id;
		}

//------------------------------------------------------------------------------------------
		public function get layerModel ():XMapLayerModel {
			return m_layerModel;
		}
		
//------------------------------------------------------------------------------------------
		public function get inuse ():Number {
			return m_layerModel.getItemInuse (id);
		}
		
		public function set inuse (__inuse:Number):void {
			m_layerModel.setItemInuse (id, __inuse);
		}
		
//------------------------------------------------------------------------------------------
		public function get id ():Number {
			return m_id;
		}
		
		public function set id (__id:Number):void {
			m_id = __id;
		}

//------------------------------------------------------------------------------------------
		public function get name ():String {
			return m_name;
		}
		
		public function set name (__name:String):void {
			m_name = __name;
		}
				
//------------------------------------------------------------------------------------------
		public function get logicClassIndex ():int {
			return m_logicClassIndex;
		}
		
		public function get logicClassName ():String {
			return m_layerModel.getClassNameFromIndex (logicClassIndex);
		}

//------------------------------------------------------------------------------------------
		public function get hasLogic ():Boolean {
			return m_hasLogic;
		}
		
		public function set hasLogic (__value:Boolean):void {
			m_hasLogic = __value;
		}
		
//------------------------------------------------------------------------------------------
		public function get XMapItem ():String {
			return m_XMapItem;
		}
		
		public function set XMapItem (__value:String):void {
			m_XMapItem = __value;
		}
		
//------------------------------------------------------------------------------------------
		public function get imageClassIndex ():int {
			return m_imageClassIndex;
		}
		
		public function get imageClassName ():String {
			return m_layerModel.getClassNameFromIndex (imageClassIndex);
		}

//------------------------------------------------------------------------------------------
		public function get frame ():Number {
			return m_frame;
		}

		public function set frame (__frame:Number):void {
			m_frame = __frame;
		}
								
//------------------------------------------------------------------------------------------
		public function get x ():Number {
			return m_x;
		}

		public function set x (__x:Number):void {
			m_x = __x;
		}
				
//------------------------------------------------------------------------------------------
		public function get y ():Number {
			return m_y;
		}

		public function set y (__y:Number):void {
			m_y = __y;
		}

//------------------------------------------------------------------------------------------
		public function get rotation ():Number {
			return m_rotation;
		}
	
		public function set rotation (__rotation:Number):void {
			m_rotation = __rotation;
		}
			
//------------------------------------------------------------------------------------------
		public function get scale ():Number {
			return m_scale;
		}
		
		public function set scale (__scale:Number):void {
			m_scale = __scale;
		}
		
//------------------------------------------------------------------------------------------
		public function get depth ():Number {
			return m_depth;
		}

		public function set depth (__depth:Number):void {
			m_depth = __depth;
		}
		
//------------------------------------------------------------------------------------------
		public function get boundingRect ():XRect {
			return m_boundingRect;
		}

		public function set boundingRect (__rect:XRect):void {
			m_boundingRect = __rect;
		}
		
//------------------------------------------------------------------------------------------
		public function get collisionRect ():XRect {
			return m_collisionRect;
		}

		public function set collisionRect (__rect:XRect):void {
			m_collisionRect = __rect;
		}

//------------------------------------------------------------------------------------------	
		public function get params ():String {
			return m_params;
		}
		
		public function set params (__params:String):void {
			m_params = __params;
		}

//------------------------------------------------------------------------------------------
		public function serialize ():XSimpleXMLNode {
			var xml:XSimpleXMLNode = new XSimpleXMLNode ();
			
			var __attribs:Array = [
				"logicClassIndex",	logicClassIndex,
				"hasLogic",			hasLogic ? "true" : "false",
				"name",				name,
				"id",				id,
				"imageClassIndex",	imageClassIndex,
				"frame",			frame,
				"XMapItem",			XMapItem,
				"x",				x,
				"y",				y,
				"rotation",			rotation,
				"scale",			scale,
				"depth",			depth,
				"cx",				collisionRect.x,
				"cy",				collisionRect.y,
				"cw",				collisionRect.width,
				"ch",				collisionRect.height,
				"bx",				boundingRect.x,
				"by",				boundingRect.y,
				"bw",				boundingRect.width,
				"bh",				boundingRect.height
			];
			
			xml.setupWithParams ("XMapItem", "", __attribs);
			
			xml.addChildWithXMLString (params);
			
			return xml;
		}

//------------------------------------------------------------------------------------------	
	}
	
//------------------------------------------------------------------------------------------	
}
