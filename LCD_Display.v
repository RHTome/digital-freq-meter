module	LCD_Display (
	CLK_50, nRST, measure_mode, N, Store, 
	T0_LCD, T1_LCD, T2_LCD, T3_LCD, Latch0_LCD, Latch1_LCD, Latch2_LCD, Latch3_LCD,
	DotLed,
	LCD_DATA, LCD_EN, LCD_RS, initial_nRST
	);

input				CLK_50, nRST, measure_mode, Store;
input 		[15:0] 	N;
input 		[2:0 ]	DotLed;
input		[8:0 ]	T0_LCD, T1_LCD, T2_LCD, T3_LCD, Latch0_LCD, Latch1_LCD, Latch2_LCD, Latch3_LCD;
output	reg [7:0 ]  	LCD_DATA;
output	reg			LCD_EN;
output	reg			LCD_RS;
output	reg			initial_nRST;

reg			[5:0 ]	LUT_INDEX;//index of table
reg			[8:0 ]	LUT_DATA;//look-up-table
reg			[1:0 ]	LCD_ST;//Status
reg			[17:0]	Delay;//
reg 		[17:0]  Delay_time;
reg 		[4:0 ]	Cont;
reg 		[8:0 ]   Num_Char[ 9:0];
reg 		[8:0 ]   Unit_Char[4:0];
parameter	LUT_SIZE	=	34;
parameter	CLK_Divide	=	16;
parameter	Line1		=	18;
parameter	Line2		=	Line1+4;

always@(posedge CLK_50 or negedge nRST)
begin
	if(!nRST)begin
		LUT_INDEX	<=	0;
		LCD_ST		<=	0;
		Delay		<=	0;
		LCD_EN	    <=  0;
		LCD_DATA	<=	0;
		LCD_RS		<=	0;
		Cont 		<= 	0;
	end
	else begin
		if(LUT_INDEX<LUT_SIZE)begin
			case(LCD_ST)
				2'b00:	begin
					LCD_DATA	<=	LUT_DATA[7:0];
					LCD_RS		<=	LUT_DATA[8];
					if (Cont<4) Cont <= Cont + 1'b1;
					else begin
						Cont <= 0;
						LCD_EN	    <=	1'b1;
						LCD_ST		<=	1'b1;	
					end
				end
				2'b01:	begin
					if(Cont<CLK_Divide)
						Cont <= Cont+1'b1;
					else begin
						Cont <= 0;
						LCD_EN 	<=	1'b0;
						LCD_ST	<=	2'b10;
					end
				end
				2'b10:	begin
					if (LCD_RS) Delay_time <= 4000;
					else Delay_time <= 210000;
					if (Cont<1) Cont <= Cont + 1'b1;
					else begin
						if(Delay<Delay_time) Delay	<=	Delay+1'b1;
						else begin
							Cont <= 0;
							Delay	<=	0;
							LCD_ST	<=	2'b11;
						end
					end
				end
				2'b11:	begin
					LUT_INDEX	<=	LUT_INDEX+1'b1;
					if (LUT_INDEX == (Line1+7)) begin
						if (!measure_mode) LUT_INDEX <=	6'd17;
					end
					LCD_ST	<=	2'b00;
					end
			endcase
		end
		else LUT_INDEX	<=	6'd17;
	end
end

always @(posedge CLK_50 or negedge nRST)
begin
if (!nRST) begin
		initial_nRST <=	0;
	end
	else begin
		if(!initial_nRST)begin
			case(LUT_INDEX)
				//	Initial start
				0:	LUT_DATA	<=	9'h038;//0011 1000 Function Set.data length is 8, double lines, 5*8dots
				1:	LUT_DATA	<=	9'h00C;//0000 1100 Display On
				2:	LUT_DATA	<=	9'h001;//0000 0001 Clear Display
				3:	LUT_DATA	<=	9'h006;//0000 0110 LCD_ENtry Mode Set. cursor move to right aotomotic
				4:	LUT_DATA	<=	9'h080;//1000 0000 Set DDRAM Address. 00H
				5:	LUT_DATA	<=	9'h146;//F
				6:	LUT_DATA	<=	9'h172;//r
				7:	LUT_DATA	<=	9'h165;//e
				8:	LUT_DATA	<=	9'h171;//q
				9:	LUT_DATA	<=	9'h13A;//:
				10:	LUT_DATA	<=	9'h0C0;
				11:	LUT_DATA	<=	9'h143;//C
				12:	LUT_DATA	<=	9'h179;//y
				13:	LUT_DATA	<=	9'h163;//c
				14:	LUT_DATA	<=	9'h16C;//l
				15:	LUT_DATA	<=	9'h165;//e
				16:	begin
						LUT_DATA	<=	9'h13A;//:
						if (LCD_ST==2'b11) initial_nRST <= 1;
					end
				//Initial end
				default:		LUT_DATA	<=	9'h000;
			endcase
		end
		else begin
			case(LUT_INDEX)
				Line1-1		:	LUT_DATA	<=	9'h085;
				Line1+0		:	LUT_DATA	<=	Num_Char[0];
				Line1+1		:	LUT_DATA	<=	Num_Char[1];
				Line1+2		:	LUT_DATA	<=	Num_Char[2];
				Line1+3		:	LUT_DATA	<=	Num_Char[3];
				Line1+4		:	LUT_DATA	<=	Num_Char[4];
				Line1+5		:	LUT_DATA	<=	Unit_Char[0];
				Line1+6		:	LUT_DATA	<=	Unit_Char[1];
				Line1+7		:	LUT_DATA	<=	Unit_Char[2];
				Line1+8		:	LUT_DATA	<=	9'h0C6;	
				Line2+5		:	LUT_DATA	<=	Num_Char[5];
				Line2+6		:	LUT_DATA	<=	Num_Char[6];
				Line2+7		:	LUT_DATA	<=	Num_Char[7];
				Line2+8		:	LUT_DATA	<=	Num_Char[8];
				Line2+9		:	LUT_DATA	<=	Num_Char[9];
				Line2+10	:	LUT_DATA	<=	Unit_Char[3];
				Line2+11	:	LUT_DATA	<=	Unit_Char[4];
				default:		LUT_DATA	<=	9'h000;
			endcase
		end
	end
end

always @(posedge CLK_50 or negedge nRST)
begin
	if (!nRST) begin
		Num_Char[0]	<=	9'h120;
		Num_Char[1]	<=	9'h120;
		Num_Char[2]	<=	9'h120;
		Num_Char[3]	<=	9'h120;
		Num_Char[4]	<=	9'h120;
		Num_Char[5]	<=	9'h120;
		Num_Char[6]	<=	9'h120;
		Num_Char[7]	<=	9'h120;
		Num_Char[8]	<=	9'h120;
		Num_Char[9]	<=	9'h120;
		Unit_Char[0]	<=	9'h120;//H
		Unit_Char[1]	<=	9'h120;//z
		Unit_Char[2]	<=	9'h120;
		Unit_Char[3]	<=	9'h120;//m
		Unit_Char[4]	<=	9'h120;//s
	end
	else if(Store)begin
		case(measure_mode)
			0:begin
				case(DotLed)//F_sel
					3'b100:begin
						Num_Char[0]	<=	Latch3_LCD;
						Num_Char[1]	<=	9'h12E;
						Num_Char[2]	<=	Latch2_LCD;
						Num_Char[3]	<=	Latch1_LCD;
						Num_Char[4]	<=	Latch0_LCD;
					end
					3'b010:begin
						Num_Char[0]	<=	Latch3_LCD;
						Num_Char[1]	<=	Latch2_LCD;
						Num_Char[2]	<=	9'h12E;
						Num_Char[3]	<=	Latch1_LCD;
						Num_Char[4]	<=	Latch0_LCD;
					end
					3'b001:begin
						Num_Char[0]	<=	Latch3_LCD;
						Num_Char[1]	<=	Latch2_LCD;
						Num_Char[2]	<=	Latch1_LCD;
						Num_Char[3]	<=	9'h12E;
						Num_Char[4]	<=	Latch0_LCD;
					end
					3'b000:begin
						Num_Char[0]	<=	Latch3_LCD;
						Num_Char[1]	<=	Latch2_LCD;
						Num_Char[2]	<=	Latch1_LCD;
						Num_Char[3]	<=	Latch0_LCD;
						Num_Char[4]	<=	9'h120;
					end
				endcase
				Unit_Char[0]	<=	9'h16B;//k
				Unit_Char[1]	<=	9'h148;//H
				Unit_Char[2]	<=	9'h17A;//z
				//clear the period data
				/*Unit_Char[3]	<=	9'h120;
				Unit_Char[4]	<=	9'h120;
				Num_Char[5]		<=	9'h120;
				Num_Char[6]		<=	9'h120;
				Num_Char[7]		<=	9'h120;
				Num_Char[8]		<=	9'h120;
				Num_Char[9]		<=	9'h120;*/
			end
			1:begin
				if(N==1000)begin 
					case(DotLed)
						3'b010:begin
							Num_Char[0]	<=	Latch3_LCD;
							Num_Char[1]	<=	Latch2_LCD;
							Num_Char[2]	<=	9'h12E;
							Num_Char[3]	<=	Latch1_LCD;
							Num_Char[4]	<=	Latch0_LCD;

							Num_Char[5]	<=	T3_LCD;
							Num_Char[6]	<=	T2_LCD;
							Num_Char[7]	<=	T1_LCD;
							Num_Char[8]	<=	9'h12E;
							Num_Char[9]	<=	T0_LCD;
						end
						3'b001:begin
								Num_Char[0]	<=	Latch3_LCD;
								Num_Char[1]	<=	Latch2_LCD;
								Num_Char[2]	<=	Latch1_LCD;
								Num_Char[3]	<=	9'h12E;
								Num_Char[4]	<=	Latch0_LCD;

								Num_Char[5]	<=	T3_LCD;
								Num_Char[6]	<=	T2_LCD;
								Num_Char[7]	<=	9'h12E;
								Num_Char[8]	<=	T1_LCD;
								Num_Char[9]	<=	T0_LCD;
						end
						3'b000:begin
								Num_Char[0]	<=	Latch3_LCD;
								Num_Char[1]	<=	Latch2_LCD;
								Num_Char[2]	<=	Latch1_LCD;
								Num_Char[3]	<=	Latch0_LCD;
								Num_Char[4]	<=	9'h120;

								Num_Char[5]	<=	T3_LCD;
								Num_Char[6]	<=	9'h12E;
								Num_Char[7]	<=	T2_LCD;
								Num_Char[8]	<=	T1_LCD;
								Num_Char[9]	<=	T0_LCD;
						end
					endcase
				end
				else begin
					case(DotLed)
						3'b100:begin
							Num_Char[0]	<=	Latch3_LCD;
							Num_Char[1]	<=	9'h12E;
							Num_Char[2]	<=	Latch2_LCD;
							Num_Char[3]	<=	Latch1_LCD;
							Num_Char[4]	<=	Latch0_LCD;

							Num_Char[5]	<=	T3_LCD;
							Num_Char[6]	<=	T2_LCD;
							Num_Char[7]	<=	T1_LCD;
							Num_Char[8]	<=	9'h12E;
							Num_Char[9]	<=	T0_LCD;
						end
						3'b010:begin
							Num_Char[0]	<=	Latch3_LCD;
							Num_Char[1]	<=	Latch2_LCD;
							Num_Char[2]	<=	9'h12E;
							Num_Char[3]	<=	Latch1_LCD;
							Num_Char[4]	<=	Latch0_LCD;

							Num_Char[5]	<=	T3_LCD;
							Num_Char[6]	<=	T2_LCD;
							Num_Char[7]	<=	9'h12E;
							Num_Char[8]	<=	T1_LCD;
							Num_Char[9]	<=	T0_LCD;
						end
						3'b001:begin
							Num_Char[0]	<=	Latch3_LCD;
							Num_Char[1]	<=	Latch2_LCD;
							Num_Char[2]	<=	Latch1_LCD;
							Num_Char[3]	<=	9'h12E;
							Num_Char[4]	<=	Latch0_LCD;

							Num_Char[5]	<=	T3_LCD;
							Num_Char[6]	<=	9'h12E;
							Num_Char[7]	<=	T2_LCD;
							Num_Char[8]	<=	T1_LCD;
							Num_Char[9]	<=	T0_LCD;
						end
					endcase
				end
				Unit_Char[0]	<=	9'h148;//H
				Unit_Char[1]	<=	9'h17A;//z
				Unit_Char[2]	<=	9'h120;
				Unit_Char[3]	<=	9'h16D;//m
				Unit_Char[4]	<=	9'h173;//s
			end
		endcase
	end
end 
endmodule