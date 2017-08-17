/* 	Joseph Austin
	ECEN4243 - Computer Architecture
	Lab 1 - ALU Design
	
	LAC.V
	This module is a 2 bit carry-lookahead adder.
	The carry signal is handled in a separate chain
	using combination logic between a generate, propagate,
	and carry signal for each bit. 
*/

`timescale 1ns / 10ps 

module lac(c, gout, pout, Cin, g, p);
	output[1:0] c; //carry (for next bit)
	output gout, pout; //generate out, propagate out (for next bit)
	input Cin; //carry in
	input[1:0] g, p; //generate, propagate (from previous bit)
	
	assign c[0] = Cin;
	assign c[1] = g[0]|(p[0]&Cin);
	assign gout = g[1]|(p[1]&g[0]);
	assign pout = p[1]&p[0];
endmodule