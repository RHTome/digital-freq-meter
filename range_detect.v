module range_detect(
	BOut0, BOut1, BOut2, BOut3, 
	F_sel, T_sel, measure_mode, 
	range_change, OF, 
	BCD0, BCD1, BCD2, BCD3, 
	count, CLK_50, 
	Clear, En, Store, 
	nRst, Switch, Select
	);
output 	reg [3:0 ] 	BOut0, BOut1, BOut2, BOut3;
output 	reg [1:0 ] 	F_sel, T_sel;
output	reg			measure_mode, range_change;

//overflow flag
output	reg			OF;
input		[3:0 ]	BCD0, BCD1, BCD2, BCD3;
input		[15:0]  count;
input				CLK_50, Clear, En, Store, nRst;
input				Switch;
input		[1:0 ]  Select;
//a gate used for decreasing sel_out
reg       Pre_Switch;
reg 		[1:0 ]  mode_change;
reg 		[1:0 ]  cnt;


always @(posedge CLK_50, negedge nRst)
begin
	if(!nRst)begin
		OF <= 1'b0;
		//allow decrease sel_out for one time
		range_change <= 1'b1;
		F_sel <= Select;
		T_sel <= Select;
		measure_mode <= Switch;
		mode_change	<=	2'b00;
		cnt<=0;
	end
	else begin
		Pre_Switch<=Switch;
		case({Pre_Switch,Switch})
			2'b01:mode_change<=2'b01;
			2'b10:mode_change<=2'b10;
		endcase
		if(En && range_change) begin
			cnt<=0;
			if(count>16'd9999)begin
				OF <= 1'b1;
				range_change<=1'b0;
				case(measure_mode)
					0:begin
						if(F_sel<2'b11)begin
							//increase the measuring range.
							F_sel <= F_sel+1'b1;
						end
					end
					1:begin
						if(T_sel>0) begin
							T_sel <= T_sel-1'b1;
						end
					end
				endcase
			end
		end
		else begin
			case(OF)
				1:begin
					BOut0 <= 4'hf;
					BOut1 <= 4'hf;
					BOut2 <= 4'hf;
					BOut3 <= 4'hf;	
				end
				0:begin
					BOut0 <= BCD0;
					BOut1 <= BCD1;
					BOut2 <= BCD2;
					BOut3 <= BCD3;
					if(Store && range_change)begin
						case(measure_mode)
							0:begin
								if(!BCD3)begin
									case(F_sel)
										2'b00:begin
											mode_change <= 2'b01;
											T_sel <= 2'b10;
										end
										default:F_sel <= F_sel-1'b1;
									endcase
								end
							end
							1:begin
								if(!BCD3)begin
									case(T_sel)
										2'b10:begin
											mode_change <= 2'b10;
											F_sel <= 2'b11;
										end
										default:T_sel <= T_sel+1'b1;
									endcase
								end
							end
						endcase
						range_change <= 1'b0;
					end
				end
			endcase
		end
		if(Clear)begin
			//reset for next measuring.
			OF <= 1'b0;
			range_change <= 1'b1;
			case(mode_change)
				2'b10: measure_mode <= 1'b0;
				2'b01: measure_mode <= 1'b1;
			endcase
			if (cnt<2) begin
				cnt<=cnt+1'b1;
			end
			else mode_change <= 2'b00;
		end
	end
end
endmodule