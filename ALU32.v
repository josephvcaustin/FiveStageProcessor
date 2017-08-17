/* 	Joseph Austin
	ECEN4243 - Computer Architecture
	Lab 1 - ALU Design
	
	ALU32.V
	This module contains all 32 instances
	of alu_cell, one for each bit of input.
	This module contains all interior wires
	for connecting all cells as well as two 
	bits to indicate signed or unsigned overflow.
*/

`timescale 1ns / 10ps 

module alu32(d, Cout, V, a, b, Cin, S);
	output[31:0] d; //The output/answer
	output Cout, V; //Unsigned and Signed overflow bits
	input[31:0] a, b; //Operands
	input Cin; //Initial carry in
	input [2:0] S; //Operation select signal
	
	//internal wires for carry chain
	wire[31:0] c, g, p; 
	wire gout, pout;
	
	//Create 32 instances of alu_cell
	alu_cell aluCell[31:0](
		.d(d),
		.g(g),
		.p(p),
		.a(a),
		.b(b),
		.c(c),
		.S(S)
	);
	
	lac5 lac(
		.c(c),
		.gout(gout),
		.pout(pout),
		.Cin(Cin),
		.g(g),
		.p(p)
	);
	
	assign Cout = gout|(pout&Cin); //Unsigned overflow
	assign V = Cout^c[31]; //Signed overflow
endmodule