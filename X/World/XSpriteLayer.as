//------------------------------------------------------------------------------------------
package X.World {

	import X.Collections.*;
	import X.World.Sprite.*;
	
	include "..\\flash.h";
	
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
		public override function cleanup ():void {
			super.cleanup ();
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
				if (CONFIG::starling) {
					removeChild (__depthSprite, true);
				}
				else
				{
					removeChild (__depthSprite);
				}
				
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
			var list:Vector.<XDepthSprite> = new Vector.<XDepthSprite> ();
			
			m_XDepthSpriteMap.forEach (
				function (sprite:*):void {
					list.push (sprite);
				}
			);
		
			if (list.length < 20) {
				list.sort (
					function (a:XDepthSprite, b:XDepthSprite):int {
						return a.depth2 - b.depth2;
					}
				);
			}
			else
			{
				flashSortOn (list, "depth2");
			}

			var i:Number;

			for (i=0; i<list.length; i++) {
				setChildIndex (list[i], i);
			}
		}
		
//------------------------------------------------------------------------------------------
// see: http://guihaire.com/code/?p=894
//------------------------------------------------------------------------------------------		
		static public function flashSortOn(o:Vector.<XDepthSprite> , key:String , multiplier:Number = 0.43):void
		{
			var n:int = o.length;
			var i:int = 0, j:int = 0, k:int = 0;
			var a:Vector.<int> = new Vector.<int>(n);
			var m:int = n*multiplier;if(m>262143)m=262143;
			var l:Vector.<int> = new Vector.<int>(m);
			var anmin:int = a[0] = o[0][key];
			var anmax:int = anmin;
			var nmax:int  = 0;
			var nmove:int = 0;
			var lk:int;
			i =0;
			
			var kmin:int,kmax:int,kimin:int,kimax:int;
			for (i=0; (i+=2) < n;)
			{
				a[i] = kmin = o[i][key];
				a[i-1] = kmax = o[i-1][key];
				
				if( kmin>kmax)
				{
					if (kmax< anmin) anmin = kmax;
					if (kmin> anmax) { anmax = kmin; nmax = i;}                                      
				}
				else
				{
					if (kmin< anmin) anmin = kmin;
					if (kmax > anmax) { anmax = kmax; nmax = i-1;}                   
				}               
			}           
			if(--i < n)
			{
				a[i] = k = o[i][key];
				
				if (k < anmin) anmin = k;
				else if (k > anmax) { anmax = k; nmax = i;}
			}
			
			//var time3:int = getTimer();
			//time2 = time3-time2;
			//trace(time1,time2);
			
			if (anmin == anmax) return;
			
			var c1:int = ((m - 1)<<13) / (anmax - anmin);
			
			for (i = -1; ++i < n;)
			{
				++l[(c1*(a[i] - anmin))>>13];
			}
			
			lk = l[0];
			for (k = 0; ++k < m;)
			{
				lk = (l[k] += lk);
			}
			
			//swap a[nmax] and a[0]
			var hold:int = anmax;
			var holdo:XDepthSprite = o[nmax];
			
			a[nmax] = a[0];
			o[nmax] = o[0];
			a[0] = hold;
			o[0] = holdo;
			
			var flash:int;
			var flasho:XDepthSprite;
			j = 0;
			k = (m - 1);
			i = (n - 1);
			
			while (nmove < i)
			{
				while (j >= l[k])
				{
					k = (c1 * (a[ (++j)] - anmin))>>13;
				}
				
				flash = a[j];
				flasho = o[j];
				
				lk = l[k];
				while (j !=lk)
				{
					hold = a[(lk = (--l[(k = ((c1 * (flash - anmin))>>13))]))];
					holdo = o[lk];
					a[lk] = flash;
					o[lk] = flasho;
					flash = hold;
					flasho = holdo;
					++nmove;                                    
				}
				
			}
			
			for(j = 0; ++j < n;)
			{
				hold = a[j];
				holdo = o[i=j];
				while((--i >= 0) && ((k=a[i]) > hold))
				{   
					o[i+1] = o[i];
					a[i+1] = k;
				}
				if(++i != j)
				{
					a[i] = hold;
					o[i] = holdo;
				}
			}   
		}
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
