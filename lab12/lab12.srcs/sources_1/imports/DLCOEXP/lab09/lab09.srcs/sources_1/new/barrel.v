`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/13 17:22:37
// Design Name: 
// Module Name: barrel
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

module barrel(
    input [31:0] indata,
    input [4:0] shamt,
	input lr, // 0 for right and 1 for left 
	input al, // 0 for logic and 1 for algorithm 
	output reg [31:0] outdata
	);
    
    always @(*) begin
        if (lr) begin
            outdata = indata << shamt;
        end
        else begin
            if (al) begin
                outdata = $signed(indata) >>> shamt;
            end
            else begin
                outdata = indata >> shamt;
            end
        end
    end
    
endmodule
