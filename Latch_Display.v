/*
Description:Latch Decoder and Display
*/
module Latch_Display(HEX0, HEX1, HEX2, HEX3, DotLed, LCD_DATA, LCD_ON, LCD_BLON, LCD_RW, LCD_EN, LCD_RS, initial_nRST, BCD0, BCD1, BCD2, BCD3, count, nRST, Store, measure_mode, OF, CLK_50, F_sel, T_sel);
output [ 6:0]  	HEX0, HEX1, HEX2, HEX3;
output [ 2:0]  	DotLed;
output	 [7:0]	LCD_DATA;				//	LCD Data bus 8 bits
output			LCD_ON;					//	LCD Power ON/OFF
output			LCD_BLON;				//	LCD Back Light ON/OFF
output			LCD_RW;					//	LCD Read/Write Select, 0 = Write, 1 = Read
output			LCD_EN;					//	LCD Enable
output			LCD_RS;					//	LCD Command/Data Select, 0 = Command, 1 = Data
output	 		initial_nRST;
input  [ 3:0]  	BCD0, BCD1, BCD2, BCD3;
input  [ 1:0]  	F_sel, T_sel;
input  [15:0]  	count;
input          	Store, nRST, measure_mode, OF, CLK_50;
wire   [15:0]  	cnt;
wire   [ 3:0]  	LatchBCD0, LatchBCD1, LatchBCD2, LatchBCD3, LatchBCD_H0, LatchBCD_H1, LatchBCD_H2, LatchBCD_H3;

//Latch 4-digit BCD
D_FF Latch0(
	.Q(LatchBCD0), 
	.D(BCD0), 
	.Store(Store), 
	.nRST(nRST)
	);
	//defparam Latch4.N=3;
D_FF Latch1(
	.Q(LatchBCD1), 
	.D(BCD1), 
	.Store(Store), 
	.nRST(nRST)
	);
	//defparam Latch4.N=3;
D_FF Latch2(
	.Q(LatchBCD2), 
	.D(BCD2), 
	.Store(Store), 
	.nRST(nRST)
	);
	//defparam Latch4.N=3;
D_FF Latch3(
	.Q(LatchBCD3), 
	.D(BCD3), 
	.Store(Store), 
	.nRST(nRST)
	);
	//defparam Latch4.N=3;
D_FF Latch4(
	.Q(cnt), 
	.D(count), 
	.Store(Store), 
	.nRST(nRST)
	);
	defparam Latch4.N=15;

BCD_cope U0(
	.O_BCD0(LatchBCD_H0), 
	.O_BCD1(LatchBCD_H1), 
	.O_BCD2(LatchBCD_H2), 
	.O_BCD3(LatchBCD_H3), 
	.LatchBCD0(LatchBCD0), 
	.LatchBCD1(LatchBCD1), 
	.LatchBCD2(LatchBCD2), 
	.LatchBCD3(LatchBCD3), 
	.N(cnt), 
	.OF(OF), 
	.measure_mode(measure_mode),
	.CLK_50(CLK_50), 
	.nRST(nRST),
	.Store(Store)
	);
// Output digits on 7-segment displays  
bcd7seg digit0(
	.oSEG(HEX0), 
	.LatchBCD(LatchBCD_H0)
	);
bcd7seg digit1(
	.oSEG(HEX1), 
	.LatchBCD(LatchBCD_H1)
	);
bcd7seg digit2(
	.oSEG(HEX2), 
	.LatchBCD(LatchBCD_H2)
	);
bcd7seg digit3(
	.oSEG(HEX3), 
	.LatchBCD(LatchBCD_H3)
	);
Dotled led(
	.DotLed(DotLed), 
	.Store(Store), 
	.nRST(nRST), 
	.measure_mode(measure_mode), 
	.N(cnt),
	.F_sel(F_sel), 
	.T_sel(T_sel)
	); 
lcd U1(
	.CLK_50(CLK_50),
	.nRST(nRST),
	.measure_mode(measure_mode),
	.N(cnt),
	.Store(Store),
	.T0(LatchBCD0),
	.T1(LatchBCD1),
	.T2(LatchBCD2),
	.T3(LatchBCD3),
	.Latch0(LatchBCD_H0),
	.Latch1(LatchBCD_H1),
	.Latch2(LatchBCD_H2),
	.Latch3(LatchBCD_H3),
	.DotLed(DotLed),
	.LCD_ON(LCD_ON),
	.LCD_BLON(LCD_BLON),
	.LCD_RW(LCD_RW),
	.LCD_EN(LCD_EN),
	.LCD_RS(LCD_RS),
	.LCD_DATA(LCD_DATA),
	.initial_nRST(initial_nRST)
);
endmodule