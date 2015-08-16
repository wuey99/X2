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
	import x.geom.*;
	import x.mvc.*;
	import x.xml.*;
	
	import flash.events.*;
	import flash.utils.*;

//------------------------------------------------------------------------------------------		
	public class XMapItemModel extends XModelBase {
		
		private var m_layerModel:XMapLayerModel;
		private var m_logicClassIndex:int;
		private var m_hasLogic:Boolean;
		private var m_name:String;
		private var m_id:int;
		private var m_imageClassIndex:int;
		private var m_frame:int;
		private var m_XMapItem:String;
		private var m_x:Number;
		private var m_y:Number;
		private var m_rotation:Number;
		private var m_scale:Number;
		private var m_depth:Number;
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
			__name:String, __id:int,
			__imageClassName:String, __frame:int,
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
		public function copy2 (__dst:XMapItemModel):void {
			__dst.layerModel = layerModel;
			__dst.hasLogic = hasLogic;
			__dst.name = name;
			__dst.id = id;
			__dst.imageClassIndex = imageClassIndex;
			__dst.frame = frame;
			__dst.XMapItem = XMapItem;
			__dst.scale = scale;
			__dst.rotation = rotation;
			__dst.depth = depth;
			collisionRect.copy2 (__dst.collisionRect);
			boundingRect.copy2 (__dst.boundingRect);
			__dst.params = params;
		}
		
//------------------------------------------------------------------------------------------
		public function clone (__newLayerModel:XMapLayerModel = null):XMapItemModel {
			var __item:XMapItemModel = new XMapItemModel ();

			if (__newLayerModel == null) {
				__newLayerModel = this.layerModel;
			}
			
			__item.setup (
				__newLayerModel,
// __logicClassName
				this.layerModel.getClassNameFromIndex (m_logicClassIndex),
// __hasLogic
				this.hasLogic,
// __name, __id
				"", __newLayerModel.generateID (),
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
				this.params,
// args
				[]
				);
			
			return __item;
		}
	
//------------------------------------------------------------------------------------------
		public function getID ():int {
			return m_id;
		}
		
//------------------------------------------------------------------------------------------
		public function setID (__id:int):void {
			m_id = __id;
		}

//------------------------------------------------------------------------------------------
		/* @:get, set layerModel XMapLayerModel */
		
		public function get layerModel ():XMapLayerModel {
			return m_layerModel;
		}
		
		public function set layerModel (__layerModel:XMapLayerModel): /* @:set_type */ void {
			m_layerModel = __layerModel;
			
			/* @:set_return null; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set inuse Int */
		
		public function get inuse ():int {
			return m_layerModel.getItemInuse (id);
		}
		
		public function set inuse (__inuse:int): /* @:set_type */ void {
			m_layerModel.setItemInuse (id, __inuse);
			
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set id Int */
		
		public function get id ():int {
			return m_id;
		}
		
		public function set id (__id:int): /* @:set_type */ void {
			m_id = __id;
			
			/* @:set_return 0; */			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		/* @:get, set name String */
		
		public function get name ():String {
			return m_name;
		}
		
		public function set name (__name:String): /* @:set_type */ void {
			m_name = __name;
			
			/* @:set_return ""; */			
		}
		/* @:end */
				
//------------------------------------------------------------------------------------------
		/* @:get, set logicClassIndex Int */
		
		public function get logicClassIndex ():int {
			return m_logicClassIndex;
		}
		
		public function set logicClassIndex (__val:int): /* @:set_type */ void {
			m_logicClassIndex = __val;
			
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set logicClassName String */
		
		public function get logicClassName ():String {
			return m_layerModel.getClassNameFromIndex (logicClassIndex);
		}

		public function set logicClassName (__val:String): /* @:set_type */ void {
			/* @:set_return ""; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set hasLogic Bool */
		
		public function get hasLogic ():Boolean {
			return m_hasLogic;
		}
		
		public function set hasLogic (__val:Boolean): /* @:set_type */ void {
			m_hasLogic = __val;
			
			/* @:set_return true; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set XMapItem String */
		
		public function get XMapItem ():String {
			return m_XMapItem;
		}
		
		public function set XMapItem (__val:String): /* @:set_type */ void {
			m_XMapItem = __val;
			
			/* @:set_return ""; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set imageClassIndex Int */
		
		public function get imageClassIndex ():int {
			return m_imageClassIndex;
		}

		public function set imageClassIndex (__val:int): /* @:set_type */ void {
			m_imageClassIndex = __val;
			
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set imageClassName String */
		
		public function get imageClassName ():String {
			return m_layerModel.getClassNameFromIndex (imageClassIndex);
		}

		public function set imageClassName (__val:String): /* @:set_type */ void {
			/* @:set_return ""; */			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		/* @:get, set frame Int */
		
		public function get frame ():int {
			return m_frame;
		}

		public function set frame (__frame:int): /* @:set_type */ void {
			m_frame = __frame;
			
			/* @:set_return 0; */			
		}
		/* @:end */
								
//------------------------------------------------------------------------------------------
		/* @:get, set x Float */
		
		public function get x ():Number {
			return m_x;
		}

		public function set x (__x:Number): /* @:set_type */ void {
			m_x = __x;
			
			/* @:set_return 0; */			
		}
		/* @:end */
				
//------------------------------------------------------------------------------------------
		/* @:get, set y Float */
			
		public function get y ():Number {
			return m_y;
		}

		public function set y (__y:Number): /* @:set_type */ void {
			m_y = __y;
			
			/* @:set_return 0; */			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		/* @:get, set rotation Float */
		
		public function get rotation ():Number {
			return m_rotation;
		}
	
		public function set rotation (__rotation:Number): /* @:set_type */ void {
			m_rotation = __rotation;
			
			/* @:set_return 0; */			
		}
		/* @:end */
			
//------------------------------------------------------------------------------------------
		/* @:get, set scale Float */
		
		public function get scale ():Number {
			return m_scale;
		}
		
		public function set scale (__scale:Number): /* @:set_type */ void {
			m_scale = __scale;
			
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set depth Float */
		
		public function get depth ():Number {
			return m_depth;
		}

		public function set depth (__depth:Number): /* @:set_type */ void {
			m_depth = __depth;
			
			/* @:set_return 0; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set boundingRect XRect */
		
		public function get boundingRect ():XRect {
			return m_boundingRect;
		}

		public function set boundingRect (__rect:XRect): /* @:set_type */ void {
			m_boundingRect = __rect;
			
			/* @:set_return null; */			
		}
		/* @:end */
		
//------------------------------------------------------------------------------------------
		/* @:get, set collisionRect XRect */
		
		public function get collisionRect ():XRect {
			return m_collisionRect;
		}

		public function set collisionRect (__rect:XRect): /* @:set_type */ void {
			m_collisionRect = __rect;
			
			/* @:set_return null; */			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		/* @:get, set params String */
		
		public function get params ():String {
			return m_params;
		}
		
		public function set params (__params:String): /* @:set_type */ void {
			m_params = __params;
			
			/* @:set_return ""; */			
		}
		/* @:end */

//------------------------------------------------------------------------------------------
		public function serialize ():XSimpleXMLNode {
			var xml:XSimpleXMLNode = new XSimpleXMLNode ();
			
			var __attribs:Array /* <Dynamic> */ = [
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
