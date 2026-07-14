`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/06 16:45:43
// Design Name: 
// Module Name: clkgen
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


module clkgen(input clkin, input rst, input clken, output reg clkout);
    parameter clk_freq = 1000;
    parameter countlimit = 100000000 / 2 / clk_freq - 1;
    reg [31:0] clkcount;

    always @ (posedge clkin)
        if (rst)
        begin
            clkcount <= 0;
            clkout <= 1'b0;
        end
        else
        begin
            if (clken)
            begin
                if (clkcount >= countlimit)
                begin
                    clkcount <= 32'd0;
                    clkout <= ~clkout;
                end
                else
                begin
                    clkcount <= clkcount + 1;
                end
            end
        end
endmodule
