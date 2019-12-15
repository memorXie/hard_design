`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/23 15:21:30
// Design Name: 
// Module Name: controller
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


module controller(
	input wire clk,rst,
	//decode stage
	input wire[5:0] opD,functD,
	input wire [4:0] rtD,
	output wire pcsrcD,branchD,
	input equalD,//zero & branch = pcsrc
	output jumpD,
	output jalD,jrD,
	//execute stage
	input wire flushE,
	output wire memtoregE,alusrcE,
	output wire regdstE,regwriteE,	
	output wire[7:0] alucontrolE,
	output wire jalE,jrE,balE,
	input stallE,

	//mem stage
	output wire memtoregM,memwriteM,memenM,
				regwriteM,
	output wire [7:0] alucontrolM,
	input stallM,
	input flushM,
	output wire [3:0] selM,
	input [31:0] aluoutM,
	//write back stage
	output wire memtoregW,regwriteW,hilo_writeW,
	output wire [7:0] alucontrolW,
	input stallW

    );
	
	//decode stage
	wire[1:0] aluopD;
	wire memtoregD,memwriteD,alusrcD,
		regdstD,regwriteD,memenD,hilo_writeD;
	wire[7:0] alucontrolD;
	wire hilo_readD;
	wire jalD,jrD,balD;
	//execute stage
	wire memwriteE;
	wire memenE;
	wire hilo_writeE;
	//memory
	wire hilo_writeM;
	main_decoder md(
		.op(opD),.funct(functD),.rt(rtD),.memen(memenD),
		.memtoreg(memtoregD),.memwrite(memwriteD),
		.branch(branchD),.alusrc(alusrcD),
		.regdst(regdstD),.regwrite(regwriteD),
		.jump(jumpD),
		.hilo_write_en(hilo_writeD),
		.hilo_read(hilo_readD),
		.jal(jalD),.jr(jrD),.bal(balD)
		);
	ALU_control ad(.funct(functD),.op(opD),.alucontrol(alucontrolD));
	data_memory_controller dmc(.addr(aluoutM),.op(alucontrolM),.sel(selM));
	assign pcsrcD = branchD & equalD;

	//pipeline registers
	flopenrc #(32) regE(
		clk,
		rst,
		~stallE,
		flushE,
		{memtoregD,memwriteD,memenD,alusrcD,regdstD,regwriteD,alucontrolD,hilo_writeD,jalD,jrD,balD},
		{memtoregE,memwriteE,memenE,alusrcE,regdstE,regwriteE,alucontrolE,hilo_writeE,jalE,jrE,balE}
		);
	flopenrc #(16) regM(
		clk,rst,~stallM,flushM,
		{memtoregE,memwriteE,memenE,regwriteE,alucontrolE,hilo_writeE},
		{memtoregM,memwriteM,memenM,regwriteM,alucontrolM,hilo_writeM}
		);
	flopenr #(16) regW(
		clk,rst,~stallW,
		{memtoregM,regwriteM,alucontrolM,hilo_writeM},
		{memtoregW,regwriteW,alucontrolW,hilo_writeW}
		);
endmodule
