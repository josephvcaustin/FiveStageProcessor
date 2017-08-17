`timescale 1ns / 10ps 

module alupipe(S, abus, bbus, clk, Cin, dbus, Cout, V);

	output reg [31:0] dbus; //The output/answer
	output Cout, V;
	input[31:0] abus, bbus; //Operands
	input Cin, clk; //Initial carry in and clock
	input [2:0] S; //Operation select signal

	wire [31:0] dwire;
	reg [31:0] areg, breg;
	
		
	alu32 alu(
		.d(dwire),
		.a(areg),
		.b(breg),
		.Cin(Cin),
		.Cout(Cout),
		.V(V),
		.S(S)
	);
	
always @ (posedge clk)
begin
	areg = abus;
	breg = bbus;
	dbus = dwire;
end	

endmodule