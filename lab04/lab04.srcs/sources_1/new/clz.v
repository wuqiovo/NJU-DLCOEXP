`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/07 17:22:59
// Design Name: 
// Module Name: clz
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


module clz(
    input  [31:0] in,
    output [4:0] out,
    output zero
    );

    reg [4:0] out_r;

    reg [15:0] value16;
    reg [7:0]  value8;
    reg [3:0]  value4;
    reg [1:0]  value2;

    assign out = out_r;
    assign zero = (in == 32'b0);

    always @(*) begin
        if (in[31:16] == 16'h0000) begin
            out_r[4] = 1'b1;
            value16 = in[15:0];
        end
        else begin
            out_r[4] = 1'b0;
            value16 = in[31:16];
        end

        if (value16[15:8] == 8'h00) begin
            out_r[3] = 1'b1;
            value8 = value16[7:0];
        end
        else begin
            out_r[3] = 1'b0;
            value8 = value16[15:8];
        end

        if (value8[7:4] == 4'h0) begin
            out_r[2] = 1'b1;
            value4 = value8[3:0];
        end
        else begin
            out_r[2] = 1'b0;
            value4 = value8[7:4];
        end

        if (value4[3:2] == 2'b00) begin
            out_r[1] = 1'b1;
            value2 = value4[1:0];
        end
        else begin
            out_r[1] = 1'b0;
            value2 = value4[3:2];
        end

        if (value2[1] == 1'b0) begin
            out_r[0] = 1'b1;
        end
        else begin
            out_r[0] = 1'b0;
        end
    end

endmodule