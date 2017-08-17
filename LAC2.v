/* 	Joseph Austin
	ECEN4243 - Computer Architecture
	Lab 1 - ALU Design
	
	LAC2.V
	This module is a 4-bit carry-lookahead adder, 
	utilizing a binary tree structure with 2 2-bit
	carry-lookahead adders. The module contains a 
	root and two leaves. This module is a leaf for
	the 8 bit LAC module.
*/
`timescale 1ns / 10ps 

module lac2(c, gout, pout, Cin, g, p);
	output[3:0] c; //carry for next LAC
	output gout, pout; //g and p output signals
	input Cin; //carry in 
	input [3:0] g, p; //input from previous LAC
	
	//internal wires to connect leaves to root
	wire[1:0] cint, gint, pint;
	
	lac leaf0(
	.c(c[1:0]),
	.gout(gint[0]),
	.pout(pint[0]),
	.Cin(cint[0]),
	.g(g[1:0]),
	.p(p[1:0])
	);
	
	lac leaf1(
	.c(c[3:2]),
	.gout(gint[1]),
	.pout(pint[1]),
	.Cin(cint[1]),
	.g(g[3:2]),
	.p(p[3:2])
	);
	
	lac root(
	.c(cint),
	.gout(gout),
	.pout(pout),
	.Cin(Cin),
	.g(gint),
	.p(pint)
	);
endmodule