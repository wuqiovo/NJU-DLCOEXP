`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/01 22:39:58
// Design Name: 
// Module Name: lab01
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


module lab01(
  input [15:0] SW,
  output [15:0] LED
  );
  
  // m_mux21 a(SW[0],SW[1],SW[15],LED[0]);
//  mux41 m_41(SW[3:0],SW[15:14],LED[0]);
  decode24 d24(SW[1:0],SW[15],LED[3:0]);
endmodule
