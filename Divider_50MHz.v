/*
Description:Modulo-25×10^6 binary counter.Clock frequency is 50MHz, and output frequency is 1Hz.
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