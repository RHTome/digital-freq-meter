module Clock_nRST(clk_wait, measure_mode, CLK_50, F_sel, T_sel);
output	[6:0]	clk_wait;
input 			CLK_50;
input	[1:0]	F_sel, T_sel;
input			measure_mode;
reg		[6:0]	clk_wait;
always @(posedge CLK_50) begin
	case(measure_mode)
		0:begin
			case(F_sel)
				2'b00:clk_wait<=7'b000_0001;
				2'b01:clk_wait<=7'b000_0010;
				2'b10:clk_wait<=7'b000_0100;
				2'b11:clk_wait<=7'b000_1000;
			endcase
		end
		1:begin
			case(T_sel)
				2'b00:clk_wait<=7'b001_0000;
				2'b01:clk_wait<=7'b010_0000;
				2'b10:clk_wait<=7'b100_0000;
			endcase
		end
	endcase
end
endmodule