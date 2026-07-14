`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/07 17:09:28
// Design Name: 
// Module Name: regfile
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


module regfile_online (
    input  [4:0]  ra,
    input  [4:0]  rb,
	input  [4:0]  rw,
	input  [31:0] wrdata,
	input  regwr,
	input  wrclk,
	output [31:0] outa,
	output [31:0] outb
	);
	
	//The regfile
	reg [31:0] regs[31:0];	
	
	//add your code here
    
	initial begin
	   regs[0] = 32'h0; regs[1] = 32'h0; regs[2] = 32'h0; regs[3] = 32'h0;
	   regs[4] = 32'h0; regs[5] = 32'h0; regs[6] = 32'h0; regs[7] = 32'h0;
	   regs[8] = 32'h0; regs[9] = 32'h0; regs[10] = 32'h0; regs[11] = 32'h0;
	   regs[12] = 32'h0; regs[13] = 32'h0; regs[14] = 32'h0; regs[15] = 32'h0;
	   regs[16] = 32'h0; regs[17] = 32'h0; regs[18] = 32'h0; regs[19] = 32'h0;
	   regs[20] = 32'h0; regs[21] = 32'h0; regs[22] = 32'h0; regs[23] = 32'h0;
	   regs[24] = 32'h0; regs[25] = 32'h0; regs[26] = 32'h0; regs[27] = 32'h0;
	   regs[28] = 32'h0; regs[29] = 32'h0; regs[30] = 32'h0; regs[31] = 32'h0;
    end
	
	assign outa = regs[ra];
	assign outb = regs[rb];
	
	always @(posedge wrclk) begin
	   if (regwr && rw != 5'd0) begin
	       regs[rw] <= wrdata;
	   end
	end
endmodule
