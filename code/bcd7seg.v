/*
Description:7 segment decoder
*/ 
module bcd7seg (oSEG, LatchBCD); 
output reg [6:0]        oSEG;
input      [3:0]    LatchBCD;
always @ (LatchBCD) 
begin
	case (LatchBCD)
		4'h0: oSEG = 7'b1000000;//40
		4'h1: oSEG = 7'b1111001;//79
		4'h2: oSEG = 7'b0100100;//24
		4'h3: oSEG = 7'b0110000;//30	 
		4'h4: oSEG = 7'b0011001;//19
		4'h5: oSEG = 7'b0010010;//12
		4'h6: oSEG = 7'b0000010;//03
		4'h7: oSEG = 7'b1111000;//78
		4'h8: oSEG = 7'b0000000;//00
		4'h9: oSEG = 7'b0010000;//10
		4'hf: oSEG = 7'b0001110;//0E
		default: oSEG = 7'b1111111;
	endcase 
end

endmodule