`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/08 00:45:04
// Design Name: 
// Module Name: bcd7seg
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


module bcd7seg(
    input  [3:0] b,
    output reg [7:0] h
    );

    always @(*) begin
        case(b)
            4'h0: h = 8'b1100_0000;
            4'h1: h = 8'b1111_1001;
            4'h2: h = 8'b1010_0100;
            4'h3: h = 8'b1011_0000;
            4'h4: h = 8'b1001_1001;
            4'h5: h = 8'b1001_0010;
            4'h6: h = 8'b1000_0010;
            4'h7: h = 8'b1111_1000;
            4'h8: h = 8'b1000_0000;
            4'h9: h = 8'b1001_0000;
            default: h = 8'b1111_1111;
        endcase
    end

endmodule
