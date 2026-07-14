`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/05 16:24:26
// Design Name: 
// Module Name: Adder4
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


module Adder4(
	input  [3:0] A,
	input  [3:0] B,
	input  addsub,
	output [3:0] F,
	output cf,
	output zero,
	output of
	);

// add your code here
    wire [3:0] t_no_cin;
    wire carry;

    assign t_no_cin = {4{addsub}} ^ B;

    assign {carry, F} = A + t_no_cin + addsub;

    assign cf = carry ^ addsub;
    
    // overflow
    assign of = (A[3] == t_no_cin[3]) && (F[3] != A[3]);

    // zero
    assign zero = ~(|F);
endmodule  
