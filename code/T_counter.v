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
