`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/12 18:38:57
// Design Name: 
// Module Name: div_radix2
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


module div_radix2(
    input               clk,
    input               rst,
    input [31:0]        a,  //divident
    input [31:0]        b,  //divisor
    input               valid,
    input               sign,   //1:signed

    // output reg          ready,
    output wire         div_stall,
    output [63:0]       result
    );
    /*
    1. 先取绝对值，计算出余数和商。再根据被除数、除数符号对结果调整
    2. 计算过程中，由于保证了remainer为正，因此最高位为0，可以用32位存储。而除数需用33位
    */

    reg [63:0] SR; //shift register
    reg [32 :0] NEG_DIVISOR;  //divisor 2's complement
    wire [31:0] REMAINER, QUOTIENT;
    assign REMAINER = SR[63:32];
    assign QUOTIENT = SR[31: 0];

    wire [31:0] divident_abs;
    wire [32:0] divisor_abs;
    wire [31:0] remainer, quotient;

    assign divident_abs = (sign & a[31]) ? ~a + 1'b1 : a;
    //余数符号与被除数相同
    assign remainer = (sign & a[31]) ? ~REMAINER + 1'b1 : REMAINER;
    assign quotient = sign & (a[31] ^ b[31]) ? ~QUOTIENT + 1'b1 : QUOTIENT;
    assign result = {remainer,quotient};

    wire CO;
    wire [32:0] sub_result;
    wire [32:0] mux_result;
    //sub
    assign {CO,sub_result} = {1'b0,REMAINER} + NEG_DIVISOR;
    //mux
    assign mux_result = CO ? sub_result : {1'b0,REMAINER};

    //state machine
    reg [5:0] cnt;
    reg start_cnt;
    always @(negedge clk, posedge rst) begin
        if(rst) begin
            cnt <= 0;
            start_cnt <= 0;
        end
        else if(!start_cnt & valid) begin
            cnt <= 1;
            start_cnt <= 1;

            //Register init
            SR[63:0] <= {31'b0,divident_abs,1'b0}; //left shift one bit initially
            NEG_DIVISOR <= (sign & b[31]) ? {1'b1,b} : ~{1'b0,b} + 1'b1; //divisor_abs的补码
        end
        else if(start_cnt) begin
            if(cnt==32) begin
                cnt <= 0;
                start_cnt <= 0;
                
                //Output result
                SR[63:32] <= mux_result[31:0];
                SR[31:0] <= {SR[30:0],CO};
                //SR[0] <= CO;
            end
            else begin
                cnt <= cnt + 1;

                SR[63:0] <= {mux_result[30:0],SR[31:0],CO}; // write and shift left
            end
        end
    end
    //assign div_stall = valid;
     assign div_stall = |cnt; //只有当cnt=0时不暂停
endmodule
