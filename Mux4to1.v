
module Mux4to1(Ctrl_CP, _1Hz, _10Hz, _100Hz, _1kHz, F_sel);
output reg 	Ctrl_CP;
input  		_1Hz, _10Hz, _100Hz, _1kHz;
input [1:0] F_sel;

always @(F_sel) //F_sel or _1kHz or _100Hz or _10Hz or _1Hz | F_sel
begin
	case(F_sel)
		2'b00: Ctrl_CP <= _1Hz;
		2'b01: Ctrl_CP <= _10Hz;
		2'b10: Ctrl_CP <= _100Hz;
		2'b11: Ctrl_CP <= _1kHz;	
		default: Ctrl_CP <= _1kHz;
	endcase
end
endmodule