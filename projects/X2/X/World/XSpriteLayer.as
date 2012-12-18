//------------------------------------------------------------------------------------------
package X.World {

	import X.Collections.*;
	import X.World.Sprite.*;
	
	import flash.display.*;
	
//------------------------------------------------------------------------------------------	
	public class XSpriteLayer extends XSprite {
		private var m_XDepthSpriteMap:XDict;
		
		public var forceSort:Boolean;
		
//------------------------------------------------------------------------------------------
		public function XSpriteLayer () {
			super ();
			
			m_XDepthSpriteMap = new XDict ();
			
			forceSort = false;
		}

//------------------------------------------------------------------------------------------
		public function setup (__xxx:XWorld):void {		
		 		xxx = __xxx;
		}
				
//------------------------------------------------------------------------------------------
		public function cleanup ():void {
		}
		
//------------------------------------------------------------------------------------------
		public function addSprite (__sprite:DisplayObject, __depth:Number, __visible:Boolean = false):XDepthSprite {
//			var __depthSprite:XDepthSprite =  new XDepthSprite ();
			var __depthSprite:XDepthSprite = xxx.getXDepthSpritePoolManager ().borrowObject () as XDepthSprite;
			
			__depthSprite.visible2 = true;
			__depthSprite.clear ();
			__depthSprite.addSprite (__sprite, __depth, this);
			__depthSprite.visible = __visible;
			__depthSprite.xxx = xxx;
			
			addChild (__depthSprite);
				
			m_XDepthSpriteMap.put (__depthSprite, 0);
			
			return __depthSprite;
		}	

//------------------------------------------------------------------------------------------
		public function addDepthSprite (__depthSprite:XDepthSprite):XDepthSprite {	
			addChild (__depthSprite);
				
			m_XDepthSpriteMap.put (__depthSprite, 0);
			
			return __depthSprite;
		}
		
//------------------------------------------------------------------------------------------
		public function removeSprite (__depthSprite:Sprite):void {
			if (m_XDepthSpriteMap.exists (__depthSprite)) {
				removeChild (__depthSprite);
	
				xxx.getXDepthSpritePoolManager ().returnObject (__depthSprite);
							
				m_XDepthSpriteMap.remove (__depthSprite);
			}
		}
	
//------------------------------------------------------------------------------------------
		public function moveSprite (__depthSprite:Sprite):void {
			if (m_XDepthSpriteMap.exists (__depthSprite)) {
				removeChild (__depthSprite);
				
				m_XDepthSpriteMap.remove (__depthSprite);
			}
		}
			
//------------------------------------------------------------------------------------------	
		public function depthSort ():void {
			var list:Array = new Array ();
			
			m_XDepthSpriteMap.forEach (
				function (sprite:*):void {
					list.push (sprite);
				}
			);
		
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
