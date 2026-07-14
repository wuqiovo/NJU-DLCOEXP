`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/01 22:47:08
// Design Name: 
// Module Name: m_mux21_test
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


module m_mux21_vlg_tst(); 
     reg a; 
     reg b;
     reg s;
     wire y; 
    
     m_mux21 i1 ( 
     .a(a),
     .b(b),
     .s(s),
     .y(y));
    
     initial begin 
         s=0; a=0; b=0; #10; 
         b=1; #10; 
         
         a=1; b=0; #10; 
         
         b=1; #10; 
         s=1; a=0; b=0; #10; 
         b=1; #10;
         a=1; b=0; #10;
         b=1; #10;
     end
endmodule
