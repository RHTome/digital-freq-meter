module Mux2to1_cnt(Count_CP, Cnt_CP, CPx, measure_mode);
output reg 	Count_CP;
input 		Cnt_CP, CPx, measure_mode;
always @(measure_mode) //measure_mode or Cnt_CP or CPx | measure_mode
begin
	case(measure_mode)
		0:Count_CP <= CPx;
		1:Count_CP <= Cnt_CP;
	endcase
end
endmodule