`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/14 22:36:23
// Design Name: 
// Module Name: PC
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


module PC #(parameter WIDTH=8)(
	input wire clk,rst,ena,
	input wire[WIDTH-1:0] d,
	output reg [WIDTH-1:0] q
);
	initial begin
		q<=32'hbfc00000;
	end
	always @(posedge clk,posedge rst) begin
		if(rst) begin
			q<=32'hbfc00000;
		end else begin
			if(ena) begin
				q<=d;
			end
		end
	end
endmodule 
