`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/01 22:59:15
// Design Name: 
// Module Name: mux41
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


 module exp1(
	input [1:0] X0,
	input [1:0] X1,
	input [1:0] X2,
	input [1:0] X3,
	input [1:0] Y,
	output reg [1:0] F
	);

//add your code here
    always @ (*)
    case(Y)
      2'd0: F = X0;
      2'd1: F = X1;
      2'd2: F = X2;
      2'd3: F = X3;
      default: F = 2'b0;
    endcase

endmodule
