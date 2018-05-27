/*
Description:D flip-flop
*/ 
module D_FF (Q, D, Store, nRST);
parameter   N =  3;
output reg [N:0] Q; 
input      [N:0] D;
input  Store, nRST; 

always @(posedge Store or negedge nRST)
begin
	if (!nRST) Q <= 4'b0000; 
	else Q <= D;
end
endmodule