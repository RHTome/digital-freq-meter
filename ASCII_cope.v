module ASCII_cope(T0_LCD, T1_LCD, T2_LCD, T3_LCD, Latch0_LCD, Latch1_LCD, Latch2_LCD, Latch3_LCD, T0, T1, T2, T3, Latch0, Latch1, Latch2, Latch3);

output 	[8:0]	T0_LCD, T1_LCD, T2_LCD, T3_LCD, Latch0_LCD, Latch1_LCD, Latch2_LCD, Latch3_LCD;
input 	[3:0]	T0, T1, T2, T3, Latch0, Latch1, Latch2, Latch3;

ASCII U0(.ascii(T0_LCD), .BCD(T0));
ASCII U1(.ascii(T1_LCD), .BCD(T1));
ASCII U2(.ascii(T2_LCD), .BCD(T2));
ASCII U3(.ascii(T3_LCD), .BCD(T3));
ASCII L0(.ascii(Latch0_LCD), .BCD(Latch0));
ASCII L1(.ascii(Latch1_LCD), .BCD(Latch1));
ASCII L2(.ascii(Latch2_LCD), .BCD(Latch2));
ASCII L3(.ascii(Latch3_LCD), .BCD(Latch3));

endmodule