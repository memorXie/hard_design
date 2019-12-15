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
	input int,
	output inst_sram_en,
	output [3:0] inst_sram_wen,
	output [31:0] inst_sram_addr,
	output [31:0] inst_sram_wdata,
	input [31:0] inst_sram_rdata,

	output data_sram_en,
	output [3:0] data_sram_wen,
	output [31:0] data_sram_addr,
	output [31:0] data_sram_wdata,
	input [31:0] data_sram_rdata,

	output [31:0] debug_wb_pc,
	output [3:0] debug_wb_rf_wen,
	output [4:0] debug_wb_rf_wnum,
	output [31:0] debug_wb_rf_wdata
    );
	wire [31:0] writedata,dataadr,writedata2;
	wire [3:0] memwrite;
	wire memen;
	wire[31:0] pc,instr,readdata;
	wire [3:0] sel;
	wire [31:0] pcW;
	wire regwriteW;
	wire [4:0] writeregW;
	wire [31:0] resultW;
	wire [31:0] dataadr_p;
	assign dataadr_p = (dataadr[31]==1'b1)? {3'b000,dataadr[28:0]}:
						dataadr;
	mips mips(clk,rst,pc,inst_sram_rdata,memwrite,memen,dataadr,writedata,writedata2,data_sram_rdata,sel,pcW,regwriteW,writeregW,resultW);
	// inst_ram imem(.clka(~clk),.addra({{2{1'b0}},pc[31:2]}),.douta(instr),.ena(1'b1));
	// data_ram dmem(.clka(~clk),.wea(sel),.addra(dataadr_p[31:2]),.dina(writedata2),.douta(readdata),.ena(memen));


	assign inst_sram_en = 1'b1;
	assign inst_sram_wen = 4'b0000;
	assign inst_sram_addr = pc;
	assign inst_sram_wdata = 32'b0;
	//assign inst_sram_rdata = instr;

	assign data_sram_en = memen;
	assign data_sram_wen = sel;
	assign data_sram_addr = dataadr_p;
	assign data_sram_wdata = writedata2;
	//assign data_sram_rdata = readdata;

	assign debug_wb_pc = pcW;
	assign debug_wb_rf_wen = {4{regwriteW}};
	assign debug_wb_rf_wnum = writeregW;
	assign debug_wb_rf_wdata = resultW;
endmodule
