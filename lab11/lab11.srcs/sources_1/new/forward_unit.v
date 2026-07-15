`timescale 1ns / 1ps

// Data-forwarding detector for the EX stage.
//
// Selection encoding:
//   2'b00: use the operand stored in ID/EX
//   2'b01: forward the final WB write-back value
//   2'b10: forward MEM_ALUResult
//
// A matching MEM instruction always has priority over WB because it is the
// newer producer.  If that MEM instruction is a load, its result is not ready
// for MEM->EX forwarding; the selector stays at 2'b00 and stall_unit inserts
// a one-cycle load-use stall.  In particular, the logic must not fall back to
// an older matching value in WB.

module forward_unit(
    input  wire [4:0] EX_rs1,
    input  wire [4:0] EX_rs2,
    input  wire       EX_use_rs1,
    input  wire       EX_use_rs2,

    input  wire [4:0] MEM_rd,
    input  wire       MEM_RegWr,
    input  wire       MEM_MemtoReg,

    input  wire [4:0] WB_rd,
    input  wire       WB_RegWr,

    output reg  [1:0] rs1_sel,
    output reg  [1:0] rs2_sel
    );

    localparam [1:0] FWD_ID_EX = 2'b00,
                     FWD_WB    = 2'b01,
                     FWD_MEM   = 2'b10;

    wire mem_match_rs1;
    wire mem_match_rs2;
    wire wb_match_rs1;
    wire wb_match_rs2;

    assign mem_match_rs1 = EX_use_rs1 && MEM_RegWr &&
                           (MEM_rd != 5'b0) && (MEM_rd == EX_rs1);
    assign mem_match_rs2 = EX_use_rs2 && MEM_RegWr &&
                           (MEM_rd != 5'b0) && (MEM_rd == EX_rs2);

    assign wb_match_rs1 = EX_use_rs1 && WB_RegWr &&
                          (WB_rd != 5'b0) && (WB_rd == EX_rs1);
    assign wb_match_rs2 = EX_use_rs2 && WB_RegWr &&
                          (WB_rd != 5'b0) && (WB_rd == EX_rs2);

    always @(*) begin
        rs1_sel = FWD_ID_EX;

        if (mem_match_rs1) begin
            // A load result becomes available only after the MEM/WB register.
            if (!MEM_MemtoReg)
                rs1_sel = FWD_MEM;
        end
        else if (wb_match_rs1) begin
            rs1_sel = FWD_WB;
        end
    end

    always @(*) begin
        rs2_sel = FWD_ID_EX;

        if (mem_match_rs2) begin
            if (!MEM_MemtoReg)
                rs2_sel = FWD_MEM;
        end
        else if (wb_match_rs2) begin
            rs2_sel = FWD_WB;
        end
    end

endmodule
