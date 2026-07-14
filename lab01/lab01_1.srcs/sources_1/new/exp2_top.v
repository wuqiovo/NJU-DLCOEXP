`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/06 18:20:02
// Design Name: 
// Module Name: exp2_top
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


module exp2_top(
    input  [8:0] SW,
    output [4:0] LED,
    output [7:0] AN,
    output [7:0] HEX
    );

    wire valid;
    wire [2:0] y;
    wire [6:0] seg;

    exp2 exp2_inst(
        .X(SW[7:0]),
        .en(SW[8]),
        .valid(valid),
        .y(y),
        .F(seg)
    );

    // LED2~LED0 for 3 bits encoding result
    assign LED[2:0] = y;

    // LED3 sets as 0
    assign LED[3] = 1'b0;

    // LED4 for valid
    assign LED[4] = valid;

    // only use the far right display tube
    assign AN = 8'b11111110;

    // F[6:0] = {CG, CF, CE, CD, CC, CB, CA}
    // HEX[7:0] = {DP, CG, CF, CE, CD, CC, CB, CA}
    // DP sets as 1
    assign HEX = {1'b1, seg};

endmodule
