`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/06 21:55:14
// Design Name: 
// Module Name: hazard
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

`include "defines.vh"
module hazard(
	//fetch stage
		output stallF,
		//decode stage
		input [4:0] rsD,rtD,
		input branchD,
		output  forwardaD,forwardbD,
		output stallD,//ok
		input jumpD,
		input  jrD,
		//execute stage
		input [4:0] rsE,rtE,
		input [4:0] writeregE,
		input [4:0] writereg2E,
		input regwriteE,
		input [7:0] alucontrolE,
		input memtoregE,
		output [1:0] forwardaE,forwardbE,
		output flushE,
		output [1:0] forwardhiloE,
		input div_stallE,
		output stallE,
		//mem stage
		input [4:0] writeregM,
		input regwriteM,
		input [7:0] alucontrolM,
		input memtoregM,
		output stallM,
		//write back stage
		input [4:0] writeregW,
		input [7:0] alucontrolW,
		input regwriteW,
		output stallW
    );
	assign forwardaE= (rsE!=0 & rsE==writeregM & regwriteM)? 2'b10:
					  (rsE!=0 & rsE==writeregW & regwriteW)? 2'b01: 2'b00;
	assign forwardbE= (rtE!=0 & rtE==writeregM & regwriteM)? 2'b10:
					  (rtE!=0 & rtE==writeregW & regwriteW)? 2'b01: 2'b00;
	wire lwstall;
	assign lwstall = ((rsD==rtE | rtD==rtE) & memtoregE);
	
	assign forwardaD = rsD!=0 & rsD==writeregM & regwriteM;
	assign forwardbD = rsD!=0 & rtD==writeregM & regwriteM;
	wire branchstall;
	wire jrstall;
	assign jrstall = (jrD & regwriteE & (writereg2E==rsD)) | (jrD & memtoregM & (writeregM==rsD));
	assign branchstall= (branchD & regwriteE & (writereg2E==rsD | writeregE==rtD)) | (branchD & memtoregM & (writeregM==rsD | writeregM==rtD));
	assign flushE=(lwstall | branchstall | jumpD | jrstall);
	assign stallD=(lwstall | branchstall | div_stallE |jrstall);
	assign stallF=(lwstall | branchstall | div_stallE |jrstall);
	assign stallE=div_stallE;
 	assign stallM=div_stallE;
 	assign stallW=div_stallE;


	assign forwardhiloE = ((alucontrolE==`EXE_MFHI_OP & alucontrolM==`EXE_MTHI_OP) | (alucontrolE==`EXE_MFLO_OP & alucontrolM==`EXE_MTLO_OP))?
			2'b10:
			((alucontrolE==`EXE_MFHI_OP & alucontrolW==`EXE_MTHI_OP) | (alucontrolE==`EXE_MFLO_OP & alucontrolW==`EXE_MTLO_OP))?
			2'b01: 2'b00;
endmodule
