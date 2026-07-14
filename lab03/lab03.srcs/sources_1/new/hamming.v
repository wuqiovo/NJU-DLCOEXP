`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/06 17:23:16
// Design Name: 
// Module Name: hamming
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


module hamming(
	input  [6:0] code,
	output reg [6:0] correct,
	output [2:0] parity
	);

// add your code here
    assign parity[0] = (code[0] ^ code[2]) ^ (code[4] ^ code[6]);
    assign parity[1] = (code[1] ^ code[2]) ^ (code[5] ^ code[6]);
    assign parity[2] = (code[3] ^ code[4]) ^ (code[5] ^ code[6]);
    
    always @(*) begin
        case(parity)
            3'b000: correct = code;
            3'b001: correct = {code[6:1], ~code[0]};
            3'b010: correct = {code[6:2], ~code[1], code[0]};
            3'b011: correct = {code[6:3], ~code[2], code[1:0]};
            3'b100: correct = {code[6:4], ~code[3], code[2:0]};
            3'b101: correct = {code[6:5], ~code[4], code[3:0]};
            3'b110: correct = {code[6], ~code[5], code[4:0]};
            3'b111: correct = {~code[6], code[5:0]};
            default: correct = 7'd0;
        endcase 
    end
endmodule
