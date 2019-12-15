`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 10:58:03
// Design Name: 
// Module Name: mips
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


module mips(
	input wire clk,rst,
	output wire[31:0] pcF,
	input wire[31:0] instrF,
	output wire memwriteM,memenM,
	output wire[31:0] aluoutM,writedataM,writedata2M,
	input wire[31:0] readdataM ,
	output wire [3:0] selM
    );
	
	wire [5:0] opD,functD;
	wire regdstE,alusrcE,pcsrcD,memtoregE,memtoregM,memtoregW,
			regwriteE,regwriteM,regwriteW,hilo_writeW;
	wire [7:0] alucontrolE,alucontrolM,alucontrolW;
	wire flushE,equalD;
	wire [4:0] rtD;
	wire jrE,jalE,balE;
	wire stallM,stallW,stallE;
	wire jalD,jrD;
	controller c(
		clk,rst,
		//decode stage
		opD,functD,
		rtD,
		pcsrcD,branchD,equalD,jumpD,
		jalD,jrD,
		
		//execute stage
		flushE,
		memtoregE,alusrcE,
		regdstE,regwriteE,	
		alucontrolE,
		jalE,jrE,balE,
		stallE,

		//mem stage
		memtoregM,memwriteM,memenM,
		regwriteM,alucontrolM,
		stallM,
		selM,
		aluoutM,
		//write back stage
		memtoregW,regwriteW,hilo_writeW,alucontrolW,
		stallW
		);
	datapath dp(
		clk,rst,
		//fetch stage
		pcF,
		instrF,
		//decode stage
		pcsrcD,branchD,
		jumpD,
		equalD,
		opD,functD,rtD,
		jalD,jrD,
		//execute stage
		memtoregE,
		alusrcE,regdstE,
		regwriteE,
		alucontrolE,
		flushE,
		jalE,jrE,balE,
		stallE,
		//mem stage
		memtoregM,
		regwriteM,
		alucontrolM,
		aluoutM,writedataM, writedata2M,
		readdataM,
		stallM,
		//writeback stage
		memtoregW,
		regwriteW,
		alucontrolW,
		hilo_writeW,
		stallW
	    );
	
endmodule
