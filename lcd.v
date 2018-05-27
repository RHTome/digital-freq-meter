
module lcd
	(	
		CLK_50,						//	50 MHz
		nRST,
		measure_mode,
		N,
		Store,
		T0, 
		T1, 
		T2, 
		T3, 
		Latch0, 
		Latch1, 
		Latch2, 
		Latch3,
		DotLed,
		LCD_ON,							//	LCD Power ON/OFF
		LCD_BLON,						//	LCD Back Light ON/OFF
		LCD_RW,							//	LCD Read/Write Select, 0 = Write, 1 = Read
		LCD_EN,							//	LCD Enable
		LCD_RS,							//	LCD Command/Data Select, 0 = Command, 1 = Data
		LCD_DATA,						//	LCD Data bus 8 bits
		initial_nRST
	);

////////////////////////	Clock Input	 	////////////////////////
input			CLK_50, nRST, measure_mode, Store;
input 	[15:0] 	N;
input 	[3:0]	T0, T1, T2, T3, Latch0, Latch1, Latch2, Latch3;
input 	[2:0]	DotLed;
////////////////////	LCD Module 16X2	////////////////////////////
output	[7:0]	LCD_DATA;				//	LCD Data bus 8 bits
output			LCD_ON;					//	LCD Power ON/OFF
output			LCD_BLON;				//	LCD Back Light ON/OFF
output			LCD_RW;					//	LCD Read/Write Select, 0 = Write, 1 = Read
output			LCD_EN;					//	LCD Enable
output			LCD_RS;					//	LCD Command/Data Select, 0 = Command, 1 = Data
output	 		initial_nRST;
wire 	[8:0] 	T0_LCD, T1_LCD, T2_LCD, T3_LCD, Latch0_LCD, Latch1_LCD, Latch2_LCD, Latch3_LCD;

//	LCD ON
assign	LCD_ON		=	1'b1;
assign	LCD_BLON	=	1'b1;
assign	LCD_RW		=	1'b0;

ASCII_cope U1(T0_LCD, T1_LCD, T2_LCD, T3_LCD, Latch0_LCD, Latch1_LCD, Latch2_LCD, Latch3_LCD, T0, T1, T2, T3, Latch0, Latch1, Latch2, Latch3);

LCD_Display U2	(
	.CLK_50(CLK_50),
	.nRST(nRST),
	.measure_mode(measure_mode),
	.N(N),
	.Store(Store),
	.T0_LCD(T0_LCD), 
	.T1_LCD(T1_LCD), 
	.T2_LCD(T2_LCD), 
	.T3_LCD(T3_LCD), 
	.Latch0_LCD(Latch0_LCD), 
	.Latch1_LCD(Latch1_LCD), 
	.Latch2_LCD(Latch2_LCD), 
	.Latch3_LCD(Latch3_LCD), 
	.DotLed(DotLed),
	.LCD_DATA(LCD_DATA),
	.LCD_EN(LCD_EN),
	.LCD_RS(LCD_RS),
	.initial_nRST(initial_nRST)
	);

endmodule
