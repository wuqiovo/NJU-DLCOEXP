`timescale 1ns / 1ps

// Nexys A7 wrapper for the 32-bit ALU.
// SW[3:0]  : operand A nibble, repeated eight times to form 32 bits
// SW[7:4]  : operand B nibble, repeated eight times to form 32 bits
// SW[11:8] : ALU control
// AN/HEX   : 32-bit ALU result in hexadecimal
module alu_top(
    input  wire        CLK100MHZ,
    input  wire [11:0] SW,
    output reg  [7:0]  AN,
    output wire [7:0]  HEX
    );

    wire [3:0] data_a;
    wire [3:0] data_b;
    wire [31:0] dataa;
    wire [31:0] datab;
    wire [3:0] ALUctr;
    wire less;
    wire zero;
    wire [31:0] aluresult;

    assign data_a = SW[3:0];
    assign data_b = SW[7:4];
    assign dataa  = {8{data_a}};
    assign datab  = {8{data_b}};
    assign ALUctr = SW[11:8];

    alu u_alu (
        .dataa     (dataa),
        .datab     (datab),
        .ALUctr    (ALUctr),
        .less      (less),
        .zero      (zero),
        .aluresult (aluresult)
    );

    reg [18:0] scan_count;
    wire [2:0] scan_index;
    reg [3:0] display_nibble;

    assign scan_index = scan_count[18:16];

    initial scan_count = 19'b0;

    always @(posedge CLK100MHZ) begin
        scan_count <= scan_count + 1'b1;
    end

    always @(*) begin
        AN = 8'hFF;
        AN[scan_index] = 1'b0;

        case (scan_index)
            3'd0: display_nibble = aluresult[3:0];
            3'd1: display_nibble = aluresult[7:4];
            3'd2: display_nibble = aluresult[11:8];
            3'd3: display_nibble = aluresult[15:12];
            3'd4: display_nibble = aluresult[19:16];
            3'd5: display_nibble = aluresult[23:20];
            3'd6: display_nibble = aluresult[27:24];
            3'd7: display_nibble = aluresult[31:28];
            default: display_nibble = 4'h0;
        endcase
    end

    alu_top_hex7seg u_hex7seg (
        .value (display_nibble),
        .seg   (HEX)
    );

endmodule


module alu_top_hex7seg(
    input  wire [3:0] value,
    output reg  [7:0] seg
    );

    always @(*) begin
        case (value)
            4'h0: seg = 8'b1100_0000;
            4'h1: seg = 8'b1111_1001;
            4'h2: seg = 8'b1010_0100;
            4'h3: seg = 8'b1011_0000;
            4'h4: seg = 8'b1001_1001;
            4'h5: seg = 8'b1001_0010;
            4'h6: seg = 8'b1000_0010;
            4'h7: seg = 8'b1111_1000;
            4'h8: seg = 8'b1000_0000;
            4'h9: seg = 8'b1001_0000;
            4'hA: seg = 8'b1000_1000;
            4'hB: seg = 8'b1000_0011;
            4'hC: seg = 8'b1100_0110;
            4'hD: seg = 8'b1010_0001;
            4'hE: seg = 8'b1000_0110;
            4'hF: seg = 8'b1000_1110;
            default: seg = 8'b1111_1111;
        endcase
    end

endmodule
