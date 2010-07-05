//------------------------------------------------------------------------------------------
package X.World {

	import X.World.Sprite.*;
	
	import flash.display.*;
	import flash.utils.*;
	
//------------------------------------------------------------------------------------------	
	public class XSpriteLayer extends XSprite {
		private var m_XDepthSpriteMap:Dictionary;
		
		public var forceSort:Boolean;
		
//------------------------------------------------------------------------------------------
		public function XSpriteLayer () {
			m_XDepthSpriteMap = new Dictionary ();
			
			forceSort = false;
		}

//------------------------------------------------------------------------------------------
		public function init (__xxx:XWorld):void {		
			xxx = __xxx;
		}
				
//------------------------------------------------------------------------------------------
		public function addSprite (__sprite:DisplayObject, __depth:Number, __visible:Boolean = false):XDepthSprite {
			var __depthSprite:XDepthSprite =  new XDepthSprite ();
			__depthSprite.addSprite (__sprite, __depth, this);
			__depthSprite.visible = __visible;
			__depthSprite.xxx = xxx;
			
			addChild (__depthSprite);
				
			m_XDepthSpriteMap[__depthSprite] = 0;
			
			return __depthSprite;
		}	

//------------------------------------------------------------------------------------------
		public function removeSprite (__depthSprite:Sprite):void {
			if (__depthSprite in m_XDepthSpriteMap) {
				removeChild (__depthSprite);
				
				delete m_XDepthSpriteMap[__depthSprite];
			}
		}
		
//------------------------------------------------------------------------------------------	
		public function depthSort ():void {
			var sprite:*;
			var list:Array = new Array ();
			
			for (sprite in m_XDepthSpriteMap) {
				list.push (sprite);
			}
		
			var i:Number;
			var d:Number;
			
			mergeSort (list, 0, list.length-1);
		
			d = numChildren-1;
			
			for (i=0; i<list.length; i++) {
				setChildIndex (list[i], d--);
			}
		}
		
//------------------------------------------------------------------------------------------
		public function mergeSort (a:Array, left:int, right:int):void {
			var center:int;
			
			if (left < right) {
				center = (left+right)/2;
				
				mergeSort (a, left, center);
				mergeSort (a, center+1, right);
				
				merge (a, left, center+1, right);
			}	
		}	

//------------------------------------------------------------------------------------------
		public function merge (a:Array, leftPos:int, rightPos:int, rightEnd:int):void {
			var leftEnd:int = rightPos-1;
			var tmpPos:int = leftPos;
			var numElements:int = rightEnd - leftPos + 1;
			
			var tmpArray:Array = new Array (a.length);
	
        	// Main loop
        	while (leftPos <= leftEnd && rightPos <= rightEnd) {
            	if (a[leftPos].depth2 > a[rightPos].depth2) {
                	tmpArray[tmpPos++] = a[leftPos++];
             	}
            	else
            	{
                	tmpArray[tmpPos++] = a[rightPos++];
             	}
        	}
        	
        	// Copy rest of first half
        	while (leftPos <= leftEnd) {
            	tmpArray[tmpPos++] = a[leftPos++];
        	}
        	
        	// Copy rest of right half
        	while (rightPos <= rightEnd) { 
            	tmpArray[tmpPos++] = a[rightPos++];
        	}
        	
        	// Copy tmpArray back
        	for (var i:int = 0; i < numElements; i++, rightEnd--) {
            	a[rightEnd] = tmpArray[rightEnd];
         	}
		}

//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
