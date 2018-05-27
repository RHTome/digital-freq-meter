/*
Description:There are three modules in the top module: Timing_Control, BCD_Counter, Latch_Display.
*/
module freq_meter(
	LEDR, 
	HEX0, HEX1, HEX2, HEX3, 
	LCD_ON, LCD_BLON, LCD_RW, LCD_EN, LCD_RS, LCD_DATA, 
	CLK_50, KEY, SW, GPIO_0
);

output 	[9:7]   LEDR;
//The signal to be measured is input from the GPIO_0
input 	[0:0] 	GPIO_0;

//display
output 	[6:0] 	HEX0, HEX1, HEX2, HEX3; 
output	[7:0]	LCD_DATA;				//	LCD Data bus 8 bits
output			LCD_ON;					//	LCD Power ON/OFF
output			LCD_BLON;				//	LCD Back Light ON/OFF
output			LCD_RW;					//	LCD Read/Write Select, 0 = Write, 1 = Read
output			LCD_EN;					//	LCD Enable
output			LCD_RS;					//	LCD Command/Data Select, 0 = Command, 1 = Data

//system clock
input 			CLK_50;
input	[3:0] 	SW;
//the "reset" push-button
input 	[0:0]	KEY;
wire 	nRST	= KEY[0];
wire  	Switch 	= SW [0];
wire  	[1:0]  Select = SW[2:1];
wire  	test	= SW [3];
wire  	[ 1:0] 	T_sel,F_sel;
wire  	[15:0] 	count;
wire  	[ 3:0] 	BCD0, BCD1, BCD2, BCD3;
wire  	[ 3:0] 	BOut0, BOut1, BOut2, BOut3;
wire  	[ 2:0] 	DotLed;
wire  	[ 4:0] 	unable;
wire  	[ 1:0] 	Status_Value;
wire  			C_Clear, C_Enable, C_Store;
wire 			_10kHz, _100kHz, _1MHz, inc;
wire 			CPx, measure_mode, range_change, OF, initial_nRST, test_nRST; 
//output initial_nRST;
//output [ 3:0] BCD0, BCD1, BCD2, BCD3;
//output C_Clear, C_Enable, C_Store;
//output measure_mode,inc;
//output [ 1:0] F_sel, T_sel;
//output  [ 4:0] unable;
//output  [ 1:0] Status_Value;
assign LEDR = DotLed;

Control_top UT0(
	.C_Clear		(C_Clear), 
	.C_Enable		(C_Enable), 
	.C_Store		(C_Store), 
	._10kHz 		(_10kHz), 
	._100kHz		(_100kHz), 
	._1MHz			(_1MHz),
	.inc			(inc), 
	.Status_Value	(Status_Value),
	.CLK_50			(CLK_50), 
	.measure_mode	(measure_mode), 
	.range_change(range_change),
	.nRST(nRST), 
	.ini_nRST(initial_nRST),
	.test_nRST(test_nRST),
	.CPx			(CPx),
	.unable			(unable),
	.F_sel			(F_sel),
	.T_sel 			(T_sel),
	.OF(OF)
	);
Count_top UT1(
	.BCD0(BCD0), 
	.BCD1(BCD1), 
	.BCD2(BCD2), 
	.BCD3(BCD3), 
	.count(count),
	.unable(unable),
	.C_Enable(C_Enable), 
	.C_Store(C_Store),
	.C_Clear(C_Clear),  
	.measure_mode(measure_mode), 
	.T_sel(T_sel),  
	._10kHz(_10kHz), 
	._100kHz(_100kHz), 
	._1MHz(_1MHz), 
	.CPx(CPx), 
	.nRST(nRST && initial_nRST),
	.Status_Value(Status_Value)
	);
range_detect UT2(
	.BOut0(BOut0), 
	.BOut1(BOut1), 
	.BOut2(BOut2), 
	.BOut3(BOut3), 
	.F_sel(F_sel),
	.T_sel(T_sel),
	.measure_mode(measure_mode),
	.OF(OF),
	.range_change(range_change),
	.BCD0(BCD0), 
	.BCD1(BCD1), 
	.BCD2(BCD2), 
	.BCD3(BCD3), 
	.count(count),
	.CLK_50(CLK_50), 
	.Clear(C_Clear), 
	.En(C_Enable), 
	.Store(C_Store), 
	.nRst(nRST && initial_nRST),
	.Switch(Switch),
	.Select(Select)
	);
Latch_Display UT3(
	.HEX0(HEX0), 
	.HEX1(HEX1), 
	.HEX2(HEX2), 
	.HEX3(HEX3), 
	.DotLed(DotLed),
	.LCD_DATA(LCD_DATA), 
	.LCD_ON(LCD_ON), 
	.LCD_BLON(LCD_BLON), 
	.LCD_RW(LCD_RW), 
	.LCD_EN(LCD_EN), 
	.LCD_RS(LCD_RS), 
	.initial_nRST(initial_nRST),
	.BCD0(BOut0), 
	.BCD1(BOut1), 
	.BCD2(BOut2), 
	.BCD3(BOut3), 
	.count(count),
	.nRST(nRST), 
	.Store(C_Store),
	.measure_mode(measure_mode),
	.OF(OF),
	.CLK_50(CLK_50),
	.F_sel(F_sel),
	.T_sel(T_sel)
	); 

Self_Test UT4(
	.CPx(CPx), 
	.test_nRST(test_nRST),
	.inc(inc), 
	.GPIO_0(GPIO_0), 
	.test(test)
	);

endmodule
