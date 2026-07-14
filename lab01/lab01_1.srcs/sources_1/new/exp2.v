`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/03 23:48:00
// Design Name: 
// Module Name: exp2
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


module exp2(
    input  [7:0] X,
    input  en,
    output reg valid,
    output [6:0] F,
    output reg [2:0] y
    );

    wire [6:0] seg;

    // 8-3
    always @(*) begin
        if (en) begin
            casez (X)
                8'b1???????: begin y = 3'd7; valid = 1'b1; end
                8'b01??????: begin y = 3'd6; valid = 1'b1; end
                8'b001?????: begin y = 3'd5; valid = 1'b1; end
                8'b0001????: begin y = 3'd4; valid = 1'b1; end
                8'b00001???: begin y = 3'd3; valid = 1'b1; end
                8'b000001??: begin y = 3'd2; valid = 1'b1; end
                8'b0000001?: begin y = 3'd1; valid = 1'b1; end
                8'b00000001: begin y = 3'd0; valid = 1'b1; end
                default:     begin y = 3'd0; valid = 1'b0; end
            endcase
        end
        else begin
            y = 3'd0;
            valid = 1'b0;
        end
    end

    bcd7seg u_bcd7seg (
        .b({1'b0, y}),
        .h(seg)
    );

    assign F = valid ? seg : 7'b1111111;

endmodule


module bcd7seg(
    input  [3:0] b,
    output reg [6:0] h
    );

    // h[6:0] = {CG, CF, CE, CD, CC, CB, CA}
    always @(*) begin
        case (b)
            4'd0: h = 7'b1000000; // 0
            4'd1: h = 7'b1111001; // 1
            4'd2: h = 7'b0100100; // 2
            4'd3: h = 7'b0110000; // 3
            4'd4: h = 7'b0011001; // 4
            4'd5: h = 7'b0010010; // 5
            4'd6: h = 7'b0000010; // 6
            4'd7: h = 7'b1111000; // 7
            4'd8: h = 7'b0000000; // 8
            4'd9: h = 7'b0010000; // 9
            default: h = 7'b1111111;
        endcase
    end

endmodule
