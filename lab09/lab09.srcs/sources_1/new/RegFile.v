`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/13 17:14:24
// Design Name: 
// Module Name: RegFile
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

module RegFile(
    input [4:0] Ra,
    input [4:0] Rb,
    input [4:0] Rw,
    input [31:0] busW,
    input RegWr,
    input WrClk,
    output [31:0] busA,
    output [31:0] busB
    );
    
    reg [31:0] regs [31:0];
    integer i;
    
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            regs[i] = 32'b0;
        end
    end
    
    assign busA = regs[Ra];
    assign busB = regs[Rb];
    
    always @(negedge WrClk) begin
        if (RegWr && Rw != 5'b0) begin
            regs[Rw] <= busW;
        end
    end
    
endmodule
