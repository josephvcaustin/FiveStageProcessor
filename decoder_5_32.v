`timescale 1ns / 10ps 

module decoder_5_32(i, o);

	input [4:0] i;
	output [31:0] o;
	
	assign o[31] = (i[4]&i[3]&i[2]&i[1]&i[0]);
	assign o[30] = (i[4]&i[3]&i[2]&i[1]&!i[0]);
	assign o[29] = (i[4]&i[3]&i[2]&!i[1]&i[0]);
	assign o[28] = (i[4]&i[3]&i[2]&!i[1]&!i[0]);
	assign o[27] = (i[4]&i[3]&!i[2]&i[1]&i[0]);
	assign o[26] = (i[4]&i[3]&!i[2]&i[1]&!i[0]);
	assign o[25] = (i[4]&i[3]&!i[2]&!i[1]&i[0]);
	assign o[24] = (i[4]&i[3]&!i[2]&!i[1]&!i[0]);
	assign o[23] = (i[4]&!i[3]&i[2]&i[1]&i[0]);
	assign o[22] = (i[4]&!i[3]&i[2]&i[1]&!i[0]);
	assign o[21] = (i[4]&!i[3]&i[2]&!i[1]&i[0]);
	assign o[20] = (i[4]&!i[3]&i[2]&!i[1]&!i[0]);
	assign o[19] = (i[4]&!i[3]&!i[2]&i[1]&i[0]);
	assign o[18] = (i[4]&!i[3]&!i[2]&i[1]&!i[0]);
	assign o[17] = (i[4]&!i[3]&!i[2]&!i[1]&i[0]);
	assign o[16] = (i[4]&!i[3]&!i[2]&!i[1]&!i[0]);
	assign o[15] = (!i[4]&i[3]&i[2]&i[1]&i[0]);
	assign o[14] = (!i[4]&i[3]&i[2]&i[1]&!i[0]);
	assign o[13] = (!i[4]&i[3]&i[2]&!i[1]&i[0]);
	assign o[12] = (!i[4]&i[3]&i[2]&!i[1]&!i[0]);
	assign o[11] = (!i[4]&i[3]&!i[2]&i[1]&i[0]);
	assign o[10] = (!i[4]&i[3]&!i[2]&i[1]&!i[0]);
	assign o[9] = (!i[4]&i[3]&!i[2]&!i[1]&i[0]);
	assign o[8] = (!i[4]&i[3]&!i[2]&!i[1]&!i[0]);
	assign o[7] = (!i[4]&!i[3]&i[2]&i[1]&i[0]);
	assign o[6] = (!i[4]&!i[3]&i[2]&i[1]&!i[0]);
	assign o[5] = (!i[4]&!i[3]&i[2]&!i[1]&i[0]);
	assign o[4] = (!i[4]&!i[3]&i[2]&!i[1]&!i[0]);
	assign o[3] = (!i[4]&!i[3]&!i[2]&i[1]&i[0]);
	assign o[2] = (!i[4]&!i[3]&!i[2]&i[1]&!i[0]);
	assign o[1] = (!i[4]&!i[3]&!i[2]&!i[1]&i[0]);
	assign o[0] = (!i[4]&!i[3]&!i[2]&!i[1]&!i[0]);
		
endmodule
