module Mux2to1_En(Enable, Ctrl_CP, CPx, measure_mode, range_change, nRst);
output reg 	Enable;
input  		Ctrl_CP, CPx, measure_mode, range_change, nRst;
reg 		iEn;

always @(measure_mode or Ctrl_CP or CPx) begin//measure_mode or Ctrl_CP or CPx | measure_mode
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
