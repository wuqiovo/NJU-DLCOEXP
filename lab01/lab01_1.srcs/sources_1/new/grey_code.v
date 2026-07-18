`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/17 17:52:42
// Design Name: 
// Module Name: grey_code
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

module graycode(
	input  [63:0] B,
	output [63:0] G
	);

    assign G = B ^ (B >> 1);
endmodule
