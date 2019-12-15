`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/14 00:56:30
// Design Name: 
// Module Name: data_memory_controller
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


module data_memory_controller(
	input [31:0] addr,
	input [7:0] op,
	output [3:0] sel
    );
	assign sel = (op==`EXE_LB_OP |op==`EXE_LBU_OP|op==`EXE_LH_OP|op==`EXE_LHU_OP|op==`EXE_LW_OP)? 4'b0000:
				(op==`EXE_SW_OP)? 4'b1111:
				(op==`EXE_SH_OP)? ( (addr[1:0]==2'b00)? 4'b1100:
									(addr[1:0]==2'b10)? 4'b0011:
									4'b0000):
				(op==`EXE_SB_OP)? ( (addr[1:0]==2'b00)? 4'b1000:
									(addr[1:0]==2'b01)? 4'b0100:
									(addr[1:0]==2'b10)? 4'b0010:
									(addr[1:0]==2'b11)? 4'b0001:
									4'b0000):
				4'b0000;
					
endmodule
