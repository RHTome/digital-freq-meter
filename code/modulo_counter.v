/*
Description:Frequency Dividerand Timing Control top block.
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
