module BCD_cope(O_BCD0, O_BCD1, O_BCD2, O_BCD3, LatchBCD0, LatchBCD1, LatchBCD2, LatchBCD3, N, OF, measure_mode, CLK_50, nRST, Store);
output reg [ 3:0] O_BCD0, O_BCD1, O_BCD2, O_BCD3;
input      [ 3:0] LatchBCD0, LatchBCD1, LatchBCD2, LatchBCD3;
input             measure_mode, OF, CLK_50, nRST, Store;
input      [15:0] N;
reg        [15:0] freq;
parameter FT = 10000000; 
always @(posedge CLK_50 or negedge nRST) 
begin
	if(!nRST)begin
		O_BCD0 <= 4'h0;
		O_BCD1 <= 4'h0;
		O_BCD2 <= 4'h0;
		O_BCD3 <= 4'h0;
	end
	else if (Store==1) begin
		case(measure_mode)
			0:begin
				O_BCD0 <= LatchBCD0;
				O_BCD1 <= LatchBCD1;
				O_BCD2 <= LatchBCD2;
				O_BCD3 <= LatchBCD3;
			end
			1:begin
				if (!OF) begin
					case(N)
						0:begin
							O_BCD0 <= 4'h0;
							O_BCD1 <= 4'h0;
							O_BCD2 <= 4'h0;
							O_BCD3 <= 4'h0;
						end
						default:begin
							case(N)
								1000:	freq <= FT/(10*N);
								default:freq <= FT/N;
							endcase
							O_BCD0	<=	freq%10;
							O_BCD1	<=	(freq/10)%10;
							O_BCD2	<=	(freq/100)%10;
							O_BCD3	<=	(freq/1000)%10;
						end
					endcase
				end
			end
		endcase		
	end

end
endmodule