`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/11 23:41:53
// Design Name: 
// Module Name: attendance
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

module attendance(
    input  [127:0] name,
    input          clk,
    input          rst,
    input  [1:0]   cmd,
    output reg [127:0] dataout
);

    reg [127:0] xor_result;

    always @(posedge clk) begin
        if (rst) begin
            xor_result <= 128'b0;
            dataout    <= 128'b0;
        end
        else if ((cmd == 2'b01) || (cmd == 2'b10)) begin
            xor_result <= xor_result ^ name;
        end
        else if (cmd == 2'b00) begin
            dataout <= xor_result;
        end
    end

endmodule

