
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
