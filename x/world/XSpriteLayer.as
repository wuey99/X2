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
package x.world {

	import x.collections.*;
	import x.type.*;
	import x.world.sprite.*;
	
	include "..\\flash.h";
	
//------------------------------------------------------------------------------------------	
	public class XSpriteLayer extends XSprite {
		private var m_XDepthSpriteMap:XDict; // <XDepthSprite, Int>
		
		public var forceSort:Boolean;
		
		public var list:Vector.<XDepthSprite>;
		
//------------------------------------------------------------------------------------------
		public function XSpriteLayer () {
			super ();
			
			m_XDepthSpriteMap = new XDict (); // <XDepthSprite, Int>
			
			list = new Vector.<XDepthSprite> (/* 2000 */);
			for (var i:int = 0; i < 2000; i++) {
				list.push (null);
			}
			
			forceSort = false;
		}

//------------------------------------------------------------------------------------------
		public override function setup ():void {		
		 	super.setup ();
		}
				
//------------------------------------------------------------------------------------------
		public override function cleanup ():void {
			super.cleanup ();
		}
		
//------------------------------------------------------------------------------------------
		public function addSprite (__sprite:DisplayObject, __depth:Number, __visible:Boolean = false):XDepthSprite {
			var __depthSprite:XDepthSprite = xxx.getXDepthSpritePoolManager ().borrowObject () as XDepthSprite;
			
			__depthSprite.setup ();
			__depthSprite.visible2 = true;
			__depthSprite.alpha = 1.0;
			__depthSprite.clear ();
			__depthSprite.addSprite (__sprite, __depth, this);
			__depthSprite.visible = __visible;
			__depthSprite.xxx = xxx;
			__depthSprite.scaleX = __depthSprite.scaleY = 1.0;
			
			addChild (__depthSprite);
				
			m_XDepthSpriteMap.set (__depthSprite, 0);
			
			return __depthSprite;
		}	

//------------------------------------------------------------------------------------------
		public function addDepthSprite (__depthSprite:XDepthSprite):XDepthSprite {	
			addChild (__depthSprite);
				
			m_XDepthSpriteMap.set (__depthSprite, 0);
			
			return __depthSprite;
		}
		
//------------------------------------------------------------------------------------------
		public function removeSprite (__depthSprite:XDepthSprite):void {
			if (m_XDepthSpriteMap.exists (__depthSprite)) {
				__depthSprite.cleanup ();
				
				// <HAXE>
				/* --
					removeChild (__depthSprite);
				-- */
				// </HAXE>
				// <AS3>
				if (CONFIG::starling) {
					removeChild (__depthSprite, true);
				}
				else
				{
					removeChild (__depthSprite);
				}
				// </AS3>
				
				xxx.getXDepthSpritePoolManager ().returnObject (__depthSprite);
							
				m_XDepthSpriteMap.remove (__depthSprite);
			}
		}
	
//------------------------------------------------------------------------------------------
		public function moveSprite (__depthSprite:XDepthSprite):void {
			if (m_XDepthSpriteMap.exists (__depthSprite)) {
				removeChild (__depthSprite);
				
				m_XDepthSpriteMap.remove (__depthSprite);
			}
		}
			
//------------------------------------------------------------------------------------------	
		public function depthSort ():void {
			var length:int = 0;
			
			// <HAXE>
			/* --
				XType.clearArray (list);
			-- */
			// </HAXE>
			// <AS3>
				list.length = 0;
			// </AS3>
			
			m_XDepthSpriteMap.forEach (
				function (sprite:*):void {
					list[length++] = sprite;
				}
			);
		
			// <HAXE>
			/* --
				list.sort (
					function (a:XDepthSprite, b:XDepthSprite):Int {
						return Std.int (a.depth2 - b.depth2);
					}
				);				
			-- */
			// </HAXE>
			// <AS3>
			if (length < 20) {
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
			// </AS3>
			
			var i:int;

			for (i=0; i<length; i++) {
				setChildIndex (list[i], i);
			}
		}
		
//------------------------------------------------------------------------------------------
// see: http://guihaire.com/code/?p=894
//------------------------------------------------------------------------------------------	
		// <HAXE>
		/* --
		-- */
		// </HAXE>
		// <AS3>
		static public function flashSortOn(o:Vector.<XDepthSprite> , key:String , multiplier:Number = 0.43):void
		{
			var n:int = o.length;
			var i:int = 0, j:int = 0, k:int = 0;
			var m_a:Vector.<int> = new Vector.<int>(n);
			m_a.length = n;
			var m:int = n*multiplier;if(m>262143)m=262143;
			var m_l:Vector.<int> = new Vector.<int>(m);
			m_l.length = m;
			var anmin:int = m_a[0] = o[0][key];
			var anmax:int = anmin;
			var nmax:int  = 0;
			var nmove:int = 0;
			var lk:int;
			i =0;
			
			var kmin:int,kmax:int,kimin:int,kimax:int;
			i = 0;
//			for (i=0; (i+=2) < n;)
			while ((i+=2) < n)
			{
				m_a[i] = kmin = o[i][key];
				m_a[i-1] = kmax = o[i-1][key];
				
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
				m_a[i] = k = o[i][key];
				
				if (k < anmin) anmin = k;
				else if (k > anmax) { anmax = k; nmax = i;}
			}
			
			//var time3:int = getTimer();
			//time2 = time3-time2;
			//trace(time1,time2);
			
			if (anmin == anmax) return;
			
			var c1:int = ((m - 1)<<13) / (anmax - anmin);
			
			i = -1;
//			for (i = -1; ++i < n;)
			while(++i < n)
			{
				++m_l[(c1*(m_a[i] - anmin))>>13];
			}
			
			lk = m_l[0];
			k = 0;
//			for (k = 0; ++k < m;)
			while(++k < m)
			{
				lk = (m_l[k] += lk);
			}
			
			//swap a[nmax] and a[0]
			var hold:int = anmax;
			var holdo:XDepthSprite = o[nmax];
			
			m_a[nmax] = m_a[0];
			o[nmax] = o[0];
			m_a[0] = hold;
			o[0] = holdo;
			
			var flash:int;
			var flasho:XDepthSprite;
			j = 0;
			k = (m - 1);
			i = (n - 1);
			
			while (nmove < i)
			{
				while (j >= m_l[k])
				{
					k = (c1 * (m_a[ (++j)] - anmin))>>13;
				}
				
				flash = m_a[j];
				flasho = o[j];
				
				lk = m_l[k];
				while (j !=lk)
				{
					hold = m_a[(lk = (--m_l[(k = ((c1 * (flash - anmin))>>13))]))];
					holdo = o[lk];
					m_a[lk] = flash;
					o[lk] = flasho;
					flash = hold;
					flasho = holdo;
					++nmove;                                    
				}
				
			}
			
			j = 0;
//			for(j = 0; ++j < n;)
			while(++j < n)
			{
				hold = m_a[j];
				holdo = o[i=j];
				while((--i >= 0) && ((k=m_a[i]) > hold))
				{   
					o[i+1] = o[i];
					m_a[i+1] = k;
				}
				if(++i != j)
				{
					m_a[i] = hold;
					o[i] = holdo;
				}
			}   
		}
		// </AS3>
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
