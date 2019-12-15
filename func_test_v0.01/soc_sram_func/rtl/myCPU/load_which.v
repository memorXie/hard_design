`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/14 01:48:09
// Design Name: 
// Module Name: load_which
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


module load_which(
	input [7:0] op,
	input [31:0] readdata,
	input [31:0] addr,
	output [31:0] finaldata

    );
	assign finaldata = (op==`EXE_LW_OP)? readdata:
						(op==`EXE_LH_OP)? (	(addr[1:0]==2'b00)? ({ {16{readdata[31]}},readdata[31:16]}):
											(addr[1:0]==2'b10)? ({ {16{readdata[15]}}, readdata[15:0]}):
											readdata
							):
						(op==`EXE_LHU_OP)? ( (addr[1:0]==2'b00)? ({ {16{1'b0}},readdata[31:16]}):
											(addr[1:0]==2'b10)?( { {16{1'b0}}, readdata[15:0]}):
											readdata
							):
						(op==`EXE_LB_OP)? ( (addr[1:0]==2'b00)? ({ {24{readdata[31]}}, readdata[31:24]}):
											(addr[1:0]==2'b01)? ({{24{readdata[23]}} , readdata[23:16]}):
											(addr[1:0]==2'b10)? ({{24{readdata[15]}},readdata[15:8]}):
											(addr[1:0]==2'b11)? ({{24{readdata[7]}},readdata[7:0]}):
											readdata
							):
						(op==`EXE_LBU_OP)? ( (addr[1:0]==2'b00)? ({ {24{1'b0}}, readdata[31:24]}):
											(addr[1:0]==2'b01)? ({{24{1'b0}} , readdata[23:16]}):
											(addr[1:0]==2'b10)? ({{24{1'b0}},readdata[15:8]}):
											(addr[1:0]==2'b11)? ({{24{1'b0}},readdata[7:0]}):
											readdata
							):
						readdata;
						
endmodule
