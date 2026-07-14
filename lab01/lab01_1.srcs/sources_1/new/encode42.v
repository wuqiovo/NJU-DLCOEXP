`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/02 22:37:48
// Design Name: 
// Module Name: encode42
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


module encode42(x, en, y);
    input [3:0] x;
    input en;
    output reg [1:0] y;

    always @(x or en)
        if (en) begin
            case (x)
                4'b0001: y = 2'b00;
                4'b0010: y = 2'b01;
                4'b0100: y = 2'b10;
                4'b1000: y = 2'b11;
                default: y = 2'bzz;
            endcase
        end
        else
            y = 2'bzz;

endmodule
