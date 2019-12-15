`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/10 00:30:16
// Design Name: 
// Module Name: ALU
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
module ALU(
	input clk,
	input rst,
	input [31:0] a,b,
	input [7:0] op,
	input [4:0] sa,
	input [63:0] hilo_i,
	//input div_ready,
	output [31:0] y,
	output overflow,
	output [63:0] hilo_o,
	output div_stall
	);
	wire div_ready;
	wire [31:0] sub_tmp;
	wire [31:0] mult_a,mult_b;
	wire valid,sign;
	wire [63:0] result;
	assign sub_tmp = (a+((~b)+1));
	assign mult_a = (op==`EXE_MULT_OP & a[31])? (~a+1):a;
	assign mult_b = (op==`EXE_MULT_OP & b[31])? (~b+1):b;
	assign valid = (op==`EXE_DIV_OP | op==`EXE_DIVU_OP);
	assign sign = (op==`EXE_DIV_OP);
	assign overflow = (op==`EXE_ADD_OP | op==`EXE_ADDI_OP)? ( (a[31]&b[31]&(~y[31])) | ((~a[31])&(~b[31])&y[31]) ):
					  (op==`EXE_SUB)? ( ((~a[31])&b[31]&y[31]) | (a[31]&(~b[31])&(~y[31])) ):
					  1'b0;
	assign hilo_o = (op==`EXE_MTHI_OP)? ({a,hilo_i[31:0]}): //rs->HI
					(op==`EXE_MTLO_OP)? ({hilo_i[63:32],a}):  //rs -> LO
					((op==`EXE_MULT_OP)&(a[31]^b[31]))? ~(mult_a*mult_b)+1:
					((op==`EXE_MULT_OP)|(op==`EXE_MULTU_OP))? (mult_a*mult_b):
					(op==`EXE_DIV_OP | op==`EXE_DIVU_OP)? result:
					hilo_i;

               //logic inst
	assign y = (op==`EXE_AND_OP | op==`EXE_ANDI_OP) ? (a&b): //按位与
				(op==`EXE_OR_OP | op==`EXE_ORI_OP) ? (a|b):
				(op==`EXE_XOR_OP | op==`EXE_XORI_OP) ? (a^b):
				(op==`EXE_NOR_OP) ? (~(a|b)):
				(op==`EXE_LUI_OP) ? ({b[15:0], b[31:16]}):
				//shift inst
				(op==`EXE_SLL_OP) ? (b<<sa): //左移立即数
				(op==`EXE_SLLV_OP) ? (b<<a[4:0]): //左移寄存器
				(op==`EXE_SRL_OP) ? (b>>sa): //逻辑右移立即数
				(op==`EXE_SRLV_OP)? (b>>a[4:0]): //逻辑右移寄存器
				(op==`EXE_SRA_OP)? (( {32{b[31]}} << (6'd32-{1'b0,sa}) )| (b>>sa) ): //算术右移立即数
				(op==`EXE_SRAV_OP)? (( {32{b[31]}} << (6'd32-{1'b0,a[4:0]}) )| (b>>a[4:0]) ): //算数右移寄存器

				//move inst
				(op==`EXE_MFHI_OP)? hilo_i[63:32]: //HI->rd寄存器
				(op==`EXE_MFLO_OP)? hilo_i[31:0]: //LO->rd寄存器

				//arithmetic inst
				(op==`EXE_ADD_OP| op==`EXE_ADDU_OP|op==`EXE_ADDI_OP|op==`EXE_ADDIU_OP)? (a+b): //加,
				(op==`EXE_SUB_OP| op==`EXE_SUBU_OP)? sub_tmp: //减
				(op==`EXE_SLT_OP| op==`EXE_SLTI_OP)? ((a[31]==1'b1 & b[31]==1'b1)? (a<b): (a[31]==1'b0 & b[31]==1'b0)? (a<b) : a[31]) : //小于置1
				(op==`EXE_SLTU_OP| op==`EXE_SLTIU_OP)? (a<b?1'b1:1'b0):

				//move inst
				(op==`EXE_LW_OP | op==`EXE_LB_OP | op==`EXE_LBU_OP | op==`EXE_LH_OP | op==`EXE_LHU_OP|op==`EXE_SB_OP|op==`EXE_SH_OP|op==`EXE_SW_OP)
				? (a+b):32'habcdef11;





	// assign {start_div,signed_div,stall_div}= (op==`EXE_DIV_OP)?  ((div_ready==1'b0)? 3'b111:
	// 											  (div_ready==1'b1)? 3'b010:
	// 											  3'b000):
	// 										 (op==`EXE_DIVU_OP)? ( (div_ready==1'b0)? 3'b101:
	// 										 	  3'b000
	// 										 	):
	// 										 3'b000; //这里也许有问题



	div_radix2 div(clk,rst,a,b,valid,sign,div_stall,result);//32 cycles
endmodule
