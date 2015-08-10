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
		public var CX_COLLIDE_LF:int = 0x0001;
		public var CX_COLLIDE_RT:int = 0x0002;
		public var CX_COLLIDE_HORZ:int = 0x0001 | 0x0002; 
		public var CX_COLLIDE_UP:int = 0x0004;
		public var CX_COLLIDE_DN:int = 0x0008;
		public var CX_COLLIDE_VERT:int = 0x0004 | 0x0008;
	
		// empty
		public var CX_EMPTY:int = 0;
		
		// solid solid
		public var CX_SOLID:int = 1;
		
		// soft
		public var CX_SOFT:int = 2;	
		
		// jump thru
		public var CX_JUMP_THRU:int = 3;
		
		// 45 degree diagonals
		public var CX_UL45:int = 4;
		public var CX_UR45:int = 5;
		public var CX_LL45:int = 6;
		public var CX_LR45:int = 7;
		
		// 22.5 degree diagonals
		public var CX_UL225A:int = 8;
		public var CX_UL225B:int = 9;
		public var CX_UR225A:int = 10;
		public var CX_UR225B:int = 11;
		public var CX_LL225A:int = 12;
		public var CX_LL225B:int = 13;
		public var CX_LR225A:int = 14;
		public var CX_LR225B:int = 15;
		
		// 67.5 degree diagonals
		public var CX_UL675A:int = 16;
		public var CX_UL675B:int = 17;
		public var CX_UR675A:int = 18;
		public var CX_UR675B:int = 19;
		public var CX_LL675A:int = 20;
		public var CX_LL675B:int = 21;
		public var CX_LR675A:int = 22;
		public var CX_LR675B:int = 23;
		
		// soft tiles
		public var CX_SOFTLF:int = 24;
		public var CX_SOFTRT:int = 25;
		public var CX_SOFTUP:int = 26;
		public var CX_SOFTDN:int = 27;
	
		// special solids
		public var CX_SOLIDX001:int = 28;
		
		// death
		public var CX_DEATH:int = 29;
		
		// ice
		public var CX_ICE:int = 30;
		
		// max
		public var CX_MAX:int = 31;
		
		// collision tile width, height
		public var CX_TILE_WIDTH:int = 16;
		public var CX_TILE_HEIGHT:int = 16;
		
		public var CX_TILE_WIDTH_MASK:int = 15;
		public var CX_TILE_HEIGHT_MASK:int = 15;
		
		public var CX_TILE_WIDTH_UNMASK:int = 0xfffffff0;
		public var CX_TILE_HEIGHT_UNMASK:int = 0xfffffff0;
		
		// alternate tile width, height
		public var TX_TILE_WIDTH:int = 64;
		public var TX_TILE_HEIGHT:int = 64;
		
		public var TX_TILE_WIDTH_MASK:int = 63;
		public var TX_TILE_HEIGHT_MASK:int = 63;
		
		public var TX_TILE_WIDTH_UNMASK:int = 0xffffffc0;
		public var TX_TILE_HEIGHT_UNMASK:int = 0xffffffc0;