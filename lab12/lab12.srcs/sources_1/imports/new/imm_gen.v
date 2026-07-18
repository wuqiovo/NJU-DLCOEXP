`timescale 1ns / 1ps

module imm_gen(
    input  wire [31:0] instr,
    input  wire [2:0]  ExtOP,
    output reg  [31:0] imm
    );

    wire [31:0] immI;
    wire [31:0] immU;
    wire [31:0] immS;
    wire [31:0] immB;
    wire [31:0] immJ;

    assign immI = {{20{instr[31]}}, instr[31:20]};

    assign immU = {instr[31:12], 12'b0};

    assign immS = {{20{instr[31]}}, instr[31:25], instr[11:7]};

    assign immB = {{20{instr[31]}}, instr[7], instr[30:25],
                   instr[11:8], 1'b0};

    assign immJ = {{12{instr[31]}}, instr[19:12], instr[20],
                   instr[30:21], 1'b0};

    always @(*) begin
        case (ExtOP)
            3'b000: imm = immI;
            3'b001: imm = immU;
            3'b010: imm = immS;
            3'b011: imm = immB;
            3'b100: imm = immJ;
            default: imm = 32'b0;
        endcase
    end

endmodule
