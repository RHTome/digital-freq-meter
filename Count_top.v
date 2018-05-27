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