module ASCII(ascii, BCD);
output reg 	[8:0] ascii;
input 		[3:0] BCD;

always @(BCD) 
begin
	case(BCD)
		4'h0:ascii 	<=	9'h130;
		4'h1:ascii 	<=	9'h131;
		4'h2:ascii 	<=	9'h132;
		4'h3:ascii 	<=	9'h133;
		4'h4:ascii 	<=	9'h134;
		4'h5:ascii 	<=	9'h135;
		4'h6:ascii 	<=	9'h136;
		4'h7:ascii 	<=	9'h137;
		4'h8:ascii 	<=	9'h138;
		4'h9:ascii 	<=	9'h139;
		4'hf:ascii 	<=	9'h146;
		default:ascii 	<=	9'h120;
	endcase
end
endmodule