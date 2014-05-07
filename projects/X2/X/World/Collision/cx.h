//------------------------------------------------------------------------------------------
// <$license$/>
//------------------------------------------------------------------------------------------
		public const CX_COLLIDE_LF:int = 0x0001;
		public const CX_COLLIDE_RT:int = 0x0002;
		public const CX_COLLIDE_HORZ:int = (CX_COLLIDE_LF+CX_COLLIDE_RT); 
		public const CX_COLLIDE_UP:int = 0x0004;
		public const CX_COLLIDE_DN:int = 0x0008;
		public const CX_COLLIDE_VERT:int = (CX_COLLIDE_UP+CX_COLLIDE_DN);
	
		// empty
		public const CX_EMPTY:int = 0;
		
		// solid solid
		public const CX_SOLID:int = 1;
		
		// soft
		public const CX_SOFT:int = 2;	
		
		// jump thru
		public const CX_JUMP_THRU:int = 3;
		
		// 45 degree diagonals
		public const CX_UL45:int = 4;
		public const CX_UR45:int = 5;
		public const CX_LL45:int = 6;
		public const CX_LR45:int = 7;
		
		// 22.5 degree diagonals
		public const CX_UL225A:int = 8;
		public const CX_UL225B:int = 9;
		public const CX_UR225A:int = 10;
		public const CX_UR225B:int = 11;
		public const CX_LL225A:int = 12;
		public const CX_LL225B:int = 13;
		public const CX_LR225A:int = 14;
		public const CX_LR225B:int = 15;
		
		// 67.5 degree diagonals
		public const CX_UL675A:int = 16;
		public const CX_UL675B:int = 17;
		public const CX_UR675A:int = 18;
		public const CX_UR675B:int = 19;
		public const CX_LL675A:int = 20;
		public const CX_LL675B:int = 21;
		public const CX_LR675A:int = 22;
		public const CX_LR675B:int = 23;
		
		// soft tiles
		public const CX_SOFTLF:int = 24;
		public const CX_SOFTRT:int = 25;
		public const CX_SOFTUP:int = 26;
		public const CX_SOFTDN:int = 27;
	
		// special solids
		public const CX_SOLIDX001:int = 28;
		
		// death
		public const CX_DEATH:int = 29;
		
		public const CX_MAX:int = 30;
		
		// collision tile width, height
		public const CX_TILE_WIDTH:int = 16;
		public const CX_TILE_HEIGHT:int = 16;
		
		public const CX_TILE_WIDTH_MASK:int = 15;
		public const CX_TILE_HEIGHT_MASK:int = 15;
		
		public const CX_TILE_WIDTH_UNMASK:int = 0xfffffff0;
		public const CX_TILE_HEIGHT_UNMASK:int = 0xfffffff0;
		
		// alternate tile width, height
		public const TX_TILE_WIDTH:int = 64;
		public const TX_TILE_HEIGHT:int = 64;
		
		public const TX_TILE_WIDTH_MASK:int = 63;
		public const TX_TILE_HEIGHT_MASK:int = 63;
		
		public const TX_TILE_WIDTH_UNMASK:int = 0xffffffc0;
		public const TX_TILE_HEIGHT_UNMASK:int = 0xffffffc0;