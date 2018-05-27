module Clear_Store(Store, Clear, Status_Value, measure_mode, Enable, OF, F_sel, T_sel, unable, nRST, CLK_50);
output reg 			Store, Clear;
//Status_Value = 1:Clear is allowed.
//Status_Value = 2:Counting is allowed.
output reg 	[1:0] 	Status_Value;
input 				measure_mode, Enable, OF, nRST, CLK_50;
input  		[1:0] 	F_sel, T_sel;
input		[4:0] 	unable;
//Clear times, used to control the width of Clear.
reg 		[7:0] 	Cltm;
//Store times, used to control the width of Store.
reg 		[23:0]	Sttm;
reg 		[1:0] 	F_sel_pre, T_sel_pre;
reg					allow_clear, allow_store;
//after nRST is active, overlook the Store and Clear for one time before Enable.
reg 				jump;
wire 				no_store;
assign no_store = OF && ((!measure_mode && F_sel_pre!=2'b11)||(measure_mode && T_sel_pre!=2'b00));

parameter store_width = 5000000;//100ms=5000000
always @(posedge Enable)
begin
	F_sel_pre <= F_sel;
	T_sel_pre <= T_sel;
end

always @(posedge CLK_50 or negedge nRST)
begin
if(!nRST)begin
		Clear <= 0;
		Store <= 0;
		Cltm <= 0;
		Sttm <= 0;
		allow_clear <= 1;
		allow_store <= 1;
		Status_Value <= 2'b11;
		jump <= 1;
	end
	else begin
		if(no_store)begin
			Status_Value <= 2'b10;
			allow_store <= 1'b0;
			allow_clear <= 1'b1;
		end
		else begin
			if(!jump)begin
				if(!Enable && allow_store) Store <= 1;
				if (Store) begin
					Sttm <= Sttm+1'b1;
					if (Sttm==1) Status_Value<=2'b01;
					if(Sttm == store_width)begin
						Store <= 0;
						Sttm <= 0;
						allow_store <= 0;
						Status_Value <= 2'b10;
					end
				end
			end
		end
		if(Status_Value == 2'b10 && allow_clear)begin
			Clear <= 1;
			Cltm <= Cltm+1'b1;
			if(Cltm == 20)begin
				Clear <= 0;
				Cltm <= 0;
				allow_clear <= 0;
				Status_Value <= 2'b11;
			end
		end
		if(Enable)begin
			jump <= 0;
			if (Status_Value == 2'b11) begin
				if (!unable[0]) begin
					allow_clear <= 1;
					allow_store <= 1;	
				end
				else begin
					allow_clear <= 0;
					allow_store <= 0;
				end	
			end
		end
	end
end
endmodule