//This module connects the pipelined ALU to the register file.
`timescale 1ns / 10ps 

module regalu(Aselect, Bselect, Dselect, clk, Cin, S, abus, bbus, dbus);

	input [31:0] Aselect, Bselect, Dselect;
	input [2:0] S;
	input clk, Cin;
	
	output [31:0] abus, bbus, dbus;
	
	wire Cout, V;
	
	alupipe alu(.S(S), .abus(abus), .bbus(bbus), .clk(clk), .Cin(Cin), .dbus(dbus), .Cout(Cout), .V(V));
	
	regfile regs(.Aselect(Aselect), .Bselect(Bselect), .Dselect(Dselect), .clk(clk), .abus(abus), .bbus(bbus), .dbus(dbus));
	
endmodule
