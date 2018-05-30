/*
Description:4-digit BCD counter
*/

module BCD_Counter(BCD3, BCD2, BCD1, BCD0, count, unable, Count_CP, En, Store, Status_Value, Clear, nRST);
output [ 3:0] BCD3, BCD2, BCD1, BCD0;
output [15:0] count;
output [ 4:0] unable;
input         Count_CP, En, Store, Clear, nRST; 
input  [ 1:0] Status_Value; 
wire          CO_BCD0, CO_BCD1, CO_BCD2, CO_BCD3;

modulo_counter ones(
	.Q(BCD0), 
	.Carry_out(CO_BCD0), 
	.unable(unable[0]),
	.CP(Count_CP), 
	.Clear(Clear),
	.nRST(nRST), 
	.En(En),
	.Store(Store),
	.Status_Value(Status_Value)
	);
defparam ones.N = 4;
defparam ones.MOD = 10;

modulo_counter tens(
	.Q(BCD1), 
	.Carry_out(CO_BCD1),
	.unable(unable[1]), 
	.CP(Count_CP), 
	.Clear(Clear),
	.nRST(nRST), 
	.En(En&CO_BCD0),
	.Store(Store),
	.Status_Value(Status_Value)
	);
defparam tens.N = 4;
defparam tens.MOD = 10;

modulo_counter hundreds(
	.Q(BCD2), 
	.Carry_out(CO_BCD2), 
	.unable(unable[2]),
	.CP(Count_CP), 
	.Clear(Clear),
	.nRST(nRST), 
	.En(En&CO_BCD0&CO_BCD1),
	.Store(Store),
	.Status_Value(Status_Value)
	);
defparam hundreds.N = 4;
defparam hundreds.MOD = 10;

modulo_counter thousands(
	.Q(BCD3), 
	.Carry_out(CO_BCD3), 
	.unable(unable[3]),
	.CP(Count_CP), 
	.Clear(Clear),
	.nRST(nRST), 
	.En(En&CO_BCD0&CO_BCD1&CO_BCD2),
	.Store(Store),
	.Status_Value(Status_Value)
	);
defparam thousands.N = 4;
defparam thousands.MOD = 10;

T_counter cnt(
	.Q(count), 
	.unable(unable[4]),
	.CP(Count_CP), 
	.Clear(Clear),
	.nRST(nRST), 
	.En(En),
	.Store(Store),
	.Status_Value(Status_Value)
	);
endmodule