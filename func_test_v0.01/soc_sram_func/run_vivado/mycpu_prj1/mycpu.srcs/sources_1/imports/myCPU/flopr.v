`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/06 21:31:23
// Design Name: 
// Module Name: flopr
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


module flopr #(parameter WIDTH=8) (
	input clk,
	input rst,
	input [WIDTH-1:0] d,
	output reg [WIDTH-1:0] q
    );
	always @(posedge clk, posedge rst)begin
		if(rst) begin
			q<=0;
		end
		else begin
			q<=d;
		end
	end
endmodule
