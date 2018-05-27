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