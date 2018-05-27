/*
Description:Frequency Divider and Timing Control top block.
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