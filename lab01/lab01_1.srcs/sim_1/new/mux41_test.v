`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/01 23:06:04
// Design Name: 
// Module Name: mux41_test
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


module mux41_vlg_tst();
 reg [3:0] a;
 reg [1:0] s;
 wire y;

 mux41 i1 (
   .a(a),
   .s(s),
   .y(y));
 
 initial begin
   s=2'b00; a=4'b1110; #10;
   a=4'b0001; #10;
   s=2'b01; a=4'b1110; #10;
   a=4'b0010; #10;
   s=2'b10; a=4'b1010; #10;
   a=4'b0100; #10;
   s=2'b11; a=4'b0111; #10;
   a=4'b1001; #10;
 end
endmodule
