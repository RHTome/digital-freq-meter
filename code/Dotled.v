module Dotled (DotLed, Store, nRST, measure_mode, N, F_sel, T_sel); 
output reg 	[2:0]   DotLed;
input      	[1:0]	F_sel, T_sel;
input      			Store, nRST, measure_mode;
input 		[15:0] 	N;
always @(posedge Store, negedge nRST)
begin
	if(!nRST) 
		DotLed <= 3'b000;
	else begin
		case(measure_mode)
			0:begin
				case(F_sel)
					2'b00: DotLed <= 3'b100;
					2'b01: DotLed <= 3'b010;
					2'b10: DotLed <= 3'b001;
					2'b11: DotLed <= 3'b000;
				endcase	
			end
			1:begin
				if(N==1000)begin
					case(T_sel)
						2'b00: DotLed <= 3'b010;
						2'b01: DotLed <= 3'b001;
						2'b10: DotLed <= 3'b000;
					endcase
				end
				else begin
					case(T_sel)
						2'b00: DotLed <= 3'b100;
						2'b01: DotLed <= 3'b010;
						2'b10: DotLed <= 3'b001;
					endcase
				end
			end
		endcase
	end
end
endmodule