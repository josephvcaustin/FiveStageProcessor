`timescale 1ns / 10ps 

module regfile(Aselect, Bselect, Dselect, clk, abus, bbus, dbus);

	input [31:0] Aselect, Bselect, Dselect, dbus;
	input clk;
	
	output [31:0] abus, bbus;
	
	regZero regs0(.d(dbus), .clk(clk), .Dselect(Dselect), .qabus(abus), .qbbus(bbus), .asel(Aselect[0]), .bsel(Bselect[0]));
	
	reg32 regs[30:0](.d(dbus), .clk(clk), .Dselect(Dselect[31:1]), .qabus(abus), .qbbus(bbus), .asel(Aselect[31:1]), .bsel(Bselect[31:1]));

endmodule