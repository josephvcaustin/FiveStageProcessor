/* 	Joseph Austin
	ECEN4243 - Computer Architecture
	Lab 1 - ALU Design
	
	ALU_CELL.V
	This module is a one-bit ALU. It receives
	a 3-bit signal S and performs either addition, 
	subtraction, XOR, XNOR, AND, OR, or NOR for two
	one- bit inputs depending on S. 
*/
`timescale 1ns / 10ps 

module alu_cell(d, g, p, a, b, c, S);
	output d, g, p; //d = answer, g = generate carry, p = propagate carry
	input a, b, c; //a, b are operands, c is carry in.
	input[2:0] S; //Operation select signal.
	
	//internal wires for b and c, the inputs to the adder
	//use internal wires to help simplify operation selection with S
	wire cint, bint;
	
	assign bint = S[0]^b; //if S[0] is 1, invert b for xnor and subtract operations
	assign g = a&bint;
	assign p = a^bint;
	assign cint = S[1]&c; //if S[1] is 1, enable the carry to do add and subtract operations
	
	//If S[2] & S[1], do a&bint
	//If S[2] & !S[1], if S[0] do a|b, if !S[0] do !(a|b)
	//If !S[2], do p^cint
	assign d = (S[2]&( 
	(S[1]&(a&bint))/*AND, NAND*/ | 
	(!S[1]&((S[0]&(!(a|b))) | (!S[0]&(a|b)))/*OR, NOR*/ ))) | 
	(!S[2]&(p^cint)) /*Add, Sub, XOR, XNOR*/;
	
endmodule