`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/13 17:25:52
// Design Name: 
// Module Name: adder
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

module adder(
	input  [31:0] A,
	input  [31:0] B,
	input  addsub,
	output [31:0] F,
	output cf,
	output zero,
	output of
	);

    wire [31:0] t_no_cin;
    wire carry;

    assign t_no_cin = {32{addsub}} ^ B;

    assign {carry, F} = A + t_no_cin + addsub;

    assign cf = carry ^ addsub;
    
    // overflow
    assign of = (A[31] == t_no_cin[31]) && (F[31] != A[31]);

    // zero
    assign zero = ~(|F);
    
endmodule   
