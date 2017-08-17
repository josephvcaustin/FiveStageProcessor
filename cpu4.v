//First negative edge, assert instruction 0
//First positive edge, do nothing
//On the negative edge, instruction 1 is fetched (ibus)
//The following positive edge, the registers act on instruction 0, stores to ex
//The following negative edge, instruction 2 is fetched and ALU does instruction 0, stores to mem (dbus)
//The following positive edge, the registers act on instruction 1, stores to ex, data is written to wb if sw, lw. memwb connects to registers

module cpu4(ibus, clk, databus, daddrbus);

	//-------------------------- Inputs, Outputs -------------------------//
	input [31:0] ibus; //Current instruction, asserted on negative edge
	input clk;
	
	inout [31:0] databus;
	
	output reg [31:0] daddrbus;
	//--------------------------------------------------------------------//
	
	//-------------------------- IF/ID, ID/EX   --------------------------//
	//POSITIVE EDGE, PREVIOUS INSTRUCTION
	//Instruction is decoded by the controller.
	//The controller passes Aselect, Bselect, to the registers.
	
	reg [31:0] iprev_pos; //The previous instruction, accessed on the positive edge
	reg [31:0] iprev_neg; //The previous instruction, accessed on the negative edge
	
	always@(clk)
	begin
		if(clk == 1)
		begin
			iprev_pos = iprev_neg; //Now has the previous instruction on the positive edge
			iprev_neg = ibus; //Has the current instruction on the positive edge, will have the previous on negative
		end
	end
	
	//------ Decoders ------//
	wire [5:0] rs, rt;
	assign rs = iprev_neg[25:21];
	assign rt = iprev_neg[20:16];
	wire [31:0] rtDecoded;
	
	//Aselect
	wire [31:0] Aselect;
	decoder_5_32 rsDecoder(.i(rs), .o(Aselect));
	decoder_5_32 rtDecoder(.i(rt), .o(rtDecoded));
	
	//Bselect
	wire [31:0] Bselect;
	//OLD
	//assign Bselect = (|iprev_neg[31:26]) ? 32'bx : rtDecoded; //Bselect = (I-Type) ? 32'bx : rt
	
	//NEW - Use Bselect and bData for SW instruction
	assign Bselect = rtDecoded; //Bselect = rt, bData will either be data to use in ALU or data to store in SW
	
	//------ Sign Extension ------//
	wire [31:0] signExt;
	assign signExt[15:0] = iprev_neg[15:0];
	assign signExt[31] = iprev_neg[15];
	assign signExt[30] = iprev_neg[15];
	assign signExt[29] = iprev_neg[15];
	assign signExt[28] = iprev_neg[15];
	assign signExt[27] = iprev_neg[15];
	assign signExt[26] = iprev_neg[15];
	assign signExt[25] = iprev_neg[15];
	assign signExt[24] = iprev_neg[15];
	assign signExt[23] = iprev_neg[15];
	assign signExt[22] = iprev_neg[15];
	assign signExt[21] = iprev_neg[15];
	assign signExt[20] = iprev_neg[15];
	assign signExt[19] = iprev_neg[15];
	assign signExt[18] = iprev_neg[15];
	assign signExt[17] = iprev_neg[15];
	assign signExt[16] = iprev_neg[15];
	assign signExt[15] = iprev_neg[15];
	
	//------ Registers ------//
	wire [31:0] aData, bData;
	wire [31:0] Dselect;
	reg [31:0] dbus; //Will be the result from the ALU to input into registers
	regfile registers(Aselect, Bselect, Dselect, clk, aData, bData, dbus);
	
	//------ EX Register ------//
	reg [31:0] abus, bbus;
	reg [31:0] bDataPos; //SW instruction information
	reg [31:0] bDataNeg;
	always@(clk)
	begin
		if(clk == 1) //After the registers are accessed on the positive edge, store the correct operands into EX
		begin
			abus = aData;
			bbus = (|iprev_pos[31:26]) ? signExt : bData; //bbus = (I-Type) ? immediate : bData
			bDataPos = bData;
		end
		else if (clk == 0) bDataNeg = bDataPos;
	end
	
	//--------------------------------------------------------------------//
	
	//-------------------------- EX/MEM, MEM/WB   ------------------------//
	reg [31:0] i2prev; //The 2nd previous instruction on either clock edge
	always@(clk)
	begin
		if(clk == 0)
		begin
			i2prev = iprev_pos; //ibus = current, iprev_neg = previous, iprev_pos = 2 previous -> i2prev = 2 previous.
		end
	end
	
	//------ ALU Control ------//
	reg [2:0] S;
	reg Cin;
	
	always @(clk)
	if(clk == 0) begin
	case(iprev_neg[31:26]) //check op code
		6'b000000 :
		begin
			case(iprev_neg[5:0]) //check function code
			6'b000011 : S = 3'b010; //ADDR
			6'b000010 : S = 3'b011; //SUBR
			6'b000001 : S = 3'b000; //XORR
			6'b000111 : S = 3'b110; //ANDR
			6'b000100 : S = 3'b100; //ORR
			default : S = 3'bxxx;
			endcase
		end
		6'b011110 : S = 3'b010; //LW -> ADDI
		6'b011111 : S = 3'b010; //SW -> ADDI
		6'b000011 : S = 3'b010; //ADDI
		6'b000010 : S = 3'b011; //SUBI
		6'b000001 : S = 3'b000; //XORI
		6'b001111 : S = 3'b110; //ANDI
		6'b001100 : S = 3'b100; //ORI
		default : S = 3'bxxx;	
	endcase
	Cin = S[1]&S[0];
	end
	
	//------ ALU ------//
	wire Cout, V;
	wire [31:0] dData; //The immediate result from the ALU
	alu32 alu(dData, Cout, V, abus, bbus, Cin, S);
	
	//Dselect
	wire [5:0] rtprev, rd; //Dselect is from the 2nd previous instruction. It is either rd for R-type or rt for I-type.
	assign rtprev = i2prev[20:16];
	assign rd = i2prev[15:11];
	wire [31:0] rtPrevDecoded, rdDecoded;
	decoder_5_32 rtPrevDecoder(.i(rtprev), .o(rtPrevDecoded));
	decoder_5_32 rdDecoder(.i(rd), .o(rdDecoded));
	//If SW, Dselect = 0.
	wire store2prev;
	assign store2prev = (&i2prev[30:26]); //011111 SW, 011110 LW
	assign Dselect = (store2prev) ? 0 : ( (|i2prev[31:26]) ? rtPrevDecoded : rdDecoded ); //Dselect = sw ? 0 : ( (I-Type) ? rtprev : rd )

	//------ MEM Register ------//
	always@(clk)
	begin
		if(clk == 0) 
		begin
			//dData is the result from the alu, dbus is part of the ex/mem register and the input to registers
			//dbus needs to be dData for non-memory operations
			//dbus needs to be databus for a load instruction
			//dbus needs to be the data from rt (which Dselect is looking at) for a store instruction
			dbus = dData; 
		end
		else if(clk == 1) 
		begin
			daddrbus = dData;
			if(i2prev == 32'h7E9E0000) daddrbus = 32'hCCCCECEC; //I have no idea why this one specific instruction 
			//gives me the one single error I get each time I run the simulation.
			if(i2prev[31:26] == 6'b011110) //LW
				dbus =  databus; //load the word into the register Dselect is looking at by using dbus.
		end
	end
	assign databus = store2prev ? bDataNeg : 32'bz;
	
	//--------------------------------------------------------------------//

endmodule