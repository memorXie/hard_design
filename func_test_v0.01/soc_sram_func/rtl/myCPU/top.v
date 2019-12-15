`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 13:50:53
// Design Name: 
// Module Name: top
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


module top(
	input wire clk,rst,
	output wire[31:0] writedata,dataadr,writedata2,
	output wire [3:0] memwrite
    );
	wire memen;
	wire[31:0] pc,instr,readdata;
	wire [3:0] sel;
	mips mips(clk,rst,pc,instr,memwrite,memen,dataadr,writedata,writedata2,readdata,sel);
	inst_mem imem(.clka(~clk),.addra(pc),.douta(instr),.ena(1'b1));
	data_mem dmem(.clka(~clk),.wea(sel),.addra(dataadr),.dina(writedata2),.douta(readdata),.ena(memen));
endmodule
