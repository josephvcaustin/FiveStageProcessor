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

module reg32(d, clk, Dselect, qabus, qbbus, asel, bsel);

	input Dselect, clk, asel, bsel; //Access register (0/1), assign to abus (0/1), assign to bbus (0/1)
	input [31:0] d; //data
	reg [31:0] q; //memory
	
	output [31:0] qabus; //output either q or z to abus
	output [31:0] qbbus; //output either q or z to bbus
	
	wire ds_clk;
	assign ds_clk = Dselect & clk;

	always @ (negedge ds_clk) 
	begin
		q = d;
	end 
	
	//buffers
	assign qabus = asel ? q : 32'bz;
	assign qbbus = bsel ? q : 32'bz;
endmodule