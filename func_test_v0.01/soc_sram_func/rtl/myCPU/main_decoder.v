`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company| 
// Engineer| 
// 
// Create Date| 2019/11/15 19|410|23
// Design Name| 
// Module Name| main_decoder
// Project Name| 
// Target Devices| 
// Tool Versions| 
// Description| 
// 
// Dependencies| 
// 
// Revision|
// Revision 0.01 - File Created
// Additional Comments|
// 
//////////////////////////////////////////////////////////////////////////////////

`include "defines.vh"
module main_decoder(
	input wire [5:0] op,
	input wire [5:0] funct,
	input wire [4:0] rt,
	output wire memtoreg,memen,memwrite,
	output wire branch,alusrc,
	output wire regdst,regwrite,
	output wire jump,
	output wire hilo_write_en,hilo_read,
	output jal,jr,bal
    );
	reg [12:0] controls;
	assign {memtoreg,memen,memwrite,branch,alusrc,regdst,regwrite,jump,hilo_read,hilo_write_en,jal,jr,bal}=controls;
    always @(*) begin
		case (op)
			`EXE_ANDI:controls<=13'b0000_101000_000;
			`EXE_ORI	:controls<=13'b0000_101000_000;
			`EXE_XORI:controls<=13'b0000_101000_000;
			`EXE_LUI	:controls<=13'b0000_101000_000;
			`EXE_SLTI :controls<=13'b0000_1010_00_000;//
			`EXE_SLTIU:controls<=13'b0000_1010_00_000;//
			`EXE_ADDI :controls<=13'b0000_1010_00_000;
			`EXE_ADDIU:controls<=13'b0000_1010_00_000;
			`EXE_J:controls<=13'b0000_0001_00_000;//
			`EXE_JAL :controls<=13'b0000_0010_00_100;
			`EXE_BEQ :controls<=13'b0001_0000_00_000;
			`EXE_BGTZ:controls<=13'b0001_0000_00_000;
			`EXE_BLEZ:controls<=13'b0001_0000_00_000;
			`EXE_BNE:controls<=13'b0001_0000_00_000;
			`EXE_LB :controls<=13'b1100_1010_00_000;
			`EXE_LBU:controls<=13'b1100_1010_00_000;
			`EXE_LH :controls<=13'b1100_1010_00_000;
			`EXE_LHU:controls<=13'b1100_1010_00_000;
			`EXE_LW :controls<=13'b1100_1010_00_000;
			`EXE_SB :controls<=13'b0110_1000_00_000;
			`EXE_SH :controls<=13'b0110_1000_00_000;
			`EXE_SW :controls<=13'b0110_1000_00_000;
			`EXE_SPECIAL_INST:begin //r-type
				case (funct)
					`EXE_AND:controls<=13'b0000_011000_000;
					`EXE_OR:controls<=13'b0000_011000_000;
					`EXE_XOR:controls<=13'b0000_011000_000;
					`EXE_NOR:controls<=13'b0000_011000_000;
					`EXE_SLL	:controls<=13'b0000_011000_000;//10'b0000_x010
					`EXE_SLLV:controls<=13'b0000_011000_000;
					`EXE_SRL :controls<=13'b0000_011000_000;//same as SLL
					`EXE_SRLV:controls<=13'b0000_011000_000;
					`EXE_SRA :controls<=13'b0000_011000_000;//same as SLL
					`EXE_SRAV:controls<=13'b0000_011000_000;
					`EXE_MFHI:controls<=13'b0000_0110_10_000;
					`EXE_MTHI:controls<=13'b0000_0000_01_000;
					`EXE_MFLO:controls<=13'b0000_0110_10_000;
					`EXE_MTLO:controls<=13'b0000_0000_01_000;
					`EXE_SLT  :controls<=13'b0000_0110_00_000;
					`EXE_SLTU :controls<=13'b0000_0110_00_000;
					`EXE_ADD  :controls<=13'b0000_0110_00_000;
					`EXE_ADDU :controls<=13'b0000_0110_00_000;//
					`EXE_SUB  :controls<=13'b0000_0110_00_000;
					`EXE_SUBU :controls<=13'b0000_0110_00_000;
					`EXE_MULT :controls<=13'b0000_0000_01_000;
					`EXE_MULTU:controls<=13'b0000_0000_01_000;
					`EXE_DIV  :controls<=13'b0000_0000_01_000;
					`EXE_DIVU :controls<=13'b0000_0000_01_000;
					`EXE_JALR:controls<=13'b0000_0110_00_010;
					`EXE_JR  :controls<=13'b0000_0001_00_010;
					`EXE_SYSCALL:controls<=`EXE_SYSCALL_OP;
					`EXE_BREAK:controls<=`EXE_BREAK_OP;
				endcase
			end
			`EXE_REGIMM_INST:begin
				case (rt)
					`EXE_BLTZ: controls<= 13'b0001_0000_00_000;
					`EXE_BLTZAL: controls <= 13'b0001_0010_00_001;
					`EXE_BGEZ: controls<= 13'b0001_0000_00_000;
					`EXE_BGEZAL: controls<=13'b0001_0010_00_001;
				endcase
			end
		endcase // op
	end
	
endmodule


// `timescale 1ns / 1ps

// // Create Date: 20131/06/21 15:52:513

// `include "defines.vh"

// module main_decoder(
// 	input [5:0] op_code,
// 	input [4:0] rs,
// 	input [4:0] rt,
// 	input [5:0] funct,
// 	output reg [0:12] main_control
//     );
// 	//main_control信号分解
// 	// assign reg_write_enD = 	main_control[0];
// 	// assign reg_dstD = 		main_control[1:2];	//00-> rt 01->rd 11 -> 5'b11111
// 	// assign alu_src_pcD = 	main_control[3];	jump al or branch al
// 	// assign alu_src_immD = 	main_control[4];	I type 1
// 	// assign write_src = 		main_control[5:6];	//写数据存储器 00 -> alu_out; 01 -> data memory; 10 -> cp0
// 	//	

// 	// assign hilo_read = 		main_control[7];	//hilo 有关
// 	// assign hilo_write_en = 	main_control[10];	//
// 	// assign branch = 			main_control[9];	//branch
// 	// assign unsign_extend =   main_control[10];	//
// 	// assign jump =   			main_control[11];	//
// 	// assign cp0_write_en = 	main_control[12];
// 	// 
// 	always @(*) begin
// 		case(op_code)
// 			`EXE_R_TYPE:
// 				case(funct)
// 					//HILO 有关
// 					`EXE_MTHI, `EXE_MTLO:
// 									main_control = 13'b0_00_0_0_00_1_1_0_0_0_0;
// 					`EXE_MFHI, `EXE_MFLO:
// 									main_control = 13'b1_01_0_0_00_1_0_0_0_0_0;
// 					`EXE_DIV, `EXE_MULT, `EXE_DIVU, `EXE_MULTU:
// 									main_control = 13'b1_01_0_0_00_0_1_0_0_0_0;
// 					//Jump R
// 					`EXE_JR:		main_control = 13'b0_00_0_0_00_0_0_0_0_1_0;
// 					`EXE_JALR:		main_control = 13'b1_01_1_0_00_0_0_0_0_1_0;
// 					default:	//一般的R type
// 	 								main_control = 13'b1_01_0_0_00_0_0_0_0_0_0;
// 				endcase
// 			//一般的I type
// 			`EXE_ADDI, `EXE_SLTI, `EXE_ANDI, `EXE_XORI, `EXE_ORI, `EXE_ADDIU, `EXE_SLTIU: 		
// 							main_control = 13'b1_00_0_1_00_0_0_0_0_0_0;
// 			`EXE_LUI:
// 							main_control = 13'b1_00_0_1_00_0_0_0_1_0_0;
// 			//memory
// 			`EXE_LW, `EXE_LB, `EXE_LBU, `EXE_LH, `EXE_LHU:
// 							main_control = 13'b1_00_0_1_01_0_0_0_0_0_0;
// 			`EXE_SW, `EXE_SB, `EXE_SH:
// 							main_control = 13'b0_00_0_1_00_0_0_0_0_0_0;
// 			//branch and jump
// 			`EXE_BEQ, `EXE_BGTZ,`EXE_BLEZ,`EXE_BNE:
// 							main_control =  13'b0_00_0_0_00_0_0_1_0_0_0;
// 			`EXE_BRANCHS:
// 				case(rt)
// 					`EXE_BLTZAL,`EXE_BGEZAL:      
//                         	main_control =  13'b1_10_1_0_00_0_0_1_0_0_0;
//                     `EXE_BLTZ, `EXE_BGEZ: 
//                        		main_control =  13'b0_00_0_0_00_0_0_1_0_0_0;
//                     default:
//                         	main_control =  13'b0_00_0_0_00_0_0_1_0_0_0;
// 				endcase
// 			`EXE_J:			main_control =  13'b0_00_0_0_00_0_0_0_0_1_0;
// 			`EXE_JAL:		main_control =  13'b1_10_1_0_00_0_0_0_0_1_0;
// 			`EXE_MTCMFC:
// 				case(rs)
// 					`RS_MFC:
// 							main_control =  13'b0_00_0_0_10_0_0_0_0_0_0;
// 					`RS_MTC:
// 							main_control =  13'b0_00_0_0_00_0_0_0_0_0_1;
// 				endcase
// 			default: 		main_control =  13'b0_00_0_0_00_0_0_0_0_0_0;
// 		endcase

// 	end
// endmodule
