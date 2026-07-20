`timescale 1ns / 1ps

module bcd7seg(
    input  [3:0] b,
    output reg [7:0] h
    );

    always @(*) begin
        case(b)
            4'h0: h = 8'b1100_0000;
            4'h1: h = 8'b1111_1001;
            4'h2: h = 8'b1010_0100;
            4'h3: h = 8'b1011_0000;
            4'h4: h = 8'b1001_1001;
            4'h5: h = 8'b1001_0010;
            4'h6: h = 8'b1000_0010;
            4'h7: h = 8'b1111_1000;
            4'h8: h = 8'b1000_0000;
            4'h9: h = 8'b1001_0000;
            4'ha: h = 8'b1000_1000; // A
            4'hb: h = 8'b1000_0011; // b
            4'hc: h = 8'b1100_0110; // C
            4'hd: h = 8'b1010_0001; // d
            4'he: h = 8'b1000_0110; // E
            4'hf: h = 8'b1000_1110; // F 
            default: h = 8'hff;
        endcase
    end

endmodule
