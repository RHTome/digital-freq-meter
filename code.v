//file tree
Cyclone II: EP2C35F672C6			

	    Entity							  Logic Cells

freq_meter									2427 (2)
Control_top:UT0								292 (0)
	CP_1MHz_1Hz:U0							205	(8)
		Clock_nRST:U1						7	(7)
			Divider_50MHz:U2				22 (22)
			Divider_50MHz:U3				26 (26)
			Divider_50MHz:U4				32 (32)
			Divider_50MHz:U5				37 (37)
			Divider_50MHz:U6				17 (17)
			Divider_50MHz:U7				12 (12)
			Divider_50MHz:U8				11 (11)
			Divider_50MHz:U9				33 (33)
		Mux4to1:U1							3  (3 )
		Mux2to1_En:U2						3  (3 )
		Clear_Store:U3						81 (81)
	Count_top:UT1							54 (1 )
		Mux3to1:U0							3  (3 )
		Mux2to1_cnt:U1						1  (1 )
		BCD_Counter:U2						49 (3 )
			T_counter:cnt					18 (18)
			modulo_counter:hundreds			8  (8 )
			modulo_counter:ones				5  (5 )
			modulo_counter:tens				8  (8 )
			modulo_counter:thousands		7  (7 )
	range_detect:UT2						71 (71)
	Latch_Display:UT3						2017 (0)
		D_FF:Latch0							4  (4 )
		D_FF:Latch1							4  (4 )
		D_FF:Latch2							4  (4 )
		D_FF:Latch3							4  (4 )
		D_FF:Latch4							16 (16)
		BCD_cope:U0							1589 (73)
			lpm_divide:Div0					540 (0)
			lpm_divide:Div1					160 (0)
			lpm_divide:Div2					201 (0)
			lpm_divide:Div3					185 (0)
			lpm_divide:Mod0					160 (0)
			lpm_divide:Mod1					132 (0)
			lpm_divide:Mod2					90  (0)
			lpm_divide:Mod3					48  (0)
		lcd:U1									363 (0)
			ASCII_cope:U1						35  (0)
				ASCII:L0						3   (3)
				ASCII:L1						3   (3)
				ASCII:L2						3   (3)
				ASCII:L3						5   (5)
				ASCII:U0						6   (6)
				ASCII:U1						5   (5)
				ASCII:U2						4   (4)
				ASCII:U3						6   (6)
			LCD_Display:U2						339 (339)
			cd7seg:digit0						8  (8 )
			bcd7seg:digit1						8  (8 )
			bcd7seg:digit2						8  (8 )
			bcd7seg:digit3						8  (8 )
			Dotled:led							17 (17)
	Self_Test:UT4								1  (1 )

/////////////////////////////////////////////////////////////////////////////////////////////////////

//Top module
/*
Description:There are three modules in the top module: Timing_Control, BCD_Counter, Latch_Display.
filename:freq_meter.v
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
	.nRst(nRST & initial_nRST),
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


/*
Description:Frequency Divider and Timing Control top block.
filename:Control_top.v
top module: freq_meter
*/
module Control_top(C_Clear, C_Enable, C_Store, _10kHz, _100kHz, _1MHz, inc, Status_Value, CLK_50, measure_mode, range_change, nRST, ini_nRST, test_nRST, CPx, unable, F_sel, T_sel, OF);

output 			C_Clear, C_Enable, C_Store; 
//connected to LED to indicate the work status
output 			_10kHz, _100kHz, _1MHz, inc;
output [1:0] 	Status_Value;
input  			CLK_50,  measure_mode, range_change, nRST, ini_nRST, test_nRST, CPx, OF;
input  [4:0]	unable;
input  [1:0] 	F_sel, T_sel; 
wire  			_1Hz, _10Hz, _100Hz, _1kHz; 
wire   			Ctrl_CP;

CP_1MHz_1Hz U0(
	._1Hz(_1Hz), 
	._10Hz(_10Hz), 
	._100Hz(_100Hz), 
	._1kHz(_1kHz), 
	._10kHz(_10kHz),
	._100kHz(_100kHz), 
	._1MHz(_1MHz), 
	.inc(inc), 
	.CLK_50(CLK_50), 
	.nRST(nRST & ini_nRST),
	.test_nRST(test_nRST),
	.measure_mode(measure_mode),
	.F_sel(F_sel), 
	.T_sel(T_sel)
	);
Mux4to1 U1(
	.Ctrl_CP(Ctrl_CP), 
	._1Hz(_1Hz), 
	._10Hz(_10Hz), 
	._100Hz(_100Hz), 
	._1kHz(_1kHz), 
	.F_sel(F_sel)
	);
Mux2to1_En U2(
	.Enable(C_Enable), 
	.Ctrl_CP(Ctrl_CP), 
	.CPx(CPx), 
	.measure_mode(measure_mode),
	.range_change(range_change),
	.nRst(nRST & ini_nRST)
	);
Clear_Store U3(
	.Store(C_Store), 
	.Clear(C_Clear), 
	.Status_Value(Status_Value),
	.measure_mode(measure_mode),
	.Enable(C_Enable), 
	.OF(OF),
	.F_sel(F_sel),
	.T_sel(T_sel),
	.unable(unable),
	.CLK_50(CLK_50), 
	.nRST(nRST & ini_nRST)
	);
endmodule

/*
filename: Count_top.v
top module: freq_meter
*/
module Count_top(BCD0, BCD1, BCD2, BCD3, count, unable, C_Enable, C_Store, C_Clear, measure_mode, T_sel,  _10kHz, _100kHz, _1MHz, 
CPx, nRST, Status_Value);
output [ 3:0] BCD0, BCD1, BCD2, BCD3;
output [15:0] count;
output [ 4:0] unable;
input         C_Enable, C_Store, C_Clear, measure_mode, _10kHz, _100kHz, _1MHz, CPx, nRST;
input  [ 1:0] T_sel;
input  [ 1:0] Status_Value;
wire          Count_CP, Cnt_CP;
Mux3to1     U0(
	.Cnt_CP(Cnt_CP), 
	._10kHz(_10kHz), 
	._100kHz(_100kHz), 
	._1MHz(_1MHz), 
	.T_sel(T_sel)
	);
Mux2to1_cnt U1(
	.Count_CP(Count_CP), 
	.Cnt_CP(Cnt_CP), 
	.CPx(CPx), 
	.measure_mode(measure_mode)
	);
BCD_Counter U2(
	.BCD3(BCD3), 
	.BCD2(BCD2), 
	.BCD1(BCD1), 
	.BCD0(BCD0), 
	.count(count),
	.unable(unable),
	.Count_CP(Count_CP), 
	.En(C_Enable), 
	.Store(C_Store),
	.Status_Value(Status_Value),
	//active-low clear input. Clear=0 when C_Clear=1 or nRST=0.
	.Clear(~C_Clear & nRST),
	.nRST(nRST)
	);
endmodule

/*
filename: range_detect.v
top module: freq_meter
*/
module range_detect(
	BOut0, BOut1, BOut2, BOut3, 
	F_sel, T_sel, measure_mode, 
	range_change, OF, 
	BCD0, BCD1, BCD2, BCD3, 
	count, CLK_50, 
	Clear, En, Store, 
	nRst, Switch, Select
	);
output 	reg [3:0 ] 	BOut0, BOut1, BOut2, BOut3;
output 	reg [1:0 ] 	F_sel, T_sel;
output	reg			measure_mode, range_change;

//overflow flag
output	reg			OF;
input		[3:0 ]	BCD0, BCD1, BCD2, BCD3;
input		[15:0]  count;
input				CLK_50, Clear, En, Store, nRst;
input				Switch;
input		[1:0 ]  Select;
//a gate used for decreasing sel_out
reg       Pre_Switch;
reg 		[1:0 ]  mode_change;
reg 		[1:0 ]  cnt;


always @(posedge CLK_50, negedge nRst)
begin
	if(!nRst)begin
		OF <= 1'b0;
		//allow decrease sel_out for one time
		range_change <= 1'b1;
		F_sel <= Select;
		T_sel <= Select;
		measure_mode <= Switch;
		mode_change	<=	2'b00;
		cnt<=0;
	end
	else begin
		Pre_Switch<=Switch;
		case({Pre_Switch,Switch})
			2'b01:mode_change<=2'b01;
			2'b10:mode_change<=2'b10;
		endcase
		if(En && range_change) begin
			cnt<=0;
			if(count>16'd9999)begin
				OF <= 1'b1;
				range_change<=1'b0;
				case(measure_mode)
					0:begin
						if(F_sel<2'b11)begin
							//increase the measuring range.
							F_sel <= F_sel+1'b1;
						end
					end
					1:begin
						if(T_sel>0) begin
							T_sel <= T_sel-1'b1;
						end
					end
				endcase
			end
		end
		else begin
			case(OF)
				1:begin
					BOut0 <= 4'hf;
					BOut1 <= 4'hf;
					BOut2 <= 4'hf;
					BOut3 <= 4'hf;	
				end
				0:begin
					BOut0 <= BCD0;
					BOut1 <= BCD1;
					BOut2 <= BCD2;
					BOut3 <= BCD3;
					if(Store && range_change)begin
						case(measure_mode)
							0:begin
								if(!BCD3)begin
									case(F_sel)
										2'b00:begin
											mode_change <= 2'b01;
											T_sel <= 2'b10;
										end
										default:F_sel <= F_sel-1'b1;
									endcase
								end
							end
							1:begin
								if(!BCD3)begin
									case(T_sel)
										2'b10:begin
											mode_change <= 2'b10;
											F_sel <= 2'b11;
										end
										default:T_sel <= T_sel+1'b1;
									endcase
								end
							end
						endcase
						range_change <= 1'b0;
					end
				end
			endcase
		end
		if(Clear)begin
			//reset for next measuring.
			OF <= 1'b0;
			range_change <= 1'b1;
			case(mode_change)
				2'b10: measure_mode <= 1'b0;
				2'b01: measure_mode <= 1'b1;
			endcase
			if (cnt<2) begin
				cnt<=cnt+1'b1;
			end
			else mode_change <= 2'b00;
		end
	end
end
endmodule

/*
filename: Latch_Display.v
top module: freq_meter
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


/*
filename: lcd.v
top module: freq_meter
*/
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


/*
filename: Self_Test.v
top module: freq_meter
*/
module Self_Test(CPx, test_nRST, inc, GPIO_0, test);
output reg 	CPx, test_nRST;
input 		inc;//inner clock
input 		test;//switch for choosing test or measurement
input [0:0] GPIO_0;//external signal 
always @(test)
begin
	case(test)
		1'b0:begin
			CPx <= GPIO_0[0];
			test_nRST <= 1'b0;
		end
		1'b1:begin
			CPx <= inc;
			test_nRST <= 1'b1;
		end
	endcase
end
endmodule


/*
filename: CP_1MHz_1Hz.v
top module: Control_top
*/
module CP_1MHz_1Hz(
	_1Hz, _10Hz, _100Hz, _1kHz, 
	_10kHz, _100kHz, _1MHz, 
	inc, 
	CLK_50, nRST, test_nRST, 
	measure_mode, F_sel, T_sel
	);
output 			_1Hz, _10Hz, _100Hz, _1kHz, _10kHz, _100kHz, _1MHz, inc;
input 			CLK_50, nRST, test_nRST;
input	[1:0]	F_sel, T_sel;
input			measure_mode;
wire	[6:0]	clk_wait;

Clock_nRST U1(clk_wait, measure_mode, CLK_50, F_sel, T_sel); 

Divider_50MHz U2(.CLK_1HzOut(_1kHz), .CLK_50M(CLK_50), .nCLR(nRST && clk_wait[3]));
defparam U2.N = 16,
	 U2.CLK_Freq = 50000000, 
	 U2.OUT_Freq = 1000;

Divider_50MHz U3(.CLK_1HzOut(_100Hz), .CLK_50M(CLK_50), .nCLR(nRST && clk_wait[2]));  
defparam U3.N = 19, 
	 U3.CLK_Freq = 50000000, 
	 U3.OUT_Freq = 100;

Divider_50MHz U4(.CLK_1HzOut(_10Hz), .CLK_50M(CLK_50), .nCLR(nRST && clk_wait[1]));
defparam U4.N = 23, 
	 U4.CLK_Freq = 50000000, 
	 U4.OUT_Freq = 10;

Divider_50MHz U5(.CLK_1HzOut(_1Hz), .CLK_50M(CLK_50), .nCLR(nRST && clk_wait[0]));
defparam U5.N = 26, 
	 U5.CLK_Freq = 50000000, 
	 U5.OUT_Freq = 1;

Divider_50MHz U6(.CLK_1HzOut(_10kHz), .CLK_50M(CLK_50), .nCLR(nRST && clk_wait[4]));
defparam U6.N = 12,
	 U6.CLK_Freq = 50000000,
	 U6.OUT_Freq = 10000;

Divider_50MHz U7(.CLK_1HzOut(_100kHz), .CLK_50M(CLK_50), .nCLR(nRST && clk_wait[5]));
defparam U7.N = 8,
	 U7.CLK_Freq = 50000000, 
	 U7.OUT_Freq = 100000;

Divider_50MHz U8(.CLK_1HzOut(_1MHz), .CLK_50M(CLK_50), .nCLR(nRST && clk_wait[6]));
defparam U8.N = 8,
	 U8.CLK_Freq = 50000000, 
	 U8.OUT_Freq = 1000000;
	 
//inner_test
Divider_50MHz U9(.CLK_1HzOut(inc), .CLK_50M(CLK_50), .nCLR(nRST && test_nRST));
defparam U9.N = 23, 
	 U9.CLK_Freq = 50000000, 
	 U9.OUT_Freq = 5000000;
endmodule


/*
filename: Mux4to1.v
top module: Control_top
*/

module Mux4to1(Ctrl_CP, _1Hz, _10Hz, _100Hz, _1kHz, F_sel);
output reg 	Ctrl_CP;
input  		_1Hz, _10Hz, _100Hz, _1kHz;
input [1:0] F_sel;

always @(F_sel) //F_sel or _1kHz or _100Hz or _10Hz or _1Hz | F_sel
begin
	case(F_sel)
		2'b00: Ctrl_CP <= _1Hz;
		2'b01: Ctrl_CP <= _10Hz;
		2'b10: Ctrl_CP <= _100Hz;
		2'b11: Ctrl_CP <= _1kHz;	
		default: Ctrl_CP <= _1kHz;
	endcase
end
endmodule


/*
filename: Mux2to1_En.v
top module: Control_top
*/
module Mux2to1_En(Enable, Ctrl_CP, CPx, measure_mode, range_change, nRst);
output reg 	Enable;
input  		Ctrl_CP, CPx, measure_mode, range_change, nRst;
reg 		iEn;

always @(measure_mode) begin//measure_mode or Ctrl_CP or CPx | measure_mode
	case(measure_mode)
		0:iEn <= Ctrl_CP;
		1:iEn <= CPx;
	endcase
end

always @(posedge iEn or negedge nRst or negedge range_change) begin
	if (!nRst) begin
		Enable 	<= 0;
	end
	else begin
		if (!range_change) begin
			Enable 	<= 0;
		end
		else begin
			Enable <= ~Enable;	
		end	
	end
end
endmodule


/*
filename: Clear_Store.v
top module: Control_top
*/
module Clear_Store(Store, Clear, Status_Value, measure_mode, Enable, OF, F_sel, T_sel, unable, nRST, CLK_50);
output reg 			Store, Clear;
//Status_Value = 1:Clear is allowed.
//Status_Value = 2:Counting is allowed.
output reg 	[1:0] 	Status_Value;
input 				measure_mode, Enable, OF, nRST, CLK_50;
input  		[1:0] 	F_sel, T_sel;
input		[4:0] 	unable;
//Clear times, used to control the width of Clear.
reg 		[7:0] 	Cltm;
//Store times, used to control the width of Store.
reg 		[23:0]	Sttm;
reg 		[1:0] 	F_sel_pre, T_sel_pre;
reg					allow_clear, allow_store;
//after nRST is active, overlook the Store and Clear for one time before Enable.
reg 				jump;
wire 				no_store;
assign no_store = OF && ((!measure_mode && F_sel_pre!=2'b11)||(measure_mode && T_sel_pre!=2'b00));

parameter store_width = 5000000;//100ms=5000000
always @(posedge Enable)
begin
	F_sel_pre <= F_sel;
	T_sel_pre <= T_sel;
end

always @(posedge CLK_50 or negedge nRST)
begin
if(!nRST)begin
		Clear <= 0;
		Store <= 0;
		Cltm <= 0;
		Sttm <= 0;
		allow_clear <= 1;
		allow_store <= 1;
		Status_Value <= 2'b11;
		jump <= 1;
	end
	else begin
		if(no_store)begin
			Status_Value <= 2'b10;
			allow_store <= 1'b0;
			allow_clear <= 1'b1;
		end
		else begin
			if(!jump)begin
				if(!Enable && allow_store) Store <= 1;
				if (Store) begin
					Sttm <= Sttm+1'b1;
					if (Sttm==1) Status_Value<=2'b01;
					if(Sttm == store_width)begin
						Store <= 0;
						Sttm <= 0;
						allow_store <= 0;
						Status_Value <= 2'b10;
					end
				end
			end
		end
		if(Status_Value == 2'b10 && allow_clear)begin
			Clear <= 1;
			Cltm <= Cltm+1'b1;
			if(Cltm == 20)begin
				Clear <= 0;
				Cltm <= 0;
				allow_clear <= 0;
				Status_Value <= 2'b11;
			end
		end
		if(Enable)begin
			jump <= 0;
			if (Status_Value == 2'b11) begin
				if (!unable[0]) begin
					allow_clear <= 1;
					allow_store <= 1;	
				end
				else begin
					allow_clear <= 0;
					allow_store <= 0;
				end	
			end
		end
	end
end
endmodule


/*
Description:Modulo-25×10^6 binary counter.Clock frequency is 50MHz, and output frequency is 1Hz.
filename: Divider_50MHz.v
top module: CP_1MHz_1Hz
*/
module Divider_50MHz(CLK_1HzOut, CLK_50M, nCLR);
//declare all the types of the port in one statement
output reg 	CLK_1HzOut;
input 		nCLR, CLK_50M;

//2^x>(50/2)M, get x> = 25
parameter N = 25;
//clock frequency
parameter CLK_Freq = 50000000;
parameter OUT_Freq = 1;

//counter
reg [N-1:0] Count_DIV;

//Response to the rising edge of CLK_50M and the falling edge of nCLR(Asynchronous reset)
always @(posedge CLK_50M or negedge nCLR) begin
	if (!nCLR) begin
		//reset the output signal
		CLK_1HzOut <= 0;
		//reset the counter
		Count_DIV <= 0;
	end
	else  begin
		if (Count_DIV<(CLK_Freq/(2*OUT_Freq)-1)) 
			Count_DIV <= Count_DIV+1'b1; 
		else begin
			//reset Count_DIV and turned over the output signal when finishes half a cycle
			Count_DIV <= 0;
			CLK_1HzOut <= ~CLK_1HzOut;
		end
	end
end
endmodule

/*
filename: Mux3to1.v
top module: Count_top
*/
module Mux3to1(Cnt_CP, _10kHz, _100kHz, _1MHz, T_sel);
output reg 	Cnt_CP;
input 		_10kHz, _100kHz, _1MHz;
input [1:0] T_sel;

always @(T_sel) //T_sel or _10kHz or _100kHz or _1MHz | T_sel
begin
	case(T_sel)
		2'b00: Cnt_CP <= _10kHz;
		2'b01: Cnt_CP <= _100kHz;
		2'b10: Cnt_CP <= _1MHz;
		default: Cnt_CP <= _10kHz;
	endcase
end
endmodule


/*
filename: Mux2to1_cnt.v
top module: Count_top
*/
module Mux2to1_cnt(Count_CP, Cnt_CP, CPx, measure_mode);
output reg 	Count_CP;
input 		Cnt_CP, CPx, measure_mode;
always @(measure_mode) //measure_mode or Cnt_CP or CPx | measure_mode
begin
	case(measure_mode)
		0:Count_CP <= CPx;
		1:Count_CP <= Cnt_CP;
	endcase
end
endmodule


/*
filename: BCD_Counter.v
top module: Count_top
*/
module BCD_Counter(BCD3, BCD2, BCD1, BCD0, count, unable, Count_CP, En, Store, Status_Value, Clear, nRST);
output [ 3:0] BCD3, BCD2, BCD1, BCD0;
output [15:0] count;
output [ 4:0] unable;
input         Count_CP, En, Store, Clear, nRST; 
input  [ 1:0] Status_Value; 
wire          CO_BCD0, CO_BCD1, CO_BCD2, CO_BCD3;

modulo_counter ones(
	.Q(BCD0), 
	.Carry_out(CO_BCD0), 
	.unable(unable[0]),
	.CP(Count_CP), 
	.Clear(Clear),
	.nRST(nRST), 
	.En(En),
	.Store(Store),
	.Status_Value(Status_Value)
	);
defparam ones.N = 4;
defparam ones.MOD = 10;

modulo_counter tens(
	.Q(BCD1), 
	.Carry_out(CO_BCD1),
	.unable(unable[1]), 
	.CP(Count_CP), 
	.Clear(Clear),
	.nRST(nRST), 
	.En(En&CO_BCD0),
	.Store(Store),
	.Status_Value(Status_Value)
	);
defparam tens.N = 4;
defparam tens.MOD = 10;

modulo_counter hundreds(
	.Q(BCD2), 
	.Carry_out(CO_BCD2), 
	.unable(unable[2]),
	.CP(Count_CP), 
	.Clear(Clear),
	.nRST(nRST), 
	.En(En&CO_BCD0&CO_BCD1),
	.Store(Store),
	.Status_Value(Status_Value)
	);
defparam hundreds.N = 4;
defparam hundreds.MOD = 10;

modulo_counter thousands(
	.Q(BCD3), 
	.Carry_out(CO_BCD3), 
	.unable(unable[3]),
	.CP(Count_CP), 
	.Clear(Clear),
	.nRST(nRST), 
	.En(En&CO_BCD0&CO_BCD1&CO_BCD2),
	.Store(Store),
	.Status_Value(Status_Value)
	);
defparam thousands.N = 4;
defparam thousands.MOD = 10;

T_counter cnt(
	.Q(count), 
	.unable(unable[4]),
	.CP(Count_CP), 
	.Clear(Clear),
	.nRST(nRST), 
	.En(En),
	.Store(Store),
	.Status_Value(Status_Value)
	);
endmodule

/*
filename: T_counter.v
top module: BCD_Counter
*/
module T_counter(Q, unable, CP, Clear, nRST, En, Store, Status_Value);
output reg 	[15:0] 	Q;
output reg  		unable;
input  				CP, Clear, nRST, En, Store;
input 		[1:0] 	Status_Value;
parameter N = 16; 

always @(posedge En or negedge nRST) 
begin
	if(!nRST) unable <= 0;
	else begin
		if (Status_Value == 2'b11) unable <= 0;
		else unable <= 1;
	end
end

always @ (posedge CP or negedge Clear) 
begin
	if(!Clear) Q <= 4'b0000;
	else if(!unable) begin
		if(En) Q <= Q+1'b1;
	end
end
endmodule


/*
Description:Frequency Dividerand Timing Control top block.
filename: modulo_counter.v
top module: BCD_Counter
*/
module modulo_counter(Q, Carry_out, unable, CP, Clear, nRST, En, Store, Status_Value); 
parameter     N =  4; 
parameter   MOD = 16; 
output 					Carry_out; 
output reg 	[N-1:0] 	Q; 
output reg    			unable;
input   				CP, Clear, nRST, En, Store;
input 		[1:0] 		Status_Value;

always @(posedge En or negedge nRST) 
begin
	if(!nRST) unable <= 0;
	else begin
		if (Status_Value == 2'b11) unable <= 0;
		else unable <= 1;
	end
end

always @ (posedge CP or negedge Clear) 
begin
	if(!Clear) Q <= 4'b0000; 
	else if(!unable)begin
		if(En) begin	
			if (Q == MOD-1) Q <= 4'b0000;
			else Q <= Q+1'b1;
		end
	end 
end
assign Carry_out = (Q == MOD-1);	
endmodule

/*
Description:D flip-flop
filename: D_FF.v
top module: Latch_Display
*/ 
module D_FF (Q, D, Store, nRST);
parameter   N =  3;
input      [N:0] D;
input  Store, nRST; 

always @(posedge Store or negedge nRST)
begin
	if (!nRST) Q <= 4'b0000; 
	else Q <= D;
end
endmodule


/*
filename: BCD_cope.v
top module: Latch_Display
*/
module BCD_cope(O_BCD0, O_BCD1, O_BCD2, O_BCD3, LatchBCD0, LatchBCD1, LatchBCD2, LatchBCD3, N, OF, measure_mode, CLK_50, nRST, Store);
output reg [ 3:0] O_BCD0, O_BCD1, O_BCD2, O_BCD3;
input      [ 3:0] LatchBCD0, LatchBCD1, LatchBCD2, LatchBCD3;
input             measure_mode, OF, CLK_50, nRST, Store;
input      [15:0] N;
reg        [15:0] freq;
parameter FT = 10000000; 
always @(posedge CLK_50 or negedge nRST) 
begin
	if(!nRST)begin
		O_BCD0 <= 4'h0;
		O_BCD1 <= 4'h0;
		O_BCD2 <= 4'h0;
		O_BCD3 <= 4'h0;
	end
	else if (Store==1) begin
		case(measure_mode)
			0:begin
				O_BCD0 <= LatchBCD0;
				O_BCD1 <= LatchBCD1;
				O_BCD2 <= LatchBCD2;
				O_BCD3 <= LatchBCD3;
			end
			1:begin
				if (!OF) begin
					case(N)
						0:begin
							O_BCD0 <= 4'h0;
							O_BCD1 <= 4'h0;
							O_BCD2 <= 4'h0;
							O_BCD3 <= 4'h0;
						end
						default:begin
							case(N)
								1000:	freq <= FT/(10*N);
								default:freq <= FT/N;
							endcase
							O_BCD0	<=	freq%10;
							O_BCD1	<=	(freq/10)%10;
							O_BCD2	<=	(freq/100)%10;
							O_BCD3	<=	(freq/1000)%10;
						end
					endcase
				end
			end
		endcase		
	end

end
endmodule


/*
filename: lcd.v
top module: Latch_Display
*/

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


/*
filename: ASCII_cope.v
top module: lcd
*/
module ASCII_cope(T0_LCD, T1_LCD, T2_LCD, T3_LCD, Latch0_LCD, Latch1_LCD, Latch2_LCD, Latch3_LCD, T0, T1, T2, T3, Latch0, Latch1, Latch2, Latch3);

output 	[8:0]	T0_LCD, T1_LCD, T2_LCD, T3_LCD, Latch0_LCD, Latch1_LCD, Latch2_LCD, Latch3_LCD;
input 	[3:0]	T0, T1, T2, T3, Latch0, Latch1, Latch2, Latch3;

ASCII U0(.ascii(T0_LCD), .BCD(T0));
ASCII U1(.ascii(T1_LCD), .BCD(T1));
ASCII U2(.ascii(T2_LCD), .BCD(T2));
ASCII U3(.ascii(T3_LCD), .BCD(T3));
ASCII L0(.ascii(Latch0_LCD), .BCD(Latch0));
ASCII L1(.ascii(Latch1_LCD), .BCD(Latch1));
ASCII L2(.ascii(Latch2_LCD), .BCD(Latch2));
ASCII L3(.ascii(Latch3_LCD), .BCD(Latch3));

endmodule

/*
filename: LCD_Display.v
top module: lcd
*/
module	LCD_Display (
	CLK_50, nRST, measure_mode, N, Store, 
	T0_LCD, T1_LCD, T2_LCD, T3_LCD, Latch0_LCD, Latch1_LCD, Latch2_LCD, Latch3_LCD,
	DotLed,
	LCD_DATA, LCD_EN, LCD_RS, initial_nRST
	);

input				CLK_50, nRST, measure_mode, Store;
input 		[15:0] 	N;
input 		[2:0 ]	DotLed;
input		[8:0 ]	T0_LCD, T1_LCD, T2_LCD, T3_LCD, Latch0_LCD, Latch1_LCD, Latch2_LCD, Latch3_LCD;
output	reg [7:0 ]  	LCD_DATA;
output	reg			LCD_EN;
output	reg			LCD_RS;
output	reg			initial_nRST;

reg			[5:0 ]	LUT_INDEX;//index of table
reg			[8:0 ]	LUT_DATA;//look-up-table
reg			[1:0 ]	LCD_ST;//Status
reg			[17:0]	Delay;//
reg 		[17:0]  Delay_time;
reg 		[4:0 ]	Cont;
reg 		[8:0 ]   Num_Char[ 9:0];
reg 		[8:0 ]   Unit_Char[4:0];
parameter	LUT_SIZE	=	34;
parameter	CLK_Divide	=	16;
parameter	Line1		=	18;
parameter	Line2		=	Line1+4;

always@(posedge CLK_50 or negedge nRST)
begin
	if(!nRST)begin
		LUT_INDEX	<=	0;
		LCD_ST		<=	0;
		Delay		<=	0;
		LCD_EN	    <=  0;
		LCD_DATA	<=	0;
		LCD_RS		<=	0;
		Cont 		<= 	0;
	end
	else begin
		if(LUT_INDEX<LUT_SIZE)begin
			case(LCD_ST)
				2'b00:	begin
					LCD_DATA	<=	LUT_DATA[7:0];
					LCD_RS		<=	LUT_DATA[8];
					if (Cont<4) Cont <= Cont + 1'b1;
					else begin
						Cont <= 0;
						LCD_EN	    <=	1'b1;
						LCD_ST		<=	1'b1;	
					end
				end
				2'b01:	begin
					if(Cont<CLK_Divide)
						Cont <= Cont+1'b1;
					else begin
						Cont <= 0;
						LCD_EN 	<=	1'b0;
						LCD_ST	<=	2'b10;
					end
				end
				2'b10:	begin
					if (LCD_RS) Delay_time <= 4000;
					else Delay_time <= 210000;
					if (Cont<1) Cont <= Cont + 1'b1;
					else begin
						if(Delay<Delay_time) Delay	<=	Delay+1'b1;
						else begin
							Cont <= 0;
							Delay	<=	0;
							LCD_ST	<=	2'b11;
						end
					end
				end
				2'b11:	begin
					LUT_INDEX	<=	LUT_INDEX+1'b1;
					if (LUT_INDEX == (Line1+7)) begin
						if (!measure_mode) LUT_INDEX <=	6'd17;
					end
					LCD_ST	<=	2'b00;
					end
			endcase
		end
		else LUT_INDEX	<=	6'd17;
	end
end

always @(posedge CLK_50 or negedge nRST)
begin
if (!nRST) begin
		initial_nRST <=	0;
	end
	else begin
		if(!initial_nRST)begin
			case(LUT_INDEX)
				//	Initial start
				0:	LUT_DATA	<=	9'h038;//0011 1000 Function Set.data length is 8, double lines, 5*8dots
				1:	LUT_DATA	<=	9'h00C;//0000 1100 Display On
				2:	LUT_DATA	<=	9'h001;//0000 0001 Clear Display
				3:	LUT_DATA	<=	9'h006;//0000 0110 LCD_ENtry Mode Set. cursor move to right aotomotic
				4:	LUT_DATA	<=	9'h080;//1000 0000 Set DDRAM Address. 00H
				5:	LUT_DATA	<=	9'h146;//F
				6:	LUT_DATA	<=	9'h172;//r
				7:	LUT_DATA	<=	9'h165;//e
				8:	LUT_DATA	<=	9'h171;//q
				9:	LUT_DATA	<=	9'h13A;//:
				10:	LUT_DATA	<=	9'h0C0;
				11:	LUT_DATA	<=	9'h143;//C
				12:	LUT_DATA	<=	9'h179;//y
				13:	LUT_DATA	<=	9'h163;//c
				14:	LUT_DATA	<=	9'h16C;//l
				15:	LUT_DATA	<=	9'h165;//e
				16:	begin
						LUT_DATA	<=	9'h13A;//:
						if (LCD_ST==2'b11) initial_nRST <= 1;
					end
				//Initial end
				default:		LUT_DATA	<=	9'h000;
			endcase
		end
		else begin
			case(LUT_INDEX)
				Line1-1		:	LUT_DATA	<=	9'h085;
				Line1+0		:	LUT_DATA	<=	Num_Char[0];
				Line1+1		:	LUT_DATA	<=	Num_Char[1];
				Line1+2		:	LUT_DATA	<=	Num_Char[2];
				Line1+3		:	LUT_DATA	<=	Num_Char[3];
				Line1+4		:	LUT_DATA	<=	Num_Char[4];
				Line1+5		:	LUT_DATA	<=	Unit_Char[0];
				Line1+6		:	LUT_DATA	<=	Unit_Char[1];
				Line1+7		:	LUT_DATA	<=	Unit_Char[2];
				Line1+8		:	LUT_DATA	<=	9'h0C6;	
				Line2+5		:	LUT_DATA	<=	Num_Char[5];
				Line2+6		:	LUT_DATA	<=	Num_Char[6];
				Line2+7		:	LUT_DATA	<=	Num_Char[7];
				Line2+8		:	LUT_DATA	<=	Num_Char[8];
				Line2+9		:	LUT_DATA	<=	Num_Char[9];
				Line2+10	:	LUT_DATA	<=	Unit_Char[3];
				Line2+11	:	LUT_DATA	<=	Unit_Char[4];
				default:		LUT_DATA	<=	9'h000;
			endcase
		end
	end
end

always @(posedge CLK_50 or negedge nRST)
begin
	if (!nRST) begin
		Num_Char[0]	<=	9'h120;
		Num_Char[1]	<=	9'h120;
		Num_Char[2]	<=	9'h120;
		Num_Char[3]	<=	9'h120;
		Num_Char[4]	<=	9'h120;
		Num_Char[5]	<=	9'h120;
		Num_Char[6]	<=	9'h120;
		Num_Char[7]	<=	9'h120;
		Num_Char[8]	<=	9'h120;
		Num_Char[9]	<=	9'h120;
		Unit_Char[0]	<=	9'h120;//H
		Unit_Char[1]	<=	9'h120;//z
		Unit_Char[2]	<=	9'h120;
		Unit_Char[3]	<=	9'h120;//m
		Unit_Char[4]	<=	9'h120;//s
	end
	else if(Store)begin
		case(measure_mode)
			0:begin
				case(DotLed)//F_sel
					3'b100:begin
						Num_Char[0]	<=	Latch3_LCD;
						Num_Char[1]	<=	9'h12E;
						Num_Char[2]	<=	Latch2_LCD;
						Num_Char[3]	<=	Latch1_LCD;
						Num_Char[4]	<=	Latch0_LCD;
					end
					3'b010:begin
						Num_Char[0]	<=	Latch3_LCD;
						Num_Char[1]	<=	Latch2_LCD;
						Num_Char[2]	<=	9'h12E;
						Num_Char[3]	<=	Latch1_LCD;
						Num_Char[4]	<=	Latch0_LCD;
					end
					3'b001:begin
						Num_Char[0]	<=	Latch3_LCD;
						Num_Char[1]	<=	Latch2_LCD;
						Num_Char[2]	<=	Latch1_LCD;
						Num_Char[3]	<=	9'h12E;
						Num_Char[4]	<=	Latch0_LCD;
					end
					3'b000:begin
						Num_Char[0]	<=	Latch3_LCD;
						Num_Char[1]	<=	Latch2_LCD;
						Num_Char[2]	<=	Latch1_LCD;
						Num_Char[3]	<=	Latch0_LCD;
						Num_Char[4]	<=	9'h120;
					end
				endcase
				Unit_Char[0]	<=	9'h16B;//k
				Unit_Char[1]	<=	9'h148;//H
				Unit_Char[2]	<=	9'h17A;//z
				//clear the period data
				/*Unit_Char[3]	<=	9'h120;
				Unit_Char[4]	<=	9'h120;
				Num_Char[5]		<=	9'h120;
				Num_Char[6]		<=	9'h120;
				Num_Char[7]		<=	9'h120;
				Num_Char[8]		<=	9'h120;
				Num_Char[9]		<=	9'h120;*/
			end
			1:begin
				if(N==1000)begin 
					case(DotLed)
						3'b010:begin
							Num_Char[0]	<=	Latch3_LCD;
							Num_Char[1]	<=	Latch2_LCD;
							Num_Char[2]	<=	9'h12E;
							Num_Char[3]	<=	Latch1_LCD;
							Num_Char[4]	<=	Latch0_LCD;

							Num_Char[5]	<=	T3_LCD;
							Num_Char[6]	<=	T2_LCD;
							Num_Char[7]	<=	T1_LCD;
							Num_Char[8]	<=	9'h12E;
							Num_Char[9]	<=	T0_LCD;
						end
						3'b001:begin
								Num_Char[0]	<=	Latch3_LCD;
								Num_Char[1]	<=	Latch2_LCD;
								Num_Char[2]	<=	Latch1_LCD;
								Num_Char[3]	<=	9'h12E;
								Num_Char[4]	<=	Latch0_LCD;

								Num_Char[5]	<=	T3_LCD;
								Num_Char[6]	<=	T2_LCD;
								Num_Char[7]	<=	9'h12E;
								Num_Char[8]	<=	T1_LCD;
								Num_Char[9]	<=	T0_LCD;
						end
						3'b000:begin
								Num_Char[0]	<=	Latch3_LCD;
								Num_Char[1]	<=	Latch2_LCD;
								Num_Char[2]	<=	Latch1_LCD;
								Num_Char[3]	<=	Latch0_LCD;
								Num_Char[4]	<=	9'h120;

								Num_Char[5]	<=	T3_LCD;
								Num_Char[6]	<=	9'h12E;
								Num_Char[7]	<=	T2_LCD;
								Num_Char[8]	<=	T1_LCD;
								Num_Char[9]	<=	T0_LCD;
						end
					endcase
				end
				else begin
					case(DotLed)
						3'b100:begin
							Num_Char[0]	<=	Latch3_LCD;
							Num_Char[1]	<=	9'h12E;
							Num_Char[2]	<=	Latch2_LCD;
							Num_Char[3]	<=	Latch1_LCD;
							Num_Char[4]	<=	Latch0_LCD;

							Num_Char[5]	<=	T3_LCD;
							Num_Char[6]	<=	T2_LCD;
							Num_Char[7]	<=	T1_LCD;
							Num_Char[8]	<=	9'h12E;
							Num_Char[9]	<=	T0_LCD;
						end
						3'b010:begin
							Num_Char[0]	<=	Latch3_LCD;
							Num_Char[1]	<=	Latch2_LCD;
							Num_Char[2]	<=	9'h12E;
							Num_Char[3]	<=	Latch1_LCD;
							Num_Char[4]	<=	Latch0_LCD;

							Num_Char[5]	<=	T3_LCD;
							Num_Char[6]	<=	T2_LCD;
							Num_Char[7]	<=	9'h12E;
							Num_Char[8]	<=	T1_LCD;
							Num_Char[9]	<=	T0_LCD;
						end
						3'b001:begin
							Num_Char[0]	<=	Latch3_LCD;
							Num_Char[1]	<=	Latch2_LCD;
							Num_Char[2]	<=	Latch1_LCD;
							Num_Char[3]	<=	9'h12E;
							Num_Char[4]	<=	Latch0_LCD;

							Num_Char[5]	<=	T3_LCD;
							Num_Char[6]	<=	9'h12E;
							Num_Char[7]	<=	T2_LCD;
							Num_Char[8]	<=	T1_LCD;
							Num_Char[9]	<=	T0_LCD;
						end
					endcase
				end
				Unit_Char[0]	<=	9'h148;//H
				Unit_Char[1]	<=	9'h17A;//z
				Unit_Char[2]	<=	9'h120;
				Unit_Char[3]	<=	9'h16D;//m
				Unit_Char[4]	<=	9'h173;//s
			end
		endcase
	end
end 
endmodule


/*
Description:7 segment decoder
filename: bcd7seg.v
top module: lcd
*/ 
module bcd7seg (oSEG, LatchBCD); 
output reg [6:0]        oSEG;
input      [3:0]    LatchBCD;
always @ (LatchBCD) 
begin
	case (LatchBCD)
		4'h0: oSEG = 7'b1000000;//40
		4'h1: oSEG = 7'b1111001;//79
		4'h2: oSEG = 7'b0100100;//24
		4'h3: oSEG = 7'b0110000;//30	 
		4'h4: oSEG = 7'b0011001;//19
		4'h5: oSEG = 7'b0010010;//12
		4'h6: oSEG = 7'b0000010;//03
		4'h7: oSEG = 7'b1111000;//78
		4'h8: oSEG = 7'b0000000;//00
		4'h9: oSEG = 7'b0010000;//10
		4'hf: oSEG = 7'b0001110;//0E
		default: oSEG = 7'b1111111;
	endcase 
end

endmodule


/*
filename: ASCII.v
top module: ASCII_cope
*/
module ASCII(ascii, BCD);
output reg 	[8:0] ascii;
input 		[3:0] BCD;

always @(BCD) 
begin
	case(BCD)
		4'h0:ascii 	<=	9'h130;
		4'h1:ascii 	<=	9'h131;
		4'h2:ascii 	<=	9'h132;
		4'h3:ascii 	<=	9'h133;
		4'h4:ascii 	<=	9'h134;
		4'h5:ascii 	<=	9'h135;
		4'h6:ascii 	<=	9'h136;
		4'h7:ascii 	<=	9'h137;
		4'h8:ascii 	<=	9'h138;
		4'h9:ascii 	<=	9'h139;
		4'hf:ascii 	<=	9'h146;
		default:ascii 	<=	9'h120;
	endcase
end
endmodule