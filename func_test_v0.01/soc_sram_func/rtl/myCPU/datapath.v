`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/02 15:12:22
// Design Name: 
// Module Name: datapath
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


module datapath(
	input wire clk,rst,
	//fetch stage
	output wire[31:0] pcF,
	input wire[31:0] instrF,
	//decode stage
	input wire pcsrcD,branchD,
	input wire jumpD,
	output wire equalD,
	output wire[5:0] opD,functD,
	output rtD,
	input jalD,jrD,
	//execute stage
	input wire memtoregE,
	input wire alusrcE,regdstE,
	input wire regwriteE,
	input wire[7:0] alucontrolE,
	output wire flushE,
	input jalE,jrE,balE,
	output stallE,
	//mem stage
	input wire memtoregM,
	input wire regwriteM,
	input [7:0] alucontrolM,
	output wire[31:0] aluoutM,writedataM,writedata2M,
	input wire[31:0] readdataM,
	output stallM,
	//writeback stage
	input wire memtoregW,
	input wire regwriteW,
	input wire [7:0] alucontrolW,
	input wire hilo_writeW,
	output stallW
    );
	wire [1:0] typ;
	wire overflow;
	//fetch stage
	wire stallF;
	//FD
	wire [31:0] pcnextFD,pcnext2FD,pcnextbrFD,pcplus4F,pcbranchD;
	//decode stage
	wire [31:0] pcplus4D,instrD;
	wire forwardaD,forwardbD;
	wire [4:0] rsD,rtD,rdD,saD;
	wire flushD,stallD; 
	wire [31:0] signimmD,signimmshD;
	wire [31:0] srcaD,srca2D,srcbD,srcb2D;
	//execute stage
	wire [1:0] forwardaE,forwardbE,forwardhiloE;
	wire [4:0] rsE,rtE,rdE,saE;
	wire [4:0] writeregE;
	wire [4:0] writereg2E;
	wire [31:0] signimmE;
	wire [31:0] srcaE,srca2E,srcbE,srcb2E,srcb3E;
	wire [31:0] aluoutE;
	wire [31:0] aluout2E;
	wire [63:0] hilo_alu_in;
	wire [63:0] hilo_iE;
	wire div_stallE;
	wire stallE;
	wire [31:0] pcplus8E;
	//mem stage
	wire [4:0] writeregM;
	wire [63:0] hilo_iM;
	wire stallM;
	//writeback stage
	wire [4:0] writeregW;
	wire [31:0] aluoutW,readdataW,resultW;
	wire [63:0] hilo_iW,hilo_oW;
	wire stallW;
	wire [31:0] finaldata;
	//hazard detection
	hazard h(
		//fetch stage
		stallF,
		//decode stage
		rsD,rtD,
		branchD,
		forwardaD,forwardbD,
		stallD,//ok
		jumpD,
		jrD,
		//execute stage
		rsE,rtE,
		writeregE,
		writereg2E,
		regwriteE,
		alucontrolE,//
		memtoregE,
		forwardaE,forwardbE,
		flushE,
		forwardhiloE,//
		div_stallE,
		stallE,
		//mem stage
		writeregM,
		regwriteM,
		alucontrolM,//
		memtoregM,
		stallM,
		//write back stage
		writeregW,
		alucontrolW,//
		regwriteW,
		stallW
		);

	//next PC logic (operates in fetch an decode)
	mux2 #(32) pcbrmux(pcplus4F,pcbranchD,pcsrcD,pcnextbrFD);
	mux2 #(32) pcmux(pcnextbrFD,
		{pcplus4D[31:28],instrD[25:0],2'b00},
		jumpD|jalD,pcnextFD);
	mux2 #(32) pcmux2(pcnextFD,srca2D,jrD,pcnext2FD);

	//regfile (operates in decode and writeback)
	regfile rf(clk,regwriteW,rsD,rtD,writeregW,resultW,srcaD,srcbD);

	//fetch stage logic
	flopenr #(32) pcreg(clk,rst,~stallF,pcnext2FD,pcF);
	adder pcadd1(pcF,32'b100,pcplus4F);
	//decode stage
	flopenr #(32) r1D(clk,rst,~stallD,pcplus4F,pcplus4D);//PC reg
	flopenrc #(32) r2D(clk,rst,~stallD,flushD,instrF,instrD);
	signext se(instrD[15:0],typ,signimmD);
	sl2 immsh(signimmD,signimmshD);
	adder pcadd2(pcplus4D,signimmshD,pcbranchD);
	mux2 #(32) forwardamux(srcaD,aluoutM,forwardaD,srca2D);
	mux2 #(32) forwardbmux(srcbD,aluoutM,forwardbD,srcb2D);
	eqcmp comp(srca2D,srcb2D,opD,rtD,equalD);

	assign opD = instrD[31:26];
	assign functD = instrD[5:0];
	assign rsD = instrD[25:21];
	assign rtD = instrD[20:16];
	assign rdD = instrD[15:11];
	assign saD = instrD[10:6];
	assign typ = instrD[29:28];
	//execute stage
	flopenrc #(32) r1E(clk,rst,~stallE,flushE,srcaD,srcaE);
	flopenrc #(32) r2E(clk,rst,~stallE,flushE,srcbD,srcbE);
	flopenrc #(32) r3E(clk,rst,~stallE,flushE,signimmD,signimmE);
	flopenrc #(5) r4E(clk,rst,~stallE,flushE,rsD,rsE);
	flopenrc #(5) r5E(clk,rst,~stallE,flushE,rtD,rtE);
	flopenrc #(5) r6E(clk,rst,~stallE,flushE,rdD,rdE);
	flopenrc #(5) r7E(clk,rst,~stallE,flushE,saD,saE);
	flopenrc #(32) r8E(clk,rst,~stallE,flushE,pcplus4D+4,pcplus8E);


	mux3 #(32) forwardaemux(srcaE,resultW,aluoutM,forwardaE,srca2E);
	mux3 #(32) forwardbemux(srcbE,resultW,aluoutM,forwardbE,srcb2E);
	mux3 #(64) forwardhiloemux(hilo_oW,hilo_iW,hilo_iM,forwardhiloE,hilo_alu_in);
	mux2 #(32) srcbmux(srcb2E,signimmE,alusrcE,srcb3E);
	ALU alu(clk,rst,srca2E,srcb3E,alucontrolE,saE,hilo_alu_in,aluoutE,overflow,hilo_iE,div_stallE);
	mux2 #(5) wrmux(rtE,rdE,regdstE,writeregE);
	mux2 #(5) wrmux2(writeregE,5'b11111,jalE|balE,writereg2E);
	mux2 #(32) wrmux3(aluoutE,pcplus8E,jalE|jrE|balE,aluout2E);
	//mem stage	
	store_which store_which(.op(alucontrolM),.writedata(writedataM),.writedata2(writedata2M));
	flopenr #(32) r1M(clk,rst,~stallM,srcb2E,writedataM);
	flopenr #(32) r2M(clk,rst,~stallM,aluout2E,aluoutM);
	flopenr #(5) r3M(clk,rst,~stallM,writereg2E,writeregM);
	flopenr #(64) r4M(clk,rst,~stallM,hilo_iE,hilo_iM);

	//writeback stage
	load_which load_which_byte(.op(alucontrolW),.readdata(readdataW),.addr(aluoutW),.finaldata(finaldata));
	flopenr #(32) r1W(clk,rst,~stallW,aluoutM,aluoutW);
	flopenr #(32) r2W(clk,rst,~stallW,readdataM,readdataW);
	flopenr #(5) r3W(clk,rst,~stallW,writeregM,writeregW);
	flopenr #(64) r4W(clk,rst,~stallW,hilo_iM,hilo_iW);
	hilo_reg hilo(clk,rst,hilo_writeW, hilo_iW[63:32],hilo_iW[31:0],hilo_oW[63:32],hilo_oW[31:0]);
	mux2 #(32) resmux(aluoutW,finaldata,memtoregW,resultW);
endmodule
