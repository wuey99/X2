//------------------------------------------------------------------------------------------
// <$begin$/>
// Copyright (C) 2014 Jimmy Huey
//
// Some Rights Reserved.
//
// The "X-Engine" is licensed under a Creative Commons
// Attribution-NonCommerical-ShareAlike 3.0 Unported License.
// (CC BY-NC-SA 3.0)
//
// You are free to:
//
//      SHARE - to copy, distribute, display and perform the work.
//      ADAPT - remix, transform build upon this material.
//
//      The licensor cannot revoke these freedoms as long as you follow the license terms.
//
// Under the following terms:
//
//      ATTRIBUTION -
//          You must give appropriate credit, provide a link to the license, and
//          indicate if changes were made.  You may do so in any reasonable manner,
//          but not in any way that suggests the licensor endorses you or your use.
//
//      SHAREALIKE -
//          If you remix, transform, or build upon the material, you must
//          distribute your contributions under the same license as the original.
//
//      NONCOMMERICIAL -
//          You may not use the material for commercial purposes.
//
// No additional restrictions - You may not apply legal terms or technological measures
// that legally restrict others from doing anything the license permits.
//
// The full summary can be located at:
// http://creativecommons.org/licenses/by-nc-sa/3.0/
//
// The human-readable summary of the Legal Code can be located at:
// http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode
//
// The "X-Engine" is free for non-commerical use.
// For commercial use, you will need to provide additional credits.
// Please contact me @ wuey99[dot]gmail[dot]com for more details.
// <$end$/>
//------------------------------------------------------------------------------------------
package X.World {

	import X.Collections.*;
	import X.World.Sprite.*;
	
	include "..\\flash.h";
	
//------------------------------------------------------------------------------------------	
	public class XSpriteLayer extends XSprite {
		private var m_XDepthSpriteMap:XDict;
		
		public var forceSort:Boolean;
		
		public var list:Vector.<XDepthSprite>;
		
//------------------------------------------------------------------------------------------
		public function XSpriteLayer () {
			super ();
			
			m_XDepthSpriteMap = new XDict ();
			
			list = new Vector.<XDepthSprite> (2000);
			
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
		public function removeSprite (__depthSprite:XDepthSprite):void {
			if (m_XDepthSpriteMap.exists (__depthSprite)) {
				__depthSprite.cleanup ();
				
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
		public function moveSprite (__depthSprite:XDepthSprite):void {
			if (m_XDepthSpriteMap.exists (__depthSprite)) {
				removeChild (__depthSprite);
				
				m_XDepthSpriteMap.remove (__depthSprite);
			}
		}
			
//------------------------------------------------------------------------------------------	
		public function depthSort ():void {
			var length:int = 0;

			list.length = 0;
			
			m_XDepthSpriteMap.forEach (
				function (sprite:*):void {
					list[length++] = sprite;
				}
			);
		
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

			var i:int;

			for (i=0; i<length; i++) {
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
			for (i=0; (i+=2) < n;)
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
			
			for (i = -1; ++i < n;)
			{
				++m_l[(c1*(m_a[i] - anmin))>>13];
			}
			
			lk = m_l[0];
			for (k = 0; ++k < m;)
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
			
			for(j = 0; ++j < n;)
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
		
//------------------------------------------------------------------------------------------
	}
	
//------------------------------------------------------------------------------------------
}
