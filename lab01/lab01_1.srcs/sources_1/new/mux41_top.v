`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/06 18:00:21
// Design Name: 
// Module Name: mux41_top
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


module exp1_top(
    input [9:0] SW,
    output [1:0] LED
    );
    
    exp1 exp1_inst(
        .Y(SW[1:0]),
        .X0(SW[3:2]),
        .X1(SW[5:4]),
        .X2(SW[7:6]),
        .X3(SW[9:8]),
        .F(LED[1:0])
    );
    
endmodule
