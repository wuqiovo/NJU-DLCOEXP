`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/02 22:31:21
// Design Name: 
// Module Name: decode24_test
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


module test_decode24();
   reg [1:0] x;
   reg en;
   wire [3:0]y;
   decode24 i1 (
       . x (x),
       . en (en),
       .y(y) );
       
   initial
   begin
     en = 1'b0;  x = 2'b00; #10;
                 x = 2'b01; #10;
                 x = 2'b10; #10;
                 x = 2'b11; #10;
     
     en = 1'b1;  x = 2'b00; #10;
                 x = 2'b01; #10;
                 x = 2'b10; #10;
                 x = 2'b11; #10;
   end
endmodule
