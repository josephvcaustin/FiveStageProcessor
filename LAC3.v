/* 	Joseph Austin
	ECEN4243 - Computer Architecture
	Lab 1 - ALU Design
	
	LAC2.V
	This module is a 8-bit carry-lookahead adder, 
	utilizing a binary tree structure with 2 4-bit
	carry-lookahead adders. The module contains a 
	root and two leaves. This module is a leaf for
	the 16 bit LAC module.
*/

`timescale 1ns / 10ps 

module lac3(c, gout, pout, Cin, g, p);
	output[7:0] c;
	output gout, pout;
	input Cin;
	input [7:0] g, p;
	
	//internal wires to connect leaves to root
	wire[1:0] cint, gint, pint;
	
	//lower leaf (4 bit)
	lac2 leaf0(
	.c(c[3:0]),
	.gout(gint[0]),
	.pout(pint[0]),
	.Cin(cint[0]),
	.g(g[3:0]),
	.p(p[3:0])
	);
	
	//higher leaf
	lac2 leaf1(
	.c(c[7:4]),
	.gout(gint[1]),
	.pout(pint[1]),
	.Cin(cint[1]),
	.g(g[7:4]),
	.p(p[7:4])
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