`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/25 16:51:14
// Design Name: 
// Module Name: signext
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


module signext(
	input [15:0] in,
	input [1:0] typ,
	output [31:0] out
    );

	assign out = (typ==2'b11)? {{16{1'b0}},in}: {{16{in[15]}}, in};
endmodule
