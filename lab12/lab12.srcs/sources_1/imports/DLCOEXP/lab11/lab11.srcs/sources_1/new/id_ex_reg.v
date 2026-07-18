`timescale 1ns / 1ps

// ID/EX pipeline register
// Lecture state: 159 bits.  use_rs1/use_rs2 are added to distinguish real
// source operands from instruction fields that merely occupy the same bits.
module id_ex_reg(
    input  wire        clock,
    input  wire        reset,
    input  wire        stall,
    input  wire        flush,

    input  wire [31:0] pc_in,
    input  wire [31:0] imm_in,
    input  wire [31:0] rs1_data_in,
    input  wire [31:0] rs2_data_in,
    input  wire [4:0]  rs1_in,
    input  wire [4:0]  rs2_in,
    input  wire [4:0]  rd_in,
    input  wire        use_rs1_in,
    input  wire        use_rs2_in,
    input  wire [9:0]  ex_ctrl_in,
    input  wire [3:0]  mem_ctrl_in,
    input  wire [1:0]  wb_ctrl_in,

    // During a load-use stall the instruction remains in EX.  These ports
    // allow a simultaneous WB->EX forwarded operand to be retained, so it is
    // not lost when the WB instruction leaves the pipeline.
    input  wire        stall_rs1_we,
    input  wire        stall_rs2_we,
    input  wire [31:0] stall_rs1_data,
    input  wire [31:0] stall_rs2_data,

    output reg  [31:0] pc_out,
    output reg  [31:0] imm_out,
    output reg  [31:0] rs1_data_out,
    output reg  [31:0] rs2_data_out,
    output reg  [4:0]  rs1_out,
    output reg  [4:0]  rs2_out,
    output reg  [4:0]  rd_out,
    output reg         use_rs1_out,
    output reg         use_rs2_out,
    output reg  [9:0]  ex_ctrl_out,
    output reg  [3:0]  mem_ctrl_out,
    output reg  [1:0]  wb_ctrl_out
    );

    always @(negedge clock or posedge reset) begin
        if (reset) begin
            pc_out       <= 32'b0;
            imm_out      <= 32'b0;
            rs1_data_out <= 32'b0;
            rs2_data_out <= 32'b0;
            rs1_out      <= 5'b0;
            rs2_out      <= 5'b0;
            rd_out       <= 5'b0;
            use_rs1_out  <= 1'b0;
            use_rs2_out  <= 1'b0;
            ex_ctrl_out  <= 10'b0;
            mem_ctrl_out <= 4'b0;
            wb_ctrl_out  <= 2'b0;
        end
        else if (stall) begin
            // All fields hold implicitly.  Only a valid WB forwarding result
            // may repair a stale operand while this instruction is stalled.
            if (stall_rs1_we)
                rs1_data_out <= stall_rs1_data;
            if (stall_rs2_we)
                rs2_data_out <= stall_rs2_data;
        end
        else if (flush) begin
            pc_out       <= 32'b0;
            imm_out      <= 32'b0;
            rs1_data_out <= 32'b0;
            rs2_data_out <= 32'b0;
            rs1_out      <= 5'b0;
            rs2_out      <= 5'b0;
            rd_out       <= 5'b0;
            use_rs1_out  <= 1'b0;
            use_rs2_out  <= 1'b0;
            ex_ctrl_out  <= 10'b0;
            mem_ctrl_out <= 4'b0;
            wb_ctrl_out  <= 2'b0;
        end
        else begin
            pc_out       <= pc_in;
            imm_out      <= imm_in;
            rs1_data_out <= rs1_data_in;
            rs2_data_out <= rs2_data_in;
            rs1_out      <= rs1_in;
            rs2_out      <= rs2_in;
            rd_out       <= rd_in;
            use_rs1_out  <= use_rs1_in;
            use_rs2_out  <= use_rs2_in;
            ex_ctrl_out  <= ex_ctrl_in;
            mem_ctrl_out <= mem_ctrl_in;
            wb_ctrl_out  <= wb_ctrl_in;
        end
    end

endmodule
