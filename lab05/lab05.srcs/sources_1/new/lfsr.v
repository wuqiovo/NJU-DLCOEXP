`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/08 00:31:57
// Design Name: 
// Module Name: lfsr
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

module lfsr (
    input  [63:0]  seed,
	input  clk,
	input  load,
	output reg [63:0] dout
	);
    //add your code here
    always @(posedge clk) begin
        if (load) begin
            dout <= seed;
        end
        else begin
            dout <= {dout[0] ^ dout[1] ^ dout[3] ^ dout[4], dout[63:1]};
        end
    end
    
endmodule
