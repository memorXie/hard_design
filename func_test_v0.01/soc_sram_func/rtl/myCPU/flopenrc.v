

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/06 21:31:23
// Design Name: 
// Module Name: flopenrc
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
module flopenrc #(parameter WIDTH=8)(
	input wire clk,rst,ena,clr,
	input wire[WIDTH-1:0] d,
	output reg [WIDTH-1:0] q
);
	always @(posedge clk,posedge rst) begin
		if(rst | clr) begin
			q<=0;
		end else if(ena) begin
			
			q<=d;
			
		end
	end

endmodule 