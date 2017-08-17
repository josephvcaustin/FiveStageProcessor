`timescale 1ns / 10ps 

//Joseph Austin - Lab 5 MIPS Controller

/*
R Type: 000000 10001 10111 01000 00000 100010
		op	   rs    rt    rd	 shift func
		
I Type: 001000 10001 10111 11111 11111 110001
		op	   rs    rt    imm
		
		I type rt is destination
*/

/*
000 XOR
001 XNOR
010 A+B
011 A-B
100 OR
101 NOR
110 AND
111 NAND (X)
*/

module controller(ibus, clk, Aselect, Bselect, Dselect, Imm, S, Cin);

	input [31:0] ibus;
	reg [31:0] idex;
	
	reg [31:0] buff; //I wish I knew another way to do this
	reg [31:0] exmem;
	input clk;
	
	output [31:0] Aselect, Bselect, Dselect;
	output reg [2:0] S;
	output reg Imm; 
	output reg Cin;
	
	///////////////////////////////////////////////////
	always @(posedge clk) 
	begin
	buff = idex; //the timing is super weird
	idex = ibus; 
	end
	always @(negedge clk) exmem = buff; //I couldn't get it to work any other way
	
	wire [4:0] rs, rt, rtmem, rd;
	assign rs = idex[25:21];
	assign rt = idex[20:16];
	assign rtmem = exmem[20:16]; // more workarounds
	assign rd = exmem[15:11];
	wire [31:0] rtDecodeWire;
	
	wire [31:0] rtMemDecodeWire; // more fun!
	
	wire [31:0] rdDecodeWire;
	
	decoder_5_32 rsDecoder(.i(rs), .o(Aselect));
	decoder_5_32 rtDecoder(.i(rt), .o(rtDecodeWire)); 
	decoder_5_32 rtMemDecoder(.i(rtmem), .o(rtMemDecodeWire)); //good thing this is just a simulation
	decoder_5_32 rdDecoder(.i(rd), .o(rdDecodeWire));
	/////////////////////////////////////////////////////////
	wire [5:0] op;
	assign op = idex[31:26];
	
	assign Bselect = (|op) ? 32'bx : rtDecodeWire;
	
	wire [5:0] func;
	assign func = idex[5:0];
	
	always @(clk)
	if(clk == 0) begin
	Imm = (|op);
	case(op)
		6'b000000 :
		begin
			case(func)
			6'b000011 : S = 3'b010; //ADDR
			6'b000010 : S = 3'b011; //SUBR
			6'b000001 : S = 3'b000; //XORR
			6'b000111 : S = 3'b110; //ANDR
			6'b000100 : S = 3'b100; //ORR
			default : S = 3'bxxx;
			endcase
		end
		6'b000011 : S = 3'b010; //ADDI
		6'b000010 : S = 3'b011; //SUBI
		6'b000001 : S = 3'b000; //XORI
		6'b001111 : S = 3'b110; //ANDI
		6'b001100 : S = 3'b100; //ORI
		default : S = 3'bxxx;	
	endcase
	Cin = S[1]&S[0];
	end
	
	assign Dselect = (|exmem[31:26]) ? rtMemDecodeWire : rdDecodeWire;
	
endmodule
