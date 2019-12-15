`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/14 02:16:00
// Design Name: 
// Module Name: store_which
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module store_which(
	input [7:0] op,
	input [31:0] writedata,
	output [31:0] writedata2

    );
	assign writedata2 = (op==`EXE_SW_OP)? writedata:
						(op==`EXE_SH_OP)? {writedata[15:0],writedata[15:0]} :
						(op==`EXE_SB_OP)? {writedata[7:0],writedata[7:0],writedata[7:0],writedata[7:0]}:
						writedata;
endmodule
