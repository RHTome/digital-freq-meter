module Mux3to1(Cnt_CP, _10kHz, _100kHz, _1MHz, T_sel);
output reg 	Cnt_CP;
input 		_10kHz, _100kHz, _1MHz;
input [1:0] T_sel;

always @(T_sel) //T_sel or _10kHz or _100kHz or _1MHz | T_sel
begin
	case(T_sel)
		2'b00: Cnt_CP <= _10kHz;
		2'b01: Cnt_CP <= _100kHz;
		2'b10: Cnt_CP <= _1MHz;
		default: Cnt_CP <= _10kHz;
	endcase
end
endmodule