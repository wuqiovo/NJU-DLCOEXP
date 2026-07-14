`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/02 22:40:15
// Design Name: 
// Module Name: encode42_test
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


module test_encode42();
    reg en;
    reg [3:0] s;
    wire [1:0] y;

    encode42 t1 (
        .en(en),
        .x(s),
        .y(y)
    );

    initial begin
        en = 1'b0; s = 4'b0000; #10;
                   s = 4'b0001; #10;
                   s = 4'b0010; #10;
                   s = 4'b0100; #10;
                   s = 4'b1000; #10;

        en = 1'b1; s = 4'b0000; #10;
                   s = 4'b0001; #10;
                   s = 4'b0010; #10;
                   s = 4'b0100; #10;
                   s = 4'b1000; #10;
    end
endmodule
