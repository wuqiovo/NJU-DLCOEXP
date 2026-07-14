`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/06 17:52:28
// Design Name: 
// Module Name: hex7seg
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


module hex7seg(
    input  [3:0] x,
    output reg [7:0] HEX
);

    always @(*) begin
        case (x)
            4'h0: HEX = 8'b1100_0000;
            4'h1: HEX = 8'b1111_1001;
            4'h2: HEX = 8'b1010_0100;
            4'h3: HEX = 8'b1011_0000;
            4'h4: HEX = 8'b1001_1001;
            4'h5: HEX = 8'b1001_0010;
            4'h6: HEX = 8'b1000_0010;
            4'h7: HEX = 8'b1111_1000;
            4'h8: HEX = 8'b1000_0000;
            4'h9: HEX = 8'b1001_0000;
            4'hA: HEX = 8'b1000_1000;
            4'hB: HEX = 8'b1000_0011;
            4'hC: HEX = 8'b1100_0110;
            4'hD: HEX = 8'b1010_0001;
            4'hE: HEX = 8'b1000_0110;
            4'hF: HEX = 8'b1000_1110;
            default: HEX = 8'b1111_1111;
        endcase
    end

endmodule