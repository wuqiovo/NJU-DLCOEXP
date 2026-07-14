`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/10 19:46:23
// Design Name: 
// Module Name: scancode_ram
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

module scancode_ram(clk, addr,outdata);
    input clk;
    input [7:0] addr;
    output reg [7:0] outdata;
    //Do not change the name of this ram, testbench will initialize this
    reg [7:0] ascii_tab[255:0];
    
    always @(posedge clk)
    begin
          outdata <= ascii_tab[addr];
    end
endmodule
