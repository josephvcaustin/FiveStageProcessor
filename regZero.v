/* 	Joseph Austin
	ECEN4243 - Computer Architecture
	Lab 3 - Register Design
	
	reg32.V
	This module is a single 32 bit register.
	The inputs are an access signal (clk & Dselect), an
	aselect signal for writing to a, and a bselect signal for 
	writing to b. Two tri-state buffers are used for outputting 
	q to the a or b buses. 
*/

module regZero(d, clk, Dselect, qabus, qbbus, asel, bsel);

	input asel, bsel, Dselect, clk; //Access register (0/1), assign to abus (0/1), assign to bbus (0/1)
	
	input [31:0] d;
	
	output [31:0] qabus; //output either q or z to abus
	output [31:0] qbbus; //output either q or z to bbus

	//buffers
	assign qabus = asel ? 32'b0 : 32'bz;
	assign qbbus = bsel ? 32'b0 : 32'bz;
endmodule